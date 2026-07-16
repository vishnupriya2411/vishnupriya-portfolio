# P002 figures — Bulk RNASeq Pipeline (APOE Orthologs)

Reproducible generation of the two figures shown in the P002 project modal on the
portfolio. Both are rendered with **ggplot2 + svglite** (the same toolchain that
produced the P001 figures) straight from real pipeline result files.

## Figures produced
| Output (`assets/images/projects/`) | What it shows | Source file |
|---|---|---|
| `p2_assembly.svg` | Trinity contig Nx lengths, de novo vs genome-guided | `trinity_*_stats.txt` |
| `p2_annotation_blast.svg` | BLASTp % identity of predicted proteins vs SwissProt | `alignPredicted.txt` |

## Data provenance
Files in `data/` are copied verbatim from
[vishnupriya2411/BINF_Computational_Methods](https://github.com/vishnupriya2411/BINF_Computational_Methods):

- `trinity_de_novo_stats.txt` — `Transcriptome-Assembly-Analysis/results/trinity-32703926-trinity_de_novo_stats.txt`
- `trinity_guided_stats.txt`  — `Transcriptome-Assembly-Analysis/results/trinity-32703926-trinity_guided_stats.txt`
- `alignPredicted.txt`        — `BLAST-Analysis/results/alignPredicted.txt` (BLASTp `outfmt6`)

## Reproduce
```bash
cd figures/p002
Rscript make_p2_figures.R
```
Requires R with `ggplot2`, `svglite`, and `scales`.

## Numbers plotted (recomputed by the script from `data/`)
- de novo N10–N50: 2049 / 1411 / 1048 / 789 / 605 bp
- genome-guided N10–N50: 1863 / 1287 / 955 / 728 / 570 bp
- assembly: 32,680 transcripts across 29,082 components, 16.6 Mb
- BLASTp: 7,032 predicted proteins, 19,714 alignments, mean 47.5% identity

Nothing here is hand-drawn or synthetic — rerunning the script regenerates the
exact SVGs from the source data.
