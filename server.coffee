http = require('http')
io = require('socket.io')

### Fuctions ###
################
nextState = () ->
  # Go to database, pick random question, that hasn't asked in a while

update = () ->
  for choice in choices
    for client in choice
      client.send {otherClients: choice}
  socket.broadcast {state: nextState()}
  choices = {}


### WEB SERVER ####
###################
server = http.createServer (req, res) ->
  res.writeHead 200, {'Content-Type': 'text/html'}
  # res.end File.read "public/index.html"

server.listen(80)

### WEB SOCKET SERVER ###
#########################
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
    "Kiss",
    "Hug",
    "Cuddle",
    "Sex"
  ]
}

choices = {}
nameHash = {}

setInterval update, 10000

