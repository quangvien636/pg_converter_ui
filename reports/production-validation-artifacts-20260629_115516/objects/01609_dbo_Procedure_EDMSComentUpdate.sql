-- ─── PROCEDURE→FUNCTION: edmscomentupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmscomentupdate();
CREATE OR REPLACE FUNCTION public.edmscomentupdate(
) RETURNS void
AS $function$
DECLARE
    id integer;
BEGIN
/*	
sp_columns edmscoment

,		Coment		nvarchar(4000)			--문서내용
,		Modifier	nvarchar(50)			--Writer
,	OrgCd		varchar(4)				--부서코드
Id := (,		Coment		=	'');
,		Modifier	=	''
,	OrgCd		varchar(4)				--부서코드
--*/

	update	EDMSComent
	Coment := Coment;
	,		Modifier	=	Modifier
	,		ModiDate	=	NOW()
	,		OrgCd		=	OrgCd
	where	id		= id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
