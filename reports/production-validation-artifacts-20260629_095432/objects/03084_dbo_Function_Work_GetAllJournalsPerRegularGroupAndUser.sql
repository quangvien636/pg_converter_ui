-- ─── FUNCTION: work_getalljournalsperregulargroupanduser ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getalljournalsperregulargroupanduser(integer, integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_getalljournalsperregulargroupanduser(
    groupno integer,
    userno integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone
) RETURNS TABLE(
    journalno text,
    creationdate text,
    title text,
    divisionname text,
    content text,
    worktime text,
    moddate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT RWJ.JournalNo, RWJ.CreationDate, RWJ.Title, D.Name AS DivisionName,
		RWJ.Content, RWJ.WorkTime, RWJ.ModDate
	FROM RegularWorkJournals RWJ
	INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = RWJ.GroupNo AND RWG.GroupNo = work_getalljournalsperregulargroupanduser.groupno
	INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
	INNER JOIN RegularWorkJournalDivisions D ON D.DivisionNo = RWJ.DivisionNo
	INNER JOIN Organization_Users U ON U.UserNo = RWJ.RegUserNo AND U.UserNo = work_getalljournalsperregulargroupanduser.userno
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = RWJ.RegUserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE RWG.Enabled = TRUE AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
	ORDER BY RWJ.CreationDate ASC, ModDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
