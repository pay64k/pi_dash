import React from 'react'
import { Button, DropdownButton, Dropdown, ButtonGroup } from 'react-bootstrap';
import Clock from './clock'
import Interval from './interval'
import Dash from "./dash";

const active_pids = getFromLS("active_pids") || [];

class Controller extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = {
      elm_status: "unknown",
      supported_pids: [],
      active_pids: JSON.parse(JSON.stringify(active_pids)),
      active_interval: 1000
    };
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
      console.log(this.state)
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

    if (!exists) {
      this.state.active_pids.push(pid)
    }

    if (!started) {
      this.pushOnChannel("status:start_pid_worker", { "pid_name": pid.obd_pid_name })
      pid["started"] = true
    }

    saveToLS("active_pids", this.state.active_pids)
  }

  update_active_interval = (new_interval) => {
    this.setState({ active_interval: new_interval });
  }

  render() {
    return (
      <div>
        <Dash channel={this.channel} active_pids={this.state.active_pids} />
        <footer className="bg-light text-center text-lg-start">
          <div className="container">
            <div className="row row-30">
              <div className="col-md-3">
                <h4>{this.state.elm_status}</h4>
              </div>
              <div className="col-md-3">
                <Interval active_interval_cb={this.update_active_interval} />
              </div>
              <div className="col-md-3">
                <div className="mb-2">
                  <DropdownButton
                    as={ButtonGroup}
                    key="pids_dropdown"
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
              <div className="col-md-3">
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
  if (ls[key] == null) {
    return [];
  }
  if (ls[key].length > 0) {
    ls[key].forEach(el => el.started = false)
  }
  return ls[key];
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