local M = {}

M.general = {
  n = {
    ["<C-h"] = { "<cmd> Tmux NavigateLeft<CR>", "window left" },
    ["<C-l"] = { "<cmd> Tmux NavigateRight<CR>", "window right" },
    ["<C-j"] = { "<cmd> Tmux NavigateDown<CR>", "window down" },
    ["<C-k"] = { "<cmd> Tmux NavigateUp<CR>", "window up" },
  }
}

return M
