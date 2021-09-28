import React from 'react'
import { Button, ButtonGroup } from 'react-bootstrap';
import Clock from './controller/clock'
import Interval from './controller/interval'
import Dash from "./gauges/dash";
import PidsDropdown from "./controller/pids_dropdown"
import GaugeSelection from "./controller/gauge_selection"
import NightMode from "./controller/night_mode"

const active_pids = getFromLS("active_pids") || [];
const gauges = ["bar", "radial", "arc", "number"]

class Controller extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = {
      elm_status: "unknown",
      supported_pids: [],
      active_pids: this.checkVersion(),
      active_interval: 1000,
      active_gauge: gauges[0]
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

  checkVersion() {
    if (readVersion() === app_version) {
      return JSON.parse(JSON.stringify(active_pids))
    }
    else {
      saveVersion(app_version)
      saveToLS("active_pids", [])
      return []
    }
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
      pid["interval"] = this.state.active_interval
      pid["active_gauge"] = this.state.active_gauge
      this.state.active_pids.push(pid)
    }

    if (!started) {
      pid["started"] = true
      this.pushOnChannel("status:start_pid_worker",
        { "pid_name": pid.obd_pid_name, "interval": pid.interval })
    }

    saveToLS("active_pids", this.state.active_pids)
  }

  clear_all_pids() {
    this.pushOnChannel("status:stop_all_workers")
    saveToLS("active_pids", [])
    this.setState({ active_pids: [] })
    location.reload();
  }

  restart() {
    this.pushOnChannel("application:restart")
    setTimeout(location.reload.bind(location), 5000);
  }

  maybe_start_pid_worker_cb = (pid) => {
    this.maybe_start_pid_worker(pid)
  }

  update_active_gauge_cb = (new_gauge) => {
    this.setState({ active_gauge: new_gauge });
  }

  update_active_interval_cb = (new_interval) => {
    this.setState({ active_interval: new_interval });
  }

  statusLight(state) {
    if (state == "connect")
      return "danger"
    else if (state == "configuring")
      return "warning"
    else if (state == "get_supported_pids")
      return "warning"
    else if (state == "connected_configured")
      return "success"
    else 
      return "secondary"
  }

  render() {
    return (
      <div>
        <Dash channel={this.channel} active_pids={this.state.active_pids} />
        <footer className="controller text-center text-lg-start">
          <div className="container p-0">
            <div className="row row-30">
              <div className="col-sm">
                <ButtonGroup aria-label="Buttons">
                  <NightMode setTheme_cb={this.props.setTheme_cb} />
                  <GaugeSelection gauges={gauges} update_active_gauge_cb={this.update_active_gauge_cb} />
                  <Interval update_active_interval_cb={this.update_active_interval_cb} />
                  <PidsDropdown
                    supported_pids={this.state.supported_pids}
                    maybe_start_pid_worker_cb={this.maybe_start_pid_worker_cb} />
                  <Button variant={this.statusLight(this.state.elm_status)}>STS</Button>{' '}
                  <Button
                    onClick={() => this.clear_all_pids()}
                    variant="secondary">Clear</Button>{' '}
                  <Button
                    onClick={() => this.restart()}
                    variant="danger">Restart</Button>{' '}
                </ButtonGroup>
              </div>
              <div className="col-sm">
                <Clock />
              </div>
            </div>
          </div>
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

function saveVersion(value) {
  if (global.localStorage) {
    global.localStorage.setItem(
      "pi_dash_version",
      JSON.stringify({
        ["ver"]: value
      })
    );
  }
}

function readVersion() {
  let version = null
  if (global.localStorage) {
    try {
      version = JSON.parse(global.localStorage.getItem("pi_dash_version"));
    } catch (e) {
      console.log(e)
      return null;
    }
  }
  if (version == null)
    return null
  else
    return version["ver"]
}

export default Controller