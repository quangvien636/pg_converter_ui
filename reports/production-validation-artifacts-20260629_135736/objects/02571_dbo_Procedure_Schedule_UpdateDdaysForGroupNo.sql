-- ─── PROCEDURE→FUNCTION: schedule_updateddaysforgroupno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.schedule_updateddaysforgroupno(character varying, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateddaysforgroupno(
    IN ddaynos character varying,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno integer
) RETURNS void
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
	END;

	UPDATE ScheduleDdays SET
		ModUserNo = schedule_updateddaysforgroupno.moduserno,
		ModDate = schedule_updateddaysforgroupno.moddate,
		GroupNo = schedule_updateddaysforgroupno.groupno
	WHERE DdayNo IN (SELECT DdayNo FROM tbDdayNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
