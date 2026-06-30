-- ─── PROCEDURE→FUNCTION: integrated_deletes ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.integrated_deletes();
CREATE OR REPLACE FUNCTION public.integrated_deletes(
) RETURNS void
AS $function$
DECLARE
    tbtemp table (
		integratedno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(IntegratedNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(IntegratedNos, LEN(IntegratedNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(IntegratedNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbTemp VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;

	DELETE FROM Integrateds WHERE IntegratedNo IN (SELECT IntegratedNo FROM tbTemp)	;
	DELETE FROM NoticesSyn WHERE IntegratedNo IN (SELECT IntegratedNo FROM tbTemp);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
