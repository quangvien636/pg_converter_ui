-- ─── FUNCTION: eappgetformnm ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetformnm(integer);
CREATE OR REPLACE FUNCTION public.eappgetformnm(
    formid integer
) RETURNS character varying
AS $function$
DECLARE
    formnm character varying;
BEGIN



	--begin
	--	SELECT 			
	--		FormNm = CASE Lang 
	--			WHEN '1' THEN Title1 
	--			WHEN '2' THEN CASE Title2 WHEN '' THEN Title1 ELSE Title2 END
	--			WHEN '3' THEN CASE Title3 WHEN '' THEN Title1 ELSE Title3 END
	--			WHEN '4' THEN CASE Title4 WHEN '' THEN Title1 ELSE Title4 END
	--			ELSE Title1
	--		END 
	--	FROM
	--		WBLDCONFIGS
	--	WHERE
	--		BOARDID = ( SELECT BOARDID 
	--					FROM EAPPFORM 
	--					WHERE ID = FormId and formtype='WBLD')
	--end
	--else
	--begin
		select FormNm = case when IsErp='1' and Description<>'' then Description else Name end from EAPPForm where ID=eappgetformnm.formid
	--end

	RETURN	(FormNm);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
