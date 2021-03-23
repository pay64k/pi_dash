import React from 'react'
import { DropdownButton, Dropdown, ButtonGroup } from 'react-bootstrap';

class GaugeSelection extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            active: "linear"
        }
    }

    update_gauge(new_gauge) {
        this.props.update_active_gauge_cb(new_gauge)
        this.setState({
            active: new_gauge
        })
    }

    render() {
        let items = this.props.gauges.map((i) => {
            if (i == this.state.active) {
                return (<Dropdown.Item
                    key={i}
                    eventKey={i}
                    active
                    onClick={() => this.update_gauge(i)}
                >{i}
                </Dropdown.Item>)
            }
            else {
                return (<Dropdown.Item
                    key={i}
                    eventKey={i}
                    onClick={() => this.update_gauge(i)}
                >{i}
                </Dropdown.Item>)
            }
        });
        return (
            <DropdownButton
                as={ButtonGroup}
                key="gauge_dropdown"
                id="gauge_dropdown"
                variant="secondary"
                title={`${this.state.active}`}
            >
                {items}
            </DropdownButton>
        );
    }
}

export default GaugeSelection