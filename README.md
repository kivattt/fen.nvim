This NeoVim plugin embeds [fen](https://github.com/kivattt/fen) file manager, and lets you open files in new tabs

This plugin works with fen v1.7.18 or above

<img src="screenshot.png" alt="Selecting multiple files to open in tabs">

## Installation
[vim-plug](https://github.com/junegunn/vim-plug):
```lua
Plug("kivattt/fen.nvim")

local fen = require("fen")
vim.keymap.set("n", "<Leader>f", fen.show)
```

## Configuration: (defaults)
```lua
local fen = require("fen")
fen.setup({
    border = "rounded", -- See: https://neovim.io/doc/user/api.html#:~:text=border%3A
    no_write = true -- Prevents deleting or modifying files in fen
})
```

## TODO
Disable search highlighting for the fen popup window\
Don't change the terminal title\
Allow setting no\_write to false, right now it does nothing
