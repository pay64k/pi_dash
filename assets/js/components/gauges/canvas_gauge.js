import React from "react"
import { RadialGauge, LinearGauge } from "canvas-gauges"

const font = "monospace"
class CanvasGauge extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel,
            height: 50,
            width: 50,
            majorTicks: majorTicks(this.props),
            maxValue: this.props.max_value,
            minValue: this.props.min_value,
            title: this.props.obd_pid_name,
            type: this.props.type,
            fontTitle: font,
            fontNumbers: font,
            fontValue: font,
            fontUnits: font,
            valueDec: 0,
            units: this.props.units,
            barBeginCircle: 0,
            borders: false,
            borderRadius: 0,
            barLength: 88,
            highlights: [],
            fontNumbersSize: 27,
            theme: props.theme
        }
    }

    componentDidMount() {
        this.props.channel.on("update:" + this.props.obd_pid_name, (message) => {
            let tempProp = { 
                ...this.state,
                width: this.state.width, 
                height: this.state.height, 
                value: message.value 
            }
            // console.log("state: ", this.state)
            // console.log(this.container.style)
            var a = document.getElementById('body')
            var color = window.getComputedStyle(a).backgroundColor

            this.gauge.update(tempProp)
            this.setState({
                value: message.value,
                width: this.container.clientWidth,
                height: this.container.clientHeight,
                colorPlate: color
            })
        });

        const options = Object.assign({}, this.state, {
            renderTo: this.el
        })
        let chosenGauge = this.gaugeType(this.state.type)
        this.gauge = new chosenGauge(options).draw()
    }

    gaugeType(type) {
        switch (type) {
            case "radial":
                return RadialGauge;
            case "line":
                return LinearGauge;
        }
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

function majorTicks(props) {
    let start = props.min_value
    let stop = props.max_value
    let step 

    if(stop > 1000){
        step = 1000
    } else if(stop === 100){
        step = 20
    } else {
        step = 50
    }

    var a = [start], b = start;
    while (b < stop) {
        a.push(b += step || 1);
    }
    // return (b > stop) ? a.slice(0,-1) : a;
    return a;
}

export default CanvasGauge