-- ─── FUNCTION: edmssethistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmssethistory();
CREATE OR REPLACE FUNCTION public.edmssethistory(
) RETURNS TABLE(
    id serial,
    htype integer,
    targetid integer,
    actorid character varying(50),
    actstate integer,
    actdate timestamp without time zone,
    comment character varying(200)
)
AS $function$
DECLARE
    htype integer;
BEGIN
/*
RETURN QUERY
select * from edmsdocument
RETURN QUERY
select * from edmshistory

	,	TARGETID   INT						--EDMS문서번호
	,	ACTORID    NVARCHAR(50)			--이력을 남긴사람 아이디
	,	ACTSTATE   INT						--상세 히스토리
	,	ACTDATE    DATETIME				--이력을 남긴 날자
	,	COMMENT    NVARCHAR(200)			--비고
	
	select	HTYPE  =	5
	,	TARGETID   =	6
	,	ACTORID    =	'admin'
	,	ACTSTATE   =	0
	,	ACTDATE    =	NOW()
	,	COMMENT    =	'admin 이 6번 문서를 열람 하였습니다.'
--*/


	INSERT INTO EDMSHistory
	(
	             HTYPE
	,            TARGETID
	,            ACTORID
	,            ACTSTATE
	,            ACTDATE
	,            COMMENT
	)
	RETURN QUERY
	SELECT 
	             HTYPE
	,            TARGETID
	,            ACTORID
	,            ACTSTATE
	,            NOW()
	,            COMMENT
		

	update	edmsdocument
	set		Hit = COALESCE(Hit,0) + 1
	where	id = TargetID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
