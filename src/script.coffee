socket = new io.Socket(null, {port: 8080, rememberTransport: false})
socket.connect()

socket.on 'connect', () ->
  $("#message").append("<br />Connected!!")

socket.on 'message', (obj) ->
  # Change the #message to new message
  if 'message' in Object.keys obj
    console.log "Message recived: "+obj.message
    $("#message").innerHTML obj.message

  else if 'state' in Object.keys(obj)
    console.log 'State recived'
    $("#otherClients ul").empty() # Clear list of agreeing users
    $("#question").text obj.state.question # Change #question to new question
    $("#awnsers").empty() # Remove the old awnsers
    for awnser in obj.state.awnsers
      div = document.createElement('div')
      div.innerHTML = awnser
      div.className = 'awnser'
      $("#awnsers").append div # Add new awnsers

  else if 'otherClients' in Object.keys obj
    for client in obj.otherClients
      li = document.createElement('li')
      li.innerHTML = client 
      $('#otherClients ul').append li # Add agreeing users

socket.on 'disconnect', () ->
  $("#message").append("<br />Disconnected!")
