-- ─── PROCEDURE→FUNCTION: schedule_deleteddays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.schedule_deleteddays();
CREATE OR REPLACE FUNCTION public.schedule_deleteddays(
) RETURNS SETOF record
AS $function$
DECLARE
    tbddaynos table (
		ddayno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(DdayNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(DdayNos, LEN(DdayNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(DdayNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbDdayNos VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;;
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
