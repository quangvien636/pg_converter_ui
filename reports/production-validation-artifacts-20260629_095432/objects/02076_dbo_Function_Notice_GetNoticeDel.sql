-- ─── FUNCTION: notice_getnoticedel ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getnoticedel(integer);
CREATE OR REPLACE FUNCTION public.notice_getnoticedel(
    noticeno integer
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
AS $function$
BEGIN





	RETURN QUERY
	SELECT N.NoticeNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, ND.Name AS DivisionName,
		N.Content, N.StartDate, N.EndDate,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM NoticeReference WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt,
		N.IsPopup
		, COALESCE(N.PPStartDate, NOW())   as PPStartDate
		, COALESCE(N.PPEndDate, P_PPEndDate)  PPEndDate
	FROM NoticesDelete  N
	LEFT JOIN Organization_Users  U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment  B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions  P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments  D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeDivisions  ND ON ND.DivisionNo = N.DivisionNo
	WHERE N.NoticeNo = notice_getnoticedel.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
