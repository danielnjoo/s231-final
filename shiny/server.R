library(shiny)
library(readxl)
library(tidyverse)
library(reshape2)
library(dbscan)
data<-readxl::read_xlsx('./../twitter_data.xlsx')

visualization <- data[4:nrow(data),] %>% 
  sapply(., as.numeric) %>% 
  as.data.frame()
names(visualization) <- data[3, ]
visualization <- visualization %>% select("openness", "conscientiousness", "extraversion", "agreeableness", 
                                          "Neuroticism", "Machiavellianism", "narcissism", "psychopathy", 
                                          "followers_count", "statuses_count", "favourites_count", "kloutscore", 
                                          "PercentOrigTweets", "PercentRT", "PercentReplies", "friends_count")

big5 <- data[4:nrow(data),2:6] %>% sapply(., as.numeric) %>% as.data.frame()
names(big5) <- data[3, 2:6]
pcabig5 <- big5 %>% 
  lapply(as.numeric) %>% 
  as.data.frame  %>% 
  log %>% 
  prcomp(center=T,scale=T)

dark3 <- data[4:nrow(data), 7:9] %>% sapply(., as.numeric) %>% as.data.frame()
names(dark3) <- data[3, 7:9]
pcadark3 <- dark3 %>% 
  lapply(as.numeric) %>% 
  as.data.frame  %>% 
  log %>% 
  prcomp(center=T,scale=T)

all8 <- data[4:nrow(data), 2:9] %>% lapply(., as.numeric) %>% as.data.frame()
names(all8) <- data[3, 2:9]
pcaall8 <- all8 %>% 
  lapply(as.numeric) %>% 
  as.data.frame  %>% 
  log %>% 
  prcomp(center=T,scale=T)


shinyServer(function(input, output) {
  
  output$initialExp <- renderPlot({
    if (input$openness==T){
      initialExpX <- visualization$openness
      xLabel <- "Openness"
    } else if (input$conscientiousness==T){
      initialExpX <- visualization$conscientiousness
      xLabel <- "Conscientiousness"
    } else if (input$extraversion==T){
      initialExpX <- visualization$extraversion
      xLabel <- "Extraversion"
    } else if (input$agreeableness==T){
      initialExpX <- visualization$agreeableness
      xLabel <- "Agreeableness"
    } else if (input$Neuroticism==T){
      initialExpX <- visualization$Neuroticism
      xLabel <- "Neuroticism"
    } else if (input$Machiavellianism==T){
      initialExpX <- visualization$Machiavellianism
      xLabel <- "Machiavellianism"
    } else if (input$narcissism==T){
      initialExpX <- visualization$narcissism
      xLabel <- "Narcissism"
    } else {
      initialExpX <- visualization$psychopathy
      xLabel <- "Psychopathy"
    } 
    title <- paste0(("Density plot of "), xLabel)
    visualization %>% ggplot(aes(initialExpX)) + geom_density() + xlab(xLabel) + ggtitle(title)
  })
  
  output$relExp <- renderPlot({
    if (input$openness2==T){
      relExpX <- visualization$openness
      xLabel <- "Openness"
    } else if (input$conscientiousness2==T){
      relExpX <- visualization$conscientiousness
      xLabel <- "Conscientiousness"
    } else if (input$extraversion2==T){
      relExpX <- visualization$extraversion
      xLabel <- "Extraversion"
    } else if (input$agreeableness2==T){
      relExpX <- visualization$agreeableness
      xLabel <- "Agreeableness"
    } else if (input$Neuroticism2==T){
      relExpX <- visualization$Neuroticism
      xLabel <- "Neuroticism"
    } else if (input$Machiavellianism2==T){
      relExpX <- visualization$Machiavellianism
      xLabel <- "Machiavellianism"
    } else if (input$narcissism2==T){
      relExpX <- visualization$narcissism
      xLabel <- "Narcissism"
    } else {
      relExpX <- visualization$psychopathy
      xLabel <- "Psychopathy"
    } 
    
    if (input$followers_count==T){ 
      max <- which.max(visualization$followers_count)
      visualization <- visualization[-max,]
      relExpX <- relExpX[-max]
      # relExpY <- visualization$followers_count[-max]
      yLabel <- "Followers Count"
    } else if (input$statuses_count==T){
      relExpY <- visualization$statuses_count
      yLabel <- "Statuses Count"
    } else if (input$favourites_count==T){
      relExpY <- visualization$favourites_count
      yLabel <- "Favourites Count"
    }  else if (input$friends_count==T){
      relExpY <- visualization$friends_count
      yLabel <- "Friends Count" 
    }  else if (input$kloutscore==T){
      relExpY <- visualization$kloutscore
      yLabel <- "Kloutscore"
    } else if (input$PercentRT==T){
      relExpY <- visualization$PercentRT
      yLabel <- "Percent Retweets"
    } else {
      relExpY <- visualization$PercentReplies
      yLabel <- "Percent Replies"
    }
    if (input$geom_smooth==F){
      if (input$log==F){
        visualization %>% ggplot(aes(relExpX, relExpY)) + geom_point() + geom_jitter() +
          xlab(xLabel) + ylab(yLabel) + ggtitle(paste0(xLabel, " on ", yLabel))
      } else {
        visualization %>% ggplot(aes(relExpX, log(relExpY))) + geom_point() + geom_jitter() +
          xlab(xLabel) + ylab(paste0(yLabel," (Log)")) + ggtitle(paste0(xLabel, " on ", yLabel," (Log)"))
      }
    } else {
      if (input$log==F){
        visualization %>% ggplot(aes(relExpX, relExpY)) + geom_point() + geom_jitter() +
          xlab(xLabel) + ylab(yLabel) + geom_smooth(se=F) + ggtitle(paste0(xLabel, " on ", yLabel))
      } else {
        visualization %>% ggplot(aes(relExpX, log(relExpY))) + geom_point() + geom_jitter() +
          xlab(xLabel) + ylab(paste0(yLabel," (Log)")) + geom_smooth(se=F) + ggtitle(paste0(xLabel, " on ", yLabel," (Log)"))
      }
    }
  })
  
  output$clusterPlot <- renderPlot({
    
    if (input$big5==T) {
      plot_data <- cbind(as.data.frame(pcabig5$x[, 1:2]), labels=as.factor(kmeans(big5, input$clusters)$cluster))  
      temp <- 'Big5 '
    } else if (input$dark3==T){
      plot_data <- cbind(as.data.frame(pcadark3$x[, 1:2]), labels=as.factor(kmeans(dark3, input$clusters)$cluster))  
      temp <- 'Dark Triad '
    } else {
      plot_data <- cbind(as.data.frame(pcaall8$x[, 1:2]), labels=as.factor(kmeans(all8, input$clusters)$cluster))  
      temp <- 'All 8 '
    }
    title <- paste0(temp, "Profiles of Twitter Users Grouped in 2 Dimensions, k=", input$clusters)
    
    plot_data %>% 
      ggplot(aes(PC1,PC2, col=labels)) +
      geom_point() +
      ggtitle(title)
    
  })
  
  output$clusterViz <- renderPlot({
    set.seed(1) #reproducibility!!!!!
    if (input$big5==T) {
      temp <- 'Big5 '
      label <- kmeans(big5, input$clusters)$cluster
      data_w_labels <- cbind(big5, label)
    } else if (input$dark3==T){
      temp <- 'Dark Triad '
      label <- kmeans(big5, input$clusters)$cluster
      data_w_labels <- cbind(dark3, label)
    } else {
      temp <- 'All 8 '
      label <- kmeans(big5, input$clusters)$cluster
      data_w_labels <- cbind(all8, label)
    }
    data_w_labels %>% melt(id.vars=c("label")) %>%
      ggplot(aes(variable,value)) +
        geom_bar(stat="identity") +
        facet_wrap(~label, nrow=1) +
        theme(axis.text.x = element_text(angle=90, vjust=0.5,hjust=1))
  })
  
  output$catAndTweets <- renderPlot({

    kmeans(big5, input$clusters)$cluster %>% 
      as.data.frame() %>% 
      cbind(visualization) -> temp2
    names(temp2)[1] <- 'cat'
    
    if (input$followers_count2==T){ 
      max <- which.max(temp2$followers_count)
      temp2 <- temp2[-max,]
      relExpX <- relExpX[-max]
      yLabel <- "Followers Count"
    } else if (input$statuses_count2==T){
      relExpY <- temp2$statuses_count
      yLabel <- "Statuses Count"
    } else if (input$favourites_count2==T){
      relExpY <- temp2$favourites_count
      yLabel <- "Favourites Count"
    } else if (input$friends_count2==T){
      relExpY <- temp2$friends_count
      yLabel <- "Friends Count"
    } else if (input$kloutscore2==T){
      relExpY <- temp2$kloutscore
      yLabel <- "Kloutscore"
    } else if (input$PercentRT2==T){
      relExpY <- temp2$PercentRT
      yLabel <- "Percent Retweets"
    } else {
      relExpY <- temp2$PercentReplies
      yLabel <- "Percent Replies"
    }
    
    g <- temp2 %>% ggplot(aes(as.factor(cat), as.numeric(relExpY))) + geom_boxplot(outlier.shape=NA)
    ylim1 = boxplot.stats(relExpY)$stats[c(1, 5)]
    g + coord_cartesian(ylim = ylim1) + ylab(yLabel) + xlab("Personality Type According to KNN clusters")
    
  })
  
  userTweetData <- eventReactive(input$showUserTweets, {
    getUser(input$twitterUser1) -> user
    c(user$favoritesCount, user$followersCount, user$friendsCount, user$statusesCount) %>% as.data.frame() -> temp
    rownames(temp) <- c("Favourites Count", "Followers Count", "Friends Count", "Statuses Count")
    return(temp)
    # withProgress(message = "Loading application", value = 0, {
    #   tweets <- userTimeline(input$twitterUser1, n = 500) #selects specified number of user tweets
    #   incProgress(0.7, detail = "Getting tweets")
    #   tab <- twListToDF(tweets) #converts tweets and associated metrics in table format
    #   tab2 <- tab[!duplicated(tab[,c('text')]),] #removes duplicated text
    #   tab2 <- tab2 %>% dplyr::select(text, favoriteCount, retweetCount, created,
    #                                  isRetweet, retweeted, longitude, latitude)
    #   incProgress(0.3, detail = "Finishing...")
    #   return(tab2)
    # })
  })
  
  output$userTweets <- renderDataTable({
    userTweetData()
  })
  
  getPreds <- eventReactive(input$getPreds, {
    
    kmeans(big5, input$clusters)$cluster %>% 
      as.data.frame() %>% 
      cbind(visualization) -> temp3
    
    names(temp3)[1] <- 'cat'
    
    temp3 %>% dplyr::select(favourites_count, followers_count, friends_count, statuses_count) %>% 
      mutate(
        favourites_count = parse_number(favourites_count),
        followers_count = parse_number(followers_count),
        friends_count = parse_number(friends_count),
        statuses_count = parse_number(statuses_count)
      ) %>% na.omit -> others
    
    userTweetData() -> temp
    
    rownames(temp) <- colnames(others)
    
    t(temp) %>% rbind(others) %>% data.matrix %>% kNN(x=.,k=100) %>% .$id %>% head(1) -> closest_100_ids
    
    prop.table(table(temp3[closest_100_ids,'cat'])) %>% 
      data.frame %>% 
      arrange(desc(Freq)) %>% 
      rename('Personality Type' = Var1 ,Probability=Freq) %>% 
      return()
    
  })
  
  output$closestTweets <- renderDataTable({
   getPreds() 
  })
  
})
