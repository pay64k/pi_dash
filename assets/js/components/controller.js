import React from 'react'
import { Button, DropdownButton, Dropdown, ButtonGroup } from 'react-bootstrap';
import Clock from './clock'

import Dash from "./dash";

const active_pids = getFromLS("active_pids") || [];

class Controller extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = {
      elm_status: "unknown",
      supported_pids: [],
      active_pids: JSON.parse(JSON.stringify(active_pids))
    };
  }

  parse_and_set_ls_to_false(ap) {

  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.pushOnChannel("status:elm_status"),
      2000
    );

    this.channel.on("status:elm_status", (message) => {
      if (message.elm_status == "connected_configured" && this.state.elm_status != "connected_configured") {
        this.state.active_pids.map((pid) =>
          this.maybe_start_pid_worker(pid)
        )
        this.pushOnChannel("status:supported_pids")
      }

      this.setState({
        elm_status: message.elm_status
      });
    });

    this.channel.on("status:supported_pids", (message) => {
      this.setState({
        supported_pids: message.supported_pids
      });
    });
  }

  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  pushOnChannel(msg, body) {
    if (body == null) { body = {} }
    this.channel.push(msg, body)
  }

  maybe_start_pid_worker(pid) {
    var exists = false
    var started = false
    this.state.active_pids.forEach(el => {
      if (el.obd_pid_name == pid.obd_pid_name) {
        exists = true
        if (el.started == false) {
          started = false
        }
      }
    })
    if(exists && !started) {
      this.pushOnChannel("status:start_pid_worker", { "pid_name": pid.obd_pid_name })
      pid["started"] = true
      saveToLS("active_pids", this.state.active_pids)
    }

    if (!exists && !started) {
      this.pushOnChannel("status:start_pid_worker", { "pid_name": pid.obd_pid_name })
      pid["started"] = true
      this.state.active_pids.push(pid)
      saveToLS("active_pids", this.state.active_pids)
    }
  }

  render() {
    return (
      <div>
        <Dash channel={this.channel} active_pids={this.state.active_pids} />
        <footer className="bg-light text-center text-lg-start">
          <div className="container">
            <div className="row row-30">
              <div className="col-md-4">
                <h4>{this.state.elm_status}</h4>
              </div>
              <div className="col-md-4">
                <div className="mb-2">
                  <DropdownButton
                    as={ButtonGroup}
                    key="dropdown"
                    id="pids_dropdown"
                    drop="up"
                    variant="secondary"
                    title="PIDS"
                  >
                    {this.state.supported_pids.map((pid) => (
                      <Dropdown.Item
                        key={pid.obd_pid_name}
                        eventKey={pid.obd_pid_name}
                        onClick={() => {
                          this.maybe_start_pid_worker(pid)
                        }
                        }

                      >{pid.obd_pid_name}</Dropdown.Item>
                    ))}
                  </DropdownButton>
                </div>
              </div>
              <div className="col-md-4">
                <Clock />
              </div>
            </div>
          </div>
          {/* <Button onClick={() => this.askForStatus(this.channel)} variant="outline-secondary" size="sm">PIDs</Button>{' '} */}
        </footer>
      </div >
    );
  }
}

function getFromLS(key) {
  let ls = {};
  if (global.localStorage) {
    try {
      ls = JSON.parse(global.localStorage.getItem("pi_dash")) || {};
    } catch (e) {
      /*Ignore*/
    }
  }
  if(ls[key] == null){
    return [];
  }
  let pids = ls[key]
  if(pids.length > 0) {
    pids.forEach( el => el.started = false)
  }
  return pids;
}

function saveToLS(key, value) {
  if (global.localStorage) {
    global.localStorage.setItem(
      "pi_dash",
      JSON.stringify({
        [key]: value
      })
    );
  }
}

export default Controller