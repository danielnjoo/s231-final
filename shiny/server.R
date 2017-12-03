
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

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
    if (input$big5==T) {
      # plot_data <- cbind(as.data.frame(pcabig5$x[, 1:2]), labels=as.factor(kmeans(big5, input$clusters)$cluster))  
      temp <- 'Big5 '
      label <- kmeans(big5, input$clusters)$cluster
      data_w_labels <- cbind(big5, label)
    } else if (input$dark3==T){
      # plot_data <- cbind(as.data.frame(pcadark3$x[, 1:2]), labels=as.factor(kmeans(dark3, input$clusters)$cluster))  
      temp <- 'Dark Triad '
      label <- kmeans(big5, input$clusters)$cluster
      data_w_labels <- cbind(dark3, label)
    } else {
      # plot_data <- cbind(as.data.frame(pcaall8$x[, 1:2]), labels=as.factor(kmeans(all8, input$clusters)$cluster))  
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
  
})
