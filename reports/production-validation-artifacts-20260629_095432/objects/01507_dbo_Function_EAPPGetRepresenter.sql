-- ─── FUNCTION: eappgetrepresenter ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetrepresenter();
CREATE OR REPLACE FUNCTION public.eappgetrepresenter(
) RETURNS character varying
AS $function$
DECLARE
    representerid character varying;
BEGIN




	
	SELECT RepresenterID=EAPPUserEnv.RepresenterID 
	FROM EAPPUserEnv 
	WHERE UserID=UserID
	--내가 부재상태일때 조건 추가(20080709 김민지)
	AND Absence = '1'        
	AND AbsenceProg = '1'
	
	RETURN	(RepresenterID);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
