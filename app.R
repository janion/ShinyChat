library(shiny)
library(shinymanager)
library(keyring)

source("ChatUi.R")
source("ChatServer.R")

# define some credentials
credentials <- data.frame(
  user = c("Person 0", "Person 1"), # mandatory
  password = c("qwerty", "12345"), # mandatory
  admin = c(FALSE, TRUE),
  stringsAsFactors = FALSE
)

key_set("R-shinymanager-key", "obiwankenobi")

# Init the database
create_db(
  credentials_data = credentials,
  sqlite_path = "database.sqlite", # will be created
  passphrase = key_get("R-shinymanager-key", "obiwankenobi")
)

ui <- secure_app(create_application_ui(), enable_admin = TRUE)
# ui <- create_application_ui()

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # check_credentials directly on sqlite db
  user_info <- secure_server(
    check_credentials = check_credentials(
      "database.sqlite",
      passphrase = key_get("R-shinymanager-key", "obiwankenobi")
    )
  )

  create_application_server(input, output, session, user_info)
}

# Run the application 
shinyApp(ui = ui, server = server)
