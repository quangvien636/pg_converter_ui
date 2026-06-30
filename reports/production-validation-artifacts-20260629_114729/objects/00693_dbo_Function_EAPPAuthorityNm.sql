-- ─── FUNCTION: eappauthoritynm ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappauthoritynm(integer);
CREATE OR REPLACE FUNCTION public.eappauthoritynm(
    authoritylevel integer
) RETURNS character varying
AS $function$
DECLARE
    authoritylang character varying;
BEGIN



	 BEGIN
	
		SELECT AuthorityLang = 'Not Found'
	
	 END
	ELSE
	 BEGIN

		SELECT 			
			AuthorityLang = CASE Lang 
				WHEN '1' THEN Kor 
				WHEN '2' THEN Eng
				WHEN '3' THEN Chi
				WHEN '4' THEN Jap
				ELSE Kor
			END 
		FROM
			EappAuthorityLang
		WHERE
			AuthorityLevel = eappauthoritynm.authoritylevel


	 END

	RETURN	(AuthorityLang);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
