@react.component
let make = (~name, ~label, ~value, ~checked) =>
  <div>
    <input id=value type_="radio" name value checked />
    <label htmlFor=value> {label->React.string} </label>
  </div>
