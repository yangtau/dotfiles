local config = {}

local function import(package)
  local options = require(package)
  for key, value in pairs(options) do
    config[key] = value
  end
end

import "configs.keymap"
import "configs.ui"
import "configs.font"

return config
