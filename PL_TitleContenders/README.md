PL_TitleContenders
=============
I use Betfair odds to find each team's (implied) probability of winning the title as a function of time. Adopting ideas from Information Theory (Shannon Entropy), I also calculate (effective) number of team's with a shot at the title vs. time.

/Get_Data_from_DB:
--------
PL_Odds_out_from_DB.sql: Creates a VIEW that extracts the odds from my local DB and cleans it.

Get_Odds.bat: Calls PL_Odds_out_from_DB.sql to create a view and uses "BCP QueryOut" to get the data from the local DB. The output is written to ../data/PL_Odds_History.csv.

log_CreateView.txt: log file.

log_qout.txt: log file. 

How Many Title Contenders.rmd
--------------------

Main file. output: (effective) number of title contenders vs. time.

PL_TitleContenders.R 
------------------------------------------------------
(almost) same as How Many Title Contenders.rmd. sandbox.

/Sample_Outputs
------------------

Sample outputs!