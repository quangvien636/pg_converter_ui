-- ─── FUNCTION: eappgetdocboxpath ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetdocboxpath(integer, character varying);
CREATE OR REPLACE FUNCTION public.eappgetdocboxpath(
    id integer,
    lang character varying DEFAULT NULL
) RETURNS character varying
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    parentid integer;
    pathall character varying;
    div character varying;
    tmp integer;
    idiv integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF LANG = '' OR LANG IS NULL	SET LANG = '1'
		




	FROM EAPPDOCUMENT 
	WHERE ID = eappgetdocboxpath.id	

	WHILE ( PARENTID <> 0	)
	BEGIN			

		SET TMP = 0

		SELECT 
			TMP = PARENTID
		,	PATH = CASE LANG
					WHEN '1' THEN COALESCE(ITEMNM1, '')
					WHEN '2' THEN COALESCE(ITEMNM2, '')
					WHEN '3' THEN COALESCE(ITEMNM3, '')
					WHEN '4' THEN COALESCE(ITEMNM4, '')
					ELSE ITEMNM1 END
		FROM EAPPTREEITEM
		WHERE ID = PARENTID

		SET PARENTID = TMP
		SET PATHALL = PATH || DIV || PATHALL  
	END		


	--마지막 DIV 제거

	SET IDIV = STRPOS(DIV, PATHALL)

	IF IDIV > 0 
		SELECT PATHALL = SUBSTRING(PATHALL, 1, LEN(PATHALL)-1)
 

	RETURN	(PATHALL);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
