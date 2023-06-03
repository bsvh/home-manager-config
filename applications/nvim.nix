{ config, pkgs, lib, inputs, outputs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [

      # Navigation
      Navigator-nvim
      telescope-nvim

      # Languages
      nvim-lspconfig
      LanguageClient-neovim
      nvim-treesitter.withAllGrammars
      null-ls-nvim

      rust-tools-nvim
      crates-nvim
      plenary-nvim
      nvim-dap

      vim-nix

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-vsnip
      vim-vsnip


      # GUI
      tokyonight-nvim
      
      
    ];
    extraPackages = with pkgs; [
      clang-tools
    ];
    extraConfig = ''
      set undofile
      set relativenumber
      set number
      set splitbelow
      set splitright
      set nowrap
      set signcolumn=yes
      set tabstop=4 shiftwidth=4 softtabstop=4

      """ Colorscheme
      colorscheme tokyonight-night

      set incsearch ignorecase smartcase hlsearch

      map <Space> <Leader>

      " Navigator
      lua require('Navigator').setup()
      nnoremap <silent><c-h> <cmd>NavigatorLeft<cr>
      nnoremap <silent><c-j> <cmd>NavigatorDown<cr>
      nnoremap <silent><c-k> <cmd>NavigatorUp<cr>
      nnoremap <silent><c-l> <cmd>NavigatorRight<cr>
      tnoremap <silent><c-h> <cmd>NavigatorLeft<cr>
      tnoremap <silent><c-j> <cmd>NavigatorDown<cr>
      tnoremap <silent><c-k> <cmd>NavigatorUp<cr>
      tnoremap <silent><c-l> <cmd>NavigatorRight<cr>

      " FZF
      " nmap <leader><tab> <plug>(fzf-maps-n)
      " noremap <silent> <leader>ff :Files<CR>
      " noremap <silent> <leader>fb :Buffers<CR>
      " noremap <silent> <leader>fp :Files ~/projects<CR>
      " noremap <silent> <leader>gf :GFiles<CR>
      " noremap <silent> <leader>gs :GFiles?<CR>
      " noremap <silent> <leader>gc :Commits<CR>
      " noremap <silent> <leader>gb :BCommits<CR>
      " noremap <leader>sr :Rg      

      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      nnoremap <leader>ld <cmd>Telescope lsp_definitions<cr>
      nnoremap <leader>li <cmd>Telescope lsp_implementations<cr>
      nnoremap <leader>le <cmd>Telescope diagnostics bufnr=0<cr>
      nnoremap <leader>lb <cmd>Telescope lsp_document_symbols<cr>
      nnoremap <leader>lw <cmd>Telescope lsp_workspace_symbols<cr>
      nnoremap <leader>gc <cmd>Telescope git_commits<cr>
      nnoremap <leader>gbc <cmd>Telescope git_bcommits<cr>
      nnoremap <leader>gbr <cmd>Telescope git_branches<cr>
      nnoremap <leader>gs <cmd>Telescope git_status<cr>
      
      " Space unhighlights search
      noremap <silent> <leader><Space> :silent noh<Bar>echo<CR>

      """ Language Specific Formatting
      autocmd FileType xml setlocal tabstop=2 shiftwidth=2
      autocmd FileType xml setlocal tabstop=2 shiftwidth=2
      autocmd FileType c,cpp,h,hpp  setlocal tabstop=8 shiftwidth=8 

      " LSP
      lua << EOF
        require('crates').setup()
        local rt = require("rust-tools")
        
        rt.setup({
          server = {
            on_attach = function(_, bufnr)
              -- Hover actions
              vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
              -- Code action groups
              vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
          },
        })
      
        local cmp = require('cmp')
      
        cmp.setup({
          snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
              -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
              -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
              -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
          },
          window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
          }, {
            { name = 'buffer' },
            { name = 'crates' },
          })
        })
      
        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
          }, {
            { name = 'buffer' },
          })
        })
      
        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })
      
        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          end,
        })
      EOF
    '';
  };
}
