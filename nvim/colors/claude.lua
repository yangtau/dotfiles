-- Claude colorscheme for Neovim
-- Inspired by claude.ai / Anthropic brand: warm cream paper + coral accent

vim.cmd.highlight "clear"
if vim.fn.exists "syntax_on" == 1 then vim.cmd.syntax "reset" end

vim.o.background = "light"
vim.g.colors_name = "claude"

local c = {
  -- Paper / background
  bg          = "#F5F4EE", -- main (claude cream)
  bg_alt      = "#EEECE3", -- slightly darker
  bg_soft     = "#FAF9F5", -- softer (floats, popup)
  bg_panel    = "#E8E6DD", -- sidebar / statusline
  bg_sel      = "#E4DFC9", -- selection
  bg_cursor   = "#E9E5D3", -- cursorline
  bg_visual   = "#DED6B8",

  -- Ink
  fg          = "#1F1F1E", -- main text
  fg_soft     = "#2B2A27",
  fg_muted    = "#6B6A63", -- comments fallback
  fg_subtle   = "#8B8A82", -- line numbers, hints
  fg_faint    = "#BAB8AD", -- dividers

  -- Claude signature coral / copper
  coral       = "#C96442", -- primary accent (darker for AA contrast)
  coral_soft  = "#D97757", -- soft highlight
  coral_dim   = "#E89B80", -- backgrounds tinted

  -- Warm muted syntax palette
  red         = "#B54A4A",
  red_soft    = "#C76A6A",
  orange      = "#B76D2B",
  yellow      = "#A67C00",
  olive       = "#6E8F48", -- strings
  green       = "#5A7A3D",
  teal        = "#3F7B79", -- types
  blue        = "#3E6A92", -- functions
  blue_soft   = "#5485AD",
  purple      = "#765C92", -- keywords variant
  magenta     = "#A14D78",

  -- Diagnostic bg tints
  red_bg      = "#F4DCD4",
  yellow_bg   = "#F2E6C2",
  green_bg    = "#E3EAD2",
  blue_bg     = "#DCE4EE",
  coral_bg    = "#F1DACA",

  -- Diff
  diff_add    = "#E3EAD2",
  diff_change = "#F1E3C5",
  diff_delete = "#F4DCD4",
  diff_text   = "#E5C99B",

  none        = "NONE",
}

-- Expose palette so other plugins (e.g. statusline) can read it
vim.g.claude_palette = c

-- Transparent background: default on. Disable with `vim.g.claude_transparent = false`.
local transparent = vim.g.claude_transparent ~= false

local function hl(group, spec) vim.api.nvim_set_hl(0, group, spec) end

