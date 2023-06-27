library(shiny)

source("ChatLogs.R")
source("DynamicChatPane.R")

create_application_server <- function(input, output, session) {
  thisUser <- get_current_user()
  contacts <- get_contacts(thisUser)
  
  currentContact <- reactiveVal()
  currentChatLog <- reactiveVal()
  
  # Create contact buttons and set the current contact when button clicked
  output$contactsSidebarPanel <- renderUI({
    lapply(contacts, function(contact) {
      btnId <- paste0("chatBtn_", contact)
      observeEvent(
        input[[btnId]],
        {
          currentContact(contact)
          updateTextInput(session = session, inputId = "messageBox", placeholder = paste0("Say Hi to ", contact))
        }
      )
      div(
        actionButton(inputId = btnId, label = contact)
      )
    })
  })
  
  # Set chat log when current contact changes
  observe(currentChatLog(get_chat_log(thisUser, currentContact())))
  
  # Add message to chat log amd update Chat log in memory when send button clicked
  observeEvent(
    input$sendBtn,
    {
      message <- input$messageBox
      updateTextInput(session = session, inputId = "messageBox", value = "")
      currentChatLog(cbind(currentChatLog(), c(thisUser, message, "Now")))
      set_chat_log(thisUser, isolate(currentContact()), currentChatLog())
    }
  )
  
  # Render the UI when the current chat log changes
  output$messagesMainPanel <- renderUI({
    if (!is.null(currentChatLog())) {
      create_chat_pane(thisUser, currentChatLog())
    }
  })
}
