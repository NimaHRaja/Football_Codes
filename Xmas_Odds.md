# Next 30 Matches (Implied) Probabilities
NHR  
Friday, December 26, 2014  

Reading Data from <http://www.betfair.com/exchange/football/competition?id=31>


```r
library(XML);
library(xtable);
library(knitr);

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
data_odds <- xpathSApply(matches_parse, "//span[@class = 'price']", xmlValue)   

data_home <- xpathSApply(matches_parse, "//span[@class = 'home-team']", xmlValue)   

data_away <- xpathSApply(matches_parse, "//span[@class = 'away-team']", xmlValue)   

# Otherwise team names would be interpreted as factors.
options(stringsAsFactors = FALSE)

# Clean odds and make them numeric
data_odds <- data.frame(matrix(data_odds[1:180], ncol = 6, byrow = TRUE))
data_odds <- data.frame(apply(data_odds, 2, as.numeric))

# Matches data.frame
all_matches <- cbind("Home" = data_home, data_away, data_odds)
colnames(all_matches) <- c("Home", "Away", "H_B", "H_L", "D_B", "D_L", "A_B", "A_L")
```


Creating probabilities data.frame with a rough normalisation method. The results are reported with 0 decimal points.


```r
# Output data.frame

H <- round((100/all_matches[,3]+ 100/all_matches[,4])/rowSums(1/all_matches[,3:8]), digits = 0)
D <- round((100/all_matches[,5]+ 100/all_matches[,6])/rowSums(1/all_matches[,3:8]), digits = 0)
A <- round((100/all_matches[,7]+ 100/all_matches[,8])/rowSums(1/all_matches[,3:8]), digits = 0)

output <- data.frame(cbind("Home" = all_matches[,1], H, D, A, "Away" = all_matches[,2]))


kable(output, format = "markdown") # MD & HTML Output
```



|Home        |H  |D  |A  |Away        |
|:-----------|:--|:--|:--|:-----------|
|Chelsea     |75 |18 |7  |West Ham    |
|Burnley     |18 |25 |57 |Liverpool   |
|C Palace    |25 |29 |46 |Southampton |
|Everton     |53 |27 |20 |Stoke       |
|Leicester   |28 |28 |44 |Tottenham   |
|Man Utd     |71 |19 |10 |Newcastle   |
|Sunderland  |48 |30 |22 |Hull        |
|Swansea     |58 |26 |16 |Aston Villa |
|West Brom   |16 |23 |61 |Man City    |
|Arsenal     |77 |16 |7  |QPR         |
|Tottenham   |29 |28 |43 |Man Utd     |
|Southampton |20 |26 |54 |Chelsea     |
|Aston Villa |41 |29 |29 |Sunderland  |
|Hull        |43 |29 |28 |Leicester   |
|Man City    |83 |12 |5  |Burnley     |
|QPR         |41 |28 |31 |C Palace    |
|Stoke       |50 |28 |22 |West Brom   |
|West Ham    |27 |27 |47 |Arsenal     |
|Newcastle   |34 |29 |37 |Everton     |
|Liverpool   |58 |24 |17 |Swansea     |
|Stoke       |23 |24 |53 |Man Utd     |
|Aston Villa |44 |27 |29 |C Palace    |
|Hull        |27 |29 |44 |Everton     |
|Liverpool   |70 |18 |13 |Leicester   |
|Man City    |77 |14 |9  |Sunderland  |
|Newcastle   |58 |23 |19 |Burnley     |
|QPR         |34 |29 |37 |Swansea     |
|Southampton |34 |26 |39 |Arsenal     |
|West Ham    |55 |25 |20 |West Brom   |
|Tottenham   |26 |28 |46 |Chelsea     |

```r
# print(xtable(output), comment=F) # PDF Output
```
