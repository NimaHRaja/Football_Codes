odds <- read.table("PL_Odds_History.csv", header = FALSE, 
                   sep = "\t", stringsAsFactor = FALSE)

colnames(odds) <- c("Market", "Team", "Back", "Lay", "Time")

odds_winner <- odds[odds$Market == "Winner",]

row.names(odds_winner) <- NULL

data_tc <- data.frame(
    sapply(
        split(
            odds_winner,
            factor(odds_winner$Time)),
        function(x) exp(sum(log(x$Back)/x$Back))))

colnames(data_tc) <- "tc"
   
data_tc$Time <- strptime(row.names(data_tc), "%Y-%m-%d %H:%M:%S.000")
row.names(data_tc) <- NULL

library(ggplot2)

plot_tc <- ggplot(data_tc, aes(x=Time, y=tc)) + 
    geom_line() + 
    xlab("Time") + 
    ylab("# Title Contenders") 

#    geom_text(data=data_tc[c(3,30), ], label=LETTERS[1:2], vjust=1)


plot_tc
