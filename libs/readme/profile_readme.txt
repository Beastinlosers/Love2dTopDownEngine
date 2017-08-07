Overview
========
profile.lua is a small, non-intrusive module for finding bottlenecks in your Lua code.
The profiler is used by making minimal changes to your existing code.
Basically, you require the profile.lua and specify when to start or stop collecting data.
Once you are done profiling, a report is generated, describing:
- which functions were called most frequently
- how much time was spent executing each function

Repository
==========
http://bitbucket.org/itraykov/profile.lua

Limitations
===========
Calling functions is slower while profiling so make sure to disable it in production code.
Hooking C functions is not very useful but you don't really need to profile those anyways.
The profiler uses a lot of Lua memory so make sure your GC is not disabled.

API
===
profile.hook(func, label)
Collects data for a given function.
This is used if you want to profile only one specific function.

profile.hookall(what)
Collects data for functions of a given type.
You can choose which functions should be profiled.
Most of the time, you will be profiling "Lua" or "hooked" functions.
Advanced users can profile "C" or "internal" functions too.

profile.report(sort, rows)
Generates a report and returns it as a string.
"sort" determines how the report is sorted, typically by execution "time" or number of "call"-s.
"rows" limits the number of rows in the report.

profile.reset()
Resets all collected data.

profile.start()
Starts collecting data.

profile.stop()
Stops collecting data.

profile.unhook(func)
Ignores data for a given function.

Installation
============
local profile = require("profile")

Usage
=====
-- consider "Lua" functions only
profile.hookall("Lua")
profile.start()
-- execute code that will be profiled
profile.stop()
-- report for the top 10 functions
local r = profile.report('time', 10)
print(r)

Example (Love2D)
=======
-- setup
function love.load()
  love.profiler = require('profile') 
  love.profiler.hookall("Lua")
  love.profiler.start()
end

-- generates a report every 100 frames
love.frame = 0
function love.update(dt)
  love.frame = love.frame + 1
  if love.frame%100 == 0 then
    love.report = love.profiler.report('time', 20)
    love.profiler.reset()
  end
end

-- prints the report
function love.draw()
  love.graphics.print(love.report or "Please wait...")
end