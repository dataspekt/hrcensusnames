# Frequencies of Croatian personal names/surnames

## Overview

Croatian bureau of statistics (CBS) gives access to frequencies of personal names/surnames based on data from official census. Function `hrcensusnames()` fetches the frequencies from [CBS app](https://www.dzs.hr/hrv/censuses/census2011/results/censusnames.htm) and makes it available for analysis in R.

## Installation

To install this package use:

```r
devtools::install_github("dataspekt/hrcensusnames")
```

## Usage

Examples:

```r
# First name
hrcensusnames("Ana")

# Full name
hrcensusnames("Ana","Fabijanec")

# Multiple first names, same surname
hrcensusnames(c("Ana","Ivana"), "Fabijanec")
```

Only first name or surname can be supplied, or both to fetch full name frequency. When supplying multiple first names and surnames, both vectors should be of the same length or one should be a unit vector and it will be replicated (with a warning). Queries are not case sensitive.

Function will return a data frame with frequencies of names. Frequencies less than 10 are not available and will be returned as missing values.

When using this data, please acknowledge the source! For more info visit [CBS page](https://www.dzs.hr/default_e.htm).
