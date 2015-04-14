# Init
library(XML)
options(stringsAsFactors = FALSE)


# Read data
results_URL <- 
    "http://www.premierleague.com/en-gb/matchday/matches.html?paramClubId=ALL&paramComp_100=true&view=.dateSeason.html"

fixtures_table <- readHTMLTable(results_URL)


# The last table in fixtures_table is the PL's table. Others -> fixtures.
# fixtures_table[length(fixtures_table)]
# lapply(fixtures_table,length)


# Extract fixtures and populate all_fixtures
all_fixtures = data.frame()

for (a_day_fixtures in fixtures_table) {
    if(dim(a_day_fixtures)[2] != 3)
        all_fixtures = rbind(all_fixtures, as.data.frame(a_day_fixtures))
}

# View(all_fixtures)


# Split fixtures and extract home and away teams
all_fixtures <- as.data.frame(all_fixtures[!is.na(all_fixtures$V7),3])
all_fixtures <- as.data.frame(strsplit(as.character(all_fixtures[,1]), " v "))
all_fixtures <- as.data.frame(t(all_fixtures))
row.names(all_fixtures) <- NULL
names(all_fixtures) <- c("Team1", "Team2")
all_fixtures$order <- 1:nrow(all_fixtures)


# Read team_abbreviations and replace long_names with short_names
team_abbreviations <- 
    read.csv('Team_Abbreviations.csv', sep = '\t', header = FALSE)
colnames(team_abbreviations) <- c('long', 'short')

all_fixtures <- merge(all_fixtures, team_abbreviations, 
                      by.x = 'Team1', by.y = 'long')
all_fixtures <- merge(all_fixtures, team_abbreviations, 
                      by.x = 'Team2', by.y = 'long')
all_fixtures <- 
    all_fixtures[c('short.x', 'short.y', 'order')]
names(all_fixtures) <- c("Team1", "Team2", "order")
all_fixtures <- all_fixtures[order(all_fixtures$order),1:2]
row.names(all_fixtures) <- NULL

all_fixtures$H <- "50"
all_fixtures$D <- "30"
all_fixtures$A <- "20"


# Write to file
write.csv(all_fixtures, "Fixtures.csv", row.names = FALSE)