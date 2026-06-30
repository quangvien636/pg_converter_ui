-- ─── FUNCTION: organizationcrewchat_roomno_userlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.organizationcrewchat_roomno_userlist(bigint);
CREATE OR REPLACE FUNCTION public.organizationcrewchat_roomno_userlist(
    roomno bigint
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN

	
		RETURN QUERY
		SELECT UserNo,Enabled,UserPhoto,Photo
		FROM Organization_Users
		WHERE UserNo in (select UserNo from CrewChat_RoomUsers where RoomNo = organizationcrewchat_roomno_userlist.roomno
		and Closed != 1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
