-- ─── FUNCTION: edmsdocumentexpand ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsdocumentexpand(character varying, integer);
CREATE OR REPLACE FUNCTION public.edmsdocumentexpand(
    docids character varying,
    expanddate integer
) RETURNS void
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    docids character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test

		SELECT 			 DocIds				= '16;14;51;'--문서번호
		,				 ExpandDate			= 4
	
		drop table #Deletelist
	--*/
	/***************************************************************************
	-- 필요변수 셋팅
	***************************************************************************/	
	select	Contents as Docid
	into	#Deletelist
	from	EDMSSplitTable(DocIds,';')	

	/***************************************************************************
	-- EDMSDOCUMENT delete
	***************************************************************************/
	
	update edmsdocument
	set		valdate = dateadd(month,ExpandDate,valdate)
	where	id in (select Docid from #Deletelist);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
