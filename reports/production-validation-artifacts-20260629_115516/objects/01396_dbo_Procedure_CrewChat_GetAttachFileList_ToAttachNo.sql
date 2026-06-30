-- ─── PROCEDURE→FUNCTION: crewchat_getattachfilelist_toattachno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.crewchat_getattachfilelist_toattachno(integer, integer, character varying, bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfilelist_toattachno(
    IN userno integer,
    IN attachno integer,
    IN searchtext character varying,
    IN roomno bigint,
    IN type integer
) RETURNS SETOF record
AS $function$
DECLARE
    tbtemp table
	(
		roomno bigint,
		startmessageno bigint
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF AttachNo = 0 THEN
		AttachNo := (SELECT MAX(AttachNo)+1 FROM CrewChat_Attach);
	END IF;

	insert into tbTemp
	RETURN QUERY
	select R.RoomNo, R.StartMessageNo
	from 
	CrewChat_RoomUsers R
	inner join CrewChat_Rooms M ON M.RoomNo=R.RoomNo AND M.LastedMsg is not null
	where R.UserNo=crewchat_getattachfilelist_toattachno.userno AND R.Closed = 0 AND R.StartMessageNo <= M.LastedMsgNo
	
	IF RoomNo = 0 THEN
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
	END IF;
	ELSE
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
