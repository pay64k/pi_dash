import React from "react";
import ScaleText from 'react-scale-text';

class NumberGauge extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel
        }
    }

    componentDidMount() {
        this.props.channel.on("update:" + this.props.obd_pid_name, (message) => {
            this.setState({ value: message.value })
        });
    }

    componentWillUnmount() {
        this.props.channel.off("update:" + this.props.obd_pid_name)
    }

    render() {
        const divStyle = {
            width: "100%",
            height: "100%"
        };
        return (
            <div style={divStyle}>
                <ScaleText>
                    {this.state.value}
                </ScaleText>
            </div>
        )
    }
}

export default NumberGauge