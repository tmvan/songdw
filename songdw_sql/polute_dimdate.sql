USE SONGDW

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimDate'))
BEGIN
	DECLARE @Now DATE = GETDATE()
	DECLARE @Year INT = YEAR(@Now), 
			@Month INT = 1, 
			@Day INT = 1,
			@i INT = 0,
			@iYear INT, @iMonth INT, @iDay INT, @iDayMax INT,
			@AltId [nvarchar](20)
	WHILE @i < 2
	BEGIN
		SET @iYear = @Year + @i
		SET @iMonth = 1

		WHILE @iMonth < 13
		BEGIN
			SET @iDay = 1
			SET @iDayMax = 
				CASE
					WHEN @iMonth = 1 OR 
						@iMonth = 3 OR 
						@iMonth = 5 OR 
						@iMonth = 7 OR 
						@iMonth = 8 OR 
						@iMonth = 10 OR 
						@iMonth = 12
					THEN 31
					WHEN @iMonth = 2 THEN
						CASE
							WHEN (@iMonth % 4 = 0 AND @iMonth % 100 = 0 AND @iMonth % 400 = 0) OR
								(@iMonth % 4 = 0 AND @iMonth % 100 <> 0)
							THEN 29
							ELSE 28 
						END
					ELSE 30
				END
			WHILE @iDay <= @iDayMax
			BEGIN
				SET @AltId = REPLACE(STR(@iYear, 4), ' ', '0') +
							REPLACE(STR(@iMonth, 2), ' ', '0') +
							REPLACE(STR(@iDay, 2), ' ', '0')

				IF NOT EXISTS(SELECT [AltId] FROM [dbo].[DimDate] WHERE [AltId] = @AltId)
				BEGIN
					INSERT INTO [dbo].[DimDate] ([AltId], [DayOfMonth], [MonthOfYear], [Year])
					VALUES (@AltId, @iDay, @iMonth, @iYear)
				END

				SET @iDay = @iDay + 1
			END

			SET @iMonth = @iMonth + 1
		END

		SET @i = @i + 1
	END
END