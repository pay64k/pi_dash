import React from 'react'
import { DropdownButton, Dropdown, ButtonGroup } from 'react-bootstrap';

const intervals = [250, 500, 1000, 2000, 5000]

class Interval extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            active: 1000
        }
    }

    update_interval(new_interval) {
        this.props.active_interval_cb(new_interval)
        this.setState({
            active: new_interval
        })
    }

    render() {
        let items = intervals.map((i) => {
            if (i == this.state.active) {
                return (<Dropdown.Item
                    key={i}
                    eventKey={i}
                    active
                    onClick={() => this.update_interval(i)}
                >{i} ms
                </Dropdown.Item>)
            }
            else {
                return (<Dropdown.Item
                    key={i}
                    eventKey={i}
                    onClick={() => this.update_interval(i)}
                >{i} ms
                </Dropdown.Item>)
            }
        });
        return (
            <DropdownButton
                as={ButtonGroup}
                key="interval_dropdown"
                id="interval_dropdown"
                variant="secondary"
                title={`${this.state.active} ms`}
            >
                {items}
            </DropdownButton>
        );
    }
}

export default Interval