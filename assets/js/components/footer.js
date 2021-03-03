import React from 'react'
import { Button } from 'react-bootstrap';
import Clock from './clock'

class Footer extends React.Component {
    constructor(props) {
      super(props);
      this.channel = this.props.channel;
      this.state = {elm_status: "unknown"};
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
          <h2>{this.state.elm_status}</h2>
        {/* <Button onClick={() => this.askForStatus(this.channel)} variant="outline-secondary" size="sm">PIDs</Button>{' '} */}
        <Clock />

        </footer>
      );
    }
  }

  export default Footer