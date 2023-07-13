
with_database <- function(action, db_path = "messages.sqlite") {
  message_db <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  tryCatch(
    {
      return(action(message_db))
    },
    finally = {
      DBI::dbDisconnect(message_db)
    }
  )
}

init_db <- function() {
  with_database(function(db_connection) {
                  if (!DBI::dbExistsTable(db_connection, 'messages')) {
                    DBI::dbCreateTable(conn = db_connection,
                                       name = 'messages',
                                       fields = c(from_user = 'text', to_user = 'text', content = 'text', timestamp = 'text'))
                  }
                })
}

get_users <- function() {
  return(
    with_database(db_path = "users.sqlite",
                  function(db_connection) {
                    shinymanager::read_db_decrypt(conn = db_connection,
                                                  name = "credentials",
                                                  passphrase = 'jjj')$user
                  })
  )
}

get_contacts <- function(user) {
  users <- get_users()
  return(users[users != user])
}

execute_query <- function(query) {
  df <- with_database(function(db_connection) {
    result = DBI::dbSendQuery(db_connection, query)
    df <- DBI::dbFetch(result)
    DBI::dbClearResult(result)
    return(df)
  })
  
  return(df)
}

get_chat_log <- function(user, contact) {
  if (length(contact) == 0) {
    return(NULL)
  }
  
  query <- paste0("SELECT from_user, content, timestamp ",
                  "FROM messages ",
                  "WHERE ",
                  "( from_user = '", user, "' AND to_user = '", contact, "' ) ",
                  "OR ",
                  "( from_user = '", contact, "' AND to_user = '", user, "' )")
  
  df <- execute_query(query)
  
  return(df)
}

check_db_updated <- function(user, contact, last_update_time) {
  update_time <- get_last_update_time(user, contact)
  if (!is.null(update_time) && (length(last_update_time()) == 0 || update_time != last_update_time())) {
    last_update_time(update_time)
    return(TRUE)
  }
  return(FALSE)
}

get_last_update_time <- function(user, contact) {
  if (length(contact) == 0) {
    return(NULL)
  }
  
  query <- paste0("SELECT timestamp ",
                  "FROM messages ",
                  "WHERE ",
                  "( from_user = '", user, "' AND to_user = '", contact, "' ) ",
                  "OR ",
                  "( from_user = '", contact, "' AND to_user = '", user, "' ) ",
                  "ORDER BY timestamp DESC ",
                  "LIMIT 1")
  
  df <- execute_query(query)
  
  return(df$timestamp)
}

message_sent <- function(user, contact, message, timestamp) {
  df = data.frame(from_user = user, to_user = contact, content = message, timestamp = timestamp)
  
  with_database(function(db_connection) {
    DBI::dbAppendTable(db_connection, 'messages', df)
  })
}