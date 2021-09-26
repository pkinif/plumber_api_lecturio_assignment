# load libraries

load_libraries <- function(){
  library(plumber)
  library(dplyr)
  library(rlang)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(data.table)
  library(stringr)
  library(lubridate)# wrangling dates
  library(aws.s3)   # reading data from S3
  library(rredis)   # connection to redis server for token validation
  #library(testthat) # unit tests
  library(RMariaDB)
  library(RSQLite)
  library(DBI)
  library(tsibble)
  library(stringr)
  library(jsonlite)  # parse json format
  library(urltools)
}