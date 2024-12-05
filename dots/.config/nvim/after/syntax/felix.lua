if vim.b.current_syntax then
    return
end

vim.cmd [[
    syn match   felixDelim    '(\|)\|\[\|\]\|:\|,\|;\|\.' display
    syn match   felixFuncDef  '^[a-z][A-Za-z_0-9]*' display
    syn match   felixNumber   '\<[0-9]\+\>' display
    syn keyword felixKeyword  case const let mut with
    syn match   felixOperator '=\|+\|->\|<-\|\.\.' display
    syn keyword felixOpKeywd  shl shr bit_and bit_not bit_or bit_xor
    syn match   felixType     '\<[A-Z][A-Za-z_0-9]*' display
    syn region  felixComment  start='(\*' end='\*)'
]]

vim.cmd [[
    hi def link felixComment  @comment
    hi def link felixDelim    @punctuation.delimiter
    hi def link felixFuncDef  @function
    hi def link felixNumber   @number
    hi def link felixKeyword  @keyword
    hi def link felixOperator @operator
    hi def link felixOpKeywd  @keyword.operator
    hi def link felixType     @type
]]

vim.cmd [[
    syn sync felixcomment felixComment minlines=50
]]

vim.b.current_syntax = "felix"
