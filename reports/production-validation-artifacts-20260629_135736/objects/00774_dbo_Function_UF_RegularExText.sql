-- ─── FUNCTION: uf_regularextext ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_regularextext();
CREATE OR REPLACE FUNCTION public.uf_regularextext(
) RETURNS character varying
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    rtn character varying;
    temp character varying;
    serchvalue character varying;
    i integer;
    n integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN






	SET Rtn = ''
	SET i = 1
	SET n = LEN(Value)
	
	WHILE i <= n
	BEGIN
		SET Temp = Substring(Value, i, 1)
		
		SET SerchValue = (CASE Temp 
							WHEN 'ㄱ' THEN '[가-깋]'
							WHEN 'ㄲ' THEN '[까-낗]'
							WHEN 'ㄴ' THEN '[나-닣]'
							WHEN 'ㄷ' THEN '[다-딯]'
							WHEN 'ㄸ' THEN '[따-띻]'
							WHEN 'ㄹ' THEN '[라-맇]'
							WHEN 'ㅁ' THEN '[마-밓]'
							WHEN 'ㅂ' THEN '[바-빟]'
							WHEN 'ㅃ' THEN '[빠-삫]'
							WHEN 'ㅅ' THEN '[사-싷]'
							WHEN 'ㅆ' THEN '[싸-앃]'
							WHEN 'ㅇ' THEN '[아-잏]'
							WHEN 'ㅈ' THEN '[자-짛]'
							WHEN 'ㅉ' THEN '[짜-찧]'
							WHEN 'ㅊ' THEN '[차-칳]'
							WHEN 'ㅋ' THEN '[카-킿]'
							WHEN 'ㅌ' THEN '[타-팋]'
							WHEN 'ㅍ' THEN '[파-핗]'
							WHEN 'ㅎ' THEN '[하-힣]'
							ELSE Temp END)
							
		SET Rtn = RTRIM(Rtn) || SerchValue
		
		SET i = i || 1
	END
	
	Return Rtn;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
