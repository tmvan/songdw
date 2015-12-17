USE [SONG]

TRUNCATE TABLE [dbo].[Genre]
TRUNCATE TABLE [dbo].[GenreGroup]
TRUNCATE TABLE [dbo].[HitStatictis]
TRUNCATE TABLE [dbo].[Page]
TRUNCATE TABLE [dbo].[Performers]
TRUNCATE TABLE [dbo].[Singer]
TRUNCATE TABLE [dbo].[Song]

DECLARE @tmp [bigint]

EXECUTE usp_InsertPageIfNotExist 'zing', 'Zing Mp3', 'http://mp3.zing.vn', @tmp OUT
EXECUTE usp_InsertPageIfNotExist 'nct', 'Nhaccuatui', 'http://nhaccuatui.com', @tmp OUT