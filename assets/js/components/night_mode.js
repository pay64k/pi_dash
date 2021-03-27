import React from 'react'

import ToggleButton from "react-bootstrap/ToggleButton"
import ButtonGroup from "react-bootstrap/ButtonGroup"
import {BrightnessHigh, BrightnessHighFill} from "react-bootstrap-icons"

function NightMode() {
    const [checked, setChecked] = React.useState(false);
 
    return (
        <ButtonGroup toggle className="mb-2">
          <ToggleButton
            type="checkbox"
            variant="secondary"
            checked={checked}
            value="1"
            onChange={(e) => toggle(e, setChecked)}
          >
              {choose_icon(checked)}
          </ToggleButton>
        </ButtonGroup>
    ); 
}

function toggle(event, setChecked_fn) {
    setChecked_fn(event.currentTarget.checked)
}

function choose_icon(checked) {
    if(checked) {
        document.getElementById("top_html").style.filter = "invert(0%)";

        return <BrightnessHigh/>
    } else {
        document.getElementById("top_html").style.filter = "invert(100%)";
        return <BrightnessHighFill/>
    }
 }

export default NightMode