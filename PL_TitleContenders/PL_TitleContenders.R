# Read Data

odds_all <- read.table("PL_Odds_History.csv", header = FALSE, 
                       sep = "\t", stringsAsFactor = FALSE)
colnames(odds_all) <- c("Market", "Team", "Back", "Lay", "Time")


# Subset Winner

odds_winner <- odds_all[odds_all$Market == "Winner",]
row.names(odds_winner) <- NULL


# First Plot


inf_time <- data.frame(
    sapply(
        split(
            odds_winner,
            factor(odds_winner$Time)),
        function(x) sum(log(x$Back)/x$Back)))

colnames(inf_time) <- "inf"

inf_time$Time <- strptime(row.names(inf_time), "%Y-%m-%d %H:%M:%S.000")
row.names(inf_time) <- NULL

library(ggplot2)

plot_tc <- ggplot(inf_time, aes(x=Time, y=exp(inf))) + 
    geom_line() + 
    xlab("Time") + 
    ylab("# Title Contenders")   

plot_tc



# Plot of Change in P_i log(P_i)


qplot(x=strptime(Time, "%Y-%m-%d %H:%M:%S.000"), 
      y=log(Back)/Back, data = odds_winner, colour = Team) +
    geom_smooth()



## Find major Events


# dcast
library(reshape2)
data_back <- dcast(odds_winner, Time ~ Team , value.var = "Back")
data_back$Time <- strptime(data_back$Time, "%Y-%m-%d %H:%M:%S.000")
data_back <- data_back[order(data_back$Time),]



# Calculate change in Information contribution
# Not a derivative. a Simple Delta


inf <- log(data_back[,2:21])/data_back[,2:21]
delta_inf <- inf[1:dim(inf)[1]-1,]- inf[2:dim(inf)[1],]
delta_inf <- data.frame(Time =data_back$Time[2:length(data_back$Time)], delta_inf)


# melt back
delta_inf_melt <- melt(delta_inf, id = 1)


delta_inf_melt[which.max(delta_inf_melt$value),]
delta_inf_major <- delta_inf_melt[order(-abs(delta_inf_melt$value)),]

# Major changes in teams' inf contributions
head(delta_inf_major)


# do the same for total inf.

delta_tot_inf <- inf_time[1:dim(inf_time)[1]-1,1]- inf_time[2:dim(inf_time)[1],1]
delta_tot_inf <- data.frame(Time = inf_time[2:dim(inf_time)[1],2], 
                            delta_tot_inf)


delta_tot_inf_melt <- melt(delta_tot_inf, id = 1)
delta_tot_inf_melt[which.max(delta_tot_inf_melt$value),]
delta_tot_inf_major <- delta_tot_inf_melt[order(-abs(delta_tot_inf_melt$value)),]
head(delta_tot_inf_major)



x <- 
    merge(
        dcast(delta_inf_major[1:100,], Time ~ variable , value.var = "value"), 
        
        
        dcast(delta_tot_inf_major[1:7,], Time ~ variable , value.var = "value")
        , by = "Time")


x <- x[order(-abs(x$delta_tot_inf)),]

# Now investigate!
# 2014-12-06 14:45:26       NEW 2-1 CHE
# 2014-09-01 23:49:13       LEI 1-1 ARS TOT 0-3 LIV MCI 0-1 STO
# 2014-11-29 23:59:09       SUN 0-0 CHE
# 2015-01-02 09:30:00       TOT 5-3 CHE
# 2014-11-08 14:54:58       LIV 1-2 CHE
# 2014-10-06 12:04:46       CHE 2-0 ARS
# 2014-11-09 09:35:52       QPR 2-2 MCI


# Back to the original graph

event_time <- c('2014-12-06 14:45:26', '2014-09-01 23:49:13', 
                '2014-11-29 23:59:09', '2015-01-02 09:30:00', 
                '2014-11-08 14:54:58',
                '2014-10-06 12:04:46', '2014-11-09 09:35:52')

event_res <- c('NEW 2-1 CHE', 'LEI 1-1 ARS TOT 0-3 LIV MCI 0-1 STO', 
               'SUN 0-0 CHE', 'TOT 5-3 CHE', 'LIV 1-2 CHE', 'CHE 2-0 ARS',
               'QPR 2-2 MCI')

event <- data.frame(Time = event_time, result = event_res)

event$Time <- strptime(event$Time, "%Y-%m-%d %H:%M:%S")


event <- event[order(event$Time),]


plot_tc <- ggplot(inf_time, aes(x=Time, y=exp(inf))) + 
    geom_line() + 
    xlab("Time") + 
    ylab("# Title Contenders")  + 
    geom_text(data=subset(inf_time, Time %in% event$Time), 
          label=event$res , vjust=1)

plot_tc
