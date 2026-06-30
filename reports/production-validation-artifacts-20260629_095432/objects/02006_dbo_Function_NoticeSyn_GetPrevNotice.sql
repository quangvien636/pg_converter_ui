-- ─── FUNCTION: noticesyn_getprevnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getprevnotice(integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getprevnotice(
    noticeno integer,
    userno integer
) RETURNS TABLE(
    noticeno text,
    reguserno text,
    username text,
    positionname text,
    departname text,
    regdate text,
    moduserno text,
    moddate text,
    title text,
    divisionno text,
    divisionname text,
    content text,
    startdate text,
    enddate text,
    important text,
    isshare text,
    isattach text,
    totalviews text,
    currentviews text,
    iscontentimg text,
    col21 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    tempno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--IF (SELECT ReadDate FROM NoticeSyn_References
	--	WHERE NoticeNo = NoticeNo AND UserNo = UserNo) IS NULL BEGIN
	
	--	UPDATE NoticeSyn_References
	--	SET ReadDate = NOW()
	--	WHERE NoticeNo = NoticeNo AND UserNo = UserNo
		
	--	UPDATE Notices
	--	SET CurrentViews = CurrentViews + 1
	--	WHERE NoticeNo = NoticeNo
		
	--END
	
	RETURN QUERY
	SELECT /* TOP 1 */ N.NoticeNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, ND.Name AS DivisionName,
		N.Content, N.StartDate, N.EndDate,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM NoticeSyn_Reference WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt,
		N.TypeNo
	FROM NoticesSyn N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	WHERE N.NoticeNo < noticesyn_getprevnotice.noticeno -- and N.IsDelete=''
	order by N.NoticeNo desc
END;


------------===/////////////////////////=============
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
