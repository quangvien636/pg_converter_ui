-- ─── FUNCTION: board_getviewedlogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getviewedlogs(bigint);
CREATE OR REPLACE FUNCTION public.board_getviewedlogs(
    contentno bigint DEFAULT 827
) RETURNS TABLE(
    logno text,
    boardno text,
    contentno text,
    userno text,
    username text,
    positionno text,
    positionname text,
    departno text,
    departname text,
    vieweddate text,
    clientip text,
    mailaddress text,
    userphoto text,
    photo text
)
AS $function$
BEGIN

	WITH SHARE AS(
		SELECT U.UserNo ,BS.ContentNo
		FROM Board_Sharers BS
		INNER JOIN (
			SELECT U.UserNo,OP.DepartNo 
			FROM Organization_Users U 
			INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
			WHERE U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
		WHERE BS.ContentNo=board_getviewedlogs.contentno
	)
	RETURN QUERY
	SELECT BV.LogNo, BV.BoardNo, BV.ContentNo, BV.UserNo, BV.UserName, BV.PositionNo,COALESCE(OP.Name,'') AS PositionName, BV.DepartNo,COALESCE(OD.Name,'') AS DepartName,
		BV.ViewedDate, BV.ClientIP,OU.MailAddress,OU.UserPhoto,OU.Photo
	FROM Board_ViewedLogs BV 
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo AND BC.ContentNo=board_getviewedlogs.contentno
	LEFT JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.UserNo=BV.UserNo
	INNER JOIN Organization_Users OU ON BV.UserNo=OU.UserNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo=BV.DepartNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo=BV.PositionNo
	WHERE   BB.SpecType=1 OR BV.ContentNo = board_getviewedlogs.contentno AND (BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo)
	ORDER BY ViewedDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
