(function() {
  var choice, socket;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  choice = null;
  socket = new io.Socket(null, {
    port: 8080,
    rememberTransport: false
  });
  socket.connect();
  socket.on('connect', function() {
    return $("#message").append("<br />Connected!!");
  });
  socket.on('message', function(obj) {
    var client, li, _i, _len, _ref, _results;
    if (__indexOf.call(Object.keys(obj), 'message') >= 0) {
      console.log("Message recived: " + obj.message);
      return $("#message").innerHTML(obj.message);
    } else if (__indexOf.call(Object.keys(obj), 'state') >= 0) {
      console.log('State recived');
      choice = null;
      $("#otherClients ul").empty();
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
              return $(choice).animate({
                backgroundColor: "#FF0000"
              }, 500).animate({
                backgroundColor: "#0000FF"
              }, 1000);
            }
          });
          $("#awnsers").append(div);
        }
        return $("#awnsers").fadeIn();
      });
    } else if (__indexOf.call(Object.keys(obj), 'otherClients') >= 0) {
      console.log("otherClients recived! " + obj);
      _ref = obj.otherClients;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        client = _ref[_i];
        li = document.createElement('li');
        li.innerHTML = client;
        _results.push($('#otherClients ul').append(li));
      }
      return _results;
    }
  });
  socket.on('disconnect', function() {
    return $("#message").append("<br />Disconnected!");
  });
}).call(this);
