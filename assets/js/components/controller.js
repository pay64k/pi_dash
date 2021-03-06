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
      active_pids: JSON.parse(JSON.stringify(active_pids)),
    };
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.pushOnChannel("status:elm_status"),
      2000
    );

    this.channel.on("status:elm_status", (message) => {
      if (message.elm_status == "connected_configured" && this.state.elm_status != "connected_configured") {
        console.log("conn conf")
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
    var newArray = [...this.state.active_pids]
    var indexItem = newArray.indexOf(pid)
    if(indexItem === -1){
      console.log("start pid worker ", pid.obd_pid_name)
      this.pushOnChannel("status:start_pid_worker", { "pid_name": pid.obd_pid_name })
      newArray.push(pid)
      saveToLS("active_pids", newArray)
      this.setState({ active_pids: newArray })
    }
    // console.log("start pid worker ", pid.obd_pid_name)
    // this.pushOnChannel("status:start_pid_worker", { "pid_name": pid.obd_pid_name })
    // saveToLS("active_pids", this.state.active_pids)
  }

  // add_to_active_pids(pid) {
  //   var newArray = [...this.state.active_pids]
  //   var indexItem = newArray.indexOf(pid)
  //   indexItem === -1 ? newArray.push(item) : console.log("exists")
  //   this.setState({ active_pids: newArray });
  // }

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
                          // this.add_to_active_pids(pid);
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