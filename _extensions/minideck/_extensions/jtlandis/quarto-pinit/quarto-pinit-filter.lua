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

function wrap_content(el, front, back)
  local content = el.content
  table.insert(content, 1, front)
  table.insert(content, back)
  return content
end

function wrap_pinit_point_from_span(el)
  local typst = "#pinit-point-from("
  if has_attr(el, "pin") then
    typst = typst .. el.attributes["pin"] .. ")["
  else
    error("pinit-point-from needs a `pin` attribute... `pin=\"1,2\"`")
    os.exit(1)
  end
  return wrap_content(
    el,
    pandoc.RawInline("typst", typst),
    pandoc.RawInline("typst", "]"))
end

function wrap_pinit_point_from(el)
  local typst = "#pinit-point-from("
  if has_attr(el, "pin") then
    typst = typst .. el.attributes["pin"] .. ")["
  else
    error("pinit-point-from needs a `pin` attribute... `pin=\"1\"`")
    os.exit(1)
  end
  return wrap_content(
    el,
    pandoc.RawBlock("typst", typst),
    pandoc.RawBlock("typst", "]"))
end

function Div(el)
  if has_class(el, "pinit-point-from") then
    el.content = wrap_pinit_point_from(el)
    return el
  end
end

function Span(el)
  if has_class(el, "pinit-point-from") then
    local new_content = wrap_pinit_point_from_span(el)
    el.content = new_content
    return el
  end
end
