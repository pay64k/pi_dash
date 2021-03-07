import React from 'react'
import { DropdownButton, Dropdown, ButtonGroup } from 'react-bootstrap';

const intervals = [250, 500, 1000, 2000, 5000]
const def_inter = 1000

class Interval extends React.Component {
    constructor(props) {
        super(props);
    }

    componentDidMount() {
        // console.log("active interval: ", this.state.active_interval)
    }

    show_state() {
        console.log(this.state)
    }

    update_interval(new_interval) {
        this.props.active_interval_cb(new_interval)
    }

    render() {
        return (
            <DropdownButton
                as={ButtonGroup}
                key="interval_dropdown"
                id="interval_dropdown"
                variant="secondary"
                title="Interval"
            >
                {intervals.map((i) =>
                    <Dropdown.Item
                        key={i}
                        eventKey={i}
                        // {() => if(i == def_inter) return "active"}
                        onClick={() => this.update_interval(i)}
                    >{i} ms
                    </Dropdown.Item>
                )}
                {/* <Dropdown.Item eventKey="3" active>1000 ms</Dropdown.Item> */}
            </DropdownButton>
        );
    }
}

export default Interval