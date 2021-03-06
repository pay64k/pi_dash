import React from "react";

import LinearGauge from './linear_gauge'

import { WidthProvider, Responsive } from "react-grid-layout";

const ResponsiveReactGridLayout = WidthProvider(Responsive);
const originalLayouts = getFromLS("layouts") || {};

class Dash extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      layouts: JSON.parse(JSON.stringify(originalLayouts)),
      pids: props.pids
    }
  }

  onLayoutChange(layout, layouts) {
    saveToLS("layouts", layouts);
    this.setState({ layouts });
  }

  componentDidUpdate(prevProps) {
    console.log("dash updated", prevProps)
    if (this.props.pids !== prevProps.pids) {
      this.setState({ pids: prevProps.pids });
      console.log("props: ", this.props)
      console.log("prevProps: ", prevProps)
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
        {this.state.pids.map((pid) => (
          // TODO get max value here
          <div key={pid} data-grid={{ w: 3, h: 1, x: 0, y: 0 }}>
            <LinearGauge name={pid} max_value={6500} channel={this.channel} />
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