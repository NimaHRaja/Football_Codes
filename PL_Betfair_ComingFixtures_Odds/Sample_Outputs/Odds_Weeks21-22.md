# PL Fixtures - (Betfair) Odds & (Implied) Probabilities

## Skip to pages 3 and 4 to see the results.


```r
library(XML);
library(xtable);
library(knitr);
```

Reading Data from <http://www.betfair.com/exchange/football/competition?id=31>


```r
matches_URL <- "http://www.betfair.com/exchange/football/competition?id=31"

# For some reason, Betfair has changed its design recently. 
# It's not a table anymore
# matches_Table <- readHTMLTable(matches_URL)

# ReadLine and Parse the HTML page.
matches_html  <- readLines(matches_URL)
matches_parse <- htmlTreeParse(matches_html,useInternal=TRUE)
```

Cleaning Data:


```r
# Extract the relevant bits.
data_odds_back <- xpathSApply(matches_parse, 
                              "//button[@class = 'bet-button back cta cta-back i13n-ltxt-FltBetSlpB i13n-Sp-1']/span[@class = 'price']"
                              , xmlValue) 

data_odds_lay <- xpathSApply(matches_parse, 
                             "//button[@class = 'bet-button lay cta cta-lay i13n-ltxt-FltBetSlpL i13n-Sp-1']/span[@class = 'price']"
                             , xmlValue) 

data_home <- xpathSApply(matches_parse, "//span[@class = 'home-team']", xmlValue)   

data_away <- xpathSApply(matches_parse, "//span[@class = 'away-team']", xmlValue)   

# Otherwise team names would be interpreted as factors.
options(stringsAsFactors = FALSE)

# make "odds" numeric

data_back <- data.frame(
    apply(
        matrix(data_odds_back, ncol = 3, byrow = TRUE)
        , 2, as.numeric))

data_lay <- data.frame(
    apply(
        matrix(data_odds_lay, ncol = 3, byrow = TRUE)
        , 2, as.numeric))

# Matches data.frame
all_matches <- cbind(data_home, data_away, data_back, data_lay)
colnames(all_matches) <- 
    c("Home", "Away", "H_B", "D_B", "A_B", "H_L", "D_L", "A_L")
```

Creating probabilities data.frame (a rough estimate + normalisation). The results are reported with 0 decimal points.


```r
# Output data.frames

H <- 
    round((100/all_matches[,3]+ 100/all_matches[,6])/rowSums(1/all_matches[,3:8])
          , digits = 0)
D <- 
    round((100/all_matches[,4]+ 100/all_matches[,7])/rowSums(1/all_matches[,3:8])
          , digits = 0)
A <- 
    round((100/all_matches[,5]+ 100/all_matches[,8])/rowSums(1/all_matches[,3:8])
          , digits = 0)

prob_output <- data.frame(cbind(
    "Home" = all_matches[,1], H, D, A, "Away" = all_matches[,2]))

odds_output <- data.frame(cbind(
    "Home" = all_matches[,1], 
    H = paste(all_matches[,3], all_matches[,6], sep = "/"),
    D = paste(all_matches[,4], all_matches[,7], sep = "/"),
    A = paste(all_matches[,5], all_matches[,8], sep = "/"),
    "Away" = all_matches[,2])
    )
```

\newpage


|Home        |H  |D  |A  |Away        |
|:-----------|:--|:--|:--|:-----------|
|Sunderland  |22 |28 |50 |Liverpool   |
|Burnley     |45 |28 |26 |QPR         |
|Chelsea     |82 |13 |5  |Newcastle   |
|Everton     |22 |25 |53 |Man City    |
|Leicester   |45 |30 |26 |Aston Villa |
|Swansea     |43 |29 |28 |West Ham    |
|West Brom   |48 |29 |22 |Hull        |
|C Palace    |26 |28 |45 |Tottenham   |
|Arsenal     |67 |21 |12 |Stoke       |
|Man Utd     |53 |26 |21 |Southampton |
|Aston Villa |22 |27 |51 |Liverpool   |
|Burnley     |41 |30 |30 |C Palace    |
|Leicester   |37 |29 |34 |Stoke       |
|QPR         |16 |23 |61 |Man Utd     |
|Swansea     |15 |24 |62 |Chelsea     |
|Tottenham   |64 |23 |13 |Sunderland  |
|Newcastle   |30 |28 |42 |Southampton |
|West Ham    |57 |26 |18 |Hull        |
|Man City    |54 |25 |21 |Arsenal     |
|Everton     |54 |26 |20 |West Brom   |



|Home        |H         |D         |A         |Away        |
|:-----------|:---------|:---------|:---------|:-----------|
|Sunderland  |4.4/4.5   |3.6/3.65  |1.99/2.02 |Liverpool   |
|Burnley     |2.2/2.22  |3.5/3.55  |3.75/3.8  |QPR         |
|Chelsea     |1.22/1.23 |7.6/7.8   |19/19.5   |Newcastle   |
|Everton     |4.6/4.7   |3.95/4    |1.87/1.88 |Man City    |
|Leicester   |2.22/2.24 |3.35/3.4  |3.85/3.9  |Aston Villa |
|Swansea     |2.3/2.34  |3.45/3.5  |3.55/3.6  |West Ham    |
|West Brom   |2.06/2.08 |3.4/3.45  |4.4/4.5   |Hull        |
|C Palace    |3.75/3.8  |3.5/3.55  |2.2/2.22  |Tottenham   |
|Arsenal     |1.49/1.5  |4.7/4.8   |8/8.2     |Stoke       |
|Man Utd     |1.88/1.89 |3.85/3.9  |4.7/4.8   |Southampton |
|Aston Villa |4.5/4.7   |3.6/3.75  |1.93/1.98 |Liverpool   |
|Burnley     |2.42/2.5  |3.3/3.5   |3.25/3.55 |C Palace    |
|Leicester   |2.62/2.78 |3.3/3.5   |2.86/3.05 |Stoke       |
|QPR         |5.9/6.8   |4.1/4.5   |1.63/1.67 |Man Utd     |
|Swansea     |6.6/7.2   |4/4.4     |1.6/1.65  |Chelsea     |
|Tottenham   |1.55/1.58 |4.3/4.6   |7/8       |Sunderland  |
|Newcastle   |3.25/3.45 |3.4/3.65  |2.34/2.46 |Southampton |
|West Ham    |1.75/1.77 |3.8/3.95  |5.5/5.8   |Hull        |
|Man City    |1.85/1.86 |3.85/4.2  |4.5/5     |Arsenal     |
|Everton     |1.83/1.87 |3.75/3.95 |4.9/5.3   |West Brom   |


