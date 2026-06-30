-- ─── FUNCTION: center_insertphonetokens ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertphonetokens(character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertphonetokens(
    phonetoken character varying,
    sessionid character varying
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_PhoneTokens WHERE PhoneToken = center_insertphonetokens.phonetoken) = 0 BEGIN
	
		INSERT INTO Center_PhoneTokens (PhoneToken, SessionID, Domain)
		VALUES (PhoneToken, SessionID, Domain)
		
	END
	
	ELSE BEGIN
	
		UPDATE Center_PhoneTokens
		SET SessionID = center_insertphonetokens.sessionid, Domain = Domain, ModDate = NOW()
		WHERE PhoneToken = center_insertphonetokens.phonetoken
			
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
