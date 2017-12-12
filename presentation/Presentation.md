Personality + Twitter Presence: Exploration and Prediction
========================================================
author: Margaret Chien, Amber Liu, Daniel Njoo
date: 12th December 2017
autosize: true
incremental: true



Outline 
========================================================
- Why

- The theory behind personality, and the scales we used

- The data

- Clustering and predictions


Personality + Online Presence?
========================================================
- Facebook, Instagram, LinkedIn, Twitter

- Barrons: 60% of firms wouldn't hire a candidate if they couldn't find any online presence

- So what does our online presence say about us?


Psychometric Theory
========================================================
- ![image](./images/image3.png)

Psychometric Theory 
========================================================
What firms do
- ![image](./images/image4.png)

Psychometric Theory
========================================================
Our approach
- ![image](./images/image2.png)


Big5
========================================================
- psycholexical approach
- reproducible across cultures/languages
- emerged out of statistical analysis of natural language, not armchair theorizing
- the measures (OCEAN):
    - Openness
    - Conscientiousness
    - Extraversion
    - Agreeableness
    - Neuroticism


Dark Triad
========================================================
- Narcissism
- Machiavellianism
- Psychopathy

- Example question: On a scale of 1-5 (disagree to agree), "Do you like to use clever manipulation to get your way?"

Getting the Dataset
========================================================

Kaggle competition: predicting psychopathy from Twitter usage?

- https://www.kaggle.com/c/twitter-personality-prediction 

- hosted by the Online Privacy Foundation

- 5 years ago, top score 86%

Couldn't get explanation of the variables, nor reproduce many of them (e.g. LIWC)

- ![image](./images/image.png)


The Dataset
========================================================

Dimensions:  

- 2930 rows, 587 columns

Groups of variables

- Big5, Dark Triad, Twitter Attributes, LIWC, etc. 
- ![image](./images/image1.png)



Data Wrangling
========================================================

Original Variables:


```r
names(twitter_data) %>% head(10)
```

```
 [1] "X__1"       "Big Five"   "X__2"       "X__3"       "X__4"      
 [6] "X__5"       "Dark Triad" "X__6"       "X__7"       "Privacy"   
```

Renamed Variables:


```r
twitter_data[3, 1:10] %>% unlist(use.names=FALSE)
```

```
 [1] "sec_num"           "openness"          "conscientiousness"
 [4] "extraversion"      "agreeableness"     "Neuroticism"      
 [7] "Machiavellianism"  "narcissism"        "psychopathy"      
[10] "privacy1"         
```


Variables 
========================================================

Big5

- Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism

Dark Triad

- Narcissism, Machiavellianism, Psychopathy



Variables
========================================================

(Reproducible) Twitter Attributes

- Favourites Count, Followers Count, Friends Count, Statuses, Count

More meaningful, non-reproducible Twitter Attributes

- Kloutscore, Percent Orig Tweets, Percent Retweets, Percent Replies
- Klout available through the Twitter API via partnership with Klout, but not through twitteR
- "Not all Tweets will be indexed or made available via the search interface."
