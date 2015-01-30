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

prob_output <- data.frame(
    "Home" = all_matches[,1], H, D, A, "Away" = all_matches[,2])


odds_output <- data.frame(cbind(
    "Home" = all_matches[,1], 
    H = paste(all_matches[,3], all_matches[,6], sep = "/"),
    D = paste(all_matches[,4], all_matches[,7], sep = "/"),
    A = paste(all_matches[,5], all_matches[,8], sep = "/"),
    "Away" = all_matches[,2])
    )

odds_output <- odds_output[1:10, ]

prob_output <- prob_output[1:10, ]

prob_output <- 
    prob_output[order(apply(prob_output[,2:4],1, max)),]
```

\newpage


|   |Home        |  H|  D|  A|Away        |
|:--|:-----------|--:|--:|--:|:-----------|
|2  |C Palace    | 35| 30| 35|Everton     |
|1  |Hull        | 37| 30| 33|Newcastle   |
|7  |West Brom   | 34| 30| 37|Tottenham   |
|6  |Sunderland  | 44| 29| 27|Burnley     |
|8  |Chelsea     | 45| 28| 27|Man City    |
|3  |Liverpool   | 59| 24| 17|West Ham    |
|5  |Stoke       | 59| 25| 15|QPR         |
|10 |Southampton | 62| 24| 14|Swansea     |
|4  |Man Utd     | 73| 17|  9|Leicester   |
|9  |Arsenal     | 77| 16|  7|Aston Villa |



|Home        |H         |D        |A         |Away        |
|:-----------|:---------|:--------|:---------|:-----------|
|Hull        |2.72/2.74 |3.3/3.35 |3/3.05    |Newcastle   |
|C Palace    |2.82/2.84 |3.35/3.4 |2.86/2.88 |Everton     |
|Liverpool   |1.68/1.69 |4.2/4.3  |5.8/5.9   |West Ham    |
|Man Utd     |1.36/1.37 |5.7/5.8  |10.5/11   |Leicester   |
|Stoke       |1.68/1.69 |3.95/4   |6.4/6.6   |QPR         |
|Sunderland  |2.28/2.3  |3.4/3.45 |3.7/3.8   |Burnley     |
|West Brom   |2.94/2.98 |3.35/3.4 |2.72/2.74 |Tottenham   |
|Chelsea     |2.22/2.24 |3.5/3.55 |3.65/3.7  |Man City    |
|Arsenal     |1.29/1.3  |6.2/6.4  |15/15.5   |Aston Villa |
|Southampton |1.63/1.64 |4.1/4.2  |7/7.2     |Swansea     |


