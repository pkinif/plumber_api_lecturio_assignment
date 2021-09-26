# functions to query mysql database, connects to DB, queries data, get names of DBs

# function to connect database
mysql_con <- function(){
  
  # Settings -----
  db_user <- Sys.getenv('MYSQL_USER')
  db_password <- Sys.getenv('MYSQL_PASSWD')
  db_host <- Sys.getenv('MYSQL_HOST')
  db_port <- Sys.getenv('MYSQL_PORT')
  db_name <- Sys.getenv('MYSQL_DB')

  
  if (db_user == '' | db_host == '' | db_port == '' | db_password == '') {
    log_message("Missing db parameter in environment.")
  
  } else{ 
    
    db_port <- as.integer(db_port)
    
    # establish connection with mysql database -----
    con <-  tryCatch(dbConnect(MariaDB(), user = db_user, password = db_password,
                               host = db_host, port = db_port), 
                     error = function(e) log_message(paste('Error in DB connection:', e))
    )
    
    return(con)
  }  
  
} # end of function


# function to query database
mysql_query <- function(con, query, setVar = NULL){

  # if there is a variable to set before query, e.g. a startDate, sets dates for subsequent queries
  if(!is.null(setVar)){
    dbExecute(con, setVar)
  }
  
  # set encoding for connection
  dbExecute(con, "SET NAMES 'utf8mb4'") 
  
  # query and fetch data
  mydata <- dbGetQuery(con, query)
  
  # return data ------
  return(mydata)
  
} # end of function


# function to get names of databases
get_db_names <- function(){
  
  # get DB names from env
  db_name_Lecturio <- Sys.getenv("MYSQL_DB_Lecturio")
  db_name_LecturioLogs <- Sys.getenv("MYSQL_DB_LecturioLogs")
  db_name_LecturioQbank <- Sys.getenv("MYSQL_DB_LecturioQbank")
  db_name_LecturioStats <- Sys.getenv("MYSQL_DB_LecturioStats")
  db_name <- Sys.getenv("MYSQL_DB")
  
  return(list(Lecturio = ifelse(db_name_Lecturio == '', ifelse(db_name == '', 'Lecturio',  db_name), db_name_Lecturio),
              LecturioLogs = ifelse(db_name_LecturioLogs == '', 'LecturioLogs', db_name_LecturioLogs),
              LecturioQbank = ifelse(db_name_LecturioQbank == "", "LecturioQbank", db_name_LecturioQbank),
              LecturioStats = ifelse(db_name_LecturioStats == "", "LecturioStats", db_name_LecturioStats)
              ))
  
}  # end of function
