-- ─── FUNCTION: approval_insertusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_insertusersetting(integer);
CREATE OR REPLACE FUNCTION public.approval_insertusersetting(
    userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO ApprovalUserSettings
	VALUES(UserNo, SignImage);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
