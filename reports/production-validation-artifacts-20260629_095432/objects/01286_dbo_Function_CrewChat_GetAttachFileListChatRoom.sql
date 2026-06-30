-- ─── FUNCTION: crewchat_getattachfilelistchatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getattachfilelistchatroom(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfilelistchatroom(
    roomno bigint
) RETURNS TABLE(
    messageno text,
    roomno text,
    userno text,
    attachno text,
    filename text,
    fullpath text,
    regdate text,
    size text,
    type text,
    thumbwidth text,
    thumbheight text
)
AS $function$
BEGIN

	RETURN QUERY
	select M.MessageNo, M.RoomNo, M.UserNo, A.AttachNo, A.FileName, 
	A.FullPath, A.RegDate, A.Size, A.Type, A.ThumbWidth, A.ThumbHeight
	from CrewChat_Messages M
	LEFT JOIN CrewChat_Attach A ON A.AttachNo = M.AttachNo
	where M.AttachNo > 0 AND A.AttachNo IS NOT NULL
	AND M.RoomNo = crewchat_getattachfilelistchatroom.roomno
	order by M.RegDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
