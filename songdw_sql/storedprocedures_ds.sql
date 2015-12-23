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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertSingerIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertSingerIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertSingerIfNotExist]
	@name [nvarchar](500),
	@isgroup [bit],
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [Singer] WHERE [Name] = @name
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Singer] ([Name], [IsGroup])
		VALUES (@name, @isgroup)
		SET @id = CAST(SCOPE_IDENTITY() AS [bigint])
	END
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertSongIfNotExist'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertSongIfNotExist] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertSongIfNotExist]
	@title [nvarchar](200),
	@singerId [bigint],
	@genreId [bigint],
	@id [bigint] OUT AS 
BEGIN
	SET @id = 0
	SELECT @id = [Id] FROM [dbo].[Song] WHERE [Title] = @title
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[Song] ([Title], [SingerId], [GenreId])
		VALUES (@title, @singerId, @genreId)
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
	@date [date] AS 
BEGIN
	DECLARE @id [bigint] = 0
	SELECT @id = [Id] FROM [dbo].[HitStatictis] WHERE [SongId] = @songId AND [PageId] = @pageId AND [date] = @date
	IF @id = 0
	BEGIN
		INSERT INTO [dbo].[HitStatictis] ([SongId], [PageId], [HitCount], [Date])
		VALUES (@songId, @pageId, @hitCount, @date)
	END
END
GO