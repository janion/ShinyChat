library(shiny)

# Define UI for application that draws a histogram
create_application_ui <- function() {
  fluidPage(
    titlePanel("Chat Client"),
    sidebarLayout(
      sidebarPanel(
        uiOutput(outputId = "contactsSidebarPanel")
      ),
      mainPanel(
        div(
          uiOutput(outputId = "messagesMainPanel", fill = TRUE),
          div(
            div(
              style="display:inline-block;",
              textInput(inputId = "messageBox", label = "")
            ),
            div(
              style="display:inline-block;",
              actionButton(inputId = "sendBtn", label = "Send", style="display:inline-block")
            )
          )
        )
      )
    )
  )
}