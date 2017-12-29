--[[
Use this file for parallel functions.
This is where I recommend you keep all parallel processing stuff, so its easier to mess with. Just require any files you need.

]]
require 'parallel'

--Example functions
parallel.fork()
parallel.nfork(2) -- Forks 'n' number of functions (forks twice)

parallel.addremote( {ip='server1.org', cores=8, lua='/path/to/torch', protocol='ssh -Y'},
                    {ip='server2.org', cores=16, lua='/path/to/torch', protocol='ssh -Y'},
                    {ip='server3.org', cores=4, lua='/path/to/torch', protocol='ssh -Y'} )
parallel.sfork(16) -- Smart fork; will distribute the 16 processes across the 3 servers based on specs
                   -- server2 will get the most, server3 will get the least
parallel.addremote(...) -- See the function call above
parallel.calibrate() -- estimates which is better
forked = parallel.sfork(parallel.remotes.cores)  -- fork as many processes as cores available (allows you to create one -> process per core)
for _,forked in ipairs(forked) do
   print('id: ' .. forked.id .. ', speed = ' .. forked.speed)
end
-- the speed of each process is a number ]0..1]. A coef of 1 means that it is the
-- fastest process available, and 0.5 for example would mean that the process is 2x
-- slower
--[[
Once processes have been forked, they all exist in a table: parallel.children, and all methods (exec,send,receive,join) work
either on individual processes, or on groups of processes.
]]
-- Read more at
-- https://github.com/clementfarabet/lua---parallel/blob/master/README.md
-- or at /libs/variousReadmes/para\\el.md
