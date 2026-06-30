-- ─── FUNCTION: edmscomentlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmscomentlist(integer);
CREATE OR REPLACE FUNCTION public.edmscomentlist(
    lan integer
) RETURNS TABLE(
    col1 text,
    col2 text,
    docid text,
    coment text,
    writer text,
    date text,
    orgcd text,
    writer text
)
AS $function$
DECLARE
    docid integer;
BEGIN
/*	
sp_columns edmscoment

,	Lan				int
select	DocId			=	43
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
