(function() {
  var socket;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  socket = new io.Socket(null, {
    port: 8080,
    rememberTransport: false
  });
  socket.connect();
  socket.on('connect', function() {
    return $("#message").append("<br />Connected!!");
  });
  socket.on('message', function(obj) {
    var awnser, client, div, li, _i, _j, _len, _len2, _ref, _ref2, _results, _results2;
    console.log(obj);
    if (__indexOf.call(Object.keys(obj), 'message') >= 0) {
      console.log("Message recived: " + obj.message);
      return $("#message").innerHTML(obj.message);
    } else if (__indexOf.call(Object.keys(obj), 'state') >= 0) {
      console.log('State recived');
      $("#otherClients ul").empty();
      $("#question").text(obj.state.question);
      $("#awnsers").empty();
      _ref = obj.state.awnsers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        awnser = _ref[_i];
        div = document.createElement('div');
        div.innerHTML = awnser;
        div.className = 'awnser';
        _results.push($("#awnsers").append(div));
      }
      return _results;
    } else if (__indexOf.call(Object.keys(obj), 'otherClients') >= 0) {
      _ref2 = obj.otherClients;
      _results2 = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        client = _ref2[_j];
        li = document.createElement('li');
        li.innerHTML = client;
        _results2.push($('#otherClients ul').append(li));
      }
      return _results2;
    }
  });
  socket.on('disconnect', function() {
    return $("#message").append("<br />Disconnected!");
  });
}).call(this);