local groups = {
  -- Editor base
  Normal          = { fg = c.fg, bg = c.bg },
  NormalNC        = { fg = c.fg, bg = c.bg },
  NormalFloat     = { fg = c.fg, bg = c.bg_soft },
  FloatBorder     = { fg = c.fg_faint, bg = c.bg_soft },
  FloatTitle      = { fg = c.coral, bg = c.bg_soft, bold = true },
  FloatFooter     = { fg = c.fg_subtle, bg = c.bg_soft },
  Cursor          = { fg = c.bg, bg = c.coral },
  lCursor         = { link = "Cursor" },
  CursorLine      = { bg = c.bg_cursor },
  CursorColumn    = { bg = c.bg_cursor },
  CursorLineNr    = { fg = c.coral, bold = true },
  LineNr          = { fg = c.fg_faint },
  SignColumn      = { bg = c.bg },
  FoldColumn      = { fg = c.fg_faint, bg = c.bg },
  Folded          = { fg = c.fg_muted, bg = c.bg_alt },
  ColorColumn     = { bg = c.bg_alt },
  VertSplit       = { fg = c.bg_panel },
  WinSeparator    = { fg = c.bg_panel },
  EndOfBuffer     = { fg = c.bg },
  MatchParen      = { fg = c.coral, bg = c.coral_bg, bold = true },
  NonText         = { fg = c.fg_faint },
  Whitespace      = { fg = c.fg_faint },
  SpecialKey      = { fg = c.fg_faint },
  Conceal         = { fg = c.fg_subtle },
  Directory       = { fg = c.blue, bold = true },
  Title           = { fg = c.coral, bold = true },
  Visual          = { bg = c.bg_visual },
  VisualNOS       = { bg = c.bg_visual },
  Search          = { fg = c.fg, bg = c.diff_text, bold = true },
  IncSearch       = { fg = c.bg, bg = c.coral, bold = true },
  CurSearch       = { fg = c.bg, bg = c.coral, bold = true },
  Substitute      = { fg = c.bg, bg = c.coral_soft },
  ErrorMsg        = { fg = c.red, bold = true },
  WarningMsg      = { fg = c.yellow },
  MsgArea         = { fg = c.fg },
  ModeMsg         = { fg = c.fg, bold = true },
  MoreMsg         = { fg = c.teal },
  Question        = { fg = c.blue },
  Todo            = { fg = c.coral, bg = c.coral_bg, bold = true },

  -- Pmenu / completion
  Pmenu           = { fg = c.fg, bg = c.bg_soft },
  PmenuSel        = { fg = c.fg, bg = c.bg_sel, bold = true },
  PmenuSbar       = { bg = c.bg_panel },
  PmenuThumb      = { bg = c.fg_faint },
  PmenuKind       = { fg = c.purple, bg = c.bg_soft },
  PmenuKindSel    = { fg = c.purple, bg = c.bg_sel, bold = true },
  PmenuExtra      = { fg = c.fg_subtle, bg = c.bg_soft },
  PmenuExtraSel   = { fg = c.fg_subtle, bg = c.bg_sel },
  WildMenu        = { link = "PmenuSel" },

  -- Tabline / Statusline
  StatusLine      = { fg = c.fg, bg = c.bg_panel },
  StatusLineNC    = { fg = c.fg_subtle, bg = c.bg_alt },
  TabLine         = { fg = c.fg_muted, bg = c.bg_alt },
  TabLineSel      = { fg = c.fg, bg = c.bg, bold = true },
  TabLineFill     = { bg = c.bg_alt },
  WinBar          = { fg = c.fg, bg = c.bg },
  WinBarNC        = { fg = c.fg_subtle, bg = c.bg },

  -- Spell
  SpellBad        = { sp = c.red, undercurl = true },
  SpellCap        = { sp = c.blue, undercurl = true },
  SpellLocal      = { sp = c.teal, undercurl = true },
  SpellRare       = { sp = c.purple, undercurl = true },

  -- Syntax (classic)
  Comment         = { fg = c.fg_subtle, italic = true },
  Constant        = { fg = c.coral },
  String          = { fg = c.olive },
  Character       = { fg = c.olive },
  Number          = { fg = c.coral_soft },
  Boolean         = { fg = c.coral, bold = true },
  Float           = { fg = c.coral_soft },
  Identifier      = { fg = c.fg_soft },
  Function        = { fg = c.blue, bold = true },
  Statement       = { fg = c.purple },
  Conditional     = { fg = c.purple },
  Repeat          = { fg = c.purple },
  Label           = { fg = c.magenta },
  Operator        = { fg = c.fg_soft },
  Keyword         = { fg = c.purple, italic = true },
  Exception       = { fg = c.red },
  PreProc         = { fg = c.magenta },
  Include         = { fg = c.magenta },
  Define          = { fg = c.magenta },
  Macro           = { fg = c.magenta },
  PreCondit       = { fg = c.magenta },
  Type            = { fg = c.teal },
  StorageClass    = { fg = c.purple, italic = true },
  Structure       = { fg = c.teal },
  Typedef         = { fg = c.teal },
  Special         = { fg = c.coral },
  SpecialChar     = { fg = c.coral },
  Tag             = { fg = c.blue },
  Delimiter       = { fg = c.fg_muted },
  SpecialComment  = { fg = c.fg_muted, italic = true },
  Debug           = { fg = c.red },
  Underlined      = { fg = c.blue, underline = true },
  Ignore          = { fg = c.fg_faint },
  Error           = { fg = c.red, bold = true },

  -- Diff
  DiffAdd         = { bg = c.diff_add },
  DiffChange      = { bg = c.diff_change },
  DiffDelete      = { bg = c.diff_delete },
  DiffText        = { bg = c.diff_text, bold = true },
  diffAdded       = { fg = c.green },
  diffRemoved     = { fg = c.red },
  diffChanged     = { fg = c.yellow },
  diffFile        = { fg = c.blue, bold = true },
  diffLine        = { fg = c.purple },

  -- Diagnostics
  DiagnosticError           = { fg = c.red },
  DiagnosticWarn            = { fg = c.yellow },
  DiagnosticInfo            = { fg = c.blue },
  DiagnosticHint            = { fg = c.teal },
  DiagnosticOk              = { fg = c.green },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.red_bg },
  DiagnosticVirtualTextWarn  = { fg = c.yellow, bg = c.yellow_bg },
  DiagnosticVirtualTextInfo  = { fg = c.blue, bg = c.blue_bg },
  DiagnosticVirtualTextHint  = { fg = c.teal, bg = c.green_bg },
  DiagnosticUnderlineError  = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn   = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo   = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint   = { sp = c.teal, undercurl = true },
  DiagnosticUnnecessary     = { fg = c.fg_faint },

  -- LSP
  LspReferenceText          = { bg = c.bg_sel },
  LspReferenceRead          = { bg = c.bg_sel },
  LspReferenceWrite         = { bg = c.coral_bg },
  LspInlayHint              = { fg = c.fg_faint, bg = c.bg_alt, italic = true },
  LspCodeLens               = { fg = c.fg_subtle, italic = true },
  LspSignatureActiveParameter = { fg = c.coral, bold = true },

  -- Treesitter (semantic)
  ["@comment"]              = { link = "Comment" },
  ["@comment.todo"]         = { fg = c.bg, bg = c.coral, bold = true },
  ["@comment.note"]         = { fg = c.bg, bg = c.blue, bold = true },
  ["@comment.warning"]      = { fg = c.bg, bg = c.yellow, bold = true },
  ["@comment.error"]        = { fg = c.bg, bg = c.red, bold = true },
  ["@variable"]             = { fg = c.fg_soft },
  ["@variable.builtin"]     = { fg = c.coral, italic = true },
  ["@variable.parameter"]   = { fg = c.fg, italic = true },
  ["@variable.member"]      = { fg = c.fg_soft },
  ["@constant"]             = { fg = c.coral },
  ["@constant.builtin"]     = { fg = c.coral, bold = true },
  ["@constant.macro"]       = { fg = c.magenta },
  ["@module"]               = { fg = c.teal },
  ["@label"]                = { fg = c.magenta },
  ["@string"]               = { link = "String" },
  ["@string.escape"]        = { fg = c.coral_soft },
  ["@string.special"]       = { fg = c.coral_soft },
  ["@string.regexp"]        = { fg = c.coral_soft },
  ["@character"]            = { link = "Character" },
  ["@boolean"]              = { link = "Boolean" },
  ["@number"]               = { link = "Number" },
  ["@float"]                = { link = "Float" },
  ["@function"]             = { link = "Function" },
  ["@function.builtin"]     = { fg = c.blue, italic = true },
  ["@function.macro"]       = { fg = c.magenta },
  ["@function.method"]      = { fg = c.blue, bold = true },
  ["@function.call"]        = { fg = c.blue },
  ["@constructor"]          = { fg = c.teal, bold = true },
  ["@operator"]             = { fg = c.fg_soft },
  ["@keyword"]              = { fg = c.purple, italic = true },
  ["@keyword.function"]     = { fg = c.purple, italic = true },
  ["@keyword.return"]       = { fg = c.purple, bold = true },
  ["@keyword.operator"]     = { fg = c.purple },
  ["@keyword.import"]       = { fg = c.magenta },
  ["@keyword.exception"]    = { fg = c.red },
  ["@conditional"]          = { fg = c.purple },
  ["@repeat"]               = { fg = c.purple },
  ["@type"]                 = { link = "Type" },
  ["@type.builtin"]         = { fg = c.teal, italic = true },
  ["@type.definition"]      = { fg = c.teal, bold = true },
  ["@type.qualifier"]       = { fg = c.purple, italic = true },
  ["@attribute"]            = { fg = c.magenta },
  ["@property"]             = { fg = c.fg_soft },
  ["@field"]                = { fg = c.fg_soft },
  ["@tag"]                  = { fg = c.blue, bold = true },
  ["@tag.attribute"]        = { fg = c.teal, italic = true },
  ["@tag.delimiter"]        = { fg = c.fg_muted },
  ["@punctuation"]          = { fg = c.fg_muted },
  ["@punctuation.bracket"]  = { fg = c.fg_muted },
  ["@punctuation.delimiter"] = { fg = c.fg_muted },
  ["@punctuation.special"]  = { fg = c.coral },

  -- Markup (markdown etc.)
  ["@markup.heading"]       = { fg = c.coral, bold = true },
  ["@markup.heading.1"]     = { fg = c.coral, bold = true },
  ["@markup.heading.2"]     = { fg = c.coral_soft, bold = true },
  ["@markup.heading.3"]     = { fg = c.blue, bold = true },
  ["@markup.heading.4"]     = { fg = c.teal, bold = true },
  ["@markup.heading.5"]     = { fg = c.purple, bold = true },
  ["@markup.heading.6"]     = { fg = c.magenta, bold = true },
  ["@markup.strong"]        = { fg = c.fg, bold = true },
  ["@markup.italic"]        = { fg = c.fg, italic = true },
  ["@markup.strikethrough"] = { strikethrough = true },
  ["@markup.underline"]     = { underline = true },
  ["@markup.quote"]         = { fg = c.fg_muted, italic = true },
  ["@markup.link"]          = { fg = c.blue, underline = true },
  ["@markup.link.label"]    = { fg = c.coral },
  ["@markup.link.url"]      = { fg = c.blue_soft, underline = true, italic = true },
  ["@markup.raw"]           = { fg = c.olive, bg = c.bg_alt },
  ["@markup.raw.block"]     = { fg = c.fg_soft, bg = c.bg_alt },
  ["@markup.list"]          = { fg = c.coral },
  ["@markup.list.checked"]  = { fg = c.green },
  ["@markup.list.unchecked"] = { fg = c.fg_faint },

  -- LSP semantic tokens
  ["@lsp.type.class"]       = { link = "@type" },
  ["@lsp.type.comment"]     = { link = "Comment" },
  ["@lsp.type.decorator"]   = { link = "@attribute" },
  ["@lsp.type.enum"]        = { link = "@type" },
  ["@lsp.type.enumMember"]  = { fg = c.coral },
  ["@lsp.type.function"]    = { link = "Function" },
  ["@lsp.type.interface"]   = { fg = c.teal, italic = true },
  ["@lsp.type.macro"]       = { link = "Macro" },
  ["@lsp.type.method"]      = { link = "@function.method" },
  ["@lsp.type.namespace"]   = { link = "@module" },
  ["@lsp.type.parameter"]   = { link = "@variable.parameter" },
  ["@lsp.type.property"]    = { link = "@property" },
  ["@lsp.type.struct"]      = { link = "@type" },
  ["@lsp.type.type"]        = { link = "@type" },
  ["@lsp.type.typeParameter"] = { fg = c.teal, italic = true },
  ["@lsp.type.variable"]    = { link = "@variable" },
  ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
  ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.method.defaultLibrary"]   = { link = "@function.builtin" },

  -- git signs / gitsigns
  GitSignsAdd              = { fg = c.green },
  GitSignsChange           = { fg = c.yellow },
  GitSignsDelete           = { fg = c.red },
  GitSignsAddInline        = { bg = c.diff_add },
  GitSignsChangeInline     = { bg = c.diff_change },
  GitSignsDeleteInline     = { bg = c.diff_delete },
  GitSignsCurrentLineBlame = { fg = c.fg_faint, italic = true },

  -- Neo-tree
  NeoTreeNormal            = { fg = c.fg, bg = c.bg_alt },
  NeoTreeNormalNC          = { fg = c.fg, bg = c.bg_alt },
  NeoTreeEndOfBuffer       = { fg = c.bg_alt, bg = c.bg_alt },
  NeoTreeWinSeparator      = { fg = c.bg_panel, bg = c.bg_alt },
  NeoTreeRootName          = { fg = c.coral, bold = true },
  NeoTreeDirectoryName     = { fg = c.fg_soft },
  NeoTreeDirectoryIcon     = { fg = c.coral },
  NeoTreeFileName          = { fg = c.fg },
  NeoTreeFileIcon          = { fg = c.fg_muted },
  NeoTreeIndentMarker      = { fg = c.fg_faint },
  NeoTreeExpander          = { fg = c.fg_subtle },
  NeoTreeGitAdded          = { fg = c.green },
  NeoTreeGitModified       = { fg = c.yellow },
  NeoTreeGitDeleted        = { fg = c.red },
  NeoTreeGitIgnored        = { fg = c.fg_faint },
  NeoTreeGitUntracked      = { fg = c.coral_soft },
  NeoTreeGitUnstaged       = { fg = c.yellow },
  NeoTreeGitStaged         = { fg = c.green },
  NeoTreeGitConflict       = { fg = c.red, bold = true },
  NeoTreeCursorLine        = { bg = c.bg_sel },
  NeoTreeTitleBar          = { fg = c.bg, bg = c.coral, bold = true },

  -- Snacks (picker / dashboard / notifier)
  SnacksNormal             = { link = "NormalFloat" },
  SnacksNormalNC           = { link = "NormalFloat" },
  SnacksBackdrop           = { bg = c.bg },
  SnacksPicker             = { link = "NormalFloat" },
  SnacksPickerBorder       = { link = "FloatBorder" },
  SnacksPickerTitle        = { link = "FloatTitle" },
  SnacksPickerInput        = { link = "NormalFloat" },
  SnacksPickerInputBorder  = { link = "FloatBorder" },
  SnacksPickerList         = { link = "NormalFloat" },
  SnacksPickerPreview      = { link = "NormalFloat" },
  SnacksPickerMatch        = { fg = c.coral, bold = true },
  SnacksPickerSelected     = { fg = c.coral },
  SnacksPickerDir          = { fg = c.fg_subtle },
  SnacksPickerFile         = { fg = c.fg },
  SnacksPickerIcon         = { fg = c.fg_muted },
  SnacksPickerBufFlags     = { fg = c.fg_subtle },
  SnacksPickerKeymapLhs    = { fg = c.coral },
  SnacksDashboardHeader    = { fg = c.coral, bold = true },
  SnacksDashboardFooter    = { fg = c.fg_subtle, italic = true },
  SnacksDashboardTitle     = { fg = c.blue, bold = true },
  SnacksDashboardIcon      = { fg = c.coral_soft },
  SnacksDashboardDesc      = { fg = c.fg },
  SnacksDashboardKey       = { fg = c.purple },
  SnacksIndent             = { fg = c.fg_faint },
  SnacksIndentScope        = { fg = c.coral_soft },
  SnacksNotifierInfo       = { fg = c.blue, bg = c.bg_soft },
  SnacksNotifierWarn       = { fg = c.yellow, bg = c.bg_soft },
  SnacksNotifierError      = { fg = c.red, bg = c.bg_soft },
  SnacksNotifierTrace      = { fg = c.fg_subtle, bg = c.bg_soft },

  -- Telescope (fallback)
  TelescopeNormal          = { link = "NormalFloat" },
  TelescopeBorder          = { link = "FloatBorder" },
  TelescopeTitle           = { link = "FloatTitle" },
  TelescopePromptNormal    = { link = "NormalFloat" },
  TelescopePromptBorder    = { link = "FloatBorder" },
  TelescopeSelection       = { bg = c.bg_sel, bold = true },
  TelescopeSelectionCaret  = { fg = c.coral },
  TelescopeMatching        = { fg = c.coral, bold = true },

  -- nvim-cmp / blink
  CmpItemAbbr              = { fg = c.fg },
  CmpItemAbbrDeprecated    = { fg = c.fg_faint, strikethrough = true },
  CmpItemAbbrMatch         = { fg = c.coral, bold = true },
  CmpItemAbbrMatchFuzzy    = { fg = c.coral_soft },
  CmpItemKind              = { fg = c.purple },
  CmpItemMenu              = { fg = c.fg_subtle },
  BlinkCmpLabel            = { fg = c.fg },
  BlinkCmpLabelMatch       = { fg = c.coral, bold = true },
  BlinkCmpKind             = { fg = c.purple },
  BlinkCmpSource           = { fg = c.fg_subtle },

  -- indent-blankline / mini.indentscope
  IblIndent                = { fg = c.fg_faint },
  IblScope                 = { fg = c.coral_soft },
  MiniIndentscopeSymbol    = { fg = c.coral_soft },

  -- notify
  NotifyBackground         = { bg = c.bg_soft },
  NotifyINFOBorder         = { fg = c.blue, bg = c.bg_soft },
  NotifyWARNBorder         = { fg = c.yellow, bg = c.bg_soft },
  NotifyERRORBorder        = { fg = c.red, bg = c.bg_soft },
  NotifyDEBUGBorder        = { fg = c.fg_subtle, bg = c.bg_soft },
  NotifyTRACEBorder        = { fg = c.purple, bg = c.bg_soft },
  NotifyINFOIcon           = { fg = c.blue },
  NotifyWARNIcon           = { fg = c.yellow },
  NotifyERRORIcon          = { fg = c.red },
  NotifyDEBUGIcon          = { fg = c.fg_subtle },
  NotifyTRACEIcon          = { fg = c.purple },

  -- Trouble
  TroubleNormal            = { link = "NormalFloat" },
  TroubleText              = { fg = c.fg },
  TroubleCount             = { fg = c.coral, bold = true },
  TroubleSource            = { fg = c.fg_subtle },
  TroubleFoldIcon          = { fg = c.coral },
  TroubleIndent            = { fg = c.fg_faint },
  TroubleLocation          = { fg = c.fg_subtle },

  -- WhichKey
  WhichKey                 = { fg = c.coral, bold = true },
  WhichKeyGroup            = { fg = c.blue },
  WhichKeyDesc             = { fg = c.fg },
  WhichKeySeparator        = { fg = c.fg_faint },
  WhichKeyFloat            = { bg = c.bg_soft },
  WhichKeyBorder           = { link = "FloatBorder" },
  WhichKeyValue            = { fg = c.fg_subtle },

  -- Flash / hop
  FlashLabel               = { fg = c.bg, bg = c.coral, bold = true },
  FlashMatch               = { fg = c.fg, bg = c.coral_bg },
  FlashCurrent             = { fg = c.fg, bg = c.diff_text, bold = true },

  -- mason
  MasonHeader              = { fg = c.bg, bg = c.coral, bold = true },
  MasonHeaderSecondary     = { fg = c.bg, bg = c.coral_soft, bold = true },
  MasonHighlight           = { fg = c.coral },
  MasonHighlightBlock      = { fg = c.bg, bg = c.coral },
  MasonHighlightBlockBold  = { fg = c.bg, bg = c.coral, bold = true },
  MasonMuted               = { fg = c.fg_subtle },
  MasonMutedBlock          = { fg = c.fg_subtle, bg = c.bg_alt },

  -- lazy
  LazyNormal               = { link = "NormalFloat" },
  LazyButton               = { fg = c.fg, bg = c.bg_alt },
  LazyButtonActive         = { fg = c.bg, bg = c.coral, bold = true },
  LazyH1                   = { fg = c.bg, bg = c.coral, bold = true },
  LazyH2                   = { fg = c.coral, bold = true },
  LazyProgressDone         = { fg = c.coral },
  LazyProgressTodo         = { fg = c.fg_faint },
  LazyReasonCmd            = { fg = c.yellow },
  LazyReasonEvent          = { fg = c.olive },
  LazyReasonFt             = { fg = c.purple },
  LazyReasonImport         = { fg = c.teal },
  LazyReasonKeys           = { fg = c.magenta },
  LazyReasonPlugin         = { fg = c.coral },
  LazyReasonSource         = { fg = c.blue },
  LazyReasonStart          = { fg = c.green },
  LazyValue                = { fg = c.coral_soft },
  LazySpecial              = { fg = c.coral_soft },

  -- Heirline / AstroUI statusline modes
  HeirlineNormal           = { bg = c.coral },
  HeirlineInsert           = { bg = c.olive },
  HeirlineVisual           = { bg = c.purple },
  HeirlineReplace          = { bg = c.red },
  HeirlineCommand          = { bg = c.yellow },
  HeirlineTerminal         = { bg = c.teal },
  HeirlineInactive         = { bg = c.fg_muted },

  -- Copilot
  CopilotSuggestion        = { fg = c.fg_faint, italic = true },
  CopilotAnnotation        = { fg = c.fg_subtle, italic = true },

  -- Render markdown (render-markdown.nvim)
  RenderMarkdownCode       = { bg = c.bg_alt },
  RenderMarkdownCodeInline = { fg = c.olive, bg = c.bg_alt },
  RenderMarkdownH1Bg       = { fg = c.coral, bg = c.coral_bg, bold = true },
  RenderMarkdownH2Bg       = { fg = c.coral_soft, bg = c.coral_bg, bold = true },
  RenderMarkdownH3Bg       = { fg = c.blue, bg = c.blue_bg, bold = true },
  RenderMarkdownH4Bg       = { fg = c.teal, bg = c.green_bg, bold = true },
  RenderMarkdownH5Bg       = { fg = c.purple, bold = true },
  RenderMarkdownH6Bg       = { fg = c.magenta, bold = true },
  RenderMarkdownBullet     = { fg = c.coral },
  RenderMarkdownQuote      = { fg = c.fg_muted },
  RenderMarkdownTableHead  = { fg = c.coral, bold = true },
  RenderMarkdownTableRow   = { fg = c.fg },

  -- Smear cursor
  SmearCursorNormal        = { fg = c.coral },
}

