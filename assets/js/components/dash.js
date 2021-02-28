import React from "react";
import { Socket } from "phoenix";

import Gauge from './gauge'

class Dash extends React.Component {
  constructor() {
    super();

    let socket = new Socket("/socket", {
      params:
        { token: window.userToken }
    });
    socket.connect();

    this.channel = socket.channel("room:dash", {});
  }

  componentDidMount() {
    this.channel.join()
      .receive("ok", response => { console.log("Joined successfully", response) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  render() {
    return (
      <div>
        <Gauge name="rpm" max_value={6500} channel={this.channel} />
        <Gauge name="speed" max_value={200} channel={this.channel} />
      </div>)
  }
}

export default Dash