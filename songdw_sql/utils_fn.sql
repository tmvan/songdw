USE[SONG]

--IF EXISTS (SELECT * 
--		FROM sys.objects 
--		WHERE  [object_id] = OBJECT_ID(N'[dbo].[ufn_]') AND 
--			[type] IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
--  EXECUTE('DROP FUNCTION [dbo].[ufn_]')
--GO

--CREATE FUNCTION [dbo].[ufn_] (
	
--)
--RETURNS [int] AS
--BEGIN
--	DECLARE @count [int] = 0
--	WHILE @count <= 1000
--END
--GO

IF EXISTS (SELECT * 
		FROM sys.objects 
		WHERE  [object_id] = OBJECT_ID(N'[dbo].[ufn_SplitString]') AND 
			[type] IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
  EXECUTE('DROP FUNCTION [dbo].[ufn_SplitString]')
GO

CREATE FUNCTION [dbo].[ufn_SplitString] (
	@string [nvarchar](1000), -- STRING TO SPLIT
	@delimiter [nvarchar](10) -- NOT SPACE!
)

RETURNS @parts TABLE (
	[Part] [nvarchar](1000)
) AS

BEGIN
	DECLARE @len [int] = LEN(@string), 
			@dlen [int] = LEN(@delimiter)
	
	IF @dlen = 0 OR @dlen > @len
		INSERT INTO @parts VALUES (@string)

	IF @dlen < @len
	BEGIN
		DECLARE @index [int] = 0,
			@start_index [int] = 0,
			@sub [nvarchar](999),
			@part [nvarchar](999)

		WHILE @index + @dlen < @len
		BEGIN
			SET @sub = SUBSTRING(@string, @index, @dlen)
			IF @sub = @delimiter
			BEGIN
				SET @part = SUBSTRING(@string, @start_index, @index - @start_index)
				INSERT INTO @parts VALUES (RTRIM(LTRIM(@part)))
				SET @start_index = @index + @dlen
			END
			SET @index = @index + 1
		END

		SET @sub = SUBSTRING(@string, @len - @dlen + 1, @dlen)
		IF @sub = @delimiter
			SET @part = SUBSTRING(@string, @start_index, @len - @start_index - @dlen + 1)
		ELSE
			SET @part = SUBSTRING(@string, @start_index, @len + 1)

		INSERT INTO @parts VALUES (RTRIM(LTRIM(@part)))
	END

	RETURN
END