# Convenciones del proyecto Quarto

Libro «Cálculo avanzado» escrito en Quarto. La salida principal es HTML (GitHub Pages); el PDF es secundario: debe compilar sin errores y verse correcto, pero no se ajusta al detalle.

## Estructura

- `_quarto.yml`: configuración del libro (capítulos, formatos, bibliografía).
- `index.qmd`: prefacio. `referencias.qmd`: lista de referencias.
- `capitulos/NN-tema/index.qmd`: un directorio por capítulo, con sus figuras en `capitulos/NN-tema/figuras/`. Cada capítulo nuevo se añade a `book.chapters` en `_quarto.yml`.
- `macros.tex`: macros de notación, fuente única para el PDF, el HTML (MathJax, vía `filtros/macros.lua`) y las figuras TikZ.
- `tikz-estilos.tex`: preámbulo y estilos compartidos por todas las figuras.
- `referencias.bib`: bibliografía. `iso690-numeric-es.csl`: estilo de citas (ISO 690 numérico, en español).
- `estilos/custom.scss`: ajustes del tema HTML.

## Escritura

- **Idioma:** todo el contenido está en español. El código fuente (macros, estilos, filtros, scripts de configuración) se comenta en inglés.
- **Entornos de teoremas:** usar los bloques nativos de Quarto, que se muestran en español gracias a `lang: es`:
  - `::: {#def-etiqueta}` → «Definición», `#thm-` → «Teorema», `#lem-` → «Lema», `#cor-` → «Corolario», `#prp-` → «Proposición», `#exm-` → «Ejemplo», `#exr-` → «Ejercicio».
  - Las demostraciones van en `::: {.proof}`.
  - El título opcional se escribe como encabezado `##` en la primera línea del bloque.
  - Los prefijos de las etiquetas son los de Quarto (en inglés); el resto de la etiqueta va en español: `#thm-valor-intermedio`.
- **Referencias cruzadas:** siempre con `@etiqueta` (`@thm-valor-intermedio`, `@fig-limite`, `@eq-limite`, `@sec-limites`), nunca con números escritos a mano.
- **Fórmulas matemáticas:** usar `$…$` para fórmulas en línea y `$$…$$` para fórmulas destacadas. *Excepción deliberada* respecto a los libros en LaTeX, que usan `\( \)`: en Quarto los dólares son la sintaxis nativa y la más fiable en todas las salidas. Las ecuaciones numeradas llevan la etiqueta tras el cierre: `$$ … $$ {#eq-nombre}`.
- **Macros de notación:** usar las macros de `macros.tex` (`\abs{x}`, `\norm{x}`, `\deriv{f}{x}`, `\pderiv{f}{x}`, …) en lugar de escribir la notación a mano. No redefinir `\H` (acento húngaro de LaTeX). Las macros nuevas deben ser compatibles con MathJax: solo `\newcommand` con argumentos obligatorios, una definición por línea.
- **Comillas:** escribir directamente las comillas angulares «», y “ ” para citas dentro de citas.
- **Mayúsculas en títulos:** los títulos en español llevan mayúscula solo en la primera letra y en los nombres propios, nunca en cada palabra como en inglés. Aplica a títulos de capítulos y secciones, títulos opcionales de teoremas, leyendas de figuras y tablas, y encabezados de los archivos Markdown del proyecto.
  - Correcto: `# Integrales múltiples`, `## El teorema de Fubini`.
  - Incorrecto: `# Integrales Múltiples`, `## El Teorema de Fubini`.
- **Nombres de resultados y conceptos:** los nombres de teoremas, lemas, desigualdades, algoritmos y demás conceptos se escriben en minúscula, salvo los nombres propios (RAE, *Ortografía*: no se usa la «mayúscula de relevancia»). La única mayúscula adicional es la de la primera palabra del título o de la oración.
  - Correcto: «la desigualdad de Cauchy-Schwarz», «el teorema de la función implícita», «el criterio de Weierstrass».
  - Incorrecto: «la Desigualdad de Cauchy-Schwarz», «el Teorema de la Función Implícita».
- **Citas bibliográficas:** `[@clave]` o `[@clave, cap. 2]`. Toda entrada nueva va en `referencias.bib`.

## Figuras

- Cada figura es un archivo TikZ independiente en `capitulos/NN-tema/figuras/nombre.tex`, que empieza con `\documentclass[tikz]{standalone}` y `\input{tikz-estilos}`.
- **Colores:** usar solo la paleta semántica de `tikz-estilos.tex` (`fig-trazo`, `fig-acento`, `fig-acento2`, `fig-relleno`, `fig-relleno2`, `fig-fondo`), nunca colores literales como `blue` o `black`. Así cada figura tiene una variante legible en el tema oscuro. El color por defecto de líneas y texto ya es `fig-trazo`.
- `scripts/figuras.sh` compila cada figura dos veces con LuaLaTeX y genera `nombre.pdf` (libro PDF), `nombre.svg` (HTML, tema claro) y `nombre-oscuro.svg` (HTML, tema oscuro, compilada con `\modooscuro` definido). Sin argumentos recompila solo las desactualizadas; `--todas` las recompila todas.
- En el capítulo, la figura se incluye **sin extensión**, para que cada formato elija la suya: `![Leyenda.](figuras/nombre){#fig-nombre}`. En HTML, `filtros/figuras-oscuras.lua` añade la variante oscura y el selector de tema de Quarto muestra la que corresponde (clases `.light-content` y `.dark-content`).
- Los SVG y PDF generados se versionan: CI no compila TikZ. El gancho `pre-commit` de lefthook los regenera y los añade al commit automáticamente.

## Compilación

- Vista previa: `quarto preview` (o `pnpm preview`).
- Libro completo: `pnpm render` (figuras + HTML + PDF en `_book/`).
- El PDF se compila con LuaLaTeX y las fuentes New Computer Modern, cargadas con el paquete `newcomputermodern` en `include-in-header` (no con `mainfont`/`mathfont`, que fallan en TinyTeX).
- Cada push a `main` publica el libro en GitHub Pages (`.github/workflows/publicar.yml`), con enlace de descarga del PDF.

## Control de versiones

- Seguir siempre la especificación de *Conventional Commits* para los mensajes de los commits (ej. `feat:`, `fix:`, `chore:`, `docs:`), escritos en español. Lo valida automáticamente LeftHook con `commitlint`.
- Las versiones y el `CHANGELOG.md` se generan con `pnpm release` (commit-and-tag-version).
