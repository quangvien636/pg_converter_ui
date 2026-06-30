-- ─── FUNCTION: edmsreturndoc ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsreturndoc(character varying);
CREATE OR REPLACE FUNCTION public.edmsreturndoc(
    userid character varying
) RETURNS TABLE(
    col1 text,
    col2 text
)
AS $function$
DECLARE
    docid integer;
BEGIN
/*

,	USERID		nvarchar(50)
SELECT	DOCID		=	45
,		USERID		=	'ADMIN'
--*/
		
		--최신버전으로 셋팅하기위한 액숀.		;
		UPDATE	EDMSDOCUMENT
		SET		VERSIONSTATE = ''
		WHERE	WGROUP =(
							SELECT WGROUP  FROM EDMSDOCUMENT WHERE	ID = DOCID
						)

		--복원;
		UPDATE	EDMSDOCUMENT
		SET		ISDELETE = '' 
		,		MODDATE = NOW()
		,		Modifier = edmsreturndoc.userid
		,		VersionState = 'Y'
		WHERE	ID = DOCID	

		RETURN QUERY
		SELECT DOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
