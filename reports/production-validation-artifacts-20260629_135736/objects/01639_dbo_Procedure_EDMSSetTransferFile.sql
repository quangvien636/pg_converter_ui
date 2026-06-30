-- ─── PROCEDURE→FUNCTION: edmssettransferfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmssettransferfile(integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmssettransferfile(
    IN docid integer,
    IN attachpath character varying,
    IN attachname character varying,
    IN attachflag character varying,
    IN ispdf character varying
) RETURNS void
AS $function$
DECLARE
    docid integer;
BEGIN
/*

	,		ATTACHNAME			varchar(255)
	,		ATTACHFLAG			varchar(255)
	,		IsPDF				char(1)
	DOCID := ('67');
	,		ATTACHPATH  		=	'/_WorkCrewUpload/_EDMS/0408004/'
	,		ATTACHNAME			=	'EDMS0000000067'
	,		ATTACHFLAG			=	'.htm'
	,		IsPDF				=	'F'
--*/	

 	INSERT INTO EDMSFILE (DOCID,ATTACHPATH,ATTACHNAME,ATTACHFlag,IsPDF)
	SELECT	DOCID		
	,		ATTACHPATH 
	,		ATTACHNAME	
	,		ATTACHFLAG	
	,		IsPDF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
