import "../css/app.scss"

import "phoenix_html"

import { Socket } from "phoenix";

import React from 'react'
import ReactDOM from 'react-dom'

import Dash from "./components/dash";

import Footer from "./components/footer";

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
  }

  render() {
    return (
      <div>
        <Dash channel={this.channel} />
        <Footer channel={this.channel}/>
      </div>
    )
  }
}

ReactDOM.render(
  <App />,
  document.getElementById("root")
)