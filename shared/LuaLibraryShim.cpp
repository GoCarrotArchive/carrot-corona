// ----------------------------------------------------------------------------
// 
// LuaLibraryShim.cpp
// Copyright (c) 2013 Corona Labs Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#include "LuaLibraryShim.h"

#include "CoronaAssert.h"
#include "CoronaLibrary.h"

// ----------------------------------------------------------------------------

// TODO: Replace 'carrot' with actual name
CORONA_EXPORT int CoronaPluginLuaLoad_plugin_carrot( lua_State * );

// ----------------------------------------------------------------------------

CORONA_EXPORT
int luaopen_plugin_carrot( lua_State *L )
{
	lua_CFunction factory = Corona::Lua::Open< CoronaPluginLuaLoad_plugin_carrot >;
	int result = CoronaLibraryNewWithFactory( L, factory, NULL, NULL );

	return result;
}

// ----------------------------------------------------------------------------
