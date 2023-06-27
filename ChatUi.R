library(shiny)
library(shinyjs)

# Define UI for application that draws a histogram
create_application_ui <- function() {
  fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Chat Client"),
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(
          condition = "output.isAdmin",
          uiOutput(outputId = "fromUserSelection")
        ),
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