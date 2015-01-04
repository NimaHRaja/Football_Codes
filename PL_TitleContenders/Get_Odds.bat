osql -E -S Nima -d NHKB -n-1 -i PL_Odds_out_from_DB.sql -o log_CreateView.txt
bcp "SELECT * FROM NHKB.dbo.PL_Odds_History" queryout  ../PL_Odds_History.csv -T -c > log_qout.txt