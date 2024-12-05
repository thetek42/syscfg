if vim.b.current_syntax then
    return
end

vim.cmd [[
    syn match   cgDelim    "{\|}\|;\|(\|)\|\.\|,\|\[\|\]"
    syn keyword cgKeyword  fn else if return struct template typedef
    syn match   cgOperator "\*\|<\|>\|=\|!\|-"
    syn keyword cgSpecial  true false nullptr
    syn keyword cgType     int size_t T void
    syn region  cgComment  start='/\*' end='\*/'
    syn region  cgComment  start='//' end='$'
]]

vim.cmd [[
    hi def link cgComment  @comment
    hi def link cgDelim    @punctuation.delimiter
    hi def link cgNumber   @number
    hi def link cgKeyword  @keyword
    hi def link cgOperator @operator
    hi def link cgSpecial  @boolean
    hi def link cgType     @type
]]

vim.b.current_syntax = "cougar"
