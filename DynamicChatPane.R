library(shiny)
library(stringr)

# Create item for single chat message
create_chat_pane <- function(username, currentChatLog) {
  div(
    style = "overflow-y: scroll; height:70vh;",
    lapply(
      seq(1, ncol(currentChatLog)),
      function(col) {
        create_message_item(username, currentChatLog[1, col], currentChatLog[2, col], currentChatLog[3, col])
      }
    )
  )
}

# Create item for single chat message
create_message_item <- function(username, sentBy, message, tooltip = NULL) {
  div(
    title = tooltip,
    if (sentBy == username) {
      p(message, style = "word-wrap: break-word; background: #eeffee; border: 2px solid gray; border-radius: 5px; margin: 2px; width: 80%; padding: 0px 5px 0px 5px; float: right;")
    } else {
      p(message, style = "word-wrap: break-word; background: #eeeeff; border: 2px solid gray; border-radius: 5px; margin: 2px; width: 80%; padding: 0px 5px 0px 5px; float: left;")
    }
  )
}