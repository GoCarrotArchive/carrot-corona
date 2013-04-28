// ----------------------------------------------------------------------------
// 
// LuaLibraryShim.h
// Copyright (c) 2013 Corona Labs Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#ifndef _LuaLibraryShim_H__
#define _LuaLibraryShim_H__

#include "CoronaLua.h"
#include "CoronaMacros.h"

// ----------------------------------------------------------------------------

// TODO: Replace 'carrot' with actual name
CORONA_EXPORT int luaopen_plugin_carrot( lua_State *L );

// ----------------------------------------------------------------------------

#endif // _LuaLibraryShim_H__
