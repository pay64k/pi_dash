import React from "react";

import LinearGauge from './linear_gauge'
import LinearGauge2 from './linear_gauge2'

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
    let p = {...props, channel: this.channel}
    switch (props.active_gauge) {
      case "linear":
        return <LinearGauge {...p}/>;
      case "linear2":
        return <LinearGauge2 {...p}/>;
    }
  }

  render() {
    return (
      <ResponsiveReactGridLayout
        className="layout"
        cols={{ lg: 12, md: 10, sm: 6, xs: 4, xxs: 2 }}
        rowHeight={30}
        layouts={this.state.layouts}
        onLayoutChange={(layout, layouts) =>
          this.onLayoutChange(layout, layouts)
        }
      >
        {this.state.active_pids.map((pid) => (
          <div key={pid.obd_pid_name} data-grid={{ w: 3, h: 1, x: 0, y: 0 }}>
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