-- ─── FUNCTION: edmsgetparent ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetparent();
CREATE OR REPLACE FUNCTION public.edmsgetparent(
) RETURNS TABLE(
    parentcd character varying
)
AS $function$
#variable_conflict use_column
DECLARE
    parentid character varying;
BEGIN
 
/*
	RETURN QUERY
	select * from EDMSTreeItem where divid = '1' 
	
--*/	
	--필요변수 셋--	


	WHILE	PARENTID <> '0' or substring(PARENTID, 1,1) <> 'G'
	BEGIN
		SELECT PARENTID = Convert(VARCHAR(50),ParentID) FROM EDMSTREEITEM WHERE DIVID = DIVCODE AND	ID = PARENTID	and (( DIVCODE = '4' AND 	UserId	=	UserId) OR DIVCODE IN ('1','2') )

		INSERT INTO Parenttable
		RETURN QUERY
		SELECT PARENTID

		if PARENTID = '0' or PARENTID = '-1'
			break;
	END

	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
