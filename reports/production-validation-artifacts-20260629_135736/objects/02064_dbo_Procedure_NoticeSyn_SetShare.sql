-- ─── PROCEDURE→FUNCTION: noticesyn_setshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_setshare(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setshare(
    IN noticeno integer,
    IN departno integer,
    IN ischild character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	IF Mode = 0 THEN

		DepartName := public."COMNGetDepartName"(DepartNo);;
		INSERT INTO NoticeSyn_Sharers(NoticeNo,DepartNo,DepartName,IsChild)
		VALUES(NoticeNo,DepartNo,DepartName,IsChild)
	END IF;
	ELSE;
		DELETE FROM NoticeSyn_Sharers WHERE NoticeNo = noticesyn_setshare.noticeno
	END IF;
	
	RETURN QUERY
	SELECT @ERROR
	END;
-------------------------////////////////////////----------------------
--- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
