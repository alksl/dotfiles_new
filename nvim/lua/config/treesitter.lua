local M = {}

function M.setup()
  require("nvim-treesitter.configs").setup {
    -- One of "all",  or a list of languages
    ensure_installed = { "lua", "ruby" },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    highlight = {
      -- `false` will disable the whole extension
      enable = true,
    },
    endwise = {
      enable = true
    }
  }
end

return M
