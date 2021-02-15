# Define UI for application that draws a histogram
library("visNetwork")

ui <- fluidPage(
  titlePanel("Interactive Figure 4"),
  sidebarLayout(
    sidebarPanel(width=3,
      helpText("To change the required maximum explained variance cutoff per metabolite-factor-association, move this slider and wait for the plot to rebuild. You may click on the nodes and edges of the plot to display the individual values for each study cohort that meet the required cutoff."),
                 tags$hr(),
                 sliderInput("slider",
                             label = "Required maximum explained variance cutoff:",
                             min = 0,
                             max = 0.15,
                             value = 0.01,
                             step = 0.005,
                             sep = "."),
      textOutput("check")
    ),
    mainPanel(visNetworkOutput("network"))
  )
)

  
  
