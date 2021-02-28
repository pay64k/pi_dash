import "../css/app.scss"

import "phoenix_html"

import React from 'react'
import ReactDOM from 'react-dom'

import Dash from "./components/dash";
import Clock from './components/clock'

class App extends React.Component {
  render() {
    return (
      <div>
      <Dash />
      <Clock />
      </div>
    )
  }
}

ReactDOM.render(
  <App/>,
  document.getElementById("root")
)