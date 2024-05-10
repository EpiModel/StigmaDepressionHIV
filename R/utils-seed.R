sample_join <- function(x, y, by) {
  x <- dplyr::mutate(x, .orig.pos = seq_len(dplyr::n()))
  d_combs <- lapply(x[by], unique) |> expand.grid() |> dplyr::as_tibble()

  d_final_list <- vector(mode = "list", length = nrow(d_combs))
  for (i in seq_len(nrow(d_combs))) {
    dt_start <- semi_join(x, d_combs[i, ])
    dt_target <- semi_join(y, d_combs[i, ])
    missing_cols <- setdiff(names(dt_start), names(dt_target))

    dt_target <- sample_n(dt_target, nrow(dt_start), replace = TRUE)
    d_final_list[[i]] <- dplyr::bind_cols(dt_target, dt_start[missing_cols])
  }

  dplyr::bind_rows(d_final_list) |>
    dplyr::arrange(.orig.pos) |>
    dplyr::select(-.orig.pos)
}

# # example
#
# n <- 5000
# d_start <- tibble(
#   x = sample(1:2, n, replace = TRUE),
#   y = sample(1:2, n, replace = TRUE),
#   z = sample(1:3, n, replace = TRUE),
#   p1 = rnorm(n),
#   p2 = rnorm(n)
# )
#
# m <- n / 2
# d_target <- tibble(
#   x = sample(1:2, m, replace = TRUE),
#   y = sample(1:2, m, replace = TRUE),
#   z = sample(1:3, m, replace = TRUE),
#   p1 = rnorm(m)
# )
#
# sample_join(d_start, d_target, c("x", "y", "z"))
