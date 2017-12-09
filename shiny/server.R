library(shiny)
library(readxl)
library(tidyverse)
library(reshape2)
data<-readxl::read_xlsx('./../twitter_data.xlsx')

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
  
  userTweetData <- eventReactive(input$showUserTweets, {
    withProgress(message = "Loading application", value = 0, {
      tweets <- userTimeline(input$twitterUser1, n = 500) #selects specified number of user tweets
      incProgress(0.7, detail = "Getting tweets")
      # tab <- twListToDF(tweets) %>% .[!duplicated(tab[,c('text')]),] 
      
      tab <- twListToDF(tweets) %>% .[!duplicated(tab[,c('text')]),] %>% dplyr::select(text, favoriteCount, retweetCount, created,
                                                                                isRetweet, retweeted, longitude, latitude) 
      
      
      # create list of multiple result? and return that? datatable as above... what else?
      
      # tab <- twListToDF(tweets) #converts tweets and associated metrics in table format
      # tab2 <- tab[!duplicated(tab[,c('text')]),] #removes duplicated text
      
      # tab2 <- tab2 %>% dplyr::select(text, favoriteCount)
      # tab2 <- tab2 %>% dplyr::select(text, favoriteCount, replyToSN, created, truncated, replyToSID, id, replyToUID, statusSource, screenName, retweetCount,
                                     # isRetweet, retweeted, longitude, latitude)
      # print(tab2)
      incProgress(0.3, detail = "Finishing...")
      return(tab)
    })
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
  
  temp <- reactive ({
    temp <- userTweetData()  
    print(temp)
  })
  
  
  output$userTweets <- renderDataTable({
    # print(userTweetData())
    # userTweetData()
    temp
  })
  
})
