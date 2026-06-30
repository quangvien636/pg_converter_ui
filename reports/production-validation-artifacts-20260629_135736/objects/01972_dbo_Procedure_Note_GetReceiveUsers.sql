-- ─── PROCEDURE→FUNCTION: note_getreceiveusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getreceiveusers();
CREATE OR REPLACE FUNCTION public.note_getreceiveusers(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		STUFF
		(
	  (SELECT ',' || CASE WHEN UserNo <> 0 THEN public."COMNGetUserName"(UserNo)
			ELSE public."COMNGetDepartName"(DepartNo)
		END;
	  FROM NoteReceiveUser
	  WHERE NoteNo = NoteNo
	  FOR XML PATH('')
	  ),1,1,'') as ReceiveUsers;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
