---@class willothy.stringlib: stringlib
local M = {}

function M.trim(str)
  return str:gsub("^%s+", ""):gsub("%s+$", "")
end

function M.split(str, sep)
  local result = {}
  for match in (str .. sep):gmatch("(.-)" .. sep) do
    table.insert(result, match)
  end
  return result
end

function M.split_lines(str)
  return M.split(str, "\n")
end

function M.lines(str)
  return coroutine.wrap(function()
    for line in str:gmatch("[^\r\n]+") do
      coroutine.yield(line)
    end
  end)
end

function M.chars(str)
  return coroutine.wrap(function()
    for char in str:gmatch(".") do
      coroutine.yield(char)
    end
  end)
end

function M.join_lines(lines)
  return M.join(lines, "\n")
end

function M.join(strs, sep)
  return table.concat(strs, sep)
end

function M.colorize_markup(str, fg)
  return "<span foreground='" .. fg .. "'>" .. str .. "</span>"
end

function M.capitalize(str)
  return str:gsub("^%l", string.upper)
end

-- Split a string by a separator, then capitalize each word.
function M.complex_capitalizing(s, sep)
  sep = sep or "-"
  local r, i = "", 0
  for w in s:gsub(sep, " "):gmatch("%S+") do
    local cs = M.capitalize(w)
    if i == 0 then
      r = cs
    else
      r = r .. " " .. cs
    end
    i = i + 1
  end

  return r
end

function M.ellipsis(str, max_len, ellipsis_fg)
  local ellipsis = "..."
  if #str > max_len - #ellipsis then
    return str:sub(1, max_len - 3)
  end
  if ellipsis_fg then
    return str .. M.colorize_markup(ellipsis, ellipsis_fg)
  else
    return str .. ellipsis
  end
end

function M.line_clamp(str, max_lines, ellipsis_fg)
  local lines = M.split_lines(str)
  if #lines <= max_lines then
    return str
  end
  local result = ""
  for i = 1, max_lines do
    if i == max_lines then
      result = result
        .. M.ellipsis(lines[i] .. "\n", #lines[i] + 1, ellipsis_fg)
    else
      result = result .. lines[i] .. "\n"
    end
  end
  return result
end

setmetatable(M, {
  __index = string,
  __newindex = function()
    error("Attempt to modify read-only table")
  end,
})

return M
