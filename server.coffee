http = require('http')
io = require('socket.io')

server = http.createServer (req, res) ->
  res.writeHead 200, {'Content-Type': 'text/html'}
  # res.end HTMLFile

server.listen(80)

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

nextState = () ->
  # Go to database, pick random question, that hasn't asked in a while

update = () ->
  for choice in choices
    for client in choice
      client.send {otherClients: choice}
  socket.broadcast {state: nextState()}
  choices = {}

setInterval update, 10000

