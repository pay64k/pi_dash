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
      layouts: JSON.parse(JSON.stringify(originalLayouts))
    }
  }

  onLayoutChange(layout, layouts) {
    saveToLS("layouts", layouts);
    this.setState({ layouts });
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
        <div key="1" data-grid={{ w: 3, h: 1, x: 0, y: 0 }}>
          <LinearGauge name="rpm" max_value={6500} channel={this.channel} />
        </div>
        <div key="2" data-grid={{ w: 3, h: 1, x: 0, y: 0 }}>
          <LinearGauge name="speed" max_value={150} channel={this.channel} />
        </div>
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