get_name_frequency <- function(firstname, surname, hidden, url)
{
    POST(
        url = url,
        add_headers(`User-Agent` = "hrcensusnames", Referer = url),
        body = list(`__EVENTARGUMENT` = "", `__EVENTTARGET` = "btnGetResult", `__EVENTVALIDATION` = hidden["__EVENTVALIDATION"], `__VIEWSTATE` = hidden["__VIEWSTATE"], `__VIEWSTATEGENERATOR` = hidden["__VIEWSTATEGENERATOR"], txtName = firstname, txtSurname = surname),
        encode = "form"
    ) -> res
    Sys.sleep(.5)
    pg <- content(res, as="parsed")
    nodes <- c("tdNameResult","tdSurnameResult","tdFullNameResult") %>% setNames(c("firstname","surname","fullname"))
    map_df(nodes, function(x) {
        html_nodes(pg, paste0("td[id='",x,"']")) %>%
            html_text() %>%
            str_extract(pattern="[[:digit:]]+$") %>% as.numeric
    }) %>%
        setNames(paste("freq",names(.),sep=".")) %>%
        list_modify(firstname = firstname,
                    surname = surname)
}

#' Census names
#'
#' \code(hrcensusnames) fetches the frequencies of names from \{https://www.dzs.hr/hrv/censuses/census2011/results/censusnames.htm}.
#'
#' When supplying multiple first names and surnames, both vectors should be of the same lenght or one should be a unit vector and it will be replicated.
#' 
#' @note Please note the source of the data! \url{https://www.dzs.hr/default_e.htm}
#'  
#' @param firstname,surname Vectors of names.
#'
#' @return Data frame with frequencies of names. 
#'
#' @export
hrcensusnames <- function(firstname,surname){
    args <- mget(ls())
    len <- map_int(args,length)
    empty <- map_chr(args,class) == "name"
    if (all(len[!empty]>1) & length(unique(len[!empty]))>1)
        stop("Arguments 'firstname' and 'surname' must be of same length or one of them must be unit vector.")
    if(length(len[!empty]) > 1 & sum(len[!empty] == 1)<2 & length(unique(len[!empty]))>1)
        warning(paste("Assuming same", names(len[len==1]), "for all", paste0(names(len[len>1]),"s.")))
    df <- args %>%
        map(function(x) if(class(x) == "character") x else NA) %>%
        as_tibble()
    url <- "https://www.dzs.hr/app/imena/default.aspx"
    pre_pg <- read_html(url)
    setNames(
        html_nodes(pre_pg, "input[type='hidden']") %>% html_attr("value"),
        html_nodes(pre_pg, "input[type='hidden']") %>% html_attr("name")
    ) -> hidden
    pmap_dfr(df, function(firstname,surname) get_name_frequency(firstname,surname,hidden=hidden, url=url)) %>%
        select(firstname,surname,freq.firstname,freq.surname,freq.fullname)
    #%>% select_if(function(x) !all(is.na(x)))
}
