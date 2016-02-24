local dt = require "date_time"
local ip = require "ip_address"
local l = require 'lpeg'
local syslog = require "syslog"
l.locale(l)

local msg = {
Timestamp   = nil,
Hostname    = nil,
Payload     = nil,
Pid         = nil,
Fields      = nil
}

local syslog_grammar = syslog.build_rsyslog_grammar("%TIMESTAMP% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")
local sp = l.space
local timestamp = "[" * l.Cg(dt.build_strftime_grammar("%d/%b/%Y:%H:%M:%S") * dt.time_secfrac / dt.time_to_ns, "Timestamp") * "]"
local log_date = l.Cg(dt.build_strftime_grammar("%b %d %H:%M:%S"), "LogDate")
local host = (l.alnum^1 + l.S("-_"))^1
local fqdn = (l.alnum^1 + l.S("-_."))^1

local proc = l.P"haproxy[" * l.R("09")^1 * l.P"]:" * l.Cg(l.Cc"haproxy", "Type")
local remote_addr = l.Cg(ip.v4, "remote_addr") * ":" * l.Cg(l.R("09")^1, "port")
local request = l.P{'"' * l.Cg(((1 - l.P'"') + l.V(1))^0, "request") * '"'}
local status = l.Cg(l.digit * l.digit * l.digit, "status")
local bytes = l.Cg(l.digit^1, "bytes")
-- local srv_data = host * l.P"/" * host
local ha_shit = (l.digit^1 + l.P"/")^1
local sep = "- - ----"
local protocol = l.Cg((l.alnum^1 + l.P("-"))^1, "protocol")
local backend = l.Cg(host, "backend_name") * l.P"/" * l.Cg(host, "backend_server")
local server = l.P("{")^1 * l.Cg(fqdn, "http_host") * l.P("}")^1

local pattern = log_date * sp * host * sp * proc * sp * remote_addr * sp * timestamp * sp * protocol * sp * backend * sp * ha_shit * sp * status * sp * bytes * sp * sep * sp * ha_shit * sp * ha_shit * sp * server * sp * request

local msg = {
Timestamp = nil,
Type      = nil,
Payload   = nil,
Fields    = nil
}

local grammar = l.Ct(pattern)

function process_message ()
    local log = read_message("Payload")
    local fields = syslog_grammar:match(log)
    if not fields then return -1 end

    msg.Timestamp = fields.timestamp
    fields.timestamp = nil

    fields.programname = fields.syslogtag.programname
    msg.Pid = fields.syslogtag.pid or nil
    fields.syslogtag = nil

    msg.Hostname = fields.hostname
    fields.hostname = nil

    local m = grammar:match(log)
    if m then
        msg.Type = m.Type
        msg.Payload = nil
        msg.Timestamp = m.Timestamp
        fields.remote_addr = m.remote_addr
        fields.request = m.request
        fields.status = m.status
        fields.bytes = m.bytes
        fields.protocol = m.protocol
        fields.backend_name = m.backend_name
        fields.backend_server = m.backend_server
        fields.http_host = m.http_host
    else
       -- Fail with return -1 or do whatever you want
       msg.Type = "Ignore"
       msg.Payload = fields.msg
    end
    fields.msg = nil

    --msg.Fields = fields
    inject_message(msg)
    return 0
end
