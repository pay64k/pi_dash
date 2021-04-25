import "justgage/justgage.js"
import React from "react"

class RadialGauge extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel,
            id: props.obd_pid_name,
            min: props.min_value,
            max: props.max_value,
            title: props.obd_pid_name,
            label: props.obd_pid_name,
            relativeGaugeSize: true,
            counter: true,
            symbol: ` ${props.units}`,
            valueFontFamily: "monospace",
            labelFontFamily: "monospace",
            gaugeColor: this.gaugeColor(),
            labelFontColor: this.textColor(),
            valueFontColor: this.textColor(),
            donut: this.isDonut(props.type),
            donutStartAngle: 90,
            customSectors: this.customSectors()
        }
    }

    componentDidMount() {
        this.props.channel.on("update:" + this.props.obd_pid_name, (message) => {

            this.setState({
                value: message.value,
            })

            this.refreshGauge()
        });
        this.gauge = new JustGage(this.state)
    }

    refreshGauge() {
        let currentTextColor = this.textColor()
        if (this.state.labelFontColor != currentTextColor) {
            let options = {
                valueFontColor: currentTextColor,
                labelFontColor: currentTextColor
            }
            this.gauge.update(options)
            this.setState({
                valueFontColor: currentTextColor,
                labelFontColor: currentTextColor
            })
        }
        let currentGaugeColor = this.gaugeColor()
        if (this.state.gaugeColor != currentGaugeColor) {
            this.gauge.destroy()
            this.setState({
                gaugeColor: currentGaugeColor
            })
            this.gauge = new JustGage(this.state)
        }

        this.gauge.refresh(this.state.value)
    }

    gaugeColor() {
        var body = document.getElementById('body')
        var bodyColor = window.getComputedStyle(body).backgroundColor;

        if (bodyColor == "rgb(226, 226, 226)") {
            return "#ececec"
        }
        if (bodyColor == "rgb(54, 53, 55)") {
            return "#5e5d5f"
        }
    }

    textColor() {
        var body = document.getElementById('body')
        return RGBToHex(window.getComputedStyle(body).color)
    }

    isDonut(type) {
        if (type == "radial")
            return true
        else
            return false
    }

    customSectors() {
        return {
            percents: true, // lo and hi values are in %
            ranges: [{
                color: "#4CA952",
                lo: 0,
                hi: 60
            },
            {
                color: "#FFBA49",
                lo: 61,
                hi: 70
            },
            {
                color: "#EF5B5B",
                lo: 71,
                hi: 100
            }
            ]
        }
    }

    render() {
        return (
            <div
                id={this.props.obd_pid_name}
                style={{ height: "100%", width: "100%" }}>
            </div>
        )
    }
}

function RGBToHex(rgb) {
    // Choose correct separator
    let sep = rgb.indexOf(",") > -1 ? "," : " ";
    // Turn "rgb(r,g,b)" into [r,g,b]
    rgb = rgb.substr(4).split(")")[0].split(sep);

    let r = (+rgb[0]).toString(16),
        g = (+rgb[1]).toString(16),
        b = (+rgb[2]).toString(16);

    if (r.length == 1)
        r = "0" + r;
    if (g.length == 1)
        g = "0" + g;
    if (b.length == 1)
        b = "0" + b;

    return "#" + r + g + b;
}

export default RadialGauge