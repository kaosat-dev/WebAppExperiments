
  
pc1=null
pc2=null

dc1=null
dc2=null
channel1=null
channel2=null
num_channels = 0
datachannels = new Array(0)

pc1_offer=null
pc2_answer=null
iter = 0
iter2 = 0

fake_audio = null
 
log = (msg) ->
  div = document.getElementById("datawindow")
  div.innerHTML = div.innerHTML + "<p>" + msg + "</p>"

submitenter=(myfield,e)->
  keycode=null
  if (window.event) 
    keycode = window.event.keyCode
  else if (e) 
    keycode = e.which
  else return true

  if (keycode == 13) 
    myfield.form.submit()
    return false
  return true

sendit=(which)->
  iter = iter + 1
  #log("Sending message #" + iter + " this = " + this)
  if (which == 1) 
    dc1.send(text_pc1.value)
    text_pc1.value = ""
  else if (which == 2)
    dc2.send(text_pc2.value)
    text_pc2.value = ""
  else
    log("Unknown send " + which)


step1=(offer)->
  pc1_offer = offer
  pc1.setLocalDescription(offer, step1_5, failed)

step1_5= ->
 setTimeout step2, 0
 
# pc1.setLocal finished, call pc2.setRemote
step2 = ->
  pc2 = new mozRTCPeerConnection()
  pc2.ondatachannel = (channel) ->
    log "pc2 onDataChannel [" + num_channels + "] = " + channel + ", label='" + channel.label + "'"
    dc2 = channel
    datachannels[num_channels] = channel
    num_channels++
    log "pc2 created channel " + dc2 + " binarytype = " + dc2.binaryType
    channel.binaryType = "blob"
    log "pc2 new binarytype = " + dc2.binaryType
    channel.onmessage = (evt) ->
      iter2 = iter2 + 1
      if evt.data instanceof Blob
        fancy_log "*** pc1 sent Blob: " + evt.data + ", length=" + evt.data.size, "red"
      else
        fancy_log "*** pc1 said: " + evt.data + ", length=" + evt.data.length, "red"

    channel.onopen = ->
      log "*** pc2 onopen fired, sending to " + channel
      channel.send "pc2 says Hi there!"

    channel.onclose = ->
      log "*** pc2 onclose fired"

    log "*** pc2 state:" + channel.readyState
    
    # There's a race condition with onopen; if the channel is already
    # open it should fire after onDataChannel -- state should normally be 0 here
    log "*** pc2 no onopen??! possible race"  unless channel.readyState is 0

  pc2.onconnection = ->
    log "pc2 onConnection "

  #dc2 = pc2.createDataChannel();
  #log("pc2 created channel " + dc2);
  pc2.onclosedconnection = ->
    log "pc2 onClosedConnection "

  pc2.addStream fake_audio
  pc2.onaddstream = (obj) ->
    log "pc2 got remote stream from pc1 " + obj.type

  pc2.setRemoteDescription pc1_offer, step3, failed
 
# pc2.setRemote finished, call pc2.createAnswer
step3 = ->
  pc2.createAnswer step4, failed

# pc2.createAnswer finished, call pc2.setLocal
step4 = (answer) ->
  pc2_answer = answer
  pc2.setLocalDescription answer, step5, failed

# pc2.setLocal finished, call pc1.setRemote
step5 = ->
  pc1.setRemoteDescription pc2_answer, step6, failed

# pc1.setRemote finished, make a data channel
step6 = ->
  log "MakeDataCh"
  setTimeout step7, 2000
  
step7 = ->
  pc1.connectDataConnection 5000, 5001
  pc2.connectDataConnection 5001, 5000
  log "connect for data channel called"

start = ->
  button.innerHTML = "Stop!"
  button.onclick = stop
  pc1 = new mozRTCPeerConnection()
  pc1.onaddstream = (obj) ->
    log "pc1 got remote stream from pc2 " + obj.type

  pc1.ondatachannel = (channel) ->
    # In case pc2 opens a channel
    log "pc1 onDataChannel [" + num_channels + "] = " + channel + ", label='" + channel.label + "'"
    datachannels[num_channels] = channel
    num_channels++
    channel.onmessage = (evt) ->
      if evt.data instanceof Blob
        fancy_log "*** pc2 sent Blob: " + evt.data + ", length=" + evt.data.size, "blue"
      else
        fancy_log "pc2 said: " + evt.data + ", length=" + evt.data.length, "blue"

    channel.onopen = ->
      log "pc1 onopen fired for " + channel
      channel.send "pc1 says Hello out there..."
      log "pc1 state: " + channel.state

    channel.onclose = ->
      log "pc1 onclose fired"

    log "pc1 state:" + channel.readyState
    
    # There's a race condition with onopen; if the channel is already
    # open it should fire after onDataChannel -- state should normally be 0 here
    log "*** pc1 no onopen??! possible race"  unless channel.readyState is 0

  pc1.onconnection = ->
    log "pc1 onConnection "
    dc1 = pc1.createDataChannel("This is pc1", {}) # reliable (TCP-like)
    #  dc1 = pc1.createDataChannel("This is pc1",{outOfOrderAllowed: true, maxRetransmitNum: 0}); // unreliable (UDP-like)
    log "pc1 created channel " + dc1 + " binarytype = " + dc1.binaryType
    channel = dc1
    channel.binaryType = "blob"
    log "pc1 new binarytype = " + dc1.binaryType
    
    # Since we create the datachannel, don't wait for onDataChannel!
    channel.onmessage = (evt) ->
      if evt.data instanceof Blob
        fancy_log "*** pc2 sent Blob: " + evt.data + ", length=" + evt.data.size, "blue"
      else
        fancy_log "pc2 said: " + evt.data, "blue"

    channel.onopen = ->
      log "pc1 onopen fired for " + channel
      channel.send "pc1 says Hello..."
      log "pc1 state: " + channel.state

    channel.onclose = ->
      log "pc1 onclose fired"

    log "pc1 state:" + channel.readyState

  pc1.onclosedconnection = ->
    log "pc1 onClosedConnection "

  navigator.mozGetUserMedia
    audio: true
    fake: true
  , ((s) ->
    pc1.addStream s
    fake_audio = s
    pc1.createOffer step1, failed
  ), (err) ->
    alert "Error " + err

stop = ->
  pc1.close()
  pc2.close()
  button.innerHTML = "Start!"
  button.onclick = start