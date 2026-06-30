-- ─── FUNCTION: personal_savepassword ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_savepassword();
CREATE OR REPLACE FUNCTION public.personal_savepassword(
) RETURNS void
AS $function$
BEGIN

	
	UPDATE Organization_Users
	SET
		Password = Password,
		PasswordChangeDate = NOW(),
		ModDate = NOW(),
		ModUserNo = UserNo
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
