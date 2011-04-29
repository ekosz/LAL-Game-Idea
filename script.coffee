socket = new io.Socket(null, {port: 8080, rememberTransport: false})
socket.connect()

socket.on 'message', (obj) ->

  # Change the #message to new message
  if 'message' in obj
    $("#message").innerHTML obj.message

  else if 'state' in obj
    $("#otherClients ul").empty() # Clear list of agreeing users
    $("#question").innerHTML obj.state.question # Change #question to new question
    $("#awnsers").empty() # Remove the old awnsers
    for awnser in obj.state.awnsers
      div = document.createElement('div')
      div.innerHTML = awnser
      $("#awnsers").append div # Add new awnsers

  else if 'otherClients' in obj
    for client in obj.otherClients
      li = document.createElement('li')
      li.innerHTML = client 
      $('#otherClients ul').append li # Add agreeing users
