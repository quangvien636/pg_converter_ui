-- ─── PROCEDURE→FUNCTION: noticesyn_deletenotices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.noticesyn_deletenotices();
CREATE OR REPLACE FUNCTION public.noticesyn_deletenotices(
) RETURNS void
AS $function$
DECLARE
    tbnoticenos table (
		noticeno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(NoticeNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(NoticeNos, LEN(NoticeNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(NoticeNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbNoticeNos VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;

	DELETE FROM NoticesSyn WHERE NoticeNo IN (SELECT NoticeNo FROM tbNoticeNos)	

END;
---------------------------------///////////////////////////-------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
