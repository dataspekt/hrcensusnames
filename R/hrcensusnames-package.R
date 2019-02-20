#' Croatian census names
#'
#' Frequency of personal names/surnames from Croatian census.
#'
#' @docType package
#' @name hrcensusnames
#' @importFrom stats setNames
#' @importFrom httr POST add_headers content
#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom xml2 read_html
#' @importFrom magrittr %>%
#' @importFrom purrr map map_int map_chr map_df pmap_dfr list_modify
#' @importFrom stringr str_extract
#' @importFrom tibble as_tibble
#' @importFrom dplyr select
#' @importFrom rlang .data
NULL
