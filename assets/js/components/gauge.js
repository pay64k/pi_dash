import React from "react";

import "loadingio-bar"

class Gauge extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel
        }
    }

    componentDidMount() {
        this.props.channel.on("update", (message) => {
            if (message.obd_pid == this.props.name) {
                console.log("update in gauge " + this.props.name, message)
                document.getElementById(this.props.name).ldBar.set(message.value);
                // bar1.set(message.value);
                // this.setState({ value: message.value })
            }
        });
    }

    render() {
        return (
            <section className="row">

                <div id={this.props.name}
                    className="ldBar"
                    data-value="50"
                    data-min="0"
                    data-max={this.props.max_value}
                    data-type="fill"
                    data-img="images/gauge.svg"
                    data-fill-dir="ltr"
                    data-duration={0.15}>
                </div>
            </section>)
    }
}

export default Gauge