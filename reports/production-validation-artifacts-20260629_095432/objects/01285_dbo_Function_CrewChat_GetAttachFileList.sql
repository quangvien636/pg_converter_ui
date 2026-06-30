-- ─── FUNCTION: crewchat_getattachfilelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getattachfilelist(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfilelist(
    userno integer
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
DECLARE
    tbtemp table
	(
		roomno bigint,
		startmessageno bigint
	);
BEGIN


	insert into tbTemp
	RETURN QUERY
	select R.RoomNo, R.StartMessageNo
	from 
	CrewChat_RoomUsers R
	inner join CrewChat_Rooms M ON M.RoomNo=R.RoomNo AND M.LastedMsg is not null
	where R.UserNo=crewchat_getattachfilelist.userno AND R.Closed = 0 AND R.StartMessageNo <= M.LastedMsgNo
		
	RETURN QUERY
	select M.MessageNo, M.RoomNo, M.UserNo, A.AttachNo, A.FileName, 
	A.FullPath, A.RegDate, A.Size, A.Type, A.ThumbWidth, A.ThumbHeight
	from CrewChat_Messages M
	INNER JOIN tbTemp R ON R.RoomNo = M.RoomNo
	LEFT JOIN CrewChat_Attach A ON A.AttachNo = M.AttachNo
	where M.AttachNo > 0 AND M.MessageNo > R.StartMessageNo AND A.AttachNo IS NOT NULL
	order by M.RegDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
