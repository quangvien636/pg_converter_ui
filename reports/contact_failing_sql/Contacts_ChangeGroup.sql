-- ─── PROCEDURE→FUNCTION: contacts_changegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_changegroup(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_changegroup(
    IN groupno integer DEFAULT 689,
    IN userseqlist character varying DEFAULT '7996,7995'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE ContactsGroupUser SET GroupNo = contacts_changegroup.groupno WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))

END;
--UPDATE ContactsGroupUser SET GroupNo = 689 WHERE UserSeq IN (SELECT * FROM fnStringtoListInt('7996,7995'))

--SELECT * FROM ContactsGroupUser WHERE UserSeq IN  (SELECT * FROM fnStringtoListInt('7996,7995'))
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.