return {
  cmd = { "blueprint-compiler", "lsp" },
  cmd_env = {
    GLOB_PATTERN = vim.env.GLOB_PATTERN or "*@(.blp)",
  },
  filetypes = { "blueprint" },
  root_markers = { ".git" },
}
