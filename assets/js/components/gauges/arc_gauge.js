// import React from "react";
// class ArcGaugeC extends React.Component {
//     constructor(props) {
//         super(props);
//         this.state = {
//             value: 0,
//             channel: props.channel,
//             color: this.getColor(0)
//         }
//     }

//     componentDidMount() {
//         console.log("mount arc")
//         this.props.channel.on("update:" + this.props.obd_pid_name, (message) => {
//             this.setState({ value: message.value, color: this.getColor(message.value) })
//         });
//     }

//     componentWillUnmount() {
//         this.props.channel.off("update:" + this.props.obd_pid_name)
//     }

//     calculateWidth(value) {
//         return Math.round((value - this.props.min_value) * (100 - 0) / (this.props.max_value - this.props.min_value) + 0);
//         // (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
//     }

//     getColor(value) {
//         // from black to red
//         var lightness = (value * 45 / this.props.max_value).toString(10);
//         return ["hsl(0,100%,", lightness - 10, "%)"].join("");
//     }

//     render() {
//         const divStyle = {
//             width: "100%",
//             height: "100%"
//         };
//         return (
//             <div style={divStyle}>
//                 <RadialGauge
//                 style={divStyle}
//                     units='°C'
//                     title='Temperature'
//                     value={this.state.value}
//                     minValue={0}
//                     maxValue={50}
//                     majorTicks={['0', '5', '15', '20', '25', '30', '35', '40', '45', '50']}
//                     minorTicks={2}
//                 ></RadialGauge>
//             </div>
//         )
//     }
// }

// export default ArcGaugeC

import React from "react"
import { RadialGauge } from "canvas-gauges"

class ReactRadialGauge extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel,
            height: 0,
            width: 0
        }
    }

    componentDidMount() {
        // let bla = { height: this.container.clientHeight, width: this.container.clientWidth, value: 0 }
        // console.log(bla)
        this.props.channel.on("update:" + this.props.obd_pid_name, (message) => {
            let la = {width: this.state.width, height: this.state.height, value: message.value}
            this.gauge.update(la)
            this.setState({ 
                value: message.value,
                width: this.container.clientWidth,
                height: this.container.clientHeight
             })
        });

        setTimeout(() => {
            console.log(this.container.clientWidth)
            console.log(this.container.clientHeight)
            this.setState({
                width: this.container.clientWidth,
                height: this.container.clientHeight
            }) // 360
        }, 1)
        console.log("state: ", this.state)
        let bla = { height: this.state.height, width: this.state.width, value: 0 }

        const options = Object.assign({}, bla, {
            renderTo: this.el
        })
        this.gauge = new RadialGauge(options).draw()
    }

    componentWillReceiveProps(nextProps) {
        this.gauge.value = nextProps.value
        this.gauge.update(nextProps)
    }

    render() {
        return (
            <div style={{ height: "100%", width: "100%" }} ref={el => (this.container = el)}>
                <canvas ref={(canvas) => {
                    this.el = canvas
                }} />
            </div>

        )
    }
}

export default ReactRadialGauge