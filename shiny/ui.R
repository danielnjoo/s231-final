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
  
  titlePanel("Twitter Personality Exploration"),
  
  p("In this Shiny App, we explore one of the datasets that matches personality scores (Big5 and Dark Triad)
    with online behaviour, in this case Twitter statistics. This dataset was obtained via private communication
    with one of the organizers of the Kaggle competition found ", tags$a(href="kaggle.com/c/twitter-personality-prediction", 
                                                                         "here.")),
  
  tags$ul(
    tags$li("We initially explore the personality dimensions of the ~3000 profiles in this dataset"),
    tags$li("Then explore potential relationships between their Twitter usage via statistics such as the number of 
    followers they have and their personality scores"),
    tags$li("Then, we use a KNN-clustering technique to create personality categories for us, which we then use to 
    again explore relationships with Twitter usage"),
    tags$li("Finally, we try to predict a new, unseen Twitter (via user input) account's personality type according 
    to their Twitter usage."),
    tags$ul(
      tags$li("Our prediction method involves selecting the highest occuring category of the new user's 100 closest 
      neighbors along the variables present in the original dataset that we can reproduce.")
    )
  ),
  
  p("It is worth noting that in general we find very weak relationships between ", tags$strong("most Twitter usage 
    statistics")," and personality scores. Further, our prediction technique is only marginally better than random 
    chance. We conclude that though the field of personality prediction is important and exploding in today's world of 
    `Big Data`, that:"),
  tags$ul(
    tags$li("larger datasets are needed (n=3000 is far too small)"),
    tags$li("the voluntary response bias inherent in this 
    dataset makes useful analysis difficult"),
    tags$li("and finally that Twitter - with 140 character limits and widespread usage archetypes, i.e. that people 
    tweet in similar ways regardless of personal differences - make personality predictions difficult.")
  ),
  
  p("Further work might yield useful results if the more hetereogenous Twitter usage variables present in the 
    original dataset could be reproduced, or if a new larger dataset could be created and made accessible."),
  
  hr(),
  
  h3("Initial Exploration"),
  
  p("Choose a single personality dimension to explore."),
  
  fluidRow(
    column(3,
           p("Big5"),
           checkboxInput("openness", "Openness", value=T),
           checkboxInput("conscientiousness", "Conscientiousness"),
           checkboxInput("extraversion", "Extraversion"),
           checkboxInput("agreeableness", "Agreeableness"),
           checkboxInput("Neuroticism", "Neuroticism"),
           hr(),
           p("Dark Triad"),
           checkboxInput("Machiavellianism", "Machiavellianism"),
           checkboxInput("narcissism", "Narcissism"),
           checkboxInput("psychopathy", "Psychopathy")
    ),
    column(9,
           plotOutput('initialExp')
    )
  ),
  
  hr(),
  
  h3("Relationship Exploration"),
  
  p("Choose a personality dimension to explore against a Twitter usage variable. Note for `followers_count`, an extreme outlier (2.9M when mean is 1280) is removed for visualization purposes."),
  
  fluidRow(
    column(4,
     fluidRow(
       column(6,
              p('X'),
              checkboxInput("openness2", "Openness", value=T),
              checkboxInput("conscientiousness2", "Conscientiousness"),
              checkboxInput("extraversion2", "Extraversion"),
              checkboxInput("agreeableness2", "Agreeableness"),
              checkboxInput("Neuroticism2", "Neuroticism"),
              checkboxInput("Machiavellianism2", "Machiavellianism"),
              checkboxInput("narcissism2", "Narcissism"),
              checkboxInput("psychopathy2", "Psychopathy")
              ),
       column(6,
              p('Y'),
              checkboxInput("favourites_count", "Favourites Count", value=T),
              checkboxInput("followers_count", "Followers Count"),
              checkboxInput("friends_count", "Friends Count"),
              checkboxInput("statuses_count", "Statuses Count"),
              checkboxInput("kloutscore", "Kloutscore"),
              checkboxInput("PercentOrigTweets", "Percent Original"),
              checkboxInput("PercentRT", "Percent Retweet"),
              checkboxInput("PercentReplies", "Percent Replies")
              )
      ),
     hr(),
     p('Log Y?'),
     checkboxInput("log", "LogY"),
     p('geom_smooth?'),
     checkboxInput("geom_smooth", "Add geom_smooth")
     ),
    column(8,
      plotOutput('relExp')
    )
  ),
  
  hr(),
  
  h3("Cluster Visualization"),
  p("Visualized below in two dimensions (via PCA) is our dataset of Twitter users (n~=3000) when clustered according 
    to a user-specified k. Big5 will be used as the subset for later prediction regardless of your choice but the k you 
  choose below will determine the number of categories / personality types."),
  p("(NB: this methodology uses k-means clustering and so the resultant clusters are by definition 'different' from each other which should not be necessarily interpreted as meaning they are meaningful. Nonetheless, we saw useful clusters when k = 3.)"),
  plotOutput('clusterPlot'),
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
  
  h3("What Each Cluster Means, WRT Personality Scores"),
  p("The clusters created above are visualized below across your chosen subset's personality dimensions."),
  plotOutput('clusterViz'),
  
  hr(),
  
  h3("Personality Types (Clusters) and Twitter Behavior"),
  p("All extreme outliers have been removed. Regardless of the subset you chose earlier, the next few sections
    work with the Big5 subset."),
  fluidRow(
    column(2,
           p('Y'),
           checkboxInput("favourites_count2", "Favourites Count", value=T),
           checkboxInput("followers_count2", "Followers Count"),
           checkboxInput("friends_count2", "Friends Count"),
           checkboxInput("statuses_count2", "Statuses Count"),
           checkboxInput("kloutscore2", "Kloutscore"),
           checkboxInput("PercentOrigTweets2", "Percent Original"),
           checkboxInput("PercentRT2", "Percent Retweet"),
           checkboxInput("PercentReplies2", "Percent Replies")
    ),
    column(10,
          plotOutput('catAndTweets')
   )
  ),
  
  
  hr(),
  
  h3("Twitter Data"),
  p("Choose a user, note that the Twitter API does not provide 'an exhaustive source of Tweets. Not all Tweets will be indexed or made available via the search interface.'"),
  div(style="display: inline-block;vertical-align:right; width: 150px;",textInput("twitterUser1", "Enter User", "realDonaldTrump")),
  actionButton("showUserTweets", "Get User Tweet Stats", style="color: #000000;background-color: #00aced;margin: 4px;"),
  fluidRow(
    dataTableOutput("userTweets")
  ),
  
  hr(),
  
  h3("Predicting A User's Personality Type"),
  actionButton("getPreds", "Get Prediction", style="color: #000000;background-color: #00aced;margin: 4px;"),
  dataTableOutput("closestTweets")
  
))
