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
|8  |Burnley     | 37| 30| 33|West Brom   |
|3  |Leicester   | 41| 30| 30|C Palace    |
|1  |Tottenham   | 29| 28| 43|Arsenal     |
|7  |Everton     | 29| 29| 43|Liverpool   |
|9  |Newcastle   | 43| 29| 28|Stoke       |
|10 |West Ham    | 24| 27| 49|Man Utd     |
|6  |Swansea     | 51| 28| 21|Sunderland  |
|5  |QPR         | 21| 26| 53|Southampton |
|2  |Aston Villa | 10| 20| 70|Chelsea     |
|4  |Man City    | 81| 13|  6|Hull        |



|Home        |H         |D        |A         |Away        |
|:-----------|:---------|:--------|:---------|:-----------|
|Tottenham   |3.4/3.45  |3.55/3.6 |2.34/2.36 |Arsenal     |
|Aston Villa |9.6/9.8   |5/5.1    |1.43/1.44 |Chelsea     |
|Leicester   |2.44/2.48 |3.35/3.4 |3.35/3.4  |C Palace    |
|Man City    |1.23/1.24 |7.4/7.6  |17.5/18.5 |Hull        |
|QPR         |4.8/4.9   |3.8/3.85 |1.88/1.89 |Southampton |
|Swansea     |1.97/1.98 |3.5/3.55 |4.7/4.8   |Sunderland  |
|Everton     |3.45/3.5  |3.45/3.5 |2.34/2.36 |Liverpool   |
|Burnley     |2.66/2.68 |3.3/3.35 |3.05/3.1  |West Brom   |
|Newcastle   |2.3/2.32  |3.4/3.45 |3.55/3.6  |Stoke       |
|West Ham    |4.1/4.2   |3.7/3.75 |2/2.02    |Man Utd     |


