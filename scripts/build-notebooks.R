#!/usr/bin/env Rscript

project_root <- normalizePath(getwd(), mustWork = TRUE)
chapter_dir <- file.path(project_root, "chapters")
qmd_dir <- file.path(project_root, "notebooks", "qmd")
ipynb_dir <- file.path(project_root, "notebooks", "ipynb")

dir.create(qmd_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(ipynb_dir, recursive = TRUE, showWarnings = FALSE)

chapters <- list.files(chapter_dir, pattern = "\\.qmd$", full.names = TRUE)

if (length(chapters) == 0L) {
  message("No se encontraron capítulos QMD.")
  quit(status = 0L)
}

expected_qmd <- basename(chapters)
expected_ipynb <- sub("\\.qmd$", ".ipynb", expected_qmd)
stale_qmd <- setdiff(list.files(qmd_dir, pattern = "\\.qmd$"), expected_qmd)
stale_ipynb <- setdiff(list.files(ipynb_dir, pattern = "\\.ipynb$"), expected_ipynb)

unlink(file.path(qmd_dir, stale_qmd))
unlink(file.path(ipynb_dir, stale_ipynb))

quarto <- Sys.which("quarto")
if (!nzchar(quarto)) {
  stop("No se encontró Quarto en PATH.")
}

for (chapter in chapters) {
  target_qmd <- file.path(qmd_dir, basename(chapter))
  target_ipynb <- file.path(
    ipynb_dir,
    sub("\\.qmd$", ".ipynb", basename(chapter))
  )

  file.copy(chapter, target_qmd, overwrite = TRUE)

  notebook_source <- readLines(chapter, warn = FALSE)
  if (length(notebook_source) > 0L && notebook_source[[1L]] == "---") {
    notebook_source <- append(notebook_source, "jupyter: ir", after = 1L)
  } else {
    notebook_source <- c("---", "jupyter: ir", "---", "", notebook_source)
  }
  notebook_source <- notebook_source[
    !grepl("^\\{\\{< chapter-actions >\\}\\}$", notebook_source)
  ]

  temporary_qmd <- tempfile(fileext = ".qmd")
  writeLines(notebook_source, temporary_qmd, useBytes = TRUE)
  on.exit(unlink(temporary_qmd), add = TRUE)

  status <- system2(
    quarto,
    c("convert", shQuote(temporary_qmd), "--output", shQuote(target_ipynb))
  )

  if (!identical(status, 0L)) {
    stop("No fue posible convertir ", basename(chapter), " a IPYNB.")
  }
}

message("Recursos generados para ", length(chapters), " capítulo(s).")
