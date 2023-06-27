get_current_user <- function() {
  return("Person 0")
}

get_contacts <- function(user) {
  return(
    c("Person 1", "Person 2", "Person 3", "Person 4", "Person 5")
  )
}

p1Chat <- matrix(
  nrow=3,
  c(
    "Person 0", "Hi", "10:31",
    "Person 1", "Hey", "10:31",
    "Person 1", "Y'ite?", "10:32",
    "Person 0", "Yup", "10:33",
    "Person 1", strrep("Kool", 100), "10:35",
    "Person 0", "kbye", "10:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35",
    "Person 1", "T'me", "11:35",
    "Person 0", "T'you", "11:35"
  )
)

p2Chat <- matrix(
  nrow=3,
  c(
    "Person 0", "Hi", "10:31",
    "Person 2", "Go away", "10:34",
    "Person 0", "kbye", "10:35"
  )
)

p3Chat <- matrix(
  nrow=3,
  c(
    "Person 0", "Hi", "10:31",
    "Person 0", "...", "10:41",
    "Person 0", "kbye", "10:44"
  )
)

p4Chat <- matrix(
  nrow=3,
  c(
    "Person 0", "Hi", "10:31",
    "Person 4", "AFK", "10:31",
    "Person 0", "kbye", "10:32"
  )
)

p5Chat <- matrix(
  nrow=3,
  c(
    "Person 0", "Hi", "10:31",
    "Person 5", "I'm outside", "10:32",
    "Person 0", "kbye", "10:32"
  )
)

get_chat_log <- function(user, contact) {
  if (length(contact) == 0) {
    return(NULL)
  }
  
  if (contact == "Person 1") {
    return(p1Chat)
  } else if (contact == "Person 2") {
    return(p2Chat)
  } else if (contact == "Person 3") {
    return(p3Chat)
  } else if (contact == "Person 4") {
    return(p4Chat)
  } else if (contact == "Person 5") {
    return(p5Chat)
  }
}

set_chat_log <- function(user, contact, chatLog) {
  if (length(contact) == 0) {
    return()
  }
  
  if (contact == "Person 1") {
    p1Chat <<- chatLog
  } else if (contact == "Person 2") {
    p2Chat <<- chatLog
  } else if (contact == "Person 3") {
    p3Chat <<- chatLog
  } else if (contact == "Person 4") {
    p4Chat <<- chatLog
  } else if (contact == "Person 5") {
    p5Chat <<- chatLog
  }
}