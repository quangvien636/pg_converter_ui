-- ─── FUNCTION: eappfculture ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappfculture(character varying);
CREATE OR REPLACE FUNCTION public.eappfculture(
    keycode character varying
) RETURNS character varying
AS $function$
DECLARE
    culture character varying;
BEGIN




		Culture=CASE Lang 
			WHEN 'ko' THEN Korean
			WHEN 'en' THEN English 
			WHEN 'zh-cn' THEN China 
			WHEN 'ja' THEN Japan 
			ELSE Korean
		END
	FROM 
		EAPPCulture
	WHERE
		KeyCode=eappfculture.keycode

	RETURN	(Culture);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
