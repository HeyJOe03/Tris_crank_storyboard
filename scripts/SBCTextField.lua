
local DELETE_KEY = 8
local ENTER_KEY = 13
local gTextFieldStartPos = 8
local gTextField = nil

-- Callback handler for the text field
function SBCTextFieldPress(mapargs) 
  local strInfo
  local data = {}
  local controlName = mapargs.context_control
  local textKey = controlName .. ".text"
  local value = gre.get_value(textKey)

  -- move cursor
  strInfo = gre.get_string_size("fonts/Roboto-Regular.ttf", 18, value)
  
  data[controlName .. ".cursorPos"] = strInfo.width + gTextFieldStartPos
  data[controlName .. ".cursorAlpha"] = 255
  gre.set_data(data)
  
  gTextField = controlName
end

-- Callback for key press on the text field
function SBCTextFieldKeyDown(mapargs) 
  if (gTextField == nil) then
    return
  end
  SBCTextFieldInputKeyEvent(mapargs)
end

-- Function to handle the key that was pressed
function SBCTextFieldInputKeyEvent(mapargs)
  local controlName = mapargs.context_control
  local keyPressed = mapargs.context_event_data.code
  local modifier = mapargs.context_event_data.modifiers
  local cbVar = mapargs.context_group .. ".callback"
  local cbName = gre.get_value(cbVar)
  local textKey = controlName .. ".text"
  local strInfo
  local data = {}

  -- current string in text field
  local value = gre.get_value(textKey)

  if (keyPressed == DELETE_KEY) then
    -- backspace
    value = string.sub(value,1,-2)
    gre.set_value(textKey, value)

    -- move cursor
    strInfo  =  gre.get_string_size("fonts/Roboto-Regular.ttf", 18, value)
    data[controlName .. ".cursorPos"] = strInfo.width + gTextFieldStartPos
    gre.set_data(data)
  
  elseif (keyPressed == ENTER_KEY) then
    -- enter
  
  else
    -- add new char to the text field
    if pcall(function() string.char(keyPressed) end) then
      value = string.format("%s%s", value, string.char(keyPressed))
      strInfo = gre.get_string_size("fonts/Roboto-Regular.ttf", 18, value)
      data[controlName .. ".cursorPos"] = strInfo.width + gTextFieldStartPos
      data[textKey] = value
      gre.set_data(data)
    end
  end
  
  -- call the callback function, if specified
  if(cbName == nil or cbName == "") then
    return
  end
  
  local cbFn = _G[cbName]
  if (cbFn == nil or type(cbFn) ~= "function") then
    return
  end
  
  cbFn(controlName, value)
end

-- Callback for focus loss on the text field
function SBCTextFieldLostFocus()
  local data = {}
  data["main_layer.TextEntry.textField.cursorAlpha"] = 0
  gre.set_data(data)
end
