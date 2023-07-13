library(shiny)
library(shinyjs)
library(shinymanager)
# library(keyring)

source("ChatUi.R")
source("ChatServer.R")

# define some credentials
credentials <- data.frame(
  user = c("Person 0", "Person 1"), # mandatory
  password = c("qwerty", "12345"), # mandatory
  admin = c(FALSE, TRUE),
  stringsAsFactors = FALSE
)

# key_set("R-shinymanager-key", "obiwankenobi")

# Init the database
shinymanager::create_db(
  credentials_data = credentials,
  sqlite_path = "users.sqlite", # will be created
  passphrase = "jjj"
)

ui <- shinymanager::secure_app(create_application_ui(), enable_admin = TRUE)
# ui <- create_application_ui()

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # check_credentials directly on sqlite db
  user_info <- shinymanager::secure_server(
    check_credentials = check_credentials(
      "users.sqlite",
      passphrase = "jjj"
    )
  )

  create_application_server(input, output, session, user_info)
}

# Run the application 
shinyApp(ui = ui, server = server)
