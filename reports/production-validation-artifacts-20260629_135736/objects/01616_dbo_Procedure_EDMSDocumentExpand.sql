-- ─── PROCEDURE→FUNCTION: edmsdocumentexpand ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.edmsdocumentexpand(character varying, integer);
CREATE OR REPLACE FUNCTION public.edmsdocumentexpand(
    IN docids character varying,
    IN expanddate integer
) RETURNS void
AS $function$
DECLARE
    docids character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test

		CREATE TEMP TABLE Deletelist AS SELECT DocIds				= '16;14;51;'--문서번호
		,				 ExpandDate			= 4
	
		drop table Deletelist
	--*/
	/***************************************************************************
	-- 필요변수 셋팅
	***************************************************************************/	
	select	Contents as Docid FROM	EDMSSplitTable(DocIds,';')	

	/***************************************************************************
	-- EDMSDOCUMENT delete
	***************************************************************************/
	
	update edmsdocument
	valdate := dateadd(month,ExpandDate,valdate);
	where	id in (select Docid from Deletelist);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
