# Neovim Config

A fast, minimal, and modern Neovim configuration built on **Neovim 0.12+** and **vim.pack**. The goal is to keep the setup lightweight, easy to understand, and close to upstream Neovim while providing a productive development experience.

## Features

- 🚀 Native package management with `vim.pack`
- ⚡ Fast fuzzy finding with `fzf-lua`
- 💡 Completion powered by `blink.cmp`
- 🔧 Built-in LSP (`vim.lsp`)
- ✨ Formatting with `conform.nvim`
- 🌳 Treesitter syntax highlighting
- 🌱 Git integration via `gitsigns.nvim`
- 📁 File explorer with `nvim-tree.lua`
- 🤖 GitHub Copilot integration
- 🎨 OneDark theme

## Prerequisites

This configuration uses **mise** to manage external tools (LSPs, formatters, linters, CLI utilities, etc.).

Install all required tools:

```bash
mise install
```

## Installation

Clone the repository:

```bash
git clone <your-repo> ~/.config/nvim
```

Start Neovim:

```bash
nvim
```

Plugins will be installed automatically on the first launch.
