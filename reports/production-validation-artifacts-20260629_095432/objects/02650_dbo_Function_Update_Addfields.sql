-- ─── FUNCTION: update_addfields ───────────────────────────────
DROP FUNCTION IF EXISTS public.update_addfields(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.update_addfields(
    userno integer,
    userid character varying,
    value character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    puserid character varying;
BEGIN


		RETURN QUERY
		SELECT
		pUserId = update_addfields.userid
	FROM Organization_Users_Addfields WHERE UserNo = update_addfields.userno

	IF pUserId is null
	BEGIN;
		INSERT INTO Organization_Users_Addfields VALUES(UserNo,UserId,Key,Value)
	END
	ELSE
	BEGIN;
		UPDATe Organization_Users_Addfields
		SET Value = update_addfields.value
		WHERE UserNo = update_addfields.userno
		and key = Key
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
