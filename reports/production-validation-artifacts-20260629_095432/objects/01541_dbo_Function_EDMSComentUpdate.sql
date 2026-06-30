-- ─── FUNCTION: edmscomentupdate ───────────────────────────────
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
select	Id			=	
,		Coment		=	''
,		Modifier	=	''
,	OrgCd		varchar(4)				--부서코드
--*/

	update	EDMSComent
	set		Coment		=	Coment
	,		Modifier	=	Modifier
	,		ModiDate	=	NOW()
	,		OrgCd		=	OrgCd
	where	id		= id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
