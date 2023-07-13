library(shiny)
library(DBI)
library(RSQLite)

source("ChatData.R")
source("DynamicChatPane.R")

create_application_server <- function(input, output, session, user_info) {
  
  init_db()
  
  fromUser <- reactiveVal()
  currentContact <- reactiveVal()
  currentChatLog <- reactiveVal()
  
  # Setup admin status on client
  output$isAdmin <- reactive(as.logical(user_info$admin))
  outputOptions(output, "isAdmin", suspendWhenHidden = FALSE)
  
  # Create drop-down menu for admins to see messages between anyone
  output$fromUserSelection <- renderUI({
    selectInput(
      inputId = "fromUserSelection",
      label = "From User:",
      choices = get_users(),
      selected = user_info$user)
  })
  
  # Set the from user to this user when the user changes
  observe({
    fromUser(user_info$user)
  })
  
  # Set the from user to the selected user when the from user changes
  observe({
    fromUser(input$fromUserSelection)
  })
  
  # Clear the current contact when the from user changes
  observeEvent(
    fromUser(),
    {
      currentContact(NULL)
      shinyjs::toggleState(id = "messageBox", condition = {fromUser() == user_info$user})
      shinyjs::toggleState(id = "sendBtn", condition = {fromUser() == user_info$user})
    }
  )
  
  # Create contact buttons and set the current contact when button clicked
  output$contactsSidebarPanel <- renderUI({
    lapply(get_contacts(fromUser()), function(contact) {
      btnId <- paste0("chatBtn_", contact)
      observeEvent(
        input[[btnId]],
        {
          currentContact(contact)
        }
      )
      div(
        actionButton(inputId = btnId, label = contact)
      )
    })
  })
  
  # Update placeholder text when current contact changes
  observe({
    updateTextInput(
      session = session,
      inputId = "messageBox",
      placeholder = ifelse(
          is.null(currentContact()),
          "",
          paste0("Say Hi to ", currentContact())
        ),
      value = ""
    )
  })
  
  # Set chat log when current contact changes
  observe({
    currentChatLog(get_chat_log(fromUser(), currentContact()))
  })
  
  # Add message to chat log and update Chat log in memory when send button clicked
  observeEvent(
    input$sendBtn,
    {
      message <- input$messageBox
      updateTextInput(session = session, inputId = "messageBox", value = "")
      message_sent(isolate(fromUser()),
                   isolate(currentContact()),
                   message,
                   format(Sys.time(), "%Y/%m/%d %H:%M:%S"))
      currentChatLog(get_chat_log(isolate(fromUser()), isolate(currentContact())))
    }
  )
  
  # Render the UI when the current chat log changes
  output$messagesMainPanel <- renderUI({
    if (!is.null(currentChatLog())) {
      create_chat_pane(isolate(fromUser()), currentChatLog())
    }
  })
}
