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
|Stoke       |24 |27 |49 |Man Utd     |
|Aston Villa |41 |30 |29 |C Palace    |
|Hull        |29 |29 |42 |Everton     |
|Liverpool   |70 |19 |11 |Leicester   |
|Man City    |80 |14 |6  |Sunderland  |
|Newcastle   |56 |26 |19 |Burnley     |
|QPR         |32 |29 |39 |Swansea     |
|Southampton |33 |28 |38 |Arsenal     |
|West Ham    |54 |26 |20 |West Brom   |
|Tottenham   |19 |25 |55 |Chelsea     |
|Sunderland  |22 |25 |53 |Liverpool   |
|Burnley     |41 |29 |31 |QPR         |
|Chelsea     |80 |13 |7  |Newcastle   |
|Everton     |19 |26 |54 |Man City    |
|Leicester   |40 |29 |31 |Aston Villa |
|Swansea     |44 |27 |29 |West Ham    |
|West Brom   |47 |29 |24 |Hull        |
|C Palace    |27 |28 |46 |Tottenham   |
|Arsenal     |71 |18 |11 |Stoke       |
|Man Utd     |58 |24 |18 |Southampton |



|Home        |H         |D         |A         |Away        |
|:-----------|:---------|:---------|:---------|:-----------|
|Stoke       |4.2/4.3   |3.6/3.7   |2.04/2.06 |Man Utd     |
|Aston Villa |2.46/2.48 |3.3/3.4   |3.35/3.45 |C Palace    |
|Hull        |3.4/3.5   |3.45/3.5  |2.36/2.4  |Everton     |
|Liverpool   |1.42/1.44 |5.1/5.2   |9.2/9.4   |Leicester   |
|Man City    |1.25/1.26 |7/7.2     |17/17.5   |Sunderland  |
|Newcastle   |1.8/1.81  |3.9/3.95  |5.3/5.4   |Burnley     |
|QPR         |3.1/3.15  |3.4/3.45  |2.58/2.62 |Swansea     |
|Southampton |2.98/3.05 |3.5/3.55  |2.6/2.64  |Arsenal     |
|West Ham    |1.86/1.87 |3.8/3.85  |4.9/5     |West Brom   |
|Tottenham   |5.1/5.2   |3.9/3.95  |1.81/1.82 |Chelsea     |
|Sunderland  |4.2/5.1   |3.6/4.3   |1.83/1.91 |Liverpool   |
|Burnley     |2.32/2.58 |3.35/3.6  |3.05/3.5  |QPR         |
|Chelsea     |1.22/1.28 |6.4/9.2   |11.5/23   |Newcastle   |
|Everton     |4.8/5.7   |3.5/4.2   |1.79/1.93 |Man City    |
|Leicester   |2.42/2.6  |3.35/3.65 |3/3.4     |Aston Villa |
|Swansea     |2.2/2.4   |3.4/4.2   |3.3/3.7   |West Ham    |
|West Brom   |2.08/2.18 |3.35/3.6  |3.95/4.5  |Hull        |
|C Palace    |3.4/4.4   |3.4/4.1   |2.1/2.42  |Tottenham   |
|Arsenal     |1.38/1.45 |4.5/7.6   |7.6/11    |Stoke       |
|Man Utd     |1.69/1.75 |3.95/4.5  |5/6.6     |Southampton |


