-- ─── FUNCTION: eappgetusernm ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetusernm(character varying);
CREATE OR REPLACE FUNCTION public.eappgetusernm(
    userid character varying
) RETURNS character varying
AS $function$
DECLARE
    usernm character varying;
BEGIN



	SELECT 			
		UserNm = CASE Lang 
				WHEN '1' THEN CASE UserNm1 WHEN '' THEN UserNm1 ELSE UserNm1 END 
				WHEN '2' THEN CASE UserNm2 WHEN '' THEN UserNm1 ELSE UserNm2 END 
				WHEN '3' THEN CASE UserNm3 WHEN '' THEN UserNm1 ELSE UserNm3 END 
				WHEN '4' THEN CASE UserNm4 WHEN '' THEN UserNm1 ELSE UserNm4 END 
				ELSE UserNm1 END
	FROM
		CMONUsers
	WHERE
		UserID = eappgetusernm.userid	

	
	
	
	if(UserNm is null)
	begin
		SELECT 			
			UserNm = CASE Lang 
				WHEN '1' THEN OrgNm1 
				WHEN '2'  THEN OrgNm2 
				WHEN '3' THEN OrgNm3 
				WHEN '4' THEN OrgNm4 
				ELSE OrgNm1
			END 
		FROM
			CMONOrgan
		WHERE
			OrgCd = replace(replace(replace(replace(UserID,'#DS#',''),'#DL#',''),'#DR#',''),'#DA#','')
	end

	if(UserNm is null and STRPOS(UserID, '#GR#') > 0)
	begin
		select 
				UserNm = CASE Lang 
				WHEN '1' THEN UserGrpNm1 
				WHEN '2'  THEN UserGrpNm2 
				WHEN '3' THEN UserGrpNm3
				WHEN '4' THEN UserGrpNm4 
				ELSE UserGrpNm1
			END 
		from CMONUserGroup where UserGrpCd=replace(UserID, '#GR#', '')
	end
	
	RETURN	(UserNm);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
