sys = require('sys')

TIME = 25
timer = TIME
choices = {}
nameHash = {}

### Fuctions ###
################
nextState = () ->
  # Go to database, pick random question, that hasn't asked in a while
  {
    question: "Would you rather...",
    awnsers: [
      "One",
      "Two",
      "Three",
      "Four"
    ],
    timeLeft: timer
  }

update = () ->
  console.log "Updating...."
  timer = TIME
  socket.broadcast {state: nextState()}
  for choice, clients of choices
    for client in clients
      client.send { otherClients: nameHash[c] for c in clients }
  choices = {}

findName = () ->
  "Someone" # Add more later

log = (statCode, url, ip, err) ->
  logStr = statCode + ' - ' + url + ' - ' + ip
  if (err)
    logStr += ' - ' + err
  console.log(logStr)

tick = () ->
  timer = timer - 1

### WEB SERVER ####
###################
path = require('path')
http = require('http')
paperboy = require('paperboy')

PORT = 9393
WEBROOT = path.join(path.dirname(__filename), 'public')

server = http.createServer (req, res) ->
  ip = req.connection.remoteAddress
  paperboy
    .deliver(WEBROOT, req, res)
    .addHeader('Expires', 300)
    .addHeader('X-PaperRoute', 'Node')
    .before( () ->
      console.log('Received Request')
    )
    .after( (statCode) ->
      log(statCode, req.url, ip)
    )
    .error( (statCode, msg) ->
      res.writeHead(statCode, {'Content-Type': 'text/plain'})
      res.end("Error " + statCode)
      log(statCode, req.url, ip, msg)
    )
    .otherwise( (err) ->
      res.writeHead(404, {'Content-Type': 'text/plain'})
      res.end("Error 404: File not found")
      log(404, req.url, ip, err)
    )

server.listen(PORT)

### WEB SOCKET SERVER ###
#########################
io = require('socket.io')
socket = io.listen(server)

socket.on 'connection', (client) ->
  # New Client
  nameHash[client] = findName() # Assign name to client

  client.send {state: nextState()}
  client.broadcast {message: nameHash[client]+" has joined"}

  client.on 'message', (data) ->
    if 'choice' in Object.keys data
      choices[data.choice] or= []
      choices[data.choice].push client

  client.on 'disconnect', () ->
    client.broadcast {message: nameHash[client]+" has left"}

### MAIN LOOP ###
#################


setInterval update, TIME*1000
setInterval tick, 1000

