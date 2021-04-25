import React from "react";

import BarGauge from './bar_gauge'
import RadialGauge from './radial_gauge'

import { WidthProvider, Responsive } from "react-grid-layout";

const ResponsiveReactGridLayout = WidthProvider(Responsive);
const originalLayouts = getFromLS("layouts") || {};

class Dash extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      layouts: JSON.parse(JSON.stringify(originalLayouts)),
      active_pids: props.active_pids
    }
  }

  onLayoutChange(layout, layouts) {
    saveToLS("layouts", layouts);
    this.setState({ layouts });
  }

  componentDidUpdate(prevProps) {
    if (this.props.active_pids !== prevProps.active_pids) {
      this.setState({ active_pids: prevProps.active_pids });
    }
  }

  gaugeTypeToComponent(props) {
    let p = {...props, channel: this.channel, type: props.active_gauge}
    if (props.active_gauge === "bar") {
      return <BarGauge {...p}/>;
    }
    else{
      return <RadialGauge {...p}/>;
    }
  }

  gaugeStyle(active_gauge) {
    if (active_gauge !== "bar"){
      return {border: 0}
    }
  }

  render() {
    return (
      <ResponsiveReactGridLayout
        className="layout"
        cols={{ lg: 12, md: 12, sm: 12, xs: 12, xxs: 12 }}
        rowHeight={30}
        layouts={this.state.layouts}
        onLayoutChange={(layout, layouts) =>
          this.onLayoutChange(layout, layouts)
        }
      >
          {/* this hack is here so theme provider applies styles to next gauges created */}
          <div key="dummy" style={{display: "none"}} data-grid={{ w: 0, h: 0, x: 0, y: 0 }}>
            {this.gaugeTypeToComponent({active_gauge: "bar"})}
          </div>
        {this.state.active_pids.map((pid) => (
          <div key={pid.obd_pid_name} style={this.gaugeStyle(pid.active_gauge)} data-grid={{ w: 3, h: 3, x: 0, y: 0 }}>
            {this.gaugeTypeToComponent(pid)}
          </div>
        ))}
      </ResponsiveReactGridLayout>
    )
  }
}

function getFromLS(key) {
  let ls = {};
  if (global.localStorage) {
    try {
      ls = JSON.parse(global.localStorage.getItem("rgl-8")) || {};
    } catch (e) {
      /*Ignore*/
    }
  }
  return ls[key];
}

function saveToLS(key, value) {
  if (global.localStorage) {
    global.localStorage.setItem(
      "rgl-8",
      JSON.stringify({
        [key]: value
      })
    );
  }
}

export default Dash