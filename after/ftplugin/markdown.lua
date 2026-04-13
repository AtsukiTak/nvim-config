-- Enter で list marker を継続させる
vim.opt_local.formatoptions:append("ro")

-- -, *, + を「次行でも継続する bullet」として扱う
vim.opt_local.comments = "b:*,b:-,b:+,n:>"
