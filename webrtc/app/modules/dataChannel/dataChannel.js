// Generated by CoffeeScript 1.3.3
var channel1, channel2, datachannels, dc1, dc2, fake_audio, iter, iter2, log, num_channels, pc1, pc1_offer, pc2, pc2_answer, sendit, start, step1, step1_5, step2, step3, step4, step5, step6, step7, stop, submitenter;

pc1 = null;

pc2 = null;

dc1 = null;

dc2 = null;

channel1 = null;

channel2 = null;

num_channels = 0;

datachannels = new Array(0);

pc1_offer = null;

pc2_answer = null;

iter = 0;

iter2 = 0;

fake_audio = null;

log = function(msg) {
  var div;
  div = document.getElementById("datawindow");
  return div.innerHTML = div.innerHTML + "<p>" + msg + "</p>";
};

submitenter = function(myfield, e) {
  var keycode;
  keycode = null;
  if (window.event) {
    keycode = window.event.keyCode;
  } else if (e) {
    keycode = e.which;
  } else {
    return true;
  }
  if (keycode === 13) {
    myfield.form.submit();
    return false;
  }
  return true;
};

sendit = function(which) {
  iter = iter + 1;
  if (which === 1) {
    dc1.send(text_pc1.value);
    return text_pc1.value = "";
  } else if (which === 2) {
    dc2.send(text_pc2.value);
    return text_pc2.value = "";
  } else {
    return log("Unknown send " + which);
  }
};

step1 = function(offer) {
  pc1_offer = offer;
  return pc1.setLocalDescription(offer, step1_5, failed);
};

step1_5 = function() {
  return setTimeout(step2, 0);
};

step2 = function() {
  pc2 = new mozRTCPeerConnection();
  pc2.ondatachannel = function(channel) {
    log("pc2 onDataChannel [" + num_channels + "] = " + channel + ", label='" + channel.label + "'");
    dc2 = channel;
    datachannels[num_channels] = channel;
    num_channels++;
    log("pc2 created channel " + dc2 + " binarytype = " + dc2.binaryType);
    channel.binaryType = "blob";
    log("pc2 new binarytype = " + dc2.binaryType);
    channel.onmessage = function(evt) {
      iter2 = iter2 + 1;
      if (evt.data instanceof Blob) {
        return fancy_log("*** pc1 sent Blob: " + evt.data + ", length=" + evt.data.size, "red");
      } else {
        return fancy_log("*** pc1 said: " + evt.data + ", length=" + evt.data.length, "red");
      }
    };
    channel.onopen = function() {
      log("*** pc2 onopen fired, sending to " + channel);
      return channel.send("pc2 says Hi there!");
    };
    channel.onclose = function() {
      return log("*** pc2 onclose fired");
    };
    log("*** pc2 state:" + channel.readyState);
    if (channel.readyState !== 0) {
      return log("*** pc2 no onopen??! possible race");
    }
  };
  pc2.onconnection = function() {
    return log("pc2 onConnection ");
  };
  pc2.onclosedconnection = function() {
    return log("pc2 onClosedConnection ");
  };
  pc2.addStream(fake_audio);
  pc2.onaddstream = function(obj) {
    return log("pc2 got remote stream from pc1 " + obj.type);
  };
  return pc2.setRemoteDescription(pc1_offer, step3, failed);
};

step3 = function() {
  return pc2.createAnswer(step4, failed);
};

step4 = function(answer) {
  pc2_answer = answer;
  return pc2.setLocalDescription(answer, step5, failed);
};

step5 = function() {
  return pc1.setRemoteDescription(pc2_answer, step6, failed);
};

step6 = function() {
  log("MakeDataCh");
  return setTimeout(step7, 2000);
};

step7 = function() {
  pc1.connectDataConnection(5000, 5001);
  pc2.connectDataConnection(5001, 5000);
  return log("connect for data channel called");
};

start = function() {
  button.innerHTML = "Stop!";
  button.onclick = stop;
  pc1 = new mozRTCPeerConnection();
  pc1.onaddstream = function(obj) {
    return log("pc1 got remote stream from pc2 " + obj.type);
  };
  pc1.ondatachannel = function(channel) {
    log("pc1 onDataChannel [" + num_channels + "] = " + channel + ", label='" + channel.label + "'");
    datachannels[num_channels] = channel;
    num_channels++;
    channel.onmessage = function(evt) {
      if (evt.data instanceof Blob) {
        return fancy_log("*** pc2 sent Blob: " + evt.data + ", length=" + evt.data.size, "blue");
      } else {
        return fancy_log("pc2 said: " + evt.data + ", length=" + evt.data.length, "blue");
      }
    };
    channel.onopen = function() {
      log("pc1 onopen fired for " + channel);
      channel.send("pc1 says Hello out there...");
      return log("pc1 state: " + channel.state);
    };
    channel.onclose = function() {
      return log("pc1 onclose fired");
    };
    log("pc1 state:" + channel.readyState);
    if (channel.readyState !== 0) {
      return log("*** pc1 no onopen??! possible race");
    }
  };
  pc1.onconnection = function() {
    var channel;
    log("pc1 onConnection ");
    dc1 = pc1.createDataChannel("This is pc1", {});
    log("pc1 created channel " + dc1 + " binarytype = " + dc1.binaryType);
    channel = dc1;
    channel.binaryType = "blob";
    log("pc1 new binarytype = " + dc1.binaryType);
    channel.onmessage = function(evt) {
      if (evt.data instanceof Blob) {
        return fancy_log("*** pc2 sent Blob: " + evt.data + ", length=" + evt.data.size, "blue");
      } else {
        return fancy_log("pc2 said: " + evt.data, "blue");
      }
    };
    channel.onopen = function() {
      log("pc1 onopen fired for " + channel);
      channel.send("pc1 says Hello...");
      return log("pc1 state: " + channel.state);
    };
    channel.onclose = function() {
      return log("pc1 onclose fired");
    };
    return log("pc1 state:" + channel.readyState);
  };
  pc1.onclosedconnection = function() {
    return log("pc1 onClosedConnection ");
  };
  return navigator.mozGetUserMedia({
    audio: true,
    fake: true
  }, (function(s) {
    pc1.addStream(s);
    fake_audio = s;
    return pc1.createOffer(step1, failed);
  }), function(err) {
    return alert("Error " + err);
  });
};

stop = function() {
  pc1.close();
  pc2.close();
  button.innerHTML = "Start!";
  return button.onclick = start;
};
