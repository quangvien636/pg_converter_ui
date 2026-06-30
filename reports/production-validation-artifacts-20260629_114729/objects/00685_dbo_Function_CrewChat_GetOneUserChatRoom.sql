-- ─── FUNCTION: crewchat_getoneuserchatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getoneuserchatroom(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_getoneuserchatroom(
    userno1 integer,
    userno2 integer
) RETURNS bigint
AS $function$
DECLARE
    temp table
	(
	rowno int,
	roomno int
	);
    datasize integer;
    temproomno integer;
    user_cnt integer;
    tempchatroomno bigint;
BEGIN


	INSERT INTO temp (RowNo, RoomNo)
	SELECT ROW_NUMBER() over(order by R.RoomNo), R.RoomNo 
	FROM CrewChat_Rooms R
	JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
	WHERE R.IsOne = TRUE AND UserNo=crewchat_getoneuserchatroom.userno1





	SET DataSize = (SELECT COUNT(*) FROM temp)


	WHILE CNT < DataSize
	BEGIN


		SET TempChatRoomNo = (SELECT RoomNo FROM temp WHERE RowNo = (CNT+1))
		
		IF exists(SELECT * FROM CrewChat_RoomUsers 	
		WHERE RoomNo = TempChatRoomNo AND UserNo=crewchat_getoneuserchatroom.userno2 AND UserNo!=crewchat_getoneuserchatroom.userno1)
		BEGIN
			SET ResultRoomNo = TempChatRoomNo
			BREAK
		END	
		
		SET CNT += 1
	END

RETURN ResultRoomNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
