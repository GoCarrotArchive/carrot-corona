-- Carrot -- Copyright (C) 2013 GoCarrot Inc.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local Library = require "CoronaLibrary"

-- Create library
local carrot = Library:new{ name='carrot', publisherId='com.gocarrot' }

local mime = require "mime"
local json = require "json"
local crypto = require "crypto"
local ltn12 = require "ltn12"
local sqlite3 = require "sqlite3"

-- Carrot SqLite3 cache statements
local kCacheCreateSQL = "CREATE TABLE IF NOT EXISTS cache(request_endpoint TEXT, request_payload TEXT, request_id TEXT, request_date REAL, retry_count INTEGER)"
local kCacheReadSQL = "SELECT rowid, request_endpoint, request_payload, request_id, request_date, retry_count FROM cache ORDER BY retry_count"
local kCacheInsertSQL = "INSERT INTO cache (request_endpoint, request_payload, request_id, request_date, retry_count) VALUES ('%s', '%s', '%s', %f, %d)"
local kCacheUpdateSQL = "UPDATE cache SET retry_count=%d WHERE rowid=%d"
local kCacheDeleteSQL = "DELETE FROM cache WHERE rowid=%d"

-- Carrot status codes.
carrot.status = {
	-- Everything is good to go.
	READY = "READY",

	-- The user has not authorized the 'publish_actions' permission.
	READ_ONLY = "READ_ONLY",

	-- The user has not authorized the application.
	NOT_AUTHORIZED = "NOT_AUTHORIZED",

	-- An invalid user token was specified.
	INVALID_USER_TOKEN = "INVALID_USER_TOKEN",

	-- The status is unknown.
	UNKNOWN = "UNKNOWN"
}

carrot.logTag = "[Carrot]"

carrot.init = function(appId, appSecret, hostname)
	carrot._appId = appId
	carrot._appSecret = appSecret
	carrot._hostname = hostname or "gocarrot.com"
	carrot._udid = system.getInfo("deviceID")
	carrot._status = carrot.status.UNKNOWN

	if carrot.logTag then print(carrot.logTag, "Initialized") end

	-- Hook into suspend/resume events for close/open the db
	Runtime:addEventListener("system", function(event)
		if event.type == "applicationSuspend" then
			if carrot._db and carrot._db:isopen() then
				carrot._db:close()
				carrot._db = nil
			end
		end
	end)
end

carrot.getStatus = function()
	return carrot._status
end

carrot.setStatusCallback = function(callback)
	carrot._statusCallback = callback
end

carrot.validateUser = function(accessToken, callback)
	local params = {
		access_token = accessToken,
		api_key = carrot._udid
	}

	carrot._postRequest("/games/"..carrot._appId.."/users.json", params, function(event)
		local status = carrot._updateStatus(event)
		if callback then callback(status) end
	end)
end

carrot.postAchievement = function(achievementId)
	carrot._makeCachedRequest("/me/achievements.json", {achievement_id = achievementId})
end

carrot.postHighScore = function(score)
	carrot._makeCachedRequest("/me/scores.json", {value = score})
end

carrot.postAction = function(actionId, objectInstanceId, actionProperties)
	local payload = {action_id = actionId, object_instance_id = objectInstanceId}
	if actionProperties then payload['action_properties'] = actionProperties end
	carrot._makeCachedRequest("/me/actions.json", payload)
end

-- Internal functions

carrot._getDb = function()
	if not (carrot._db and carrot._db:isopen())
		local path = system.pathForFile("carrot.db", system.DocumentsDirectory)
		carrot._db = sqlite3.open(path)

		if carrot._db then
			if carrot._db:exec(kCacheCreateSQL) ~= sqlite3.OK then
				if carrot.logTag then print(carrot.logTag, "Error creating Carrot cache "..carrot._db:error_message()) end
			end
		else
			if carrot.logTag then print(carrot.logTag, "Error creating Carrot cache "..carrot._db:error_message()) end
		end
	end
	return carrot._db
end

carrot._updateStatus = function(event)
	local status = carrot._status
	if event.status == 201 or event.status == 200 then
		status = carrot.status.READY
	elseif event.status == 401 then
		status = carrot.status.READ_ONLY -- no 'publish_actions'
	elseif event.status == 403 or event.status == 405 then
		status = carrot.status.NOT_AUTHORIZED
	elseif event.status == 422 then
		status = carrot.status.INVALID_USER_TOKEN
	end

	if carrot._status ~= status then
		if carrot._statusCallback then carrot._statusCallback(status) end
	end

	if carrot._status ~= carrot.status.READY and status == carrot.status.READY then
		timer.performWithDelay(0, carrot._runCachedRequests)
	end

	carrot._status = status
	return status
