-- ─── PROCEDURE→FUNCTION: edmstreeauthoritycheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmstreeauthoritycheck(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmstreeauthoritycheck(
    IN departcode character varying,
    IN treeid character varying,
    IN authority character varying,
    IN divid character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departcode character varying;
    viewflag character varying;
    viewcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

,	Authority	char(1)
DepartCode := ('0900');
,	TreeId		=	1
,	Authority	= ''	-- 'Y' : 권한이 있는사람 : '' 권한이 없는사람.		
--*/

	/**********************************************************************************************************
	--기본변수 셋팅
	************************************************************************************************************/


	SELECT (SELECT COUNT(1) INTO viewcount FROM	EDMSTreeAuthority WHERE folderID = edmstreeauthoritycheck.treeid and DivID=edmstreeauthoritycheck.divid)
	-----------------------------------------------------------------------------------------------------------	
	
	
	IF VIEWCOUNT = 0 or Authority = 'Y' THEN
		VIEWFLAG := ('Y');
	END IF;
	ELSE
		IF	EXISTS(SELECT 1 FROM	EDMSTreeAuthority WHERE folderID = edmstreeauthoritycheck.treeid and DivID=edmstreeauthoritycheck.divid AND departid = edmstreeauthoritycheck.departcode)
			BEGIN
				VIEWFLAG := ('Y');
			END;
			ELSE
				VIEWFLAG := ('');
			END IF;
	END IF;

	RETURN QUERY
	SELECT VIEWFLAG;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
