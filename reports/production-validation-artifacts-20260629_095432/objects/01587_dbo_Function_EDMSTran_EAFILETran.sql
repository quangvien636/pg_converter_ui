-- ─── FUNCTION: edmstran_eafiletran ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstran_eafiletran(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.edmstran_eafiletran(
    ispdf character varying DEFAULT 'N'	-- pdf파일여부 : 'Y' PDF파일 'N' 일반파일.,
    contentid integer DEFAULT NULL,
    length integer DEFAULT NULL
) RETURNS void
AS $function$
DECLARE
    chk integer;
BEGIN

ATTACHPATH=ATTACHPATH and 
ATTACHNAME=ATTACHNAME and 
ATTACHFlag=ATTACHFlag

if chk = 0
begin;
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
