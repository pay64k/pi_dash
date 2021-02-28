import "../css/app.scss"

import socket from "./socket"

import "phoenix_html"

var loadingioBar = require("loadingio-bar")

import React from 'react'
import ReactDOM from 'react-dom'

import Clock from './components/clock'

ReactDOM.render(
    <Clock />,
    document.getElementById('root')
  );
