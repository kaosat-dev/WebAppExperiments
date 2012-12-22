
  
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

step1_5=()->
 setTimeout step2, 0
 
