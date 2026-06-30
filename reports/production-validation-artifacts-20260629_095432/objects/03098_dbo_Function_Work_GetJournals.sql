-- ─── FUNCTION: work_getjournals ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getjournals(integer);
CREATE OR REPLACE FUNCTION public.work_getjournals(
    workno integer
) RETURNS TABLE(
    journalno text,
    reguserno text,
    username text,
    positionname text,
    regdate text,
    moduserno text,
    moddate text,
    workno text,
    creationdate text,
    divisionno text,
    divisionname text,
    worktime text,
    completionrate text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT WJ.JournalNo, WJ.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName,
		WJ.RegDate, WJ.ModUserNo, WJ.ModDate,
		WJ.WorkNo, WJ.CreationDate, WJ.DivisionNo, WJD.Name AS DivisionName,
		WJ.WorkTime, WJ.CompletionRate, WJ.Content
	FROM WorkJournals WJ
	INNER JOIN WorkJournalDivisions WJD ON WJD.DivisionNo = WJ.DivisionNo
	INNER JOIN Organization_Users U ON U.UserNo = WJ.RegUserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE WJ.WorkNo = work_getjournals.workno
	ORDER BY WJ.CreationDate DESC, WJ.ModDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
