tick = () ->
  $("#timer").text parseInt($("#timer").text())-1
  setTimeout tick, 1000

choice = null
socket = new io.Socket(null, {port: 9393})
socket.connect()

socket.on 'connect', () ->
  $("#message").append("<br />Connected!!")

socket.on 'message', (obj) ->
  # Change the #message to new message
  if 'message' in Object.keys obj
    $("#message").innerHTML obj.message

  else if 'state' in Object.keys(obj)
    choice = null #Reset the choice

    $("#timer").fadeOut () ->
      $("#timer").text obj.state.timeLeft
      $("#timer").fadeIn()


    $("#otherClients").empty() # Clear list of agreeing users

    $("#question").fadeOut () ->
      $("#question").text obj.state.question # Change #question to new question
      $("#question").fadeIn()

    $("#awnsers").fadeOut () ->
      $("#awnsers").empty() # Remove the old awnsers

      for awnser in obj.state.awnsers
        div = document.createElement('div')
        div.innerHTML = awnser
        div.className = 'awnser'
        $(div).click () ->
          unless choice
            choice = this
            $(this).css 'background-color', 'blue'
            socket.send {choice: $(this).text()} # Send the choice to the server
          else
            $(choice).stop().animate({backgroundColor:"red"}, 250).animate({backgroundColor:"blue"}, 750) # if there is a choice already

        $("#awnsers").append div # Add new awnsers
      $("#awnsers").fadeIn()

  else if 'otherClients' in Object.keys obj
    for client in obj.otherClients
      li = document.createElement('li')
      li.innerHTML = client 
      $('ul').append li # Add agreeing users

socket.on 'disconnect', () ->
  $("#message").append("<br />Disconnected!")

tick()
