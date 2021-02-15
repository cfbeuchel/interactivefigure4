# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # load dependencies
  source(file = "functions/app_dependencies.R")
  
  # for storage
  values <- reactiveValues()
  
  # load plot data
  load("data/plotData.RData")
  values$dat <- all.plot.dat
  
  # observe cutoff slider input
  # observe Slider and take values
  observeEvent(input$slider, {
    
    # get the slider value
    values$slider.input <- input$slider
    
    # isolate the slider value
    plot.dat <- isolate(values$dat)
    slider.val <- isolate(values$slider.input)
    
    # check for too small or too high slider input
    output$check <- renderText({
      validate(
        need(expr = slider.val != 0,
             message = "Network to large! Please choose a different cutoff!"),
        need(expr = plot.dat[term.r.squared >= (slider.val), .N] > 0,
             message = "Filter set too high, cannot build plot!")
      )
    })
    
    # test and print text in output
    validate(
      need(expr = slider.val != 0,
           message = "Network to large! Please choose a different cutoff!"),
      need(expr = plot.dat[term.r.squared >= (slider.val), .N] > 0,
           message = "Filter set too high, cannot build plot!")
    )
    
    # create the network plot
    my.network <- network_plot(assocResults = plot.dat[term.r.squared >= (slider.val), ],
                               rSquaredColumn = "term.r.squared",
                               pColumn = "p.hierarchical.bonferroni",
                               cohort = "cohort.max",
                               hierarchicalNetwork = FALSE) %>% 
      visNodes(size = 10,
               physics = TRUE,
               font= '32px arial black') %>%
      visOptions(width = "900px",
                 height = "860px",
                 highlightNearest = T)
    
    # built multivariable network
    output$network <- renderVisNetwork({
      
      # construct network plot
      my.network
      
    })
    
  }) # end of slider-reactive action
  
} # end of server