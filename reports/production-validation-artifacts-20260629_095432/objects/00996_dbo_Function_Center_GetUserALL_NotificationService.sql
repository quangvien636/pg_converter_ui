-- ─── FUNCTION: center_getuserall_notificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getuserall_notificationservice();
CREATE OR REPLACE FUNCTION public.center_getuserall_notificationservice(
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
	select A.UserNo,A.UserID,A.Name,A.Password,A.MailAddress from Organization_Users A
	join Organization_BelongToDepartment B
	on A.UserNo = B.UserNo 
	where A.Enabled = TRUE and UserID != 'crewnotifer' and B.IsDefault = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
