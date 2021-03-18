import React from "react";
import LinearProgress from '@material-ui/core/LinearProgress'
import { withStyles } from '@material-ui/core/styles';

  const BorderLinearProgress = withStyles((theme) => ({
    root: {
      height: '100%',
      borderRadius: 0,
    },
    colorPrimary: {
      backgroundColor: theme.palette.grey[theme.palette.type === 'light' ? 200 : 700],
    },
    bar: {
      borderRadius: 0,
      backgroundColor: 'black'
    },
  }))(LinearProgress);

class LinearGauge2 extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 0,
            channel: props.channel,
            color: this.getColor(0)
        }
    }

    componentDidMount() {
        console.log(this.props.name, "did mount")
        this.props.channel.on("update:" + this.props.name, (message) => {
           
            this.setState({ value: message.value, color: this.getColor(message.value) })
        });
    }

    componentWillUnmount(){
        console.log(this.props.name, "will unmount")
        this.props.channel.off("update:" + this.props.name)
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
            </div>
        )
    }
}

export default LinearGauge2