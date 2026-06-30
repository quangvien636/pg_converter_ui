-- ─── PROCEDURE→FUNCTION: work_deleteworks ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.work_deleteworks(character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_deleteworks(
    IN worknos character varying,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    tbworknos table (
		workno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(WorkNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(WorkNos, LEN(WorkNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(WorkNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbWorkNos VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;

	UPDATE Works SET Enabled = FALSE, ModUserNo = work_deleteworks.moduserno, ModDate = work_deleteworks.moddate
	WHERE WorkNo IN (SELECT WorkNo FROM tbWorkNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
