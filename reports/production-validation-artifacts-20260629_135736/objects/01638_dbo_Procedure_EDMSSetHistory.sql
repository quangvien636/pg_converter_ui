-- ─── PROCEDURE→FUNCTION: edmssethistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmssethistory();
CREATE OR REPLACE FUNCTION public.edmssethistory(
) RETURNS SETOF record
AS $function$
DECLARE
    htype integer;
-- !! WARNING: output needs manual review — see TODO comments
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
	
	HTYPE := (5);
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
	Hit := COALESCE(Hit,0) + 1;
	where	id = TargetID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
