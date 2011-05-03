(function() {
  /* FUNCTIONS */  var choice, createMessage, socket, tick;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  tick = function() {
    if (parseInt($("#timer").text) !== 0) {
      $("#timer").text(parseInt($("#timer").text()) - 1);
    }
    return setTimeout(tick, 1000);
  };
  createMessage = function(message) {
    var p;
    p = document.createElement('p');
    p.innerHTML = message;
    p.className = 'message';
    p.id = Math.floor(Math.random() * 1000);
    $("#message").append(p);
    return setTimeout("$('#" + p.id + "').fadeOut(function() { $('#" + p.id + "').remove();});", 5000);
  };
  choice = null;
  /* WEB SOCKET */
  socket = new io.Socket(null, {
    port: 9393
  });
  socket.connect();
  socket.on('connect', function() {
    return createMessage('Connected!');
  });
  socket.on('message', function(obj) {
    var client, li, _i, _len, _ref, _results;
    if (__indexOf.call(Object.keys(obj), 'message') >= 0) {
      return createMessage(obj.message);
    } else if (__indexOf.call(Object.keys(obj), 'name') >= 0) {
      return $("#name").text(obj.name);
    } else if (__indexOf.call(Object.keys(obj), 'state') >= 0) {
      choice = null;
      $("#timer").fadeOut(function() {
        $("#timer").text(obj.state.timeLeft);
        return $("#timer").fadeIn();
      });
      $("#otherClients").empty();
      $("#question").fadeOut(function() {
        $("#question").text(obj.state.question);
        return $("#question").fadeIn();
      });
      return $("#awnsers").fadeOut(function() {
        var awnser, div, _i, _len, _ref;
        $("#awnsers").empty();
        _ref = obj.state.awnsers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          awnser = _ref[_i];
          div = document.createElement('div');
          div.innerHTML = awnser;
          div.className = 'awnser';
          $(div).click(function() {
            if (!choice) {
              choice = this;
              $(this).css('background-color', 'blue');
              return socket.send({
                choice: $(this).text()
              });
            } else {
              return $(choice).stop().animate({
                backgroundColor: "red"
              }, 250).animate({
                backgroundColor: "blue"
              }, 750);
            }
          });
          $("#awnsers").append(div);
        }
        return $("#awnsers").fadeIn();
      });
    } else if (__indexOf.call(Object.keys(obj), 'otherClients') >= 0) {
      _ref = obj.otherClients;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        client = _ref[_i];
        li = document.createElement('li');
        li.innerHTML = client;
        _results.push($('ul').append(li));
      }
      return _results;
    }
  });
  socket.on('disconnect', function() {
    return createMessage("Disconnected!");
  });
  /* MAIN LOOP */
  tick();
}).call(this);