end

carrot._runCachedRequests = function()
	local real_fn = carrot._runCachedRequests
	carrot._runCachedRequests = function() end
	for row in carrot._getDb():nrows(kCacheReadSQL) do
		carrot._postCachedRequest(row.request_endpoint, row.rowid, row.request_date, row.request_id, json.decode(row.request_payload))
	end
	carrot._runCachedRequests = real_fn
end

carrot._makeCachedRequest = function(endpoint, params)
	local request_id = carrot._guid()
	local request_date = os.time()

	local params_json = json.encode(params)
	local sql = string.format(kCacheInsertSQL, endpoint, params_json, request_id, request_date, 0)
	if carrot._getDb():exec(sql) ~= sqlite3.OK then
		if carrot.logTag then print(carrot.logTag, "Error caching request: "..carrot._getDb():error_message()) end
	elseif carrot.getStatus() == carrot.status.READY then
		local cache_id = carrot._getDb():last_insert_rowid()
		carrot._postCachedRequest(endpoint, cache_id, request_date, request_id, params, 0)
	end
end

carrot._postCachedRequest = function(endpoint, cache_id, request_date, request_id, payload, retry_count)
	carrot._postSignedRequest(endpoint, request_date, request_id, payload, function(event)
		local delete_sql = string.format(kCacheDeleteSQL, cache_id)
		if event.status == 404 then
			if carrot.logTag then print(carrot.logTag, "Resource not found, removing from queue.") end
			if carrot._getDb():exec(delete_sql) ~= sqlite3.OK then
				if carrot.logTag then print(carrot.logTag, "Error deleting request from cache: "..carrot._getDb():error_message()) end
			end
		elseif carrot._updateStatus(event) == carrot.status.READY then
			if carrot._getDb():exec(delete_sql) ~= sqlite3.OK then
				if carrot.logTag then print(carrot.logTag, "Error deleting request from cache: "..carrot._getDb():error_message()) end
			end
		else
			local retry_sql = string.format(kCacheUpdateSQL, retry_count + 1, cache_id)
			if carrot._getDb():exec(retry_sql) ~= sqlite3.OK then
				if carrot.logTag then print(carrot.logTag, "Error adding retry in cache: "..carrot._getDb():error_message()) end
			end
		end
	end)
end

carrot._postSignedRequest = function(endpoint, request_date, request_id, payload, callback)
	local params = {
		api_key = carrot._udid,
		game_id = carrot._appId,
		request_date = request_date,
		request_id = request_id
	}
	for k,v in pairs(params) do payload[k] = v end

	local pairsByKeys = function(t, f)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0
		local iter = function ()
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
		return iter
	end

	local urlParams = ""
	for k,v in pairsByKeys(payload) do
		urlParams = urlParams.."&"..k.."="..v
	end

	local stringToSign = "POST\n"..carrot._hostname.."\n"..endpoint.."\n"..urlParams:sub(2)
	local hash = crypto.hmac(crypto.sha256, stringToSign, carrot._appSecret, true)
	local b64hash = {}
	ltn12.pump.all(
		ltn12.source.string(hash),
		ltn12.sink.chain(
			mime.encode("base64"),
			ltn12.sink.table(b64hash)
		)
	)
	payload['sig'] = table.concat(b64hash)

	carrot._postRequest(endpoint, payload, callback)
end

carrot._postRequest = function (endpoint, params, callback)
	local boundary = "-===-httpB0unDarY-==-"

	local body = ""
	for k,v in pairs(params) do
		body = body.."--"..boundary.."\r\n"
		body = body.."Content-Disposition: form-data; name=\""..k.."\"\r\n\r\n"..v.."\r\n"
	end
	body = body.."--"..boundary.."--\r\n"

	local headers = {}
	headers["Content-Type"] = "multipart/form-data; boundary="..boundary

	network.request("https://"..carrot._hostname..endpoint, "POST", callback, {headers = headers, body = body})
end

carrot._guid = function()
	local to_hex = function(num)
		local hexstr = '0123456789abcdef'
		local s = ''
		while num > 0 do
			local mod = math.fmod(num, 16)
			s = string.sub(hexstr, mod+1, mod+1) .. s
			num = math.floor(num / 16)
		end
		if s == '' then s = '0' end
		return s
	end
	local S4 = function() return to_hex(math.floor(math.random() * 0x10000)) end
	return (
		S4()..S4().."-"..
		S4().."-"..
		S4().."-"..
		S4().."-"..
		S4()..S4()..S4()
	)
end

return carrot
