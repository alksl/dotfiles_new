local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
      enable = true,
      -- the amount in ms that a plugins load time must be over for it to be
      -- included in the profile
      threshold = 1,
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Notification
    use {
      "rcarriga/nvim-notify",
      event = "VimEnter",
      config = function()
        vim.notify = require "notify"
      end,
    }

    -- Colorscheme
    use {
      "tanvirtin/monokai.nvim",
      config = function()
        vim.cmd "colorscheme monokai"
      end,
    }

    -- WhichKey
    use {
      "folke/which-key.nvim",
      config = function()
        require("config.whichkey").setup()
      end,
    }

    -- Better icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- Statusline
    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = function()
        require("config.lualine").setup()
      end,
      requires = {
        "nvim-web-devicons",
        "SmiteshP/nvim-navic",
      },
    }
    use {
      "SmiteshP/nvim-navic",
      requires = {
        "neovim/nvim-lspconfig",
      },
    }

    -- Treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        "RRethy/nvim-treesitter-endwise",
      }
    }

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim", tag = "0.1.2",
      config = function()
        require("config.telescope").setup()
      end,
      requires = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "nvim-telescope/telescope-dap.nvim" },
      }
    }

    -- FZF
    use { "junegunn/fzf", run = "./install --all" }
    use { "junegunn/fzf.vim" }
    use {
      "ibhagwan/fzf-lua",
      event = "BufEnter",
      requires = { "kyazdani42/nvim-web-devicons" },
    }

    -- Completion
    use {
      "ms-jpq/coq_nvim",
      branch = "coq",
      run = ":COQdeps",
      config = function()
        require("config.coq").setup()
      end,
      requires = {
        { "ms-jpq/coq.artifacts",  branch = "artifacts" },
        { "ms-jpq/coq.thirdparty", branch = "3p",       module = "coq_3p" },
      },
      disable = false,
    }

    -- LSP
    use {
      "williamboman/mason.nvim",
      run = ":MasonUpdate", -- :MasonUpdate updates registry contents
    }
    use {
      "williamboman/mason-lspconfig.nvim",
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require("config.lsp").setup()
      end,
      requires = {
        "ms-jpq/coq_nvim",
        "b0o/schemastore.nvim",
      },
    }
    use {
      "j-hui/fidget.nvim",
      tag = "legacy",
      config = function()
        require("fidget").setup {}
      end,
    }

    -- GraphQL
    use {
      "jparise/vim-graphql"
    }

    -- Terraform
    use {
      "hashivim/vim-terraform",
    }

    -- Git
    use {
      "tpope/vim-fugitive",
    }
    use {
      "tpope/vim-rhubarb",
    }

    -- Github
    use {
      "pwntester/octo.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("octo").setup({ enable_builtin = true })
        vim.cmd([[hi OctoEditable guibg=none]])
      end,
    }

    -- Helpers
    use {
      "tpope/vim-eunuch"
    }

    -- Testing
    use {
      "nvim-neotest/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "olimorris/neotest-rspec",
        "nvim-neotest/neotest-plenary",
        "nvim-neotest/neotest-python",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-plenary"),
            require("neotest-rspec"),
            require("neotest-python")({
              dap = { justMyCode = false },
              test_command = "pytest",
              test_file_pattern = "test_*.py",
            })
          }
        })
      end
    }

    -- DAP
    use {
      "mfussenegger/nvim-dap",
    }
    use {
      "suketa/nvim-dap-ruby",
      requires = {
        "mfussenegger/nvim-dap",
      },
    }
    use {
      "mfussenegger/nvim-dap-python",
      requires = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        require("dap-python").setup()
      end,
    }
    use {
      "mfussenegger/nvim-dap-ui",
      requires = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        require("dapui").setup()
      end,
    }

    -- REPL
    use {
      "Vigemus/iron.nvim",
      config = function()
        require("config.iron").setup()
      end
    }

    -- Rust
    use {
      "rust-lang/rust.vim",
    }


    -- Copliot
    use {
      "github/copilot.vim",
    }

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

return M
