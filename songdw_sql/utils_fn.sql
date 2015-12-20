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
		WHERE  [object_id] = OBJECT_ID(N'[dbo].[ufn_Trim]') AND 
			[type] IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
  EXECUTE('DROP FUNCTION [dbo].[ufn_Trim]')
GO

CREATE FUNCTION [dbo].[ufn_Trim] (
	@string [nvarchar](1000) -- STRING TO SPLIT
)
RETURNS [nvarchar](1000) AS
BEGIN
	DECLARE @trimmed [nvarchar](1000) = RTRIM(LTRIM(@string))

	DECLARE	@left [nvarchar](1) = LEFT(@trimmed, 1),
			@right [nvarchar](1) = RIGHT(@trimmed, 1)

	IF @left IN ('"')
		SET @trimmed = SUBSTRING(@trimmed, 2, LEN(@trimmed))
		
	IF @right IN ('"')
		SET @trimmed = SUBSTRING(@trimmed, 1, LEN(@trimmed) - 1)

	RETURN RTRIM(LTRIM(@trimmed))
END
GO

IF EXISTS (SELECT * 
		FROM sys.objects 
		WHERE  [object_id] = OBJECT_ID(N'[dbo].[ufn_CommaSplit]') AND 
			[type] IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
  EXECUTE('DROP FUNCTION [dbo].[ufn_CommaSplit]')
GO

CREATE FUNCTION [dbo].[ufn_CommaSplit] (
	@string [nvarchar](1000) -- STRING TO SPLIT
)

RETURNS @parts TABLE (
	[Part] [nvarchar](1000)
) AS

BEGIN
	DECLARE @len [int] = LEN(@string),
			@ignore [bit] = 0

	IF @len > 1
	BEGIN
		DECLARE @index [int] = 0,
			@start_index [int] = 0,
			@sub [nvarchar](999),
			@part [nvarchar](999)

		WHILE @index + 1 < @len
		BEGIN
			SET @sub = SUBSTRING(@string, @index, 1)
			IF @sub = '"'
			BEGIN
				IF @ignore = 0
					SET @ignore = 1
				ELSE
					SET @ignore = 0
			END
			IF @sub = ',' AND @ignore = 0
			BEGIN
				SET @part = SUBSTRING(@string, @start_index, @index - @start_index)
				INSERT INTO @parts VALUES ([dbo].[ufn_Trim](@part))
				SET @start_index = @index + 1
			END
			SET @index = @index + 1
		END

		SET @sub = SUBSTRING(@string, @len, 1)
		IF @sub = ','
			SET @part = SUBSTRING(@string, @start_index, @len - @start_index)
		ELSE
			SET @part = SUBSTRING(@string, @start_index, @len + 1)

		INSERT INTO @parts VALUES ([dbo].[ufn_Trim](@part))
	END

	RETURN
END