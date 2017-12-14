# Twitter + Online Presence: Exploring and Predicting

Amherst College Data Science (S231) Final Project, taught by [Alex Baldenko](https://www.linkedin.com/in/alex-baldenko-4b173862/), and completed by Margaret Chien, Amber Liu, and Daniel Njoo.

## Contents

- Shiny app
- technical appendix
- presentation

## Quick notes

Our accompanying Shiny app can be found [here](http://danielnjoo.shinyapps.io/shiny/), and a hosted compiled version of our technical appendix can be found [here](https://danielnjoo.github.io/data_investigations/other/technical_appendix).

We highly recommend using RStudio.

### Prerequisites

To compile our technical appendix you'll need the following R packages installed:

- readxl
- tidyverse
- dbscan

And in order to copmile our Shiny app you'll additionally need:

- shiny
- twitteR
- DT
- reshape2

### Running

The technical appendix *should* compile painlessly.

To access the prediction portion of our Shiny app, however, you'll need a set of Twitter API keys, instructions on how to get these can be found [here](https://www.r-bloggers.com/getting-started-with-twitter-in-r/). These keys need to be entered into first section of ui.R file (it's at the top). The app can still be run without these keys if you comment out the appropriate lines -- although this is redundant because you can find the keys we used in a previous commit. Feel free to use them if don't want to get your own.
