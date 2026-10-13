# Cálculo avanzado

Libro en español escrito con [Quarto](https://quarto.org), publicado en HTML (con versión PDF descargable) mediante GitHub Pages.

## Requisitos

- Quarto 1.10 o superior.
- Una distribución TeX con LuaLaTeX y las fuentes `newcomputermodern` (para el PDF y las figuras).
- Poppler (`pdftocairo`) para convertir las figuras a SVG.
- Node.js y pnpm (solo para los ganchos de git y las versiones).

## Uso

```sh
pnpm install          # instala lefthook y commitlint, y activa los ganchos
pnpm preview          # vista previa con recarga en vivo
pnpm figuras          # recompila las figuras TikZ desactualizadas
pnpm render           # figuras + HTML + PDF en _book/
pnpm release          # nueva versión y CHANGELOG (Conventional Commits)
```

Las convenciones de escritura están en [AGENTS.md](AGENTS.md).

## Licencia

El contenido se distribuye bajo [CC BY-SA 4.0](LICENSE).
