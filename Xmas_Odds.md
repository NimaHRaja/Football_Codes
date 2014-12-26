# Next 30 Matches (Implied) Probabilities
NHR  
Friday, December 26, 2014  

Reading Data from <http://www.betfair.com/exchange/football/competition?id=31>


```r
library(XML);
library(xtable);
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

print(xtable(output), comment=F)
```

\begin{table}[ht]
\centering
\begin{tabular}{rlllll}
  \hline
 & Home & H & D & A & Away \\ 
  \hline
1 & Chelsea & 75 & 17 & 8 & West Ham \\ 
  2 & Burnley & 18 & 25 & 57 & Liverpool \\ 
  3 & C Palace & 25 & 29 & 46 & Southampton \\ 
  4 & Everton & 53 & 27 & 20 & Stoke \\ 
  5 & Leicester & 28 & 28 & 43 & Tottenham \\ 
  6 & Man Utd & 71 & 19 & 10 & Newcastle \\ 
  7 & Sunderland & 48 & 30 & 22 & Hull \\ 
  8 & Swansea & 56 & 26 & 18 & Aston Villa \\ 
  9 & West Brom & 15 & 23 & 62 & Man City \\ 
  10 & Arsenal & 77 & 16 & 7 & QPR \\ 
  11 & Tottenham & 30 & 28 & 42 & Man Utd \\ 
  12 & Southampton & 20 & 26 & 54 & Chelsea \\ 
  13 & Aston Villa & 41 & 29 & 29 & Sunderland \\ 
  14 & Hull & 43 & 29 & 28 & Leicester \\ 
  15 & Man City & 83 & 12 & 5 & Burnley \\ 
  16 & QPR & 41 & 28 & 31 & C Palace \\ 
  17 & Stoke & 50 & 28 & 22 & West Brom \\ 
  18 & West Ham & 27 & 27 & 46 & Arsenal \\ 
  19 & Newcastle & 34 & 29 & 37 & Everton \\ 
  20 & Liverpool & 58 & 24 & 17 & Swansea \\ 
  21 & Stoke & 23 & 24 & 53 & Man Utd \\ 
  22 & Aston Villa & 44 & 27 & 29 & C Palace \\ 
  23 & Hull & 27 & 29 & 44 & Everton \\ 
  24 & Liverpool & 70 & 18 & 13 & Leicester \\ 
  25 & Man City & 77 & 14 & 9 & Sunderland \\ 
  26 & Newcastle & 58 & 23 & 19 & Burnley \\ 
  27 & QPR & 34 & 29 & 37 & Swansea \\ 
  28 & Southampton & 34 & 26 & 39 & Arsenal \\ 
  29 & West Ham & 55 & 25 & 20 & West Brom \\ 
  30 & Tottenham & 26 & 28 & 46 & Chelsea \\ 
   \hline
\end{tabular}
\end{table}

