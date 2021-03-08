import React from "react";

class LinearGauge extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel
        }
    }

    componentDidMount() {
        console.log(this.props.name, "did mount")
        this.props.channel.on("update:" + this.props.name, (message) => {
            // console.log("update in gauge " + this.props.name, message)
            var canvas = document.getElementById(this.props.name);
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.fillStyle = this.getColor(message.value);
            ctx.fillRect(0, 0, this.calculateWidth(message.value, canvas), canvas.height);
            this.setState({ value: message.value })
        });
    }

    componentWillUnmount(){
        console.log(this.props.name, "will unmount")
        this.props.channel.off("update:" + this.props.name)
    }

    calculateWidth(value, canvas) {
        return Math.round((value - this.props.min_value) * (canvas.width - 0) / (this.props.max_value - this.props.min_value) + 0); 
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
        const canvasStyle = {
            width: "100%",
            height: "80%"
        };
        const footerStyle = {
            width: "100%",
            height: "20%"
        };
        return (
            <div style={divStyle}>
                <canvas id={this.props.name} style={canvasStyle}></canvas>
                <div style={footerStyle}>
                    {this.props.name} {this.state.value}
                </div>
            </div>
        )
    }
}

export default LinearGauge