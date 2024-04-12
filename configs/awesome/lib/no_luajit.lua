-- compatability module for when luajit is not installed
-- and we're using a Lua interpreter that is based on Lua 5.2+
local M = {}

local bit = {}

M.bit = bit

function bit.band(a, b)
  return a & b
end

function bit.bor(a, b)
  return a | b
end

function bit.bxor(a, b)
  return a ~ b
end

function bit.lshift(a, n)
  return a << n
end

function bit.rshift(a, n)
  return a >> n
end

return M
