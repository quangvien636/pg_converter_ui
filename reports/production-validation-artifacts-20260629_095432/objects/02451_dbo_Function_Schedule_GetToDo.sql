-- ─── FUNCTION: schedule_gettodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodo(integer);
CREATE OR REPLACE FUNCTION public.schedule_gettodo(
    todono integer
) RETURNS TABLE(
    todono text,
    reguserno text,
    regusername text,
    regdate text,
    moduserno text,
    moddate text,
    title text,
    groupno text,
    groupname text,
    important text,
    completedate text,
    iscomplete text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text,
    notitimetype text,
    progressrate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ToDoNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) as RegUserName, S.RegDate, S.ModUserNo, S.ModDate, Title, S.GroupNo, DG.Name AS GroupName,
		S.Important, CompleteDate, IsComplete,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate
	FROM ScheduleToDos S
	LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
	WHERE ToDoNo = schedule_gettodo.todono;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
