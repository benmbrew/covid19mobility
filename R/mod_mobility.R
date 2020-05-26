# Module mobility and covid19

#' @title   mod_mobility.R
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_mobility_ui
#'
#' @keywords internal
#' @export 
#' @import tidyverse
#' @import ggplot2
#' @import ggthemes
#' @import reshape2
#' @importFrom shiny NS tagList 


mod_mobility_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    fluidPage(
      column(8,
             plotOutput(
               ns('plot_mobility'), height = '900px', width = '1000px',
             )),
      column(4,
             selectInput(ns('state'), 'State',
                         choices =  state_names,
                         selected = 'Florida'),
             selectInput(ns('cases_or_deaths'), 'Daily cases or deaths',
                         choices = c('Daily cases', 'Daily deaths'),
                         selected = 'Daily deaths'),
             selectInput(ns('mob_ind'), 'Mobility indicator',
                         choices = c('Grocery', 'Parks', 'Workplace', 'Transit', 'Residential'),
                         selected = c('Grocery', 'Parks', 'Workplace', 'Transit', 'Residential'),
                         multiple = TRUE),
             checkboxInput(ns('roll_avg'), '3 day rolling acg',
                           value = TRUE),
             checkboxInput(ns('per_capita'), 'Per 1 million',
                           value = TRUE),
             
             # useShinyalert(),  # Set up shinyalert
             # actionButton(ns("plot_info"), "Plot Info")
             )
    )
  )
}

# Module Server
#' @rdname mod_mobility_server
#' @export
#' @import tidyverse
#' @import RColorBrewer
#' @import ggplot2
#' @import tidyr
#' @import ggthemes
#' @import scales
#' @import reshape2
#' @import htmltools
#' @keywords internal

mod_mobility_server <- function(input, output, session){
  
  output$plot_mobility <- renderPlot({
    # get inputs
    state = 'Florida'
    cases_or_deaths = 'Daily deaths'
    roll_avg = TRUE
    per_capita = TRUE
    mob_ind = c('Grocery', 'Parks', 'Transit')
    state = input$state
    cases_or_deaths = input$cases_or_deaths
    roll_avg = input$roll_avg
    per_capita = input$per_capita
    mob_ind <- input$mob_ind
    # get data
    df <- covid19mobility::df
    lock <- covid19mobility::lock
    regions_pop <- covid19mobility::regions_pop
    mob_usa <- covid19mobility::mob_usa
    # convert to date
    lock$start_som <- as.Date(lock$start_som)
    lock$start_sah <- as.Date(lock$start_sah)
    
    us_pop <- regions_pop %>% dplyr::filter(country == 'US')
    ##### ------- subset by usa
    
    # jhu data
    df <- df %>% dplyr::filter(country == 'US')
    
    # subset by state
    df <- df %>% dplyr::filter(district == state)
    mob_usa <- mob_usa %>% dplyr::filter(sub_region_1 == state)
    mob_usa <- mob_usa %>% dplyr::select(sub_region_1, date, all_of(mob_ind))
    mob_usa  <- melt(mob_usa, id.vars = c('sub_region_1', 'date'))
    # subset columns by mobility of choice and covid data
    
    # get lockdown dates
    lock <- lock[lock$state == state,]
    state_of_emergency <- lock$start_som
    stay_at_home <- lock$start_sah
    
    # shift days
    # df$date <- df$date - shift_days
    
    # get labels
    x_axis = 'Date'
    plot_title = paste0(state, ': ', 'Mobility data ',
                        'And Daily ', Hmisc::capitalize(cases_or_deaths))
    
    col_vec <- RColorBrewer::brewer.pal(length(unique(mob_usa$variable)), 'Dark2')
    
    # save.image(file = 'sve.rda')
    if(cases_or_deaths == 'Daily deaths'){
      
      # get rolling avg
      if(roll_avg){
        df$deaths_non_cum <- pracma::movavg(df$deaths_non_cum, type = 's', n = 3)
      }
      
      if(per_capita){
        df <- dplyr::left_join(df, us_pop, by = c('district'='ccaa'))
        df$deaths_non_cum <- (df$deaths_non_cum/df$pop)*1000000
      }
      # Plot
      p <- ggplot() +
        geom_bar(data = df, aes(date, deaths_non_cum, fill = 'Daily deaths'),stat = 'identity', alpha = 0.7) +
        scale_fill_manual(name = '', values = c('Daily deaths' = '#EE0432'))
      
      
    } else if (cases_or_deaths == 'Daily cases'){
      
      if(roll_avg){
        df$cases_non_cum <- pracma::movavg(df$cases_non_cum, type = 's', n = 3)
      }
      
      if(per_capita){
        df <- dplyr::left_join(df, us_pop, by = c('district'='ccaa'))
        df$cases_non_cum <- (df$cases_non_cum/df$pop)*1000000
      }
      # Plot
      p <- ggplot() +
        geom_bar(data = df, aes(date, cases_non_cum, fill = 'Daily cases'),stat = 'identity', alpha = 0.7) +
        scale_fill_manual(name = '', values = c('Daily cases' = '#EE0432'))
      
      
    } else {
      # Plot
      p<-  ggplot() +
        geom_bar(data = df, aes(date, uci_non_cum, fill = 'Daily ICU'),stat = 'identity', alpha = 0.7) +
        scale_fill_manual(name = '', values = c('Daily ICU' = '#EE0432'))
      
    }
    p <- p + geom_vline(xintercept =as.Date(stay_at_home), linetype = 2) +
      geom_point(data = mob_usa, aes(date, value, color = variable), alpha = 0.7) +
      scale_color_manual(name = 'Mobility',
                         values = col_vec) +
      labs (x = x_axis,
            y = '',
            title = plot_title) +
      ggthemes::theme_pander()
    
    
    p
  })
  
}

## To be copied in the UI
# mod_mobility_ui("mobile_plot")


## To be copied in the server
# callModule(mod_mobility_server, 'mobile_plot')

