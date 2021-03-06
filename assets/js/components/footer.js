import React from 'react'
import { Button } from 'react-bootstrap';
import Clock from './clock'

class Footer extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = { elm_status: "unknown" };
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.askForStatus(),
      2000
    );

    this.channel.on("status:elm_status", (message) => {
      this.setState({
        elm_status: message.elm_status
      });
    });
  }

  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  askForStatus() {
    this.channel.push("status:elm_status", {})
  }

  render() {
    return (
      <footer className="bg-light text-center text-lg-start">
        <div class="container">
          <div class="row row-30">
            <div class="col-md-4">
              <p>{this.state.elm_status}</p>
            </div>
            <div class="col-md-4">
            </div>
            <div class="col-md-4">
              <Clock />
            </div>
          </div>
        </div>
        {/* <Button onClick={() => this.askForStatus(this.channel)} variant="outline-secondary" size="sm">PIDs</Button>{' '} */}
      </footer>
    );
  }
}

export default Footer