# PL Fixtures - (Betfair) Odds & (Implied) Probabilities

## Skip to pages 3 and 4 to see the results.


```r
library(XML);
library(xtable);
library(knitr);
```

Reading Data from <http://www.betfair.com/exchange/football/competition?id=31>


```r
matches_URL <- "https://www.betfair.com/exchange/football/competition?id=31"

# For some reason, Betfair has changed its design recently. 
# It's not a table anymore
# matches_Table <- readHTMLTable(matches_URL)

# ReadLine and Parse the HTML page.
# download.file(matches_URL, "aa.html")

matches_html  <- readLines("aa.html")
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


|   |Home        |  H|  D|  A|Away      |
|:--|:-----------|--:|--:|--:|:---------|
|5  |Sunderland  | 36| 31| 33|West Brom |
|1  |Aston Villa | 37| 30| 32|Stoke     |
|10 |Southampton | 38| 29| 33|Liverpool |
|4  |Hull        | 48| 29| 24|QPR       |
|6  |Swansea     | 23| 28| 49|Man Utd   |
|2  |C Palace    | 20| 26| 54|Arsenal   |
|9  |Everton     | 54| 27| 19|Leicester |
|8  |Tottenham   | 55| 25| 20|West Ham  |
|7  |Man City    | 77| 15|  8|Newcastle |
|3  |Chelsea     | 83| 12|  5|Burnley   |



|Home        |H         |D        |A         |Away      |
|:-----------|:---------|:--------|:---------|:---------|
|Aston Villa |2.68/2.7  |3.25/3.3 |3.05/3.1  |Stoke     |
|C Palace    |5/5.1     |3.8/3.85 |1.85/1.86 |Arsenal   |
|Chelsea     |1.21/1.22 |8/8.2    |19.5/21   |Burnley   |
|Hull        |2.1/2.12  |3.45/3.5 |4.2/4.3   |QPR       |
|Sunderland  |2.74/2.78 |3.25/3.3 |3/3.1     |West Brom |
|Swansea     |4.2/4.4   |3.6/3.65 |2.04/2.06 |Man Utd   |
|Man City    |1.3/1.31  |6.4/6.6  |12.5/13   |Newcastle |
|Tottenham   |1.83/1.84 |4/4.1    |4.9/5     |West Ham  |
|Everton     |1.85/1.86 |3.7/3.75 |5.2/5.3   |Leicester |
|Southampton |2.6/2.62  |3.4/3.45 |3/3.1     |Liverpool |


