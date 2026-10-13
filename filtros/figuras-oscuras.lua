-- For HTML output, pairs every image that has a dark variant
-- (figuras/nombre.svg + figuras/nombre-oscuro.svg, built by
-- scripts/figuras.sh) so the theme toggle shows the right one: the light
-- image gets .light-content and the dark copy .dark-content, both hidden or
-- shown by Quarto's own CSS. Images without a dark variant are left alone.
-- Runs after Quarto's filters so figures and cross-references are already
-- resolved.

local function exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

local function dark_variant(src)
  if src:match("^%a[%w+.-]*:") then
    return nil -- remote or data URL
  end
  local base = src:gsub("%.svg$", "")
  if base:match("%.%w+$") then
    return nil -- some other explicit extension
  end
  local dark_src = base .. "-oscuro.svg"
  local input_dir = pandoc.path.directory(quarto.doc.input_file)
  if exists(pandoc.path.join({ input_dir, dark_src })) then
    return dark_src
  end
  return nil
end

function Image(img)
  if not quarto.doc.is_format("html") then
    return nil
  end
  local dark_src = dark_variant(img.src)
  if not dark_src then
    return nil
  end
  local dark = img:clone()
  dark.src = dark_src
  dark.identifier = ""
  dark.classes:insert("dark-content")
  img.classes:insert("light-content")
  return { img, dark }
end
