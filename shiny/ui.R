#layout guide https://shiny.rstudio.com/articles/layout-guide.html
#fix crashing on deploy https://github.com/rstudio/shiny/issues/1726 - its a package thing, all of them need to rebuilt with the latest version of R via update.packages(ask = FALSE, checkBuilt = TRUE)


library(shiny)

shinyUI(fluidPage(

  title = "Twitter Personality Exploration",
  
  plotOutput('clusterPlot'),
  
  hr(),
  
  fluidRow(
    column(5, offset = 1,
     h4("Choose subset to visualize"),
     checkboxInput('big5', 'Big5', value=T),
     checkboxInput('dark3', 'Dark Triad'),
     checkboxInput('all8', 'Both (All8)')
     
    ),
    column(5,
     sliderInput("clusters",
                 "Number of clusters:",
                 min = 1,
                 max = 10,
                 value = 3)
    )
  ),
  
  hr(),
  
  plotOutput('clusterViz')
  
))
