-- ─── PROCEDURE→FUNCTION: edmstran_eafiletran ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmstran_eafiletran(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.edmstran_eafiletran(
    IN ispdf character varying DEFAULT 'N'	-- pdf파일여부 : 'Y' PDF파일 'N' 일반파일.,
    IN contentid integer DEFAULT NULL,
    IN length integer DEFAULT NULL
) RETURNS void
AS $function$
DECLARE
    chk integer;
BEGIN

ATTACHPATH=ATTACHPATH and 
ATTACHNAME=ATTACHNAME and 
ATTACHFlag=ATTACHFlag

IF chk = 0 THEN;
INSERT INTO EDMSFILE
	SELECT	DOCID		
		,	ATTACHPATH	
		,	ATTACHNAME	
		,	ATTACHFlag	
		,	IsPDF	
		,	ContentID
		,	Length;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
