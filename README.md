# Hubot AsakusaSatellite Adapter

## Description

This is an AsakusaSatellite adapter for hubot.

## Installation and Setup

NOTICE: To use this adapter, you need Hubot(>= v2.3.0). This adapter only works when you select Socky as your WebSocket server.

* Run `npm install hubot-asakusa --save` in the extracted `Hubot` directory to add the `hubot-asakusa` adapter to your dependencies.
* Install dependencies with `npm install`
* Set your environment variables like: (Windows Users substitute `set` for `export`)
      * export HUBOT_ASAKUSA_DOMAIN="localhost"
      * export HUBOT_ASAKUSA_HUBOT="/path/to/hubot/"
      * export HUBOT_ASAKUSA_NAME="hu bot"
      * export HUBOT_ASAKUSA_ROOM_ID="50ba5a0422d330235500000a;50ba5a0432c230424300001a"
      * export HUBOT_ASAKUSA_SECRET="uDEPRjLafZgiiHrxu1Aw"
      * export HUBOT_ASAKUSA_WS_URL="localhost:3002/websocket/as"
      * Run hubot with `bin/hubot -a asakusa`
* If you use SSL to request to your AsakusaSatellite, set another environment valiable:
      * export HUBOT_ASAKUSA_SSL="foo"
* If your Hubot version is v2.3:
      * export HUBOT_ASAKUSA_V2_3="bar"
      * You can set only single room id to HUBOT_ASAKUSA_ROOM_ID

## Usage

You will need to set some environment variables to use this adapter.

### Heroku

I do not know if this bot works well with Heroku because you have to set require path to hubot.

    % heroku config:add HUBOT_ASAKUSA_DOMAIN="your.herokuapp.com"
    % heroku config:add HUBOT_ASAKUSA_HUBOT="hubot"
    % heroku config:add HUBOT_ASAKUSA_NAME="hu bot"
    % heroku config:add HUBOT_ASAKUSA_ROOM_ID="50ba5a0422d330235500000a"
    % heroku config:add HUBOT_ASAKUSA_SECRET="uDEPRjLafZgiiHrxu1Aw"
    % heroku config:add HUBOT_ASAKUSA_WS_URL="your.ws.url"

### Non-Heroku environment variables
    % export HUBOT_ASAKUSA_DOMAIN="localhost"
    % export HUBOT_ASAKUSA_HUBOT="/path/to/hubot/"
    % export HUBOT_ASAKUSA_NAME="hu bot"
    % export HUBOT_ASAKUSA_ROOM_ID="50ba5a0422d330235500000a"
    % export HUBOT_ASAKUSA_SECRET="uDEPRjLafZgiiHrxu1Aw"
    % export HUBOT_ASAKUSA_WS_URL="localhost:3002/websocket/as"

## TODO
* Support Pusher and Keima
