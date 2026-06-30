-- ─── PROCEDURE→FUNCTION: edmscomentinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmscomentinsert();
CREATE OR REPLACE FUNCTION public.edmscomentinsert(
) RETURNS void
AS $function$
DECLARE
    docid integer;
BEGIN
/*	

,		Coment		nvarchar(4000)			--문서내용
,		Writer		nvarchar(50)			--Writer
,	OrgCd		varchar(4)				--부서코드
DocId := (,		Coment		=	'');
,		Writer		=	''
,	OrgCd		varchar(4)				--부서코드
--*/;
	INSERT INTO EDMSComent(DocId,Coment,Writer,WriteDate,isDelete,OrgCd)
	select	DocId		
	,		Coment
	,		Writer
	,		NOW()
	,		''
	,		OrgCd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
