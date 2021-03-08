import React from 'react'
import { Button, DropdownButton, Dropdown, ButtonGroup } from 'react-bootstrap';

class PidsDropdown extends React.Component {
    constructor(props) {
        super(props);
    }


    render() {
        return (
            <div className="mb-2">
                <DropdownButton
                    as={ButtonGroup}
                    key="pids_dropdown"
                    id="pids_dropdown"
                    drop="up"
                    variant="secondary"
                    title="PIDS"
                >
                    {this.props.supported_pids.map((pid) => (
                        <Dropdown.Item
                            key={pid.obd_pid_name}
                            eventKey={pid.obd_pid_name}
                            onClick={() => {
                                this.props.maybe_start_pid_worker_cb(pid)
                            }
                            }

                        >{pid.obd_pid_name}</Dropdown.Item>
                    ))}
                </DropdownButton>
            </div>
        );
    }
}

export default PidsDropdown