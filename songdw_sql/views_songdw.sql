USE [SongDW]

DECLARE @SongKey [bigint] = 15111

SELECT s.SongFactKey, s.SongKey, s.SingerKey, s.DateKey, s.PageKey, s.HitCount, 
	   dd.[DayOfMonth], dd.MonthOfYear, dd.[Year],
	   ds.Name AS [SingerName], ds.IsGroup,
	   dsong.Title AS [SongTitle],
	   dg.Genre,
	   dp.Name AS [PageName]
FROM (
		SELECT fs.SongFactKey, fs.SongKey, fs.SingerKey, fs.DateKey, fs.PageKey, fs.HitCount
		FROM FactSong fs, (SELECT DISTINCT TOP 1 DateKey FROM FactSong ORDER BY DateKey DESC) d
		WHERE SongKey = @SongKey AND fs.DateKey > d.DateKey - 8
	) s JOIN DimDate dd ON s.DateKey = dd.DateKey
	JOIN DimSinger ds ON ds.SingerKey = s.SingerKey
	JOIN DimSong dsong on dsong.SongKey = s.SongKey
	JOIN DimGenre dg on dsong.GenreKey = dg.GenreKey
	JOIN DimPage dp on dp.PageKey = s.PageKey
ORDER BY s.PageKey, s.DateKey
