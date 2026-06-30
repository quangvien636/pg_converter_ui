-- ─── FUNCTION: edmsstatediscard ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsstatediscard(character varying);
CREATE OR REPLACE FUNCTION public.edmsstatediscard(
    userid character varying
) RETURNS TABLE(
    col1 text,
    col2 text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    docid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

,	USERID		nvarchar(50)
SELECT	DOCID		=	45
,		USERID		=	'ADMIN'
--*/
		--폐기상태로;
		UPDATE	EDMSDOCUMENT
		SET		ISDELETE	= '' 
		,		MODDATE		= NOW()
		,		Modifier	= edmsstatediscard.userid
		,		valdate		= dateadd(day,-1,NOW())		
		WHERE	ID = DOCID	

		RETURN QUERY
		SELECT DOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
