-- ─── PROCEDURE→FUNCTION: contacts_getonerowchildgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getonerowchildgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getonerowchildgroup(
    IN groupno integer,
    IN reguserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
SELECT b.* FROM 
(select * FROM public."GetChildGroup"(RegUserNo,groupno) WHERE Level=2) a,
(select *from ContactsGroup where RegUserNo = contacts_getonerowchildgroup.reguserno) b where a.TreeID = b.GroupNo
order by b.Sort asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
