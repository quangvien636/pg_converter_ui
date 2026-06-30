-- ─── FUNCTION: noticesyn_getnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getnotice(integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getnotice(
    noticeno integer,
    userno integer
) RETURNS TABLE(
    typeno serial,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying(100),
    name_ko character varying(100),
    name_en character varying(100),
    name_vn character varying(100),
    name_ch character varying(100),
    sort integer,
    status integer
)
AS $function$
BEGIN


	IF (SELECT ReadDate FROM NoticeSyn_References
		WHERE NoticeNo = noticesyn_getnotice.noticeno AND UserNo = noticesyn_getnotice.userno) IS NULL BEGIN
	
		UPDATE NoticeSyn_References
		SET ReadDate = NOW()
		WHERE NoticeNo = noticesyn_getnotice.noticeno AND UserNo = noticesyn_getnotice.userno
		
		UPDATE Notices
		SET CurrentViews = CurrentViews + 1
		WHERE NoticeNo = noticesyn_getnotice.noticeno
		
	END
	
	RETURN QUERY
	SELECT N.NoticeNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, ND.Name AS DivisionName,
		N.Content, N.StartDate, N.EndDate,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM NoticeSyn_Reference WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt,
		N.TypeNo,TP.Name as TypeName
	FROM NoticesSyn N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	Left JOIN NoticeSyn_Type TP ON TP.TypeNo = N.TypeNo
	WHERE N.NoticeNo = noticesyn_getnotice.noticeno

END
RETURN QUERY
select * from NoticeSyn_Type;
-------------------------------/////////////////////////////////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
