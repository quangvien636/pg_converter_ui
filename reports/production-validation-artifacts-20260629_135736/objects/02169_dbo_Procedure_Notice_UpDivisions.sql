-- ─── PROCEDURE→FUNCTION: notice_updivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updivisions(integer);
CREATE OR REPLACE FUNCTION public.notice_updivisions(
    IN divisionno integer
) RETURNS void
AS $function$
DECLARE
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN



RANKTEMPNO := 1;
FOR _rec IN SELECT  DivisionNo from NoticeDivisions WHERE  Status=1 ORDER BY Sort ASC,DivisionNo ASC
LOOP
    tempno
WHILE := _rec.divisionno LOOP

		UPDATE NoticeDivisions SET Sort = RANKTEMPNO WHERE TEMPNO=notice_updivisions.divisionno
		
		IF TEMPNO=notice_updivisions.divisionno THEN
			SORTNO := RANKTEMPNO;
		END IF;
		RANKTEMPNO := RANKTEMPNO+1;
		   END LOOP;;
UPDATE NoticeDivisions SET Sort = SORTNO WHERE Status=1 And SORTNO = Sort + 1;
UPDATE NoticeDivisions SET Sort = SORTNO - 1 WHERE DivisionNo = notice_updivisions.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
