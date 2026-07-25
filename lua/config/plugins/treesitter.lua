-- https://github.com/romus204/tree-sitter-manager.nvim
-- Requires `tree-sitter` CLI, a C compiler and git.
return {
  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    config = function()
      require("tree-sitter-manager").setup {
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        highlight = true,
      }
    end,
  },
}
