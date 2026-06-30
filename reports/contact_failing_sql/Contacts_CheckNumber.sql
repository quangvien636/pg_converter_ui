-- ─── PROCEDURE→FUNCTION: contacts_checknumber ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_checknumber(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_checknumber(
    IN reguserno integer,
    IN value character varying,
    IN type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
IF Type = 0 THEN
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsNumber N
	INNER JOIN ContactsUser U ON U.Seq = N.UserSeq AND U.UseYn='Y'
	WHERE N.RegUserNo = contacts_checknumber.reguserno
	AND REPLACE(N.Value,'-','') = REPLACE(Value,'-','');
ELSE
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsEmail E
	INNER JOIN ContactsUser U ON U.Seq = E.UserSeq AND U.UseYn='Y'
	WHERE E.RegUserNo = contacts_checknumber.reguserno AND E.Value = contacts_checknumber.value;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.