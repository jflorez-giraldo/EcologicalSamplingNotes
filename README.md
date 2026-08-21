# Ecological Sampling

Libro Quarto sobre diseño, estimación y análisis reproducible en muestreo
ecológico.

## Requisitos

- Quarto 1.5 o posterior
- R 4.5 o posterior
- paquetes de R administrados con `renv`
- Jupyter e IRkernel para abrir los notebooks IPYNB
- una distribución de LaTeX para producir el PDF

## Desarrollo local

```bash
Rscript -e 'renv::restore()'
Rscript scripts/build-notebooks.R
quarto preview
```

Para construir todas las salidas:

```bash
quarto render
```

Los archivos QMD son la fuente canónica. Los IPYNB de `notebooks/ipynb/` se
generan mediante `scripts/build-notebooks.R` y no deben editarse manualmente.

## Arquitectura editorial

- once capítulos organizados en seis partes;
- teoría aplicada, proyectos guiados en R y ejercicios;
- un capítulo de síntesis para proyectos completos;
- casos reales documentados en `data-catalog.qmd`;
- plantillas reproducibles en `resources/templates/`; y
- materiales de enseñanza privados en `instructor/`, fuera del render público.

## Desarrollar un capítulo

1. Desarrolle el contenido dentro del archivo `chapters/chapterNN.qmd` existente.
2. Conserve fundamentos, proyecto guiado, interpretación, ejercicios y proyecto autónomo.
3. Registre fuentes en `references.bib` y cite con la sintaxis `[@clave]`.
4. Documente todo nuevo dataset con la plantilla de metadatos.
5. Genere notebooks y renderice el libro antes de publicar.
