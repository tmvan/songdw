USE SONGDW

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimDate')
BEGIN
	CREATE TABLE [dbo].[DimDate] (
		[DateKey] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[AltKey] [nvarchar] (20) UNIQUE NOT NULL,
		[DayOfMonth] INT NOT NULL,
		[MonthOfYear] INT NOT NULL,
		[Year] INT NOT NULL
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimPage')
BEGIN
	CREATE TABLE [dbo].[DimPage] (
		[PageKey] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[BusinessKey] [bigint] NOT NULL,
		[Name] [nvarchar] (100) NOT NULL,
		[Home] [nvarchar] (100) NOT NULL
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSinger')
BEGIN
	CREATE TABLE [dbo].[DimSinger] (
		[SingerKey] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[BusinessKey] [bigint] NOT NULL,
		[Name] [nvarchar] (500) NOT NULL,
		[IsGroup] [bit] NOT NULL
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimGenre')
BEGIN
	CREATE TABLE [dbo].[DimGenre] (
		[GenreKey] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[BusinessKey] [bigint] NOT NULL,
		[Genre] [nvarchar] (100) NOT NULL
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSong')
BEGIN
	CREATE TABLE [dbo].[DimSong] (
		[SongKey] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[BusinessKey] [bigint] NOT NULL,
		[Title] [nvarchar] (200) NOT NULL,
		[GenreKey] [bigint] NOT NULL,
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'FactSong')
BEGIN
	CREATE TABLE [dbo].[FactSong] (
		[SongFactKey] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[SongKey] [bigint] NOT NULL,
		[SingerKey] [bigint] NOT NULL,
		[DateKey] [bigint] NOT NULL,
		[PageKey] [bigint] NOT NULL,
		[HitCount] [int] NOT NULL
	)
END