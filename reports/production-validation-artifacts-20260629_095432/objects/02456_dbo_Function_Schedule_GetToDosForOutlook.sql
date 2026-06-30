-- ─── FUNCTION: schedule_gettodosforoutlook ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodosforoutlook(boolean);
CREATE OR REPLACE FUNCTION public.schedule_gettodosforoutlook(
    iscomplete boolean DEFAULT FALSE
) RETURNS TABLE(
    outlookentryid text,
    folderentryid text,
    foldername text,
    todono text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    title text,
    groupno text,
    important text,
    completedate text,
    iscomplete text,
    progressrate text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text
)
AS $function$
BEGIN

	IF IsComplete = TRUE
	BEGIN
		RETURN QUERY
		SELECT 
			COALESCE(TDO.OutlookEntryID,'') AS OutlookEntryID,
			COALESCE(TDGO.FolderEntryID,'') AS FolderEntryID,
			TDG.Name AS FolderName,
			TD.ToDoNo,
			TD.RegUserNo,
			TD.RegDate,
			TD.ModUserNo,
			TD.ModDate,
			TD.Title,
			TD.GroupNo,
			TD.Important,
			COALESCE(TD.CompleteDate, TD.RegDate) AS CompleteDate,
			TD.IsComplete,
			TD.ProgressRate,
			TD.IsNotiNote,
			TD.IsNotiMail,
			TD.IsNotiSMS,
			TD.IsNotiPopup
		FROM ScheduleToDos TD
		LEFT JOIN ScheduleToDosOutlook TDO ON TD.ToDoNo = TDO.ToDoNo
		LEFT JOIN ScheduleToDoGroups TDG ON TD.GroupNo = TDG.GroupNo
		LEFT JOIN ScheduleToDoGroupsOutlook TDGO ON TDG.GroupNo = TDGO.GroupNo
		WHERE TD.RegUserNo = UserNo
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT 
			COALESCE(TDO.OutlookEntryID,'') AS OutlookEntryID,
			COALESCE(TDGO.FolderEntryID,'') AS FolderEntryID,
			TDG.Name AS FolderName,
			TD.ToDoNo,
			TD.RegUserNo,
			TD.RegDate,
			TD.ModUserNo,
			TD.ModDate,
			TD.Title,
			TD.GroupNo,
			TD.Important,
			COALESCE(TD.CompleteDate,TD.RegDate) AS CompleteDate,
			TD.IsComplete,
			TD.ProgressRate,
			TD.IsNotiNote,
			TD.IsNotiMail,
			TD.IsNotiSMS,
			TD.IsNotiPopup
		FROM ScheduleToDos TD
		LEFT JOIN ScheduleToDosOutlook TDO ON TD.ToDoNo = TDO.ToDoNo
		LEFT JOIN ScheduleToDoGroups TDG ON TD.GroupNo = TDG.GroupNo
		LEFT JOIN ScheduleToDoGroupsOutlook TDGO ON TDG.GroupNo = TDGO.GroupNo
		WHERE TD.RegUserNo = UserNo
		AND TD.IsComplete = FALSE
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
