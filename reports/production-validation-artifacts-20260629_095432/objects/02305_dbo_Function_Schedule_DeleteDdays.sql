-- ─── FUNCTION: schedule_deleteddays ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddays();
CREATE OR REPLACE FUNCTION public.schedule_deleteddays(
) RETURNS TABLE(
    ddayno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbddaynos table (
		ddayno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(DdayNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(DdayNos, LEN(DdayNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(DdayNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbDdayNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END;
	INSERT INTO ScheduleDdaysHistory
	(
		DdayNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	RETURN QUERY
	SELECT DdayNo, 'D', NOW(), (SELECT RegUserNo FROM ScheduleDdays D WHERE D.DdayNo = T.DdayNo) FROM tbDdayNos T
	
	DELETE FROM ScheduleDdays WHERE DdayNo IN (SELECT DdayNo FROM tbDdayNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
