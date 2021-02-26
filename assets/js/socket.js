import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})


socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:dash", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("update", (message) => {
  console.log("message", message)
  update_bar(message)

});

function update_bar(message) {
  switch(message.obd_pid){
    case "speed":
      var bar1 = document.getElementById('speed').ldBar;
      bar1.set(message.value);
      break;
    case "rpm":
      var bar1 = document.getElementById('rpm').ldBar;
      bar1.set(message.value); // set second arg to false to disable animation
      break;
  }
}

export default socket
