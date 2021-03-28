import React from "react";
import LinearProgress from '@material-ui/core/LinearProgress'
import { withStyles } from '@material-ui/core/styles';
import { Typography } from '@material-ui/core';

const BorderLinearProgress = withStyles((theme) => ({
    root: {
        height: '100%',
        borderRadius: 0,
    },
    bar: {
        borderRadius: 0
    }
}))(LinearProgress);

class BarGauge extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel,
            color: this.getColor(0)
        }
    }

    componentDidMount() {
        this.props.channel.on("update:" + this.props.obd_pid_name, (message) => {

            this.setState({ value: message.value, color: this.getColor(message.value) })
        });
    }

    componentWillUnmount() {
        this.props.channel.off("update:" + this.props.obd_pid_name)
    }

    calculateWidth(value) {
        return Math.round((value - this.props.min_value) * (100 - 0) / (this.props.max_value - this.props.min_value) + 0);
        // (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    }

    getColor(value) {
        // from black to red
        var lightness = (value * 45 / this.props.max_value).toString(10);
        return ["hsl(0,100%,", lightness - 10, "%)"].join("");
    }

    render() {
        const divStyle = {
            width: "100%",
            height: "100%"
        };
        return (
            <div style={divStyle}>
                <BorderLinearProgress variant="determinate" value={this.calculateWidth(this.state.value)} />
                <Typography
                    style={{
                        position: "absolute",
                        color: "white",
                        top: 0,
                        left: "1%",
                        fontFamily: "monospace",
                        mixBlendMode: "difference"
                    }}
                >
                    {this.props.obd_pid_name}
                </Typography>
                <Typography
                    style={{
                        position: "absolute",
                        color: "white",
                        top: 0,
                        left: "99%",
                        fontFamily: "monospace",
                        transform: "translateX(-100%)",
                        mixBlendMode: "difference"
                    }}
                >
                    {this.state.value}
                </Typography>
            </div>
        )
    }
}

export default BarGauge