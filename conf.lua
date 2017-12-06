-- Config
function love.conf(t)

    --[[ ====================================================================================
        After each setting, follows a description, and the type of input that the
        individual setting can be set to (ex):
            t.class.setting = value   -- Description of what this setting does (type of variable it receives)

        't' calls back to conf(), just ignore it, it is needed

        Instead of removing something, disable it, and push it to the bottom of the page
        out of sight ( ͡° ͜ʖ ͡°)
        ====================================================================================]]

    t.version = "0.10.2"                -- Made Using this version of LÖVE (string) Will throw error if stupid
    t.console = false                   -- Attach a console (boolean, Windows only, see MORE)--[[
       --[[
        MORE:
    If you are using atom.io (from github), download love-ide (through atom package installer) and its dependancies, go to
    love-ide package settings, set up one click run and turn on console of choice (dependant on Operation System;
    win->cmd, linux->shell, as well as other cool stuff    ]]


    t.window.title = "Window Title"         -- The window title (string)
    t.window.icon = nil                 -- Filepath (C:/example/example.png/jpeg) to icon image (top left corner of window)
    t.window.width = 1366                -- The window width (number)
    t.window.height = 736               -- The window height (number)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = false          -- Let the window be user-resizable (boolean)


    t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = false               -- Enable vertical sync (boolean)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1                -- Identifies monitor to show game on (default=1) (number)
    t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)

    -- t.window.x and t.window.y identify where on screen to spawn window (default = nil (mean no place, therefore centered)
    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)

    t.identity = nil                    -- The name of the save directory (string)

    t.modules.audio = true              -- Enable the audio module (boolean)
    t.modules.event = true              -- Enable the event module (boolean)
    t.modules.graphics = true           -- Enable the graphics module (boolean)
    t.modules.image = true              -- Enable the image module (boolean)
    t.modules.joystick = false           -- Enable the joystick module (boolean) Keep false unless on mobile
    t.modules.keyboard = true           -- Enable the keyboard module (boolean)
    t.modules.math = true               -- Enable the math module (boolean)
    t.modules.mouse = true              -- Enable the mouse module (boolean)     true = desktop false = mobile
    t.modules.physics = true            -- Enable the physics module (boolean)
    t.modules.sound = true              -- Enable the sound module (boolean)
    t.modules.system = true             -- Enable the system module (boolean)
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    t.modules.touch = false              -- Enable the touch module (boolean)
    t.modules.video = true              -- Enable the video module (boolean)
    t.modules.window = true             -- Enable the window module (boolean)
    t.modules.thread = true             -- Enable the thread module (boolean)

    -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.accelerometerjoystick = false
    -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.externalstorage = false
end
