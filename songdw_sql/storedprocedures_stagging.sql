USE [SONGSTAGGING]

--IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_'))
--   EXECUTE('CREATE PROCEDURE [dbo].[usp_] AS BEGIN SET NOCOUNT ON; END')
--GO

--ALTER PROCEDURE [dbo].[usp_]
--AS
--BEGIN
--END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertToPageStagging'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertToPageStagging] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertToPageStagging]
	@key [bigint],
	@name [nvarchar](100),
	@home [nvarchar](100) AS
BEGIN
	INSERT INTO [dbo].[Page] ([BusinessKey], [Name], [Home])
	VALUES (@key, @name, @home)	
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertToSingerStagging'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertToSingerStagging] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertToSingerStagging]
	@key [bigint],
	@name [nvarchar](200),
	@isgroup [bit] AS
BEGIN
	INSERT INTO [dbo].[Singer] ([BusinessKey], [Name], [IsGroup])
	VALUES (@key, @name, @isgroup)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertToGenreStagging'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertToGenreStagging] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertToGenreStagging]
	@key [bigint],
	@genre [nvarchar](50) AS
BEGIN
	INSERT INTO [dbo].[Genre] ([BusinessKey], [Genre])
	VALUES (@key, @genre)	
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_InsertToSongStagging'))
   EXECUTE('CREATE PROCEDURE [dbo].[usp_InsertToSongStagging] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE [dbo].[usp_InsertToSongStagging]
	@key [bigint],
	@title [nvarchar](100) AS
BEGIN
	INSERT INTO [dbo].[Song] ([BusinessKey], [Title])
	VALUES (@key, @title)	
END
GO