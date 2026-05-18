-- Night Owlish Light for Neovim
-- Ported from Sarah Drasner's VS Code Night Owl theme (light variant)

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') == 1 then vim.cmd('syntax reset') end

vim.o.background = 'light'
vim.g.colors_name = 'night-owlish-light'

local hi = vim.api.nvim_set_hl

local c = {
  bg       = '#FBFBFB',
  fg       = '#403f53',
  comment  = '#989fb1',
  keyword  = '#994cc3',
  func     = '#4876d6',
  string   = '#c96765',
  number   = '#aa0982',
  type     = '#111111',
  operator = '#0c969b',
  boolean  = '#bc5454',
  error    = '#E64D49',
  warning  = '#daaa01',
  selection= '#d5e3f7',
  line_bg  = '#F0F0F0',
  line_nr  = '#aab1be',
  border   = '#d0d0d0',
  pmenu_bg = '#F0F0F0',
  pmenu_sel= '#dce4f5',
  git_add  = '#49d0c5',
}

-- Editor chrome
hi(0, 'Normal',            { fg = c.fg,      bg = c.bg })
hi(0, 'NormalFloat',       { fg = c.fg,      bg = c.pmenu_bg })
hi(0, 'CursorLine',        { bg = c.line_bg })
hi(0, 'CursorLineNr',      { fg = c.keyword, bg = c.line_bg, bold = true })
hi(0, 'LineNr',            { fg = c.line_nr })
hi(0, 'SignColumn',        { fg = c.line_nr, bg = c.bg })
hi(0, 'ColorColumn',       { bg = c.line_bg })
hi(0, 'VertSplit',         { fg = c.border,  bg = c.bg })
hi(0, 'WinSeparator',      { fg = c.border,  bg = c.bg })
hi(0, 'Folded',            { fg = c.comment, bg = c.line_bg })
hi(0, 'FoldColumn',        { fg = c.line_nr, bg = c.bg })
hi(0, 'Visual',            { bg = c.selection })
hi(0, 'Search',            { fg = c.fg,      bg = '#fce094' })
hi(0, 'IncSearch',         { fg = c.bg,      bg = c.keyword })
hi(0, 'MatchParen',        { fg = c.operator, bold = true })
hi(0, 'StatusLine',        { fg = c.fg,      bg = c.line_bg })
hi(0, 'StatusLineNC',      { fg = c.line_nr, bg = c.line_bg })
hi(0, 'Pmenu',             { fg = c.fg,      bg = c.pmenu_bg })
hi(0, 'PmenuSel',          { fg = c.fg,      bg = c.pmenu_sel })
hi(0, 'PmenuSbar',         { bg = c.border })
hi(0, 'PmenuThumb',        { bg = c.line_nr })
hi(0, 'NonText',           { fg = c.border })
hi(0, 'SpecialKey',        { fg = c.border })

-- Syntax
hi(0, 'Comment',           { fg = c.comment,  italic = true })
hi(0, 'Constant',          { fg = c.func })
hi(0, 'String',            { fg = c.string })
hi(0, 'Character',         { fg = c.string })
hi(0, 'Number',            { fg = c.number })
hi(0, 'Boolean',           { fg = c.boolean })
hi(0, 'Float',             { fg = c.number })
hi(0, 'Identifier',        { fg = c.fg })
hi(0, 'Function',          { fg = c.func,    italic = true })
hi(0, 'Statement',         { fg = c.keyword, italic = true })
hi(0, 'Conditional',       { fg = c.keyword, italic = true })
hi(0, 'Repeat',            { fg = c.keyword, italic = true })
hi(0, 'Label',             { fg = c.keyword })
hi(0, 'Operator',          { fg = c.operator })
hi(0, 'Keyword',           { fg = c.keyword, italic = true })
hi(0, 'Exception',         { fg = c.keyword, italic = true })
hi(0, 'PreProc',           { fg = c.keyword })
hi(0, 'Include',           { fg = c.keyword, italic = true })
hi(0, 'Define',            { fg = c.keyword })
hi(0, 'Macro',             { fg = c.keyword })
hi(0, 'Type',              { fg = c.type })
hi(0, 'StorageClass',      { fg = c.keyword, italic = true })
hi(0, 'Structure',         { fg = c.type })
hi(0, 'Typedef',           { fg = c.type })
hi(0, 'Special',           { fg = c.operator })
hi(0, 'SpecialChar',       { fg = c.string })
hi(0, 'Delimiter',         { fg = c.fg })
hi(0, 'Error',             { fg = c.error })
hi(0, 'Todo',              { fg = c.keyword,  bold = true })
hi(0, 'Underlined',        { underline = true })

-- Treesitter
hi(0, '@comment',                  { link = 'Comment' })
hi(0, '@keyword',                  { link = 'Keyword' })
hi(0, '@keyword.import',           { fg = c.keyword, italic = true })
hi(0, '@keyword.operator',         { fg = c.keyword, italic = true })
hi(0, '@keyword.return',           { fg = c.keyword, italic = true })
hi(0, '@function',                 { link = 'Function' })
hi(0, '@function.call',            { fg = c.func })
hi(0, '@function.method',          { link = 'Function' })
hi(0, '@function.method.call',     { fg = c.func })
hi(0, '@variable',                 { fg = c.fg })
hi(0, '@variable.builtin',         { fg = c.boolean })
hi(0, '@variable.member',          { fg = c.fg })
hi(0, '@string',                   { link = 'String' })
hi(0, '@string.escape',            { fg = c.operator })
hi(0, '@number',                   { link = 'Number' })
hi(0, '@number.float',             { link = 'Number' })
hi(0, '@boolean',                  { link = 'Boolean' })
hi(0, '@type',                     { link = 'Type' })
hi(0, '@type.builtin',             { fg = c.type })
hi(0, '@constructor',              { fg = c.type })
hi(0, '@constant',                 { fg = c.func })
hi(0, '@constant.builtin',         { fg = c.boolean })
hi(0, '@operator',                 { link = 'Operator' })
hi(0, '@punctuation.delimiter',    { fg = c.fg })
hi(0, '@punctuation.bracket',      { fg = c.fg })
hi(0, '@punctuation.special',      { fg = c.operator })
hi(0, '@tag',                      { fg = c.keyword })
hi(0, '@tag.attribute',            { fg = c.func, italic = true })
hi(0, '@tag.delimiter',            { fg = c.operator })
hi(0, '@attribute',                { fg = c.func, italic = true })
hi(0, '@namespace',                { fg = c.type })
hi(0, '@parameter',                { fg = c.fg })
hi(0, '@property',                 { fg = c.fg })

-- Diagnostics
hi(0, 'DiagnosticError',           { fg = c.error })
hi(0, 'DiagnosticWarn',            { fg = c.warning })
hi(0, 'DiagnosticInfo',            { fg = c.func })
hi(0, 'DiagnosticHint',            { fg = c.comment })
hi(0, 'DiagnosticUnderlineError',  { undercurl = true, sp = c.error })
hi(0, 'DiagnosticUnderlineWarn',   { undercurl = true, sp = c.warning })

-- Git (gitsigns)
hi(0, 'GitSignsAdd',               { fg = c.git_add })
hi(0, 'GitSignsChange',            { fg = c.func })
hi(0, 'GitSignsDelete',            { fg = c.error })

-- LSP references
hi(0, 'LspReferenceText',          { bg = c.selection })
hi(0, 'LspReferenceRead',          { bg = c.selection })
hi(0, 'LspReferenceWrite',         { bg = c.selection })
