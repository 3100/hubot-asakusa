# Hubot AsakusaSatellite Adapter

## Description

This is an AsakusaSatellite adapter for hubot.

## Installation and Setup

NOTICE: This bot is for 2.4.6. It only works when you select Socky as your WebSocket server.

* Run `npm install hubot-asakusa --save` in the extracted `Hubot` directory to add the `hubot-asakusa` adapter to your dependencies.
* Install dependencies with `npm install`
* Set your environment variables like: (Windows Users substitute `set` for `export`)
      * export HUBOT_ASAKUSA_DOMAIN="http://localhost/"
      * export HUBOT_ASAKUSA_HUBOT="/path/to/hubot/"
      * export HUBOT_ASAKUSA_NAME="hu bot"
      * export HUBOT_ASAKUSA_ROOM_ID="50ba5a0422d330235500000a"
      * export HUBOT_ASAKUSA_SECRET="uDEPRjLafZgiiHrxu1Aw"
      * Run hubot with `bin/hubot -a asakusa`

## Usage

You will need to set some environment variables to use this adapter.

### Heroku

I do not know if this bot works well with Heroku because you have to set require path to hubot.
    % heroku config:add HUBOT_ASAKUSA_DOMAIN="http://localhost/"
    % heroku config:add HUBOT_ASAKUSA_HUBOT="hubot"
    % heroku config:add HUBOT_ASAKUSA_NAME="hu bot"
    % heroku config:add HUBOT_ASAKUSA_ROOM_ID="50ba5a0422d330235500000a"
    % heroku config:add HUBOT_ASAKUSA_SECRET="uDEPRjLafZgiiHrxu1Aw"

### Non-Heroku environment variables
    % export HUBOT_ASAKUSA_DOMAIN="http://localhost/"
    % export HUBOT_ASAKUSA_HUBOT="/path/to/hubot/"
    % export HUBOT_ASAKUSA_NAME="hu bot"
    % export HUBOT_ASAKUSA_ROOM_ID="50ba5a0422d330235500000a"
    % export HUBOT_ASAKUSA_SECRET="uDEPRjLafZgiiHrxu1Aw"

## TODO
* Support older version of Hubot
* Support Pusher and Keima
