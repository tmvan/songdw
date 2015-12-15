USE [SONGDW]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimPage'))
BEGIN
	DROP TABLE [dbo].[DimPage]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimDate'))
BEGIN
	DROP TABLE [dbo].[DimDate]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimPerformers'))
BEGIN
	DROP TABLE [dbo].[DimPerformers]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimGenre'))
BEGIN
	DROP TABLE [dbo].[DimGenre]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSinger'))
BEGIN
	DROP TABLE [dbo].[DimSinger]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSong'))
BEGIN
DROP TABLE [dbo].[DimSong]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimSongGenre'))
BEGIN
	DROP TABLE [dbo].[DimSongGenre]
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'FactSong'))
BEGIN
	DROP TABLE [dbo].[FactSong]
END