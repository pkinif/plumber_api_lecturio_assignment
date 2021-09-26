# run this file by clicking Run API

# #=== load functions for API  =======================================================
path_to_functions <- c("R/")             # set path
my_functions <- list.files(path_to_functions, "*.[rR]")  # locate all .R files
purrr::map(paste0(path_to_functions, my_functions),
          source)  # source all R scripts!

# #==========================================================================

#' @apiTitle Lecturio API - Assignment
#' @apiDescription Hope you will like my way of building the API

# source scripts with endpoint functions -----
source("endpoint1.R")

# start /endpoint1 ======

#* Returns the sum of watched hours per group_id and per year or per month
#* @param group_id:char all group_ids to consider (if multiple: values separated by comma (no space))
#* @param time_unit:char either year or month 

#* @serializer json
#* @get /endpoint1

endpoint1