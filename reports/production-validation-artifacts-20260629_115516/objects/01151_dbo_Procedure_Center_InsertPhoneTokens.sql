-- ─── PROCEDURE→FUNCTION: center_insertphonetokens ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertphonetokens(character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertphonetokens(
    IN phonetoken character varying,
    IN sessionid character varying
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_PhoneTokens WHERE PhoneToken = center_insertphonetokens.phonetoken) = 0 THEN
	
		INSERT INTO Center_PhoneTokens (PhoneToken, SessionID, Domain)
		VALUES (PhoneToken, SessionID, Domain)
		
	END IF;
	
	ELSE BEGIN
	
		UPDATE Center_PhoneTokens
		SessionID := center_insertphonetokens.sessionid, Domain = Domain, ModDate = NOW();
		WHERE PhoneToken = center_insertphonetokens.phonetoken
			
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
