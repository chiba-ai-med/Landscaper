source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile <- args[4]

# Loading
E <- unlist(read.table(infile1, header=FALSE))
Basin <- unlist(read.table(infile2, header=FALSE))
EnergyBarrier <- as.matrix(read.table(infile3, header=FALSE))

# Dendrogram
data.frame(state=seq_along(E)-1, E=E) -> state_energy
EnergyBarrier |>
    as.dist() |>
    hclust(method="single") -> hc
hc |> as.dendrogram() -> dend

# get x and y coordinates of nodes.
tibble(leaf = hc$order, count = seq_along(hc$order)) -> node_order

get_nodes_xy(dend) %>%
  data.frame() %>%
  as_tibble() %>%
  magrittr::set_colnames(c("x", "y")) %>%
  mutate(node = seq_len(NROW(.)),
         state = if_else(y == 0, "basin", "transition")) %>%
  group_by(state) %>%
  mutate(count = row_number()) %>%
  left_join(node_order,
            by = "count") %>%
  mutate(count = if_else(state == "transition", count, leaf)) %>%
  mutate(node_name = str_c(state, count, sep = "_")) %>%
  ungroup() %>%
  left_join(state_energy |>
              filter(state %in% (Basin - 1)) %>%
              mutate(stateID = row_number(),
                     stateID = paste0("basin_", stateID)) %>%
              select(!state),
            by = c("node_name" = "stateID")) %>%
  mutate(y = if_else(is.na(E), y, E)) -> df_xy


# assume top node is used by all subtrees
partition_leaves(dend) -> subtrees
subtrees[[1]] -> leaves
lapply(leaves, function(x, subtrees){pathRoutes(x, subtrees)}, subtrees=subtrees) -> paths

tibble(leaf = rep(seq_along(paths), times = lengths(paths)),
                   from = flatten_int(paths)) |>
    mutate(to = lead(from , 1)) |>
    filter(to > from) |>
    select(from, to) |>
    unique() %>%
  left_join(df_xy %>% select(x, y, node, node_name),
            by = c("to" = "node")) %>%
  rename(xend = x,
         yend = y) %>%
  left_join(df_xy %>% select(x, y, node),
            by = c("from" = "node")) %>%
  mutate(leaf = if_else(str_detect(node_name, "basin"), node_name, NA_character_)) -> dg_skeleton

# Save
save(hc, dend, node_order, df_xy, subtrees, leaves, paths, dg_skeleton, file=outfile)