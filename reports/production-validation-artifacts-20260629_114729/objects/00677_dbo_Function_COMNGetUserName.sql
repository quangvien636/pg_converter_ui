-- ─── FUNCTION: comngetusername ───────────────────────────────
DROP FUNCTION IF EXISTS public.comngetusername();
CREATE OR REPLACE FUNCTION public.comngetusername(
) RETURNS character varying
AS $function$
DECLARE
    username character varying;
BEGIN

	-- Declare the return variable here

	-- Add the T-SQL statements to compute the return value here
	SELECT UserName = Name FROM Organization_Users WHERE UserNo = UserNo

	-- Return the result of the function
	RETURN UserName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
