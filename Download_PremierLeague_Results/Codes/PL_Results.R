library(XML)
options(stringsAsFactors = FALSE)

# Read data
results_URL <- "http://www.premierleague.com/en-gb/matchday/results.html?paramComp_100=true&view=.dateSeason"
matches_table <- readHTMLTable(results_URL)


# The last table in matches_table is the PL's table. Others -> results.
# matches_table[length(matches_table)]
# lapply(matches_table,length)


all_matches = data.frame()

# Extract results and populate all_matches
for (a_day_matches in matches_table) {
    if(dim(a_day_matches)[2] != 3)
        all_matches = rbind(all_matches, as.data.frame(a_day_matches))
}

# View(all_matches)


# Convert results to {home_team, away_team, home_score, away_score, points, week} format
all_results <- as.data.frame(t(as.data.frame(strsplit(as.character(all_matches$V3), " - "))))

all_results <- data.frame(
    'home' = all_matches$V2, 
    'away' = all_matches$V4,
    'home_s' = all_results$V1,
    'away_s' = all_results$V2,
    'points' = 0,
    'week' =  ceiling(dim(all_results)[1]:1 / 10))


# Output1 -> results in {home, away, home_score, away_score, week} format
output1 <- subset(all_results,select =-c(points))



# Read team_abbreviations and replace long_names with short_names
team_abbreviations <- read.csv('Team_Abbreviations.csv', sep = '\t', header = FALSE)
colnames(team_abbreviations) <- c('long', 'short')

all_results <- merge(all_results, team_abbreviations, by.x = 'home', by.y = 'long')
all_results <- merge(all_results, team_abbreviations, by.x = 'away', by.y = 'long')
all_results <- all_results[c('week', 'short.x', 'short.y', 'home_s', 'away_s', 'points')]
names(all_results) <- c('week', 'home', 'away', 'home_s', 'away_s', 'points')



# Home teams' results in {Team1, Team2 (name + "(h)"), points, week} format

all_results_h <- all_results

all_results_h[all_results_h$home_s > all_results_h$away_s,]$points <- 3
all_results_h[all_results_h$home_s == all_results_h$away_s,]$points <- 1

Team1 <- all_results_h$home
Team2 <- paste(all_results_h$away , '(h)', sep = '')
points <- all_results_h$points 
week <- all_results_h$week

output2_1 <- data.frame(week, Team1, Team2, points)


# Away teams' results in {Team1, Team2 (name + "(a)"), points, week} format

all_results_a <- all_results

all_results_a[all_results_a$home_s < all_results_a$away_s,]$points <- 3
all_results_a[all_results_a$home_s == all_results_a$away_s,]$points <- 1

Team1 <- all_results_a$away
Team2 <- paste(all_results_a$home , '(a)', sep = '')
points <- all_results_a$points 
week <- all_results_a$week

output2_2 <- data.frame(week, Team1, Team2, points)


# bind home and away results
output2 <- rbind(output2_1, output2_2)



# Write to files
source('write2file.R')
write2file(output1 ,results_scores, 
           row.names = FALSE, col.names = FALSE, sep = '\t', quote = FALSE)

write2file(output2 ,results_points, 
           row.names = FALSE, col.names = FALSE, sep = '\t', quote = FALSE)

