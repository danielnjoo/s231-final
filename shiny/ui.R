#layout guide https://shiny.rstudio.com/articles/layout-guide.html
#fix crashing on deploy https://github.com/rstudio/shiny/issues/1726 - its a package thing, all of them need to rebuilt with the latest version of R via update.packages(ask = FALSE, checkBuilt = TRUE)

library(twitteR)
library(shiny)
library(DT)

consumer_key <- "NIfnSrABY2sJy4CkxFNPX9dU4"
consumer_secret <- "oSxr4XacD2Xu5OZ92SaF7WSlMU9aIenOWcbDpM9Lw1yZoet9lB"
access_token <- "243835598-Gcf6tBZ1eiMFOUtasmBehLyUbTbLtCH45zfKXJLt"
access_secret <- "86s0MJ2r43i40f7q1LvDCxCO9g943Pce5ZFiKqk8KVnwf"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


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
  
  plotOutput('clusterViz'),
  
  hr(),
  
  div(style="display: inline-block;vertical-align:right; width: 150px;",textInput("twitterUser1", "Enter User", "hadleywickham")),
  actionButton("showUserTweets", "Show User Tweets", style="color: #000000;background-color: #00aced;margin: 4px;"),
  fluidRow(
    dataTableOutput("userTweets")
  )
  
))
