import React from "react";

import GridLayout from 'react-grid-layout';
import Gauge from './gauge'

class Dash extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
  }
  render() {
    // layout is an array of objects, see the demo for more complete usage
    const layout = [
      { i: 'a', x: 0, y: 0, w: 1, h: 2 },
      { i: 'b', x: 1, y: 0, w: 3, h: 2, minW: 2, maxW: 4 },
      { i: 'c', x: 4, y: 0, w: 1, h: 2 }
    ];
    return (
      <GridLayout className="layout" layout={layout} cols={12} rowHeight={60} width={1200}>
        <div key="a">
          <Gauge name="rpm" max_value={6500} channel={this.channel} />
        </div>
        <div key="b">
          <Gauge name="speed" max_value={200} channel={this.channel} />
        </div>
        <div key="c">c</div>
      </GridLayout>
    )
  }
}
export default Dash