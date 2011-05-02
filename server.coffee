### Fuctions ###
################
nextState = () ->
  # Go to database, pick random question, that hasn't asked in a while
  state

update = () ->
  console.log "Updating...."
  for choice of choices
    for client in choices[choice]
      client.send {otherClients: choice}
  socket.broadcast {state: nextState()}
  choices = {}

findName = () ->
  "Someone" # Add more later

log = (statCode, url, ip, err) ->
  logStr = statCode + ' - ' + url + ' - ' + ip
  if (err)
    logStr += ' - ' + err
  console.log(logStr)

### WEB SERVER ####
###################
path = require('path')
http = require('http')
paperboy = require('paperboy')

PORT = 8080
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

  client.send {state: state}
  client.broadcast {message: nameHash[client]+" has joined"}

  client.on 'message', (data) ->
    if 'choice' in data
      choices[data.choice].push client

  client.on 'disconnect', () ->
    client.broadcast {message: nameHash[client]+" has left"}

### MAIN LOOP ###
#################
state = {
  question: "Would you rather...",
  awnsers: [
    "One",
    "Two",
    "Three",
    "Four"
  ]
}

choices = {}
nameHash = {}

setInterval update, 25000

