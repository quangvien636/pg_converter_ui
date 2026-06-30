-- ─── FUNCTION: noticesyn_deletenotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_deletenotices();
CREATE OR REPLACE FUNCTION public.noticesyn_deletenotices(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbnoticenos table (
		noticeno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(NoticeNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(NoticeNos, LEN(NoticeNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(NoticeNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbNoticeNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	DELETE FROM NoticesSyn WHERE NoticeNo IN (SELECT NoticeNo FROM tbNoticeNos)	

END;
---------------------------------///////////////////////////-------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
