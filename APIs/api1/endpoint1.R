# definition for endpoint1 of API1

endpoint1 <- function (group_id = "1,2,3", 
                       time_unit = "year",
                       res, 
                       req) {
  

  # 1) connect to DB -----
  con <- dbConnect(drv = RSQLite::SQLite(), dbname = "APIs/api1/assessment_data.sqlite3")
  
  # check whether connection to DB successful
  if (is.null(con)) {
    res$status <- 500
    return(list(error = "can't connect to DB"))
  }
  
  group_id <- as.numeric(str_split(group_id, ",") %>% unlist()) %>% c()
  results = try(sum_watched_hours(conn = con, group_id, 
                                 as.character(time_unit)), 
               silent = F)
  
  if(class(results)[1] == "try-error"){
    res$status <- 500
    results = 'Incorrect Inputs'
  }
  
  # disconnect database
  on.exit(dbDisconnect(con))
  
  res$status <- 200
  
  results
  
} 
