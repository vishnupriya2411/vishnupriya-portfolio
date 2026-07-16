# Vishnu Priya Nuthanapati — Portfolio

Personal portfolio of **Vishnu Priya Nuthanapati**, computational bioinformatician
(cancer genomics, spatial & single-cell transcriptomics, multi-omics, and
reproducible NGS pipelines).

**Live site:** https://vishnupriya2411.github.io/vishnupriya-portfolio/

Static HTML/CSS/JS — no build step, no framework. `index.html` has all CSS and JS
inlined; the `assets/` folder holds every image, so the site renders identically
wherever it is hosted (this repo exists so the assets travel with the page).

## Structure

```
index.html                     # the whole site (HTML + inline CSS/JS)
assets/
  images/
    Vishnu_Headshot.jpg        # portrait (About section)
    icons/                     # company + technology logos
    projects/                  # project result figures (SVG/PNG)
    og-image.png               # social share card
  favicon.svg, favicon.ico
figures/                       # reproducible figure generation (provenance)
  p002/  make_p2_figures.R + data   # Trinity assembly + BLASTp figures
  p003/  make_p3_figures.R + data   # miRNA-gene network drug-target figure
robots.txt, sitemap.xml, vercel.json
```

## Project figures

The figures shown under **Projects** are generated from actual analysis outputs:

- **P001 — Single-Cell Transcriptomics:** UMAP and volcano from the
  [Single-Cell-Transcriptomics](https://github.com/vishnupriya2411/Single-Cell-Transcriptomics) repo.
- **P002 — Bulk RNA-seq (APOE):** `figures/p002/make_p2_figures.R` regenerates the
  assembly-contiguity and BLASTp-identity figures from the pipeline result files.
- **P003 — miRNA-Gene Networks (Schizophrenia):** a real Cytoscape network plus
  `figures/p003/make_p3_figures.R` for the drug-target chart.

## Preview locally

```bash
python3 -m http.server 8000   # then open http://localhost:8000
```

## Hosting

Deployed via **GitHub Pages** (Settings → Pages → deploy from `main` / root).
Also works on any static host (e.g. Vercel via `vercel.json`). No build step.
