-- ─── FUNCTION: schedule_getdday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getdday(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getdday(
    ddayno integer,
    userno integer DEFAULT 0
) RETURNS TABLE(
    tagimageno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate, 
	    S.Title, S.Contents, S.GroupNo, DG.Name AS GroupName,
		DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
		RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		DisplayType, IsComplete, CompleteDate,
		CASE WHEN (
			SELECT COUNT(TagImageNo) 
			FROM ScheduleDdaysTag
			WHERE UserNo = schedule_getdday.userno AND GroupNo = S.GroupNo) = 0 THEN 
				COALESCE((
					SELECT TagImageNo 
					FROM ScheduleDdaysTag
					WHERE UserNo = S.RegUserNo
					AND GroupNo = S.GroupNo
				 ),0)
			ELSE
				COALESCE((
					SELECT TagImageNo 
					FROM ScheduleDdaysTag
					WHERE UserNo = schedule_getdday.userno
					AND GroupNo = S.GroupNo
				),0)  
		END AS TagImageNo
	FROM ScheduleDdays S
	LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
	WHERE DdayNo = schedule_getdday.ddayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
