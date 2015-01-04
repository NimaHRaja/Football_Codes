odds <- read.table("PL_Odds_History.csv", header = FALSE, 
                   sep = "\t", stringsAsFactor = FALSE)

colnames(odds) <- c("Market", "Team", "Back", "Lay", "Time")

odds_winner <- odds[odds$Market == "Winner",]

row.names(odds_winner) <- NULL

# data_tc <- data.frame(
#     sapply(
#         split(
#             odds_winner,
#             factor(odds_winner$Time)),
#         function(x) exp(sum(log(x$Back)/x$Back))))
# 
# colnames(data_tc) <- "tc"
#    
# data_tc$Time <- strptime(row.names(data_tc), "%Y-%m-%d %H:%M:%S.000")
# row.names(data_tc) <- NULL
# 
# library(ggplot2)
# 
# plot_tc <- ggplot(data_tc, aes(x=Time, y=tc)) + 
#     geom_line() + 
#     xlab("Time") + 
#     ylab("# Title Contenders")   
# 
# #    geom_text(data=data_tc[c(3,30), ], label=LETTERS[1:2], vjust=1)
# 
# 
# plot_tc

 qplot(x=strptime(Time, "%Y-%m-%d %H:%M:%S.000"), 
       y=log(Back)/Back, data = odds_winner, colour = Team) +
    geom_smooth()
    





library(reshape2)
odds_winner <- dcast(odds_winner, Time ~ Team , value.var = "Back")
odds_winner$Time <- strptime(odds_winner$Time, "%Y-%m-%d %H:%M:%S.000")
odds_winner <- odds_winner[order(odds_winner$Time),]



# Not a derivative. a Simple Delta

inf <- log(odds_winner[,2:21])/odds_winner[,2:21]
delta_inf <- inf[1:dim(inf)[1]-1,]- inf[2:dim(inf)[1],]

View(melt(delta_inf))
delta_inf <- cbind(Time =odds_winner$Time[2:length(odds_winner$Time)], delta_inf)


dd <- melt(delta_inf, id = 1)

dd[which.max(dd$value),]

View(dd[order(-abs(dd$value)),])
