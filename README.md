[vim-plug](https://github.com/junegunn/vim-plug) installation:
```lua
Plug("kivattt/fen.nvim")

local fen = require("fen")
vim.keymap.set("n", "<Leader>f", fen.show)
```

Configuration
```lua
local fen = require("fen")
fen.setup({
    border = "single"
})
```