-- Transparent background: clear bg on editor/panel surfaces while keeping
-- popups (Pmenu/NormalFloat) opaque for readability.
if transparent then
  local transparent_groups = {
    "Normal", "NormalNC",
    "SignColumn", "FoldColumn", "EndOfBuffer",
    "MsgArea", "LineNr", "CursorLineNr",
    "StatusLine", "StatusLineNC",
    "TabLine", "TabLineFill",
    "WinBar", "WinBarNC",
    "VertSplit", "WinSeparator",
    "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
    "NeoTreeWinSeparator",
    "TroubleNormal",
  }
  for _, g in ipairs(transparent_groups) do
    local spec = groups[g]
    if spec then
      spec.bg = "NONE"
      spec.ctermbg = "NONE"
    end
  end
end

for group, spec in pairs(groups) do
  hl(group, spec)
end

-- Terminal colors (for :terminal)
vim.g.terminal_color_0  = c.fg
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.olive
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.blue
vim.g.terminal_color_5  = c.purple
vim.g.terminal_color_6  = c.teal
vim.g.terminal_color_7  = c.fg_muted
vim.g.terminal_color_8  = c.fg_subtle
vim.g.terminal_color_9  = c.red_soft
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.coral_soft
vim.g.terminal_color_12 = c.blue_soft
vim.g.terminal_color_13 = c.magenta
vim.g.terminal_color_14 = c.teal
vim.g.terminal_color_15 = c.fg
