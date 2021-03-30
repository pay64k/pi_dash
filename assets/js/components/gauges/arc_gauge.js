import React from "react"
import { RadialGauge } from "canvas-gauges"

class ReactRadialGauge extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel,
            height: 1,
            width: 1
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

        // setTimeout(() => {
        //     this.setState({
        //         width: this.container.clientWidth,
        //         height: this.container.clientHeight
        //     }) 
        // }, 1)

        const options = Object.assign({}, this.props, {
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