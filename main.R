
# API running at: https://acme-dev.lecturio.com/api-r/en/latest/html5/gw/performance/groups?group_ids=20555&assignment_id=158155&context_type=lecture&context_id=22662&attempts_mode=last

# ren::install()
# renv::load()
# renv::status()
# renv::snapshot()

#=== load functions that are shared =======================================================
path_to_functions <- c("R/")             # set path
my_functions <- list.files(path_to_functions, "*.[rR]")  # locate all .R files
purrr::map(paste0(path_to_functions, my_functions),
           source)  # source all R scripts!
#==========================================================================

# load libraries 
suppressMessages(load_libraries())


# /api1 -----
r_api1 <- pr("APIs/api1/api1.R")

# build API -----
r_all <- pr() %>% 
  pr_mount("/api1", r_api1)

# run API -----
r_all$run()
