-- ─── FUNCTION: crewchat_getattachfilelist_toattachno ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getattachfilelist_toattachno(integer, integer, character varying, bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfilelist_toattachno(
    userno integer,
    attachno integer,
    searchtext character varying,
    roomno bigint,
    type integer
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
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    tbtemp table
	(
		roomno bigint,
		startmessageno bigint
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF AttachNo = 0
	BEGIN
		SET AttachNo = (SELECT MAX(AttachNo)+1 FROM CrewChat_Attach)
	END

	insert into tbTemp
	RETURN QUERY
	select R.RoomNo, R.StartMessageNo
	from 
	CrewChat_RoomUsers R
	inner join CrewChat_Rooms M ON M.RoomNo=R.RoomNo AND M.LastedMsg is not null
	where R.UserNo=crewchat_getattachfilelist_toattachno.userno AND R.Closed = 0 AND R.StartMessageNo <= M.LastedMsgNo
	
	IF RoomNo = 0
	BEGIN
		RETURN QUERY
		select /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, A.AttachNo, A.FileName, 
		A.FullPath, A.RegDate, A.Size, A.Type, A.ThumbWidth, A.ThumbHeight
		from CrewChat_Messages M
		INNER JOIN tbTemp R ON R.RoomNo = M.RoomNo
		LEFT JOIN CrewChat_Attach A ON A.AttachNo = M.AttachNo
		where M.AttachNo > 0 AND M.MessageNo > R.StartMessageNo AND A.AttachNo IS NOT NULL
		AND A.AttachNo < crewchat_getattachfilelist_toattachno.attachno
		AND (public."COMNGetUserName"(M.UserNo) ILIKE '%' || SearchText || '%' OR A.FileName ILIKE '%' || SearchText || '%' OR public."CrewChat_GetChatRoomTitle"(M.RoomNo, UserNo) ILIKE '%' || SearchText || '%')
		AND A.Type = crewchat_getattachfilelist_toattachno.type
		order by M.RegDate DESC
	END
	ELSE
	BEGIN
		RETURN QUERY
		select /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, A.AttachNo, A.FileName, 
		A.FullPath, A.RegDate, A.Size, A.Type, A.ThumbWidth, A.ThumbHeight
		from CrewChat_Messages M
		INNER JOIN tbTemp R ON R.RoomNo = M.RoomNo
		LEFT JOIN CrewChat_Attach A ON A.AttachNo = M.AttachNo
		where M.AttachNo > 0 AND M.MessageNo > R.StartMessageNo AND A.AttachNo IS NOT NULL
		AND A.AttachNo < crewchat_getattachfilelist_toattachno.attachno
		AND (public."COMNGetUserName"(M.UserNo) ILIKE '%' || SearchText || '%' OR A.FileName ILIKE '%' || SearchText || '%' OR public."CrewChat_GetChatRoomTitle"(M.RoomNo, UserNo) ILIKE '%' || SearchText || '%')
		AND M.RoomNo = crewchat_getattachfilelist_toattachno.roomno
		AND A.Type = crewchat_getattachfilelist_toattachno.type
		order by M.RegDate DESC
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
