USE [SONGSTAGGING]

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Page'))
BEGIN
	CREATE TABLE [dbo].[Page](
		[BusinessKey] [bigint] NOT NULL,
		[Name] [nvarchar](100) NOT NULL,
		[Home] [nvarchar](100) NOT NULL
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Singer')
BEGIN
	CREATE TABLE [dbo].[Singer] (
		[BusinessKey] [bigint] NOT NULL,
		[Name] [nvarchar](200) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Performers'))
BEGIN
	CREATE TABLE [dbo].[Performers] (
		[BusinessKey] [bigint] NOT NULL,
		[SingerId] [bigint] NOT NULL,
		[SongId] [bigint] NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Genre'))
BEGIN
	CREATE TABLE [dbo].[Genre] (
		[BusinessKey] [bigint] NOT NULL,
		[Genre] [nvarchar](50) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'Song'))
BEGIN
	CREATE TABLE [dbo].[Song] (
		[BusinessKey] [bigint] NOT NULL,
		[Title] [nvarchar](100) NOT NULL
	)
END

IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'GenreGroup'))
BEGIN
	CREATE TABLE [dbo].[GenreGroup](
		[BusinessKey] [bigint] NOT NULL,
		[SongId] [bigint] NOT NULL,
		[GenreId] [bigint] NOT NULL
	)
END
