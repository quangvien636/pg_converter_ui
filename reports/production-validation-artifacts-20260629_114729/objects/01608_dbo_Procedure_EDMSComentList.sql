-- ─── PROCEDURE→FUNCTION: edmscomentlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmscomentlist(integer);
CREATE OR REPLACE FUNCTION public.edmscomentlist(
    IN lan integer
) RETURNS SETOF record
AS $function$
DECLARE
    docid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*	
sp_columns edmscoment

,	Lan				int
DocId := (43);
,	Lan				=   2

--*/

	RETURN QUERY
	select	ID
	,		DocId
	,		Coment
	,		Writer	
	,		convert(varchar(10),WriteDate,120) as Date
	,		orgcd
	,		Writer
	from	EDMSComent 			
	where	Docid = DocId
	and		isdelete = ''
	order by WriteDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
