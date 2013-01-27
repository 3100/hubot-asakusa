{Robot, Adapter, TextMessage, Response} = require process.env.HUBOT_ASAKUSA_HUBOT

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
    room_ids    : process.env.HUBOT_ASAKUSA_ROOM_ID.split ';'
    secret      : process.env.HUBOT_ASAKUSA_SECRET
    ws_url      : process.env.HUBOT_ASAKUSA_WS_URL
    is_v2_3     : process.env.HUBOT_ASAKUSA_V2_3?
   console.log options
   bot = new AsakusaStreaming(options)
   name = process.env.HUBOT_ASAKUSA_NAME

   bot.open (data,err) ->
     if data.name is name
       return
     if @is_v2_3
       self.receive new TextMessage data.name, data.body
     else
       self.receive new TextMessage data.name, data.body, data.room.id

   @bot = bot
   self.emit 'connected'

exports.use = (robot) ->
 new Asakusa robot

class AsakusaStreaming extends EventEmitter
 self = @
 constructor: (options) ->
    if options.domain? and options.room_ids? and options.secret? and options.ws_url? and options.is_v2_3?
      @api           = '/api/v1'
      @domain        = options.domain
      @room_ids      = options.room_ids
      @secret        = options.secret
      @ws_url        = options.ws_url
      @is_v2_3       = options.is_v2_3
    else
      throw new Error("Not enough parameters provided.")

 send: (user,text,callback) ->
   if @is_v2_3
     @post "#{@api}/message.json", "message=> #{user}\n#{text}&room_id=#{@room_ids[0]}&api_key=#{@secret}", callback
   else
     @post "#{@api}/message.json", "message=> #{user.user}\n#{text}&room_id=#{user.message.id}&api_key=#{@secret}", callback

 get: (path, callback) ->
   @request "GET", path, null, callback

 post: (path, body, callback) ->
   @request "POST", path, body, callback

 open: (callback) ->
   options =
     subscribed        : false
     subscribing_count : 0
     room_ids          : @room_ids
   client = new WebSocketClient()
   client.on 'connectionFailed', (err) ->
     console.log "Connect error: #{err}"
   client.on 'connect', (connection) ->
     connection.on 'error', (error) ->
       console.log "Connection error: #{error}"

     connection.on 'close', () ->
       console.log "connection closed."

     connection.on "message", (message) ->
       if options.subscribing_count > 0
         console.log message
         options.subscribing_count -= 1
       else if options.subscribed is false
         for room_id in options.room_ids
           subscribe connection, message, room_id
           options.subscribing_count += 1
         options.subscribed = true
       else
         try
           data = JSON.parse JSON.parse JSON.parse(message.utf8Data).data
           callback data.content,null
         catch err
           console.log "error:#{err}"

   subscribe = (connection, message, room_id) ->
     info =
      "event"  : "socky:subscribe"
      "channel" : "as-#{room_id}"
      "connection_id" : JSON.parse(message.utf8Data).connection_id
     connection.sendUTF JSON.stringify info

   client.connect("ws://#{@ws_url}")

 request: (method, path, body, callback) ->
   console.log "#{@domain}#{path}"

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
