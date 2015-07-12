# Description:
#   Example scripts for you to examine and try out.
#

{knuthShuffle} = require 'knuth-shuffle'


module.exports = (robot) ->

  robot.respond /assign/m, (res) ->
    tokens = res.message.text.split(/\s+/)
    members = tokens.filter (token) -> token.match /^@/
    rooms = tokens.filter (token) -> token.match /^#/
    if members.length > 0 and rooms.length > 0
      rooms.forEach (room) ->
        robot.brain.set "members#{room}", members
        robot.brain.set "current#{room}", members[0]
        res.reply "Assigned #{members.join ', '} in #{room}"

  robot.respond /list members/, (res) ->
    room = '#' + res.message.room
    members = robot.brain.get "members#{room}"
    current = robot.brain.get "current#{room}"
    if members
      membersWithCursor = members.map (member) ->
        if member == current then "#{member} <- now" else member
      res.reply "I know members in #{room}\n#{membersWithCursor.join '\n'}"
    else
      res.reply "I don't know #{room}, please tell me `assign #{room} @members...` first"

  robot.respond /shuffle member/, (res) ->
    room = '#' + res.message.room
    members = robot.brain.get "members#{room}"
    if members
      res.reply "Shuffled"
    else
      res.reply "I don't know #{room}, please tell me `assign #{room} @members...` first"

  robot.respond /who is next/, (res) ->
    room = '#' + res.message.room
    members = robot.brain.get "members#{room}"
    current = robot.brain.get "current#{room}"
    if members
      nextIndex = members.indexOf(current) + 1
      current = members[nextIndex % current.length]
      robot.brain.set "current#{room}", current
      res.reply "Hey, next is #{current}"
    else
      res.reply "I don't know #{room}, please tell me `assign #{room} @members...` first"

