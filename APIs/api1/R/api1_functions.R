

# Function definitions

# functions used go here



sum_watched_hours <- function(conn, group_id, time_unit = c("year", "month")){
  
  #' sum_watched_hours()
  #' @description
  #' Returns the sum of watched hours per group and per year or per month. 
  #'
  #' @param group_id A vector of the group_id to consider in the function
  #' @param time_unit Either year or month 
  #' @param conn An SQL Connection
  #' 
  #'
  #' @return A data frame including the year and month (depending on the 
  #' summarising unit), the group name(s) and the hours watched
  #' @export
  #'
  #' @examples
  #' sum_watched_hours(conn, 1, "year")
  #' sum_watched_hours(conn, 1:3, "month")
  
  # Packages
  require(RSQLite)
  require(lubridate)
  require(DBI)
  require(tsibble)
  require(stringr)
  require(dplyr)
  
  # Prepare SQL Variable
  group_id_sql <- toString(sprintf("'%s'", group_id))

  # Export Data from SQL 
  query_table <- RSQLite::dbGetQuery(conn, str_glue("SELECT group_id,
  report_date_yyyymmdd as date,
  sum(watched_seconds) as total_watched_seconds
  FROM user_Activity ta
  INNER JOIN user_groups tb ON ta.user_id = tb.user_id
  WHERE group_id IN ({group_id_sql})
  GROUP by 1,2"))
  
  # Date Padding (see requirement: If a group did not watch anything during 
  # a year/month, value should be 0.


  query_table <- query_table %>% 
    mutate(date = as.Date(date)) %>% 
    group_by(group_id) %>% 
    padr::pad() %>%  # date padding
    mutate(total_watched_seconds = ifelse(is.na(total_watched_seconds), 0 , total_watched_seconds))
  
  # # DB Disconnection
  # DBI::dbDisconnect(conn)
  
  # Summarize by time_unit
  if (time_unit == "year") {
    
    output <- query_table %>% 
      group_by(group_id, year = lubridate::year(date)) %>% 
      summarize(total_watched_seconds = sum(total_watched_seconds)) %>% 
      ungroup()    
    
    message("ok output year")
    
    
  } else {
    
    output <- query_table %>% 
      group_by(group_id, month = as.character(tsibble::yearmonth(date))) %>% 
      summarize(total_watched_seconds = sum(total_watched_seconds)) %>% 
      ungroup()
    
    message("ok output month")
    
  }
  
  # Return Output
  
  message("ok output")
  return(output)
}

