-- ─── FUNCTION: edmstreeauthoritycheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreeauthoritycheck(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmstreeauthoritycheck(
    departcode character varying,
    treeid character varying,
    authority character varying,
    divid character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    departcode character varying;
    viewflag character varying;
    viewcount integer;
BEGIN
/*

,	Authority	char(1)
RETURN QUERY
SELECT	
	DepartCode =	'0900'
,	TreeId		=	1
,	Authority	= ''	-- 'Y' : 권한이 있는사람 : '' 권한이 없는사람.		
--*/

	/**********************************************************************************************************
	--기본변수 셋팅
	************************************************************************************************************/


	SELECT VIEWCOUNT = (SELECT COUNT(1) FROM	EDMSTreeAuthority WHERE folderID = edmstreeauthoritycheck.treeid and DivID=edmstreeauthoritycheck.divid)
	-----------------------------------------------------------------------------------------------------------	
	
	
	IF VIEWCOUNT = 0 or Authority = 'Y' 
	BEGIN
		SELECT 	VIEWFLAG = 'Y'
	END
	ELSE
	BEGIN
		IF	EXISTS(SELECT 1 FROM	EDMSTreeAuthority WHERE folderID = edmstreeauthoritycheck.treeid and DivID=edmstreeauthoritycheck.divid AND departid = edmstreeauthoritycheck.departcode)
			BEGIN
				SELECT 	VIEWFLAG = 'Y'
			END
			ELSE
			BEGIN
				SELECT 	VIEWFLAG = ''
			END			
	END

	RETURN QUERY
	SELECT VIEWFLAG;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
