local lsp_types = require("cmp.types.lsp")
local buffer = require("nvlime.buffer")
local opts = require("nvlime.config")
local psl = require("parsley")
require("cmp.types.cmp")
local _2bfuzzy_3f_2b
local function _1_(_241)
  return ("SWANK-FUZZY" == _241)
end
_2bfuzzy_3f_2b = not psl["empty?"](psl.filter(_1_, opts.contribs))
local flag_kind = {b = lsp_types.CompletionItemKind.Variable, f = lsp_types.CompletionItemKind.Function, g = lsp_types.CompletionItemKind.Method, c = lsp_types.CompletionItemKind.Class, t = lsp_types.CompletionItemKind.Class, m = lsp_types.CompletionItemKind.Operator, s = lsp_types.CompletionItemKind.Operator, p = lsp_types.CompletionItemKind.Module}
local kind_precedence = {lsp_types.CompletionItemKind.Module, lsp_types.CompletionItemKind.Class, lsp_types.CompletionItemKind.Operator, lsp_types.CompletionItemKind.Method, lsp_types.CompletionItemKind.Function, lsp_types.CompletionItemKind.Variable}
local function flags__3ekind(flags)
  if (type(flags) ~= "string") then
    return nil
  else
  end
  local kinds = {}
  for i = 1, #flags do
    local kind = flag_kind[flags:sub(i, i)]
    if kind then
      kinds[kind] = true
    else
    end
  end
  for _, kind in ipairs(kind_precedence) do
    if kinds[kind] then
      return kind
    else
    end
  end
  return nil
end
local function set_documentation(item)
  local get_documentation = vim.fn["nvlime#cmp#get_docs"]
  local function _5_(_241)
    item["documentation"] = string.gsub(_241, "^Documentation for the symbol.-\n\n", "", 1)
    return nil
  end
  return get_documentation(item.label, _5_)
end
local get_lsp_kind
if _2bfuzzy_3f_2b then
  local function _6_(item)
    local flags = item[2]
    local flags_str
    if (type(flags) == "string") then
      flags_str = flags
    else
      flags_str = nil
    end
    return {label = psl.first(item), labelDetails = {detail = flags_str}, kind = (flags__3ekind(flags) or lsp_types.CompletionItemKind.Keyword)}
  end
  get_lsp_kind = _6_
else
  local function _8_(_241)
    return {label = _241}
  end
  get_lsp_kind = _8_
end
local get_completion
local _10_
if _2bfuzzy_3f_2b then
  _10_ = "nvlime#cmp#get_fuzzy"
else
  _10_ = "nvlime#cmp#get_simple"
end
get_completion = vim.fn[_10_]
local source = {}
source.is_available = function(self)
  return not psl["null?"](buffer["get-conn-var!"](0))
end
source.get_debug_name = function(self)
  return "CMP Nvlime"
end
source.get_keyword_pattern = function(self)
  return "\\k\\+"
end
source.complete = function(self, params, callback)
  local on_done
  local function _12_(candidates)
    local function _13_()
      local tbl_26_ = {}
      local i_27_ = 0
      for _, c in ipairs((candidates or {})) do
        local val_28_ = get_lsp_kind(c)
        if (nil ~= val_28_) then
          i_27_ = (i_27_ + 1)
          tbl_26_[i_27_] = val_28_
        else
        end
      end
      return tbl_26_
    end
    return callback(_13_())
  end
  on_done = _12_
  local input = string.sub(params.context.cursor_before_line, params.offset)
  return get_completion(input, on_done)
end
source.resolve = function(self, item, callback)
  set_documentation(item)
  local function _15_()
    return callback(item)
  end
  return vim.defer_fn(_15_, 5)
end
return source