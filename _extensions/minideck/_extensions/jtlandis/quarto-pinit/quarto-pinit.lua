return {
  ['pin'] = function(args, kwargs, meta) 
    if #kwargs ~= 0 then
      error("pin shortcode does not take any keyword arguments")
      os.exit(1)
    end
    if #args ~= 1 then
      error("pin shortcode requires exactly 1 argument")
      os.exit(1)
    end
    return pandoc.RawBlock("typst", "#pin(" .. args[1] .. ")")
  end,
  ['pinit-highlight'] = function(args, kwargs, meta)
    if #kwargs ~= 0 then
      error("pinit-highlight shortcodes does not take any keyword arguments")
      os.exit(1)
    end
    if #args ~= 2 then
      error("pinit-highlight shortcodes requires exactly 2 arguments")
      os.exit(1)
    end
    return pandoc.RawBlock("typst", "#pinit-highlight(" .. args[1] .. ", " .. args[2] .. ")")
  end
    
}
