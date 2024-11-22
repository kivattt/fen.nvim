[vim-plug](https://github.com/junegunn/vim-plug) installation:
```lua
Plug("kivattt/fen.nvim")

local fen = require("fen")
vim.keymap.set("n", "<Leader>f", fen.show)
```

Optional configuration, defaults:
```lua
local fen = require("fen")
fen.setup({
    border = "rounded" -- See: https://neovim.io/doc/user/api.html#:~:text=border%3A
})
```
