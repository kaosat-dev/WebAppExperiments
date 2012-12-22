// RTCPeerConnection setup and offer-answer exchange omitted
var dc1 = pc1.createDataChannel("mylabel");  // create the sending RTCDataChannel (reliable mode)
var dc2 = pc2.createDataChannel("mylabel");  // create the receiving RTCDataChannel (reliable mode)

// append received RTCDataChannel messages to a textarea
var receiveTextarea = document.querySelector("textarea#receive");
dc2.onmessage = function(event) {
  receiveTextarea.value += event.data;
};

var sendInput = document.querySelector("input#send");
// send message over the RTCDataChannel
function onSend() {
  dc1.send(sendInput.value);
}

/**
 * Assume we've connected a PeerConnection with a friend - usually with audio
 * and/or video.  For the time being, always at least include a 'fake' audio
 * stream - this will be fixed soon.
 *
 * connectDataConnection is a temporary function that will soon disappear.
 * The two sides need to use inverted copies of the two numbers (eg. 5000, 5001
 * on one side, 5001, 5000 on the other)
 */
pc.connectDataConnection(5001, 5000);
 
function handle_new(channel) {
  channel.binaryType = "blob";
  channel.onmessage = function(evt) {
    if (evt.data instanceof Blob) {
      console.log("I received a blob");
      // assign data to an image, save in a file, etc
    } else {
      console.log("I got a message: " + evt.data);
    }
  };
 
  channel.onopen = function() {
    // We can now send, like WebSockets
    channel.send("The channel is open!");
  };
 
  channel.onclose = function() {
    console.log("pc1 onclose fired");
  };
};
 
/* For when the other side creates a channel */
pc.onDataChannel = handle_new;
 
channel = pc.createDataChannel("My Datastream",{});
if (channel) {
  handle_new(channel);
}