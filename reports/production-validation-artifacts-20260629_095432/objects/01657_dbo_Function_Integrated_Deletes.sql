-- ─── FUNCTION: integrated_deletes ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_deletes();
CREATE OR REPLACE FUNCTION public.integrated_deletes(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbtemp table (
		integratedno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(IntegratedNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(IntegratedNos, LEN(IntegratedNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(IntegratedNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbTemp VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	DELETE FROM Integrateds WHERE IntegratedNo IN (SELECT IntegratedNo FROM tbTemp)	;
	DELETE FROM NoticesSyn WHERE IntegratedNo IN (SELECT IntegratedNo FROM tbTemp);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
