-- ─── PROCEDURE→FUNCTION: contacts_getuser_groupinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser_groupinfo(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_groupinfo(
    IN reguserno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT G.* FROM ContactsGroupUser U
	INNER JOIN ContactsGroup G ON G.GroupNo = U.GroupNo
	WHERE U.UserSeq=contacts_getuser_groupinfo.userno AND U.RegUserNo = contacts_getuser_groupinfo.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
