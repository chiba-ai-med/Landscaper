source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Loading
load(infile)

# Plot a disconnectivity graph with the pele or PyConnect style.
dg_skeleton %>%
  ggplot() +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_text(aes(x = xend, y = yend - 0.05, label = state)) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        panel.grid = element_blank()) +
  labs(x = "", y = "Energy", title = "Disconnectivity graph with straight line style") -> g1

# Plot a disconnectivity graph with the 90 degree bending connection style.
dg_skeleton %>%
  ggplot() +
  geom_segment(aes(x = x, y = y, xend = xend, yend = y)) +
  geom_segment(aes(x = xend, y = y, xend = xend, yend = yend)) +
  geom_text(aes(x = xend, y = yend - 0.05, label = state)) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        panel.grid = element_blank()) +
  labs(x = "", y = "Energy", title = "Disconnectivity graph with right-angle bending style") -> g2

# Plot
ggsave(file=outfile1, plot=g1, height = 6, width = 8)
ggsave(file=outfile2, plot=g2, height = 6, width = 8)
