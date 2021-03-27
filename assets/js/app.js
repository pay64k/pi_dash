import "../css/app.scss"

import "phoenix_html"

import { Socket } from "phoenix";

import React from 'react'
import ReactDOM from 'react-dom'

import { ThemeProvider } from 'styled-components';
import { lightTheme, darkTheme } from './themes/theme';
import { GlobalStyles } from './themes/global';


import Controller from "./components/controller";

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      theme: lightTheme
    }

    let socket = new Socket("/socket", {
      params:
        { token: window.userToken }
    });
    socket.connect();

    this.channel = socket.channel("room:dash", {});
  }

  maybe_start_pid_worker_cb = (pid) => {
    this.maybe_start_pid_worker(pid)
  }

  setTheme_cb = (new_theme) => {
    let theme
    switch (new_theme) {
      case "light":
        theme = lightTheme
        break;
      case "dark":
        theme = darkTheme
        break;
    }
    this.setState({
      theme: theme
    })
  }

  componentDidMount() {
    this.channel.join()
      .receive("ok", response => { console.log("Joined successfully", response) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  render() {
    return (
      <ThemeProvider theme={this.state.theme}>
        <>
          <GlobalStyles />
          <Controller channel={this.channel} setTheme_cb={this.setTheme_cb} />
        </>
      </ThemeProvider>
    )
  }
}

ReactDOM.render(
  <App />,
  document.getElementById("root")
)

