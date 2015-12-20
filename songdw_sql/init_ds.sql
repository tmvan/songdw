USE [SONG]

DECLARE @tmp [bigint]

EXECUTE usp_InsertPageIfNotExist 'zing', 'Zing Mp3', 'http://mp3.zing.vn', @tmp OUT
EXECUTE usp_InsertPageIfNotExist 'nct', 'Nhaccuatui', 'http://nhaccuatui.com', @tmp OUT