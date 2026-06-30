-- ─── FUNCTION: eappgetalarmmessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetalarmmessage(character varying);
CREATE OR REPLACE FUNCTION public.eappgetalarmmessage(
    code character varying
) RETURNS character varying
AS $function$
DECLARE
    msg character varying;
BEGIN




	
	SELECT Msg = CASE Lang 
				WHEN '1' THEN Message_Ko 
				WHEN '2' THEN Message_Ja				
				WHEN '3' THEN Message_En 				
				WHEN '4' THEN Message_Zh_Ch
				ELSE Message_Ko
			END 
	FROM MESGAlarmMessage
	WHERE Code =eappgetalarmmessage.code

	

	RETURN	(Msg);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
