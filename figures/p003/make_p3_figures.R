#!/usr/bin/env Rscript
# =============================================================================
# make_p3_figures.R
#
# Portfolio figures for project P003 (miRNA-Gene Regulatory Networks in
# Schizophrenia). Data is transcribed verbatim from the embedded result
# charts of the project presentation:
#   "Mapping of microRNA-mediated Gene Regulatory Networks across different
#    tissues in Schizophrenia" (CAMPUS Fellowship 2020; presented at
#    Experimental Biology 2021), held in the Transcriptomics GitHub repo.
#
#   p3_drug_targets.svg  DE hub genes -> candidate drugs (chart 4 + slide 21)
#
# The P003 modal pairs this bar with a real Cytoscape network image from the
# deck (slide 13): assets/images/projects/p3_network_ba46.png.
#
# Usage:  cd figures/p003 && Rscript make_p3_figures.R
# Output: written to ../../assets/images/projects/
# =============================================================================

suppressPackageStartupMessages({ library(ggplot2); library(svglite) })

here    <- tryCatch(dirname(sub("^--file=", "",
             grep("^--file=", commandArgs(FALSE), value = TRUE))), error = function(e) ".")
if (length(here) == 0 || here == "") here <- "."
data_dir <- file.path(here, "data")
out_dir  <- normalizePath(file.path(here, "..", "..", "assets", "images", "projects"),
                          mustWork = FALSE)

INDIGO <- "#818cf8"; TEAL <- "#2dd4bf"; SKY <- "#38bdf8"; PINK <- "#f472b6"
INK <- "#1f2937"; MUT <- "#64748b"

theme_portfolio <- function() {
  theme_minimal(base_size = 13) +
    theme(
      plot.title    = element_text(face = "bold", size = 15, colour = INK),
      plot.subtitle = element_text(size = 11, colour = MUT, margin = margin(b = 10)),
      axis.title    = element_text(size = 11, colour = MUT),
      axis.text     = element_text(size = 9.5, colour = INK),
      panel.grid.minor = element_blank(),
      legend.position = "top", legend.justification = "left",
      legend.title  = element_blank(), legend.text = element_text(size = 10, colour = INK),
      plot.margin   = margin(16, 20, 12, 12)
    )
}

# =============================================================================
# FIGURE — DE hub genes mapped to candidate repurposable drugs
#
# Note: the portfolio pairs this bar figure with a real Cytoscape network image
# taken from the presentation (assets/images/projects/p3_network_ba46.png,
# the BA46 down-regulated miRNA network on slide 13), so only this figure is
# generated here.
# =============================================================================
g <- read.csv(file.path(data_dir, "gene_drug_targets_ba46.csv"), stringsAsFactors = FALSE)
g$dir   <- ifelse(g$logFC >= 0, "Up-regulated in SCZ", "Down-regulated in SCZ")
g$dir   <- factor(g$dir, levels = c("Up-regulated in SCZ", "Down-regulated in SCZ"))
g$gene  <- factor(g$gene, levels = g$gene[order(g$logFC)])
g$lab   <- paste0(g$drug, " (", g$action, ")")
g$hjust <- ifelse(g$logFC >= 0, -0.05, 1.05)

xr <- max(abs(g$logFC))
p2 <- ggplot(g, aes(logFC, gene, fill = dir)) +
  geom_col(width = 0.66) +
  geom_vline(xintercept = 0, colour = "#94a3b8", linewidth = 0.5) +
  geom_text(aes(label = lab, hjust = hjust), size = 3.1, colour = MUT) +
  scale_fill_manual(values = c("Up-regulated in SCZ" = PINK,
                               "Down-regulated in SCZ" = INDIGO)) +
  scale_x_continuous(limits = c(-xr * 2.1, xr * 2.1),
                     breaks = seq(-2, 2, 1), expand = expansion(mult = c(0.02, 0.02))) +
  labs(title = "Dysregulated hub genes matched to candidate drugs (BA46)",
       subtitle = "Drug-target genes by log2 fold change; labels show the matched repurposable drug",
       x = "log2 fold change (SCZ vs control)", y = NULL) +
  theme_portfolio()

ggsave(file.path(out_dir, "p3_drug_targets.svg"), p2, width = 7.6, height = 4.6, device = "svg")
cat("wrote p3_drug_targets.svg\n")

cat(sprintf("\nDrug-target genes: %d across %d drugs\n",
    nrow(g), length(unique(g$drug))))
