IF OBJECT_ID('PL_Odds_History', 'V') IS NOT NULL DROP VIEW PL_Odds_History
GO

CREATE VIEW PL_Odds_History AS
SELECT TT.Market_Short AS Market, TA.Team_Short AS Team,
ISNULL(t_back.back,1) as Back, ISNULL(t_lay.lay,10000) as Lay, TT.time as Time 
FROM
(SELECT DISTINCT MA.Market_Short, CONVERT(datetime,BO.time,103) AS Time FROM 
NHKB.dbo.Market_Abbreviations MA INNER JOIN NHKB.dbo.Betfair_Odds BO ON MA.Market_Long = BO.Market) TT
INNER JOIN Team_Abbreviations TA ON 1=1
LEFT JOIN
(SELECT Market_Short, MAX(odds) back, Outcome, CONVERT(datetime,time,103) AS time 
FROM NHKB.dbo.Betfair_Odds 
INNER JOIN NHKB.dbo.Market_Abbreviations ON NHKB.dbo.Betfair_Odds.Market = NHKB.dbo.Market_Abbreviations.Market_Long
WHERE [Back/Lay]='back' GROUP BY Outcome, time, Market_Short) T_back
ON TT.Market_Short = T_back.Market_Short AND TT.Time = T_back.time AND TA.Team_Long = T_back.Outcome
LEFT JOIN
(SELECT Market_Short, MIN(odds) lay, Outcome, CONVERT(datetime,time,103) AS time 
FROM NHKB.dbo.Betfair_Odds 
INNER JOIN NHKB.dbo.Market_Abbreviations ON NHKB.dbo.Betfair_Odds.Market = NHKB.dbo.Market_Abbreviations.Market_Long
WHERE [Back/Lay]='lay' GROUP BY Outcome, time, Market_Short) T_Lay
ON TT.Market_Short = T_Lay.Market_Short AND TT.Time = T_Lay.time AND TA.Team_Long = T_Lay.Outcome
GO