### FUNCTIONS ###
#################

tick = () ->
  $("#timer").text parseInt($("#timer").text())-1 unless parseInt($("#timer").text) == 0
  setTimeout tick, 1000

createMessage = (message) ->
  p = document.createElement('p')
  p.innerHTML = message
  p.className = 'message'
  p.id = Math.floor(Math.random()*1000)
  $("#message").append p
  setTimeout "$('#"+p.id+"').fadeOut(function() { $('#"+p.id+"').remove();});", 5000

choice = null

### WEB SOCKET ###
##################

socket = new io.Socket(null, {port: 9393})
socket.connect()

socket.on 'connect', () ->
  createMessage('Connected!')

socket.on 'message', (obj) ->
  if 'message' in Object.keys obj
    createMessage(obj.message) # Add message

  else if 'name' in Object.keys(obj)
    $("#name").text obj.name

  else if 'state' in Object.keys(obj)
    choice = null #Reset the choice

    $("#timer").fadeOut () ->
      $("#timer").text obj.state.timeLeft # Update Timeleft
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
  createMessage("Disconnected!")

### MAIN LOOP ####
##################

tick()
