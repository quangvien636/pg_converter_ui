-- ─── FUNCTION: center_getuserno_notificationservice_row ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getuserno_notificationservice_row();
CREATE OR REPLACE FUNCTION public.center_getuserno_notificationservice_row(
) RETURNS TABLE(
    userno text,
    userid text,
    name text,
    password text,
    mailaddress text
)
AS $function$
BEGIN


	RETURN QUERY
	select UserNo,UserID,Name,Password,MailAddress from Organization_Users
	where UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
