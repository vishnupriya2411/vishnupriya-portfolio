#!/usr/bin/env Rscript
# =============================================================================
# make_p2_figures.R
#
# Reproducibly regenerate the two portfolio figures for project P002
# (Bulk RNASeq Pipeline, APOE Orthologs) directly from the real result
# files produced by the BINF_Computational_Methods pipeline.
#
#   Fig 1  p2_assembly.svg          Trinity contig Nx lengths (de novo vs guided)
#   Fig 2  p2_annotation_blast.svg  BLASTp % identity of predicted proteins vs SwissProt
#
# Inputs (in ./data/, copied verbatim from the repo):
#   trinity_de_novo_stats.txt   <- Transcriptome-Assembly-Analysis/results/
#   trinity_guided_stats.txt    <- Transcriptome-Assembly-Analysis/results/
#   alignPredicted.txt          <- BLAST-Analysis/results/  (BLASTp outfmt6)
#
# Usage:  cd figures/p002 && Rscript make_p2_figures.R
# Output: written to ../../assets/images/projects/
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(svglite)   # same SVG device used for the P001 figures
})

here    <- tryCatch(dirname(sub("^--file=", "",
             grep("^--file=", commandArgs(FALSE), value = TRUE))), error = function(e) ".")
if (length(here) == 0 || here == "") here <- "."
data_dir <- file.path(here, "data")
out_dir  <- normalizePath(file.path(here, "..", "..", "assets", "images", "projects"),
                          mustWork = FALSE)

# --- site palette (matches index.html CSS custom properties) -----------------
INDIGO <- "#818cf8"; TEAL <- "#2dd4bf"; SKY <- "#38bdf8"; PINK <- "red"
INK <- "#1f2937"; MUT <- "#64748b"

theme_portfolio <- function() {
  theme_minimal(base_size = 13) +
    theme(
      plot.title      = element_text(face = "bold", size = 15, colour = INK),
      plot.subtitle   = element_text(size = 11, colour = MUT, margin = margin(b = 10)),
      axis.title      = element_text(size = 11, colour = MUT),
      axis.text       = element_text(size = 10, colour = MUT),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(colour = "#eef1f5"),
      legend.position = c(0.99, 0.99), legend.justification = c(1, 1),
      legend.title    = element_blank(), legend.text = element_text(size = 10, colour = INK),
      plot.margin     = margin(16, 18, 12, 12)
    )
}

# --- helper: pull the "Contig Nxx" values from a Trinity stats file ----------
# Uses the "Stats based on ALL transcript contigs" block (first occurrence).
parse_trinity_nx <- function(path) {
  ln  <- readLines(path)
  blk <- ln[seq(grep("Stats based on ALL", ln)[1], grep("ONLY LONGEST", ln)[1])]
  nx  <- setNames(
    as.integer(sub(".*Contig N[0-9]+:\\s*", "", grep("Contig N[1-5]0:", blk, value = TRUE))),
    paste0("N", seq(10, 50, 10)))
  nx
}

# =============================================================================
# FIGURE 1 — assembly contiguity
# =============================================================================
denovo <- parse_trinity_nx(file.path(data_dir, "trinity_de_novo_stats.txt"))
guided <- parse_trinity_nx(file.path(data_dir, "trinity_guided_stats.txt"))

# total transcripts / assembled bases for the subtitle (de novo)
dn_ln    <- readLines(file.path(data_dir, "trinity_de_novo_stats.txt"))
n_trans  <- as.integer(sub(".*:\\s*", "", grep("Total trinity transcripts", dn_ln, value = TRUE)))
n_comp   <- as.integer(sub(".*:\\s*", "", grep("Total trinity 'genes'",       dn_ln, value = TRUE)))
n_bases  <- as.numeric(sub(".*:\\s*", "", grep("Total assembled bases",       dn_ln, value = TRUE)))

asm <- data.frame(
  Nx    = factor(rep(names(denovo), 2), levels = names(denovo)),
  bp    = c(denovo, guided),
  assy  = factor(rep(c("de novo", "genome-guided"), each = length(denovo)),
                 levels = c("de novo", "genome-guided")))

p1 <- ggplot(asm, aes(Nx, bp, fill = assy)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.68) +
  geom_text(aes(label = scales::comma(bp)), position = position_dodge(width = 0.75),
            vjust = -0.5, size = 3.1, colour = INK) +
  scale_fill_manual(values = c("de novo" = INDIGO, "genome-guided" = TEAL)) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.10))) +
  labs(title = "Trinity assembly contiguity: contig Nx length (bp)",
       subtitle = sprintf("%s de novo transcripts · %s components · %.1f Mb assembled",
                          scales::comma(n_trans), scales::comma(n_comp), n_bases / 1e6),
       x = "Assembly Nx statistic", y = "Contig length (bp)") +
  theme_portfolio()

ggsave(file.path(out_dir, "p2_assembly.svg"), p1, width = 7.6, height = 4.8, device = "svg")
cat("wrote", file.path(out_dir, "p2_assembly.svg"), "\n")

# =============================================================================
# FIGURE 2 — BLASTp percent identity of predicted proteins vs SwissProt
# =============================================================================
# outfmt6 columns: qseqid sseqid pident length mismatch gapopen qs qe ss se evalue bitscore
bl <- read.table(file.path(data_dir, "alignPredicted.txt"), sep = "\t",
                 header = FALSE, quote = "", comment.char = "")
pident   <- bl[[3]]
n_hits   <- nrow(bl)
n_prot   <- length(unique(bl[[1]]))
mean_pid <- mean(pident)

p2 <- ggplot(data.frame(pident = pident), aes(pident)) +
  geom_histogram(breaks = seq(10, 100, 10), fill = SKY, colour = "white",
                 linewidth = 0.4, closed = "left") +
  stat_bin(breaks = seq(10, 100, 10), closed = "left", geom = "text",
           aes(label = scales::comma(after_stat(count))),
           vjust = -0.5, size = 2.9, colour = INK) +
  geom_vline(xintercept = mean_pid, colour = PINK, linetype = "dashed", linewidth = 0.6) +
  annotate("text", x = mean_pid + 1.5, y = Inf, vjust = 1.6, hjust = 0,
           label = sprintf("mean %.1f%%", mean_pid), colour = "#db2777",
           fontface = "bold", size = 3.2) +
  scale_x_continuous(breaks = seq(10, 100, 10)) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.10))) +
  labs(title = "Predicted proteins vs SwissProt: BLASTp percent identity",
       subtitle = sprintf("%s ORFs annotated · %s alignments · mean %.1f%% identity",
                          scales::comma(n_prot), scales::comma(n_hits), mean_pid),
       x = "Percent identity to SwissProt (%)", y = "BLASTp alignments") +
  theme_portfolio() + theme(panel.grid.major.x = element_blank())

ggsave(file.path(out_dir, "p2_annotation_blast.svg"), p2, width = 7.6, height = 4.8, device = "svg")
cat("wrote", file.path(out_dir, "p2_annotation_blast.svg"), "\n")

cat(sprintf("\nSummary (recomputed from data):\n  de novo Nx : %s\n  guided  Nx : %s\n  BLASTp     : %s proteins, %s alignments, mean %.1f%%\n",
            paste(denovo, collapse = "/"), paste(guided, collapse = "/"),
            scales::comma(n_prot), scales::comma(n_hits), mean_pid))
