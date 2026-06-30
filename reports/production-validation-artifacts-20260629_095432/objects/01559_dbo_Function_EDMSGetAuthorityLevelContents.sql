-- ─── FUNCTION: edmsgetauthoritylevelcontents ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetauthoritylevelcontents(integer);
CREATE OR REPLACE FUNCTION public.edmsgetauthoritylevelcontents(
    authoritylevel integer
) RETURNS character varying
AS $function$
DECLARE
    returnstring character varying;
BEGIN



		,	AultAuthorityLevelContent nvarchar(2000)
		,	RearAuthorityLevel	nvarchar(50)

	IF(AuthorityLevel IS NULL)
	BEGIN
			SET returnstring = '지정등급 없음'
	END
	ELSE
	BEGIN
		

		select  AultAuthorityLevel = valuedata from  EDMSConfiguration where keycode = 'AultAuthorityLevel'

		select  AultAuthorityLevelContent = contents FROM		EDMSSplitTable(AultAuthorityLevel,',') where id = edmsgetauthoritylevelcontents.authoritylevel

		select	returnstring = contents from EDMSSplitTable(AultAuthorityLevelContent,':') where id = 2
	END
		
	RETURN returnstring;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
