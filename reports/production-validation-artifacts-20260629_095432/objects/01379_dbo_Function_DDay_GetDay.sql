-- ─── FUNCTION: dday_getday ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getday(integer, bigint);
CREATE OR REPLACE FUNCTION public.dday_getday(
    userno integer DEFAULT 70,
    dayno bigint DEFAULT 2006
) RETURNS TABLE(
    managerno text,
    userno text
)
AS $function$
DECLARE
    reguserno integer;
BEGIN



	SET RegUserNo = (SELECT RegUserNo FROM DDay_Days WHERE DayNo = dday_getday.dayno)

	IF (RegUserNo = dday_getday.userno) BEGIN

		RETURN QUERY
		SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
			D.GroupNo, COALESCE(G.TagNo, 0) AS TagNo, COALESCE(G.Name, '') AS GroupName,
			D.TypeNo,
			D.RepeatOptions, D.Title, D.Content, CanHide,
			COALESCE(R.UserNo, 0) AS DirectorUserNo
		FROM DDay_Days D
		LEFT JOIN DDay_Groups G ON G.GroupNo = D.GroupNo
		LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
		WHERE D.DayNo = dday_getday.dayno

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT D.DayNo, D.RegUserNo, D.ModUserNo, D.ModDate,
			COALESCE(G.GroupNo, 0) AS GroupNo, COALESCE(G.TagNo, 0) AS TagNo, COALESCE(G.Name, '') AS GroupName,
			D.TypeNo,
			D.RepeatOptions, D.Title, D.Content, CanHide,
			COALESCE(R.UserNo, 0) AS DirectorUserNo
		FROM DDay_Days D
		LEFT JOIN DDay_GroupInfoOfSharedDays S ON S.DayNo = D.DayNo AND S.UserNo = dday_getday.userno
		LEFT JOIN DDay_Groups G ON G.GroupNo = S.GroupNo
		LEFT JOIN DDay_Directors R ON R.DayNo = D.DayNo
		WHERE D.DayNo = dday_getday.dayno

	END

	RETURN QUERY
	SELECT SharerNo, DepartNo, UserNo
	FROM DDay_Sharers
	WHERE DayNo = dday_getday.dayno

	RETURN QUERY
	SELECT ManagerNo, UserNo
	FROM DDay_Managers
	WHERE DayNo = dday_getday.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
