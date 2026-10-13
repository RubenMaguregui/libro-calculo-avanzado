-- Injects the notation macros from macros.tex into every HTML page as a
-- hidden MathJax block, so HTML and PDF share a single source of macros.
-- For LaTeX output the macros arrive through include-in-header instead.

local function read_macros()
  local path = pandoc.path.join({ quarto.project.directory, "macros.tex" })
  local file = io.open(path, "r")
  if not file then
    error("filtros/macros.lua: cannot open " .. path)
  end
  local lines = {}
  for line in file:lines() do
    local code = line:gsub("%%.*$", "")
    if code:match("%S") then
      table.insert(lines, code)
    end
  end
  file:close()
  return table.concat(lines, "\n")
end

function Pandoc(doc)
  if not quarto.doc.is_format("html") then
    return doc
  end
  local block = pandoc.RawBlock(
    "html",
    '<div class="macros-mathjax" style="display:none">\n\\[\n'
      .. read_macros()
      .. "\n\\]\n</div>"
  )
  table.insert(doc.blocks, 1, block)
  return doc
end
