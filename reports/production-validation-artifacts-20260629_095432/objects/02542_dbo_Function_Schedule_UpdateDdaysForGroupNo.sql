-- ─── FUNCTION: schedule_updateddaysforgroupno ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateddaysforgroupno(character varying, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateddaysforgroupno(
    ddaynos character varying,
    moduserno integer,
    moddate timestamp without time zone,
    groupno integer
) RETURNS void
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

	END

	UPDATE ScheduleDdays SET
		ModUserNo = schedule_updateddaysforgroupno.moduserno,
		ModDate = schedule_updateddaysforgroupno.moddate,
		GroupNo = schedule_updateddaysforgroupno.groupno
	WHERE DdayNo IN (SELECT DdayNo FROM tbDdayNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
