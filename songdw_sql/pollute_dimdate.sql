USE SONGDW

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = 'dbo'
	AND  TABLE_NAME = 'DimDate'))
BEGIN
	DECLARE @Now DATE = GETDATE()
	DECLARE @Year INT = YEAR(@Now), 
			@Month INT = 1, 
			@Day INT = 1,
			@i INT = -1,
			@iYear INT, @iMonth INT, @iDay INT, @iDayMax INT,
			@AltKey [nvarchar](20)
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
				SET @AltKey = REPLACE(STR(@iYear, 4), ' ', '0') +
							REPLACE(STR(@iMonth, 2), ' ', '0') +
							REPLACE(STR(@iDay, 2), ' ', '0')

				IF NOT EXISTS(SELECT [AltKey] FROM [dbo].[DimDate] WHERE [AltKey] = @AltKey)
				BEGIN
					INSERT INTO [dbo].[DimDate] ([AltKey], [DayOfMonth], [MonthOfYear], [Year])
					VALUES (@AltKey, @iDay, @iMonth, @iYear)
				END

				SET @iDay = @iDay + 1
			END

			SET @iMonth = @iMonth + 1
		END

		SET @i = @i + 1
	END
END