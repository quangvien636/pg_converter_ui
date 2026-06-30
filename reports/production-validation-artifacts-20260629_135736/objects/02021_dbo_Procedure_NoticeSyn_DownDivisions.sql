-- ─── PROCEDURE→FUNCTION: noticesyn_downdivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_downdivisions(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_downdivisions(
    IN divisionno integer
) RETURNS void
AS $function$
DECLARE
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN



RANKTEMPNO := 1;
FOR _rec IN SELECT  DivisionNo from NoticeSyn_Divisions WHERE  Status=1 ORDER BY Sort ASC,DivisionNo ASC
LOOP
    tempno
WHILE := _rec.divisionno LOOP

		UPDATE NoticeSyn_Divisions SET Sort = RANKTEMPNO WHERE TEMPNO=noticesyn_downdivisions.divisionno
		
		IF TEMPNO=noticesyn_downdivisions.divisionno THEN
			SORTNO := RANKTEMPNO;
		END IF;
		RANKTEMPNO := RANKTEMPNO+1;
		   END LOOP;;
UPDATE NoticeSyn_Divisions SET Sort = SORTNO WHERE Status=1 And SORTNO = Sort - 1;
UPDATE NoticeSyn_Divisions SET Sort = SORTNO + 1 WHERE DivisionNo = noticesyn_downdivisions.divisionno;

--------------------------------------///////////////////////////////////////--------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
