{Robot, Adapter, TextMessage, EnterMessage, LeaveMessage, Response} = require process.env.HUBOT_ASAKUSA_HUBOT

if process.env.HUBOT_ASAKUSA_SSL?
  HTTP = require 'https'
else
  HTTP = require 'http'

EventEmitter = require('events').EventEmitter
WebSocketClient = require('websocket').client

class Asakusa extends Adapter
 send: (user, strings...) ->
   console.log "Sending strings to user: " + user
   @bot.send user, strings

 run: ->
   self = @
   options =
    domain      : process.env.HUBOT_ASAKUSA_DOMAIN
    room_id     : process.env.HUBOT_ASAKUSA_ROOM_ID
    secret      : process.env.HUBOT_ASAKUSA_SECRET
    ws_url      : process.env.HUBOT_ASAKUSA_WS_URL
    is_v2_3     : process.env.HUBOT_ASAKUSA_V2_3?
   console.log options
   bot = new AsakusaStreaming(options)
   name = process.env.HUBOT_ASAKUSA_NAME

   bot.open options, (data,err) ->
     if data.name is name
       return
     if @is_v2_3
       self.receive new TextMessage data.name, data.body
     else
       self.receive new TextMessage data.name, data.body, null

   @bot = bot
   self.emit 'connected'

exports.use = (robot) ->
 new Asakusa robot

class AsakusaStreaming extends EventEmitter
 self = @
 constructor: (options) ->
    if options.domain? and options.room_id? and options.secret? and options.ws_url?
      @api           = '/api/v1'
      @domain        = options.domain
      @room_id       = options.room_id
      @secret        = options.secret
      @ws_url        = options.ws_url
      @is_v2_3       = options.is_v2_3
    else
      throw new Error("Not enough parameters provided.")

 send: (user,text,callback) ->
   if @is_v2_3
     console.log "v2.3"
     @post "#{@api}/message.json", "message=> #{user}\n#{text}&room_id=#{@room_id}&api_key=#{@secret}", callback
   else
     console.log "v2.4"
     @post "#{@api}/message.json", "message=> #{user.user}\n#{text}&room_id=#{@room_id}&api_key=#{@secret}", callback

 get: (path, callback) ->
   @request "GET", path, null, callback

 post: (path, body, callback) ->
   @request "POST", path, body, callback

 open: (options, callback) ->
   subscribed = false
   client = new WebSocketClient()
   client.on 'connectionFailed', (err) ->
     console.log "Connect error: #{err}"
   client.on 'connect', (connection) ->
     connection.on 'error', (error) ->
       console.log "Connection error: #{error}"

     connection.on 'close', () ->
       console.log "connection closed."

     connection.on "message", (message) ->
       if subscribed == false
         subscribe =
          "event"  : "socky:subscribe"
          "channel" : "as-#{options.room_id}"
          "connection_id" : JSON.parse(message.utf8Data).connection_id
         tmp = JSON.stringify(subscribe)
         connection.sendUTF(tmp)
         subscribed = true
       else
         try
           data = JSON.parse JSON.parse JSON.parse(message.utf8Data).data
           callback data.content,null
         catch err
           console.log "error:#{message}"

   client.connect("ws://#{@ws_url}")

 request: (method, path, body, callback) ->
   console.log "http://#{@domain}#{path}"

   options =
     host: @domain
     path: path
     method: method

   data =''
   res = (response) ->
     response.on "data", (chunk) ->
       console.log 'data '+chunk
       data += chunk

     response.on "end", () ->
       console.log 'end request'
       obj = JSON.parse(data)
       if callback
         callback obj,null

     response.on "error", (data) ->
       console.log 'error '+data

   request = HTTP.request options, res
   if method == "POST"
     request.write(body)
   request.end()
