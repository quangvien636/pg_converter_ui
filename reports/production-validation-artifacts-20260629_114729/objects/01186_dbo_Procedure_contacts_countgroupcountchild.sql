-- ─── PROCEDURE→FUNCTION: contacts_countgroupcountchild ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_countgroupcountchild(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_countgroupcountchild(
    IN reguserno integer,
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 RETURN QUERY
 select count(*) from ContactsGroup 
    where ContactsGroup.RegUserNo=contacts_countgroupcountchild.reguserno and ContactsGroup.ParentGNo=contacts_countgroupcountchild.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
