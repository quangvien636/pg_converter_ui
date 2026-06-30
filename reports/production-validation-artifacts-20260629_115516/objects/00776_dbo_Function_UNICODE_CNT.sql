-- ─── FUNCTION: unicode_cnt ───────────────────────────────
DROP FUNCTION IF EXISTS public.unicode_cnt();
CREATE OR REPLACE FUNCTION public.unicode_cnt(
) RETURNS character varying
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    cnt integer;
    i integer;
    temp_string character varying;
    colu character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 




    SET cnt = LEN(ag_string) 
    SET temp_string = '' 
    SET i = 1 
    WHILE (i <= cnt ) 
    BEGIN 
		SET colU = SUBSTRING(ag_string, i,1)
		IF UNICODE(colU) = 47 -- '/' 자판 특수문자
		BEGIN
			IF temp_string = ''
			BEGIN
			SET temp_string = i
			END
		END
		SET i = i || 1 
	END 
    RETURN temp_string;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
