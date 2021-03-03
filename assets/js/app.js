import "../css/app.scss"

import "phoenix_html"

import { Socket } from "phoenix";

import React from 'react'
import ReactDOM from 'react-dom'

import Dash from "./components/dash";
import Clock from './components/clock'

import { Button } from 'react-bootstrap';

class App extends React.Component {
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

    this.channel.on("status:elm_state", (message) => {
      console.log("got msg on status:", message)
    });
  }

  askForStatus(channel) {
    channel.push("status:elm_state", {})
  }

  render() {
    return (
      <div>
        <Dash channel={this.channel} />
        <Button onClick={() => this.askForStatus(this.channel)} variant="outline-secondary" size="sm">ELM status</Button>{' '}
        <Clock />
      </div>
    )
  }
}

ReactDOM.render(
  <App />,
  document.getElementById("root")
)