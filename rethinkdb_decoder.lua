local dt = require 'date_time'
local l = require 'lpeg'
local sp = l.space
l.locale(l)
local hyphen = l.P("-")
local colon = l.P(":")
local date = l.Cg(l.R("09")^0 * hyphen * l.R("09")^0 * hyphen * l.R("09")^0, "date")
local time = l.Cg(l.R("09")^0 * colon * l.R("09")^0 * colon * l.R("09")^0 * l.P(".") * l.R("09") ^ 0, 'time')
local timestamp = l.Cg(date * l.P("T") * time, "timestamp")
local runningtime = l.Cg(l.R("09")^0 * l.P('.') * l.R("09")^0 * l.P('s'), 'runningtime')
local msgtype = l.Cg(l.R("az")^0, "msgtype") * l.P(":")
local msgtext = l.Cg(l.P(1)^0, 'msgtext')
local pattern = timestamp * sp * runningtime * sp * msgtype * sp * msgtext
local grammar = l.Ct(pattern)

local msg = {
  Timestamp = nil,
  Type = nil,
  Payload = nil
}

function process_message()
  local log = read_message("Payload")

  local m = grammar:match(log)
  if not m then return -1 end
  if m then
    msg.Type = m.msgtype
    msg.Payload = m.msgtext
    msg.Timestamp = m.timestamp
  else
    msg.Type = "Ignore"
  end

  inject_message(msg)
  return 0
end
