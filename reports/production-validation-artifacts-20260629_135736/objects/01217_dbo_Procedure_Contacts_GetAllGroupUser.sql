-- ─── PROCEDURE→FUNCTION: contacts_getallgroupuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getallgroupuser(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallgroupuser(
    IN reguserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE RegUserNo=contacts_getallgroupuser.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
