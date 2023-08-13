# nvim-config

## setup

このディレクトリを `~/.config/nvim` として配置する。

## plugins

plugin は `~/.local/share/nvim/site/pack/default/{start,opt}` に配置する。

### start

- barbar.nvim
- copilog.vim.git
- coc.nvim
- nvim-lspconfig
- nvim-treesitter
- rust.vim
- vim-terraform

### opt

- vim-prettier
- rust-tools.nvim

## CoC.nvim

LSPクライアントとしてCoC.nvimを利用している。

### Extensions

インストールしているCoC Extensionsのリスト。
これらは `:CocInstall <extension>` でインストールできる。

- coc-rust-analyzer

### Configuration

`:CocConfig` コマンドを実行すると、cocのconfigが編集できる。
現在設定している値は↓

- `suggest.autoTrigger`: `none`
- `rust-analyzer.restartServerOnConfigChange`: `true`

## Rust

### rust-analyzerのtargetをデフォルト以外にしたいとき

rust-analyzerのtargetは、デフォルトでホスト環境になっている。
これをそれ以外の値（"wasm32-unknown-unknown"とか）に変えたいときは、以下の手順に従う。

1. `:CocConfig` コマンドでcocのconfigを開く
2. `rust-analyzer.cargo.target` の値を対象の値に変える。（デフォルトに戻したいときは `null` にする）
3. vimを開き直す。（ `:CocCommand rust-analyzer.reload` では設定が反映されない）
