local function file_stem(path)
  local filename = path:match("([^/\\]+)$") or path
  return filename:gsub("%.[^%.]+$", "")
end

local function normalize_offset(offset)
  if offset == nil or offset == "." then
    return ""
  end
  if offset ~= "" and not offset:match("/$") then
    return offset .. "/"
  end
  return offset
end

return {
  ["chapter-actions"] = function()
    if not quarto.doc.is_format("html") or quarto.doc.input_file == nil then
      return pandoc.Null()
    end

    local stem = file_stem(quarto.doc.input_file)
    local offset = normalize_offset(quarto.project.offset)
    local source = offset .. "notebooks/qmd/" .. stem .. ".qmd"
    local notebook = offset .. "notebooks/ipynb/" .. stem .. ".ipynb"
    local pdf = offset .. "ecological-sampling.pdf"

    local html = string.format([[
<div class="chapter-actions" aria-label="Recursos del capítulo">
  <a class="chapter-action" href="%s" download>
    <i class="bi bi-file-earmark-code" aria-hidden="true"></i>
    <span>Descargar QMD</span>
  </a>
  <a class="chapter-action" href="%s" download>
    <i class="bi bi-journal-code" aria-hidden="true"></i>
    <span>Descargar IPYNB</span>
  </a>
  <a class="chapter-action chapter-action-pdf" href="%s" download>
    <i class="bi bi-file-earmark-pdf" aria-hidden="true"></i>
    <span>Descargar libro en PDF</span>
  </a>
</div>
]], source, notebook, pdf)

    return pandoc.RawBlock("html", html)
  end
}
