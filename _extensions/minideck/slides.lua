function str_split(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local splits = {}
  for match in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(splits, match)
  end
  return splits
end

-- generic test element class is present
function has_class(el, target_class)
  if (el.classes and #el.classes > 0) then
    for _, class in pairs(el.classes) do
      if class == target_class then
        return true
      end
    end
  end
  return false
end

function has_any_attr(el)
  if (el and el.attributes and #el.attributes > 0) then
    return true
  end
  return false
end

function has_attr(el, attr)
  if has_any_attr(el) then
    for t, v in pairs(el.attributes) do
      if t == attr then
        return true
      end
    end
  end
  return false
end

function typst_block(string, inline)
  if inline then
    return pandoc.RawInline('typst', string)
  else
    return pandoc.RawBlock('typst', string)
  end
end

function wrap_content(el, front, back)
  local content = el.content
  table.insert(content, 1, front)
  table.insert(content, back)
  return content
end

function wrap_uncover(el, inline)
  local typst = "#uncover("
  -- grab arguments
  local indices = has_attr(el, "indices")
  local from = has_attr(el, "from")
  if indices or from then
    if indices then
      typst = typst .. el.attributes["indices"]
    end
    if from then
      if indices then
        typst = typst .. ", "
      end
      typst = typst .. "from: " .. el.attributes["from"]
    end
  else
    error("uncover block used, but `indices` or `from` is required")
    os.exit(1)
  end
  typst = typst .. ")["
  return wrap_content(el, typst_block(typst, inline), typst_block("]", inline))
end

function wrap_only(el, inline)
  local typst = "#only("
  -- grab arguments
  local indices = has_attr(el, "indices")
  local from = has_attr(el, "from")
  if indices or from then
    if indices then
      typst = typst .. el.attributes["indices"]
    end
    if from then
      if indices then
        typst = typst .. ", "
      end
      typst = typst .. "from: " .. el.attributes["from"]
    end
  else
    error("only block used, but `indices` or `from` is required")
    os.exit(1)
  end
  typst = typst .. ")["
  return wrap_content(el, typst_block(typst, inline), typst_block("]", inline))
end

function Div(el)
  if has_class(el, "slide") then
    return wrap_content(
      el,
      typst_block("#slide[", false), typst_block("]", false)
    )
  end
  if has_class(el, "title-slide") then
    return wrap_content(
      el,
      typst_block("#title-slide[", false), typst_block("]", false)
    )
  end
  if has_class(el, "only") then
    return wrap_only(el, false)
  end
  if has_class(el, "uncover") then
    return wrap_uncover(el, false)
  end
  return el
end

function Span(el)
  if has_class(el, "only") then
    return wrap_only(el, true)
  end
  if has_class(el, "uncover") then
    return wrap_uncover(el, true)
  end
  return el
end
