nUSE [SONG]

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Page'))
BEGIN
	CREATE TABLE [dbo].[Page](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[ShortName] [nvarchar](20) NOT NULL,
		[Name] [nvarchar](100) NOT NULL,
		[Home] [nvarchar](100) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Singer'))
BEGIN
	CREATE TABLE [dbo].[Singer](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](100) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Performers'))
BEGIN
	CREATE TABLE [dbo].[Performers](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SingerId] [bigint] NOT NULL,
		[SongId] [bigint] NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Genre'))
BEGIN
	CREATE TABLE [dbo].[Genre](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Genre] [NVARCHAR](50) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Song'))
BEGIN
	CREATE TABLE [dbo].[Song](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Title] [nvarchar](200) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'GenreGroup'))
BEGIN
	CREATE TABLE [dbo].[GenreGroup](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SongId] [bigint] NOT NULL,
		[GenreId] [bigint] NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'HitStatictis'))
BEGIN
	CREATE TABLE [dbo].[HitStatictis](
		[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SongId] [bigint] NOT NULL,
		[PageId] [bigint] NOT NULL,
		[HitCount] [int] NOT NULL,
		[Date] [Date] NOT NULL
	)
END
