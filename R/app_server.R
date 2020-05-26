#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyURL

#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  # Capture URL parameters
  shinyURL.server()
  
  ## Social
  # callModule(mod_social_server, "social_module_1")
  callModule(mod_mobility_server, 'mobile_plot')
  
}
