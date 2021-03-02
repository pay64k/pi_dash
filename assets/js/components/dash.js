import React from "react";

import GridLayout from 'react-grid-layout';
import LinearGauge from './linear_gauge'

class Dash extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
  }
  render() {
    const layout = [
      { i: 'b', x: 0, y: 0, w: 3, h: 1 },
      { i: 'c', x: 0, y: 1, w: 3, h: 1 }
    ];
    return (
      <GridLayout className="layout" layout={layout} cols={12} rowHeight={100} width={1200}>
        <div key="b">
          <LinearGauge name="rpm" max_value={6500} channel={this.channel} />
        </div>
        <div key="c">
          <LinearGauge name="speed" max_value={200} channel={this.channel} />
        </div>
      </GridLayout>
    )
  }
}
export default Dash