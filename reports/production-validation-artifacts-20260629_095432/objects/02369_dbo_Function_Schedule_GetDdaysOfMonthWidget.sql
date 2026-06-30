-- ─── FUNCTION: schedule_getddaysofmonthwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonthwidget(integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonthwidget(
    userno integer,
    groupno integer,
    wcconut integer,
    isshare boolean DEFAULT FALSE
) RETURNS TABLE(
    tagimageno text
)
AS $function$
BEGIN

    
	-- 목록
	IF GroupNo = -1 BEGIN
		
		IF IsShare = FALSE
		BEGIN
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
					S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
					COALESCE(R.RepeatDate,S.DoomDate) As DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType, 
					COALESCE(R.IsComplete,S.IsComplete) As IsComplete, 
					COALESCE(R.CompleteDate, S.CompleteDate) As CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag
						WHERE UserNo = schedule_getddaysofmonthwidget.userno AND GroupNo = S.GroupNo) = 0 THEN 
							COALESCE((
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = S.RegUserNo
								AND GroupNo = S.GroupNo
							 ),0)
						ELSE
							(
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = schedule_getddaysofmonthwidget.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdaysRepeat R ON S.DdayNo = R.DdayNo
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddaysofmonthwidget.userno
			) AS T
			WHERE RowNum <= schedule_getddaysofmonthwidget.wcconut
			ORDER BY DoomDate
		END
		ELSE 
		BEGIN
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
					S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
					COALESCE(R.RepeatDate,S.DoomDate) As DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType,
					COALESCE(R.IsComplete,S.IsComplete) As IsComplete, 
					COALESCE(R.CompleteDate, S.CompleteDate) As CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag 
						WHERE UserNo = schedule_getddaysofmonthwidget.userno AND GroupNo = S.GroupNo) = 0 THEN 
							COALESCE((
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = S.RegUserNo
								AND GroupNo = S.GroupNo
							 ),0)
						ELSE
							(
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = schedule_getddaysofmonthwidget.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdaysRepeat R ON S.DdayNo = R.DdayNo
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddaysofmonthwidget.userno
					OR S.DdayNo IN (
						SELECT DdayNo
						FROM ScheduleDdaySharers SDS
						WHERE (SDS.UserNo = schedule_getddaysofmonthwidget.userno OR SDS.DepartNo IN (SELECT DepartNo FROM Organization_BelongToDepartment 	WHERE UserNo = schedule_getddaysofmonthwidget.userno) OR SDS.PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment 	WHERE UserNo =schedule_getddaysofmonthwidget.userno))
						)
			) AS T
			WHERE RowNum <= schedule_getddaysofmonthwidget.wcconut
			ORDER BY DoomDate
		END
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
				S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
				Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
				COALESCE(R.RepeatDate,S.DoomDate) As DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
				RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
				IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
				DisplayType,
				COALESCE(R.IsComplete,S.IsComplete) As IsComplete, 
				COALESCE(R.CompleteDate, S.CompleteDate) As CompleteDate,
				CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag 
						WHERE UserNo = schedule_getddaysofmonthwidget.userno AND GroupNo = S.GroupNo) = 0 THEN 
							COALESCE((
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = S.RegUserNo
								AND GroupNo = S.GroupNo
							 ),0)
						ELSE
							(
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = schedule_getddaysofmonthwidget.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
			FROM ScheduleDdays S
			LEFT JOIN ScheduleDdaysRepeat R ON S.DdayNo = R.DdayNo
			LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_getddaysofmonthwidget.userno AND S.GroupNo = schedule_getddaysofmonthwidget.groupno
		) AS T
		WHERE RowNum <= schedule_getddaysofmonthwidget.wcconut
		ORDER BY DoomDate
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
