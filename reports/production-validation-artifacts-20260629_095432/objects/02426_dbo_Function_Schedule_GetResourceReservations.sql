-- ─── FUNCTION: schedule_getresourcereservations ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcereservations(date, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcereservations(
    startdate date,
    enddate date,
    p_lang character varying DEFAULT 'CH'
) RETURNS TABLE(
    reservationno text,
    title text,
    resourceno text,
    reguserno text,
    username text,
    positionname text,
    resourcename text,
    content text,
    repeattype text,
    repeatcount text,
    repeatmonth text,
    repeatweek text,
    repeatday text,
    repeatdows text,
    startdate text,
    enddate text,
    starttime text,
    endtime text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text,
    notitimetype text,
    rsvnstatus text,
    isreservation text,
    regusername text,
    col27 text,
    col28 text,
    col29 text,
    col30 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT S.ReservationNo, S.Title, S.ResourceNo,
		S.RegUserNo, U.Name AS UserName, public."UF_PositionName"(U.UserNo) AS PositionName, R.Name AS ResourceName, Content,
		S.RepeatType, S.RepeatCount, S.RepeatMonth, S.RepeatWeek, S.RepeatDay, S.RepeatDOWs,
		S.StartDate, S.EndDate, S.StartTime, S.EndTime,
		S.IsNotiNote, S.IsNotiMail, S.IsNotiSMS, S.IsNotiPopup, NotiTimeType,
		S.RsvnStatus, R.IsReservation
		,CASE WHEN p_lang = 'VN' THEN COALESCE(u.Name_VN,u.Name) 
			WHEN  p_lang = 'JP' THEN COALESCE(u.Name_JP,u.Name) 
			WHEN  p_lang = 'CH' THEN COALESCE(u.Name_CH,u.Name) 
			WHEN  p_lang = 'EN' THEN COALESCE(u.Name_EN,u.Name) 
		ELSE u.Name END AS RegUserName
		,COALESCE( R.IsHidenReg,0) IsHidenReg
		,COALESCE( S.IsAllDay,0) IsAllDay
		,COALESCE(r.Color,'') Color
		,COALESCE(R.CategoryNo,0)  CategoryNo-- search by category
	FROM ScheduleResourceReservations S
	INNER JOIN Organization_Users U ON U.UserNo = S.RegUserNo
	INNER JOIN ScheduleResources R ON R.ResourceNo = S.ResourceNo
	WHERE S.RsvnStatus != 'RR' and ( (StartDate BETWEEN StartDate AND EndDate OR EndDate BETWEEN StartDate AND EndDate)
		OR (StartDate BETWEEN StartDate AND EndDate OR EndDate BETWEEN StartDate AND EndDate))
	ORDER BY StartDate, StartTime;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
