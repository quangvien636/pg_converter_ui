-- ─── FUNCTION: eddocumentdelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.eddocumentdelete();
CREATE OR REPLACE FUNCTION public.eddocumentdelete(
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    docid integer;
    versiongroup integer;
BEGIN
	/*	test

,	USERID			NVARCHAR(50)		--작성자
RETURN QUERY
select	
	DocID			= 44
,	USERID			= 'Duck'
	--*/

	--문서 상태 변경.;
	UPDATE	EDMSDOCUMENT
	SET		ISDELETE	= 'Y'
	,		Modifier	= USERID
	,		ModDate		= NOW()
	WHERE	ID	=	DOCID

	--버젼그룹 중에 삭제 내역이후로 가장 최근데이터를 최상위버젼으로 등록한다.
	IF EXISTS(SELECT * FROM EDMSDOCUMENT WHERE ID = DOCID AND	VERSIONSTATE = 'Y')
	BEGIN
		--변경될 문서그룹번호 , 번호

 
		SELECT	VERSIONGROUP = WGROUP 
		FROM	EDMSDOCUMENT
		WHERE	ID = DOCID

		SELECT 	VERSIONID = ID
		FROM	EDMSDOCUMENT
		WHERE	WGROUP  = VERSIONGROUP
		AND		ISDELETE = ''
		AND		VERSIONSTATE = ''
		AND		DOCSTATE = 0
		ORDER BY REGDATE
	
		UPDATE	EDMSDOCUMENT
		SET		VERSIONSTATE = 'Y'
		WHERE	ID	= VERSIONID	
	END


RETURN QUERY
select 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
