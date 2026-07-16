# Vishnu Priya Nuthanapati's Portfolio

Source for my personal portfolio site. I'm a computational bioinformatician, and
most of my work sits in cancer genomics, spatial and single-cell transcriptomics,
multi-omics, and building NGS pipelines that other people can actually rerun.

Live at **https://vishnupriya-portfolio-rho.vercel.app/**

It's one static page. No framework, no build step. The CSS and JavaScript are
inlined into `index.html`, and every image it needs lives in `assets/`, so the
site renders the same wherever you put it. That's really why this repo exists:
the page and its assets stay together.

## What's in here

```
index.html         the entire site
assets/
  images/
    Vishnu_Headshot.jpg
    icons/         company and technology logos
    projects/      the figures shown on each project
    og-image.png   link preview card
  favicon.svg, favicon.ico
figures/           scripts that regenerate the project figures
  p002/            Trinity assembly and BLASTp charts
  p003/            miRNA gene network drug target chart
robots.txt, sitemap.xml, vercel.json
```

## Project figures

The charts on the project cards aren't mockups. Each one comes out of the real
analysis:

* **P001, single-cell transcriptomics.** The UMAP and volcano are exported
  straight from my
  [Single-Cell-Transcriptomics](https://github.com/vishnupriya2411/Single-Cell-Transcriptomics)
  repo.
* **P002, bulk RNA-seq on APOE orthologs.** Running
  `figures/p002/make_p2_figures.R` rebuilds the assembly contiguity and BLASTp
  identity charts from the pipeline's own result files.
* **P003, miRNA gene networks in schizophrenia.** The network is a real Cytoscape
  export, and `figures/p003/make_p3_figures.R` produces the drug target chart.

## Running it locally

```bash
python3 -m http.server 8000
```

Then open http://localhost:8000.

## Deploying

The live site is on Vercel. I upload it directly instead of wiring up the Git
integration, so this repo is just where the source lives. To ship a change:

```bash
npx vercel@latest deploy --prod --yes
```

`.vercelignore` keeps the `figures/` data, `docs/`, and my resume source out of
what actually gets deployed.
