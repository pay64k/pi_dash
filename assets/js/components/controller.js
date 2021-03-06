import React from 'react'
import { Button, DropdownButton, Dropdown, ButtonGroup} from 'react-bootstrap';
import Clock from './clock'

class Controller extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = {
      elm_status: "unknown",
      supported_pids: []
    };
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.pushOnChannel("status:elm_status"),
      2000
    );

    this.channel.on("status:elm_status", (message) => {
      if (message.elm_status == "connected_configured" && this.state.elm_status != "connected_configured") {
        console.log("get pids!")
        this.pushOnChannel("status:supported_pids")
      }

      this.setState({
        elm_status: message.elm_status
      });
    });

    this.channel.on("status:supported_pids", (message) => {
      console.log("supported pids: ", message)
      this.setState({
        supported_pids: message.supported_pids
      });
    });
  }

  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  pushOnChannel(msg) {
    this.channel.push(msg, {})
  }

  askForStatus() {
  }

  render() {
    return (
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
                    <Dropdown.Item key={pid} eventKey={pid}>{pid}</Dropdown.Item>
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
    );
  }
}

export default Controller