USE SONGDW

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimDate'))
BEGIN
	CREATE TABLE [dbo].[DimDate](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[AltId] [nvarchar](20) UNIQUE NOT NULL,
		[DayOfMonth] INT NOT NULL,
		[WeekOfMonth] INT NOT NULL,
		[WeekOfYear] INT NOT NULL,
		[MonthOfYear] INT NOT NULL,
		[Year] INT NOT NULL
	)
END
ELSE
BEGIN
	DECLARE @Now DATE = GETDATE()
	DECLARE @Year INT = YEAR(@Now), 
			@Month INT = 1, 
			@Day INT = 1,
			@i INT = 0,
			@iYear INT, @iMonth INT, @iDay INT, @iDayMax INT,
			@yearDayCount INT = 0, @monthDayCount INT = 0,
			@AltId [nvarchar](20)
	WHILE @i < 2
	BEGIN
		SET @iYear = @Year + @i
		SET @iMonth = 1
		SET @monthDayCount = 0

		WHILE @iMonth < 13
		BEGIN
			SET @iDay = 1
			SET @iDayMax = 
				CASE
					WHEN @iMonth = 1 OR 
						@iMonth = 3 OR 
						@iMonth = 5 OR 
						@iMonth = 7 OR 
						@iMonth = 8 OR 
						@iMonth = 10 OR 
						@iMonth = 12
					THEN 31
					WHEN @iMonth = 2 THEN
						CASE
							WHEN (@iMonth % 4 = 0 AND @iMonth % 100 = 0 AND @iMonth % 400 = 0) OR
								(@iMonth % 4 = 0 AND @iMonth % 100 <> 0)
							THEN 29
							ELSE 28 
						END
					ELSE 30
				END
			WHILE @iDay <= @iDayMax
			BEGIN
				SET @AltId = REPLACE(STR(@iYear, 4), ' ', '0') +
							REPLACE(STR(@iMonth, 2), ' ', '0') +
							REPLACE(STR(@iDay, 2), ' ', '0')

				IF NOT EXISTS(SELECT [AltId] FROM [dbo].[DimDate] WHERE [AltId] = @AltId)
				BEGIN
					INSERT INTO [dbo].[DimDate] ([AltId], [DayOfMonth], [MonthOfYear], [WeekOfMonth], [WeekOfYear], [Year])
					VALUES (@AltId, @iDay, @iMonth, @yearDayCount / 7, @monthDayCount / 7, @iYear)
				END

				SET @iDay = @iDay + 1
				SET @yearDayCount = @yearDayCount + 1
				SET @monthDayCount = @monthDayCount + 1
			END

			SET @iMonth = @iMonth + 1
		END

		SET @i = @i + 1
	END
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSinger'))
BEGIN
	CREATE TABLE [dbo].[DimSinger](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](100) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimPerformers'))
BEGIN
	CREATE TABLE [dbo].[DimPerformers](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SingerId] [bigint] NOT NULL,
		[Name] [nvarchar](200) NULL,
		CONSTRAINT [UC_SingerId] UNIQUE NONCLUSTERED(
			[Id],
			[SingerId]
		)
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimGenre'))
BEGIN
	CREATE TABLE [dbo].[DimGenre](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Genre] [NVARCHAR](50) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSong'))
BEGIN
	CREATE TABLE [dbo].[DimSong](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SongId] [bigint] NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSongGenre'))
BEGIN
	CREATE TABLE [dbo].[DimSongGenre](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[GenreId] [bigint] NOT NULL,
		[Name] [nvarchar](500) NOT NULL,
		CONSTRAINT [UC_SongGenreId] UNIQUE NONCLUSTERED(
			[Id],
			[GenreId]
		)
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'FactSong'))
BEGIN
	CREATE TABLE [dbo].[FactSong](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SongId] [bigint] NOT NULL,
		[DateId] [bigint] NOT NULL,
		[PerformersId] [bigint] NOT NULL,
		[SongGenreId] [bigint] NOT NULL,
		[TotalPlay] [int] NOT NULL
	)
END