USE [SONG]

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertPageIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertPageIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertPageIfNotExist]
	@shortName [nvarchar](20),
	@name [nvarchar](100),
	@homepage [nvarchar](100),
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[Page] WHERE [ShortName] = @shortName
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Page] ([ShortName], [Name], [Home]) 
		VALUES (@shortName, @name, @homepage)

		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertGenreIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertGenreIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertGenreIfNotExist]
	@genre [nvarchar](50),
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[Genre] WHERE [Genre] = @genre
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Genre] ([Genre]) 
		VALUES (@genre)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertGenreGroupIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertGenreGroupIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertGenreGroupIfNotExist]
	@songId [bigint],
	@genreId [bigint],
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[GenreGroup] WHERE [SongId] = @songId AND [GenreId] = @genreId
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[GenreGroup] ([GenreId], [SongId]) 
		VALUES (@genreId, @songId)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertPerformersIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertPerformersIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertPerformersIfNotExist]
	@singerId [bigint],
	@songId [bigint],
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[Performers] WHERE [SongId] = @songId AND [SingerId] = @singerId
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Performers] ([SingerId], [SongId])
		VALUES (@singerId, @songId)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertSingerIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertSingerIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertSingerIfNotExist]
	@name [nvarchar](100),
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [Singer] WHERE [Name] = @name
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Singer] ([Name])
		VALUES (@name)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertSongIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertSongIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertSongIfNotExist]
	@title [nvarchar](200),
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[Song] WHERE [Title] = @title
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Song] ([Title])
		VALUES (@title)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertHitStatictisIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertHitStatictisIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertHitStatictisIfNotExist]
	@songId [bigint],
	@pageId [bigint],
	@hitCount [int],
	@date [date],
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[HitStatictis] WHERE [SongId] = @songId AND [PageId] = @pageId AND [date] = @date
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[HitStatictis] ([SongId], [PageId], [HitCount], [Date])
		VALUES (@songId, @pageId, @hitCount, @date)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InserDataFromCsvRow'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InserDataFromCsvRow] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InserDataFromCsvRow]
	@title [nvarchar](200),
	@performers [nvarchar](1000),
	@genres [nvarchar](1000),
	@hitcount [int],
	@pageId [bigint],
	@date [date] AS
BEGIN
	DECLARE @songId [bigint], 
			@singerId [bigint],
			@singer [nvarchar](100),
			@genreId [bigint],
			@genre [nvarchar](50),
			@tmpId [bigint]

	IF EXISTS(SELECT [Id] FROM [dbo].[Page] WHERE [Id] = @pageId)
	BEGIN
		EXECUTE usp_InsertSongIfNotExist @title, @songId OUT

		-- SPLIT SINGERS NAME AND INSERT TO DATABASE
		DECLARE performers_cursor CURSOR
		FOR SELECT [Part] FROM [dbo].[ufn_SplitString](@performers, ',')
		
		OPEN performers_cursor
		FETCH NEXT FROM performers_cursor INTO @singer

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE [dbo].[usp_InsertSingerIfNotExist] @singer, @singerId OUT
			EXECUTE [dbo].[usp_InsertPerformersIfNotExist] @singerId, @songId, @tmpId OUT
			FETCH NEXT FROM performers_cursor INTO @singer
		END

		CLOSE performers_cursor
		DEALLOCATE performers_cursor

		-- SPLIT GENRES NAME AND INSERT TO DATABASE
		DECLARE genres_cursor CURSOR
		FOR SELECT [Part] FROM ufn_SplitString(@genres, ',')

		OPEN genres_cursor
		FETCH NEXT FROM genres_cursor INTO @genre
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE [dbo].[usp_InsertGenreIfNotExist] @genre, @genreId OUT
			EXECUTE [dbo].[usp_InsertGenreGroupIfNotExist] @songId, @genreId, @tmpId OUT
			FETCH NEXT FROM genres_cursor INTO @genre
		END

		CLOSE genres_cursor
		DEALLOCATE genres_cursor

		EXECUTE [dbo].[usp_InsertHitStatictisIfNotExist] @songId, @pageId, @hitcount, @date, @tmpId OUT

		RETURN 1
	END
	ELSE
		RETURN 0
END
GO