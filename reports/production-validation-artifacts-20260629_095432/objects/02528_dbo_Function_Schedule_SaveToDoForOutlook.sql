-- ─── FUNCTION: schedule_savetodoforoutlook ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savetodoforoutlook(character varying, character varying, integer, character varying, date, boolean, integer, integer, boolean, boolean, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_savetodoforoutlook(
    folderentryid character varying,
    foldername character varying,
    userno integer,
    title character varying,
    completedate date,
    iscomplete boolean,
    progressrate integer,
    important integer DEFAULT 1,
    isnotinote boolean DEFAULT FALSE,
    isnotimail boolean DEFAULT FALSE,
    isnotisms boolean DEFAULT FALSE,
    isnotipopup boolean DEFAULT FALSE,
    notitimetype integer DEFAULT 1
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    groupcnt integer;
    groupno integer;
    todocnt integer;
    chktodono character varying;
    todono integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN






	SELECT GroupCnt = COUNT(FolderEntryID) 
	FROM ScheduleToDoGroupsOutlook
	WHERE UserNo = schedule_savetodoforoutlook.userno
	AND FolderEntryID = schedule_savetodoforoutlook.folderentryid
	
	SELECT ToDoCNT = COUNT(OutlookEntryID) 
	FROM ScheduleToDosOutlook
	WHERE UserNo = schedule_savetodoforoutlook.userno
	AND OutlookEntryID = OutlookEntryID
	
	IF LEN(FolderEntryID) > 0
	BEGIN
		IF GroupCnt = 0
		BEGIN;
			INSERT INTO ScheduleToDoGroups
			(
				RegUserNo,
				RegDate,
				ModUserNo,
				ModDate,
				Name
			)
			VALUES
			(
				UserNo,
				NOW(),
				UserNo,
				NOW(),
				FolderName
			)
			SET GroupNo = lastval()
			
			INSERT INTO ScheduleToDoGroupsOutlook
			(
				UserNo,
				GroupNo,
				FolderEntryID
			)
			VALUES
			(
				UserNo,
				GroupNo,
				FolderEntryID
			)
		END
		ELSE
		BEGIN
			SELECT GroupNo = GroupNo 
			FROM ScheduleToDoGroupsOutlook
			WHERE UserNo = schedule_savetodoforoutlook.userno
			AND FolderEntryID = schedule_savetodoforoutlook.folderentryid
			
			UPDATE ScheduleToDoGroups
			SET
				Name = schedule_savetodoforoutlook.foldername
			WHERE GroupNo = GroupNo
		END
	END
	ELSE
	BEGIN
		SET GroupNo = 0
	END
	
	IF ToDoCNT = 0
	BEGIN
	
		INSERT INTO ScheduleToDos
		(
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			Title,
			GroupNo,
			Important,
			CompleteDate,
			ProgressRate,
			IsComplete,
			IsNotiNote,
			IsNotiMail,
			IsNotiSMS,
			IsNotiPopup,
			NotiTimeType
		)
		VALUES
		(
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			Title,
			GroupNo,
			Important,
			CompleteDate,
			ProgressRate,
			IsComplete,
			IsNotiNote,
			IsNotiMail,
			IsNotiSMS,
			IsNotiPopup,
			NotiTimeType
		)
		
		SET ToDoNo = lastval()
		
		INSERT INTO ScheduleToDosOutlook
		(
			UserNo,
			ToDoNo,
			OutlookEntryID
		)
		VALUES
		(
			UserNo,
			ToDoNo,
			OutlookEntryID
		)
	END
	ELSE
	BEGIN
		SELECT ToDoNo = ToDoNo FROM ScheduleToDosOutlook
		WHERE UserNo = schedule_savetodoforoutlook.userno 
		AND OutlookEntryID = OutlookEntryID
		
		UPDATE ScheduleToDos
		SET
			ModUserNo = schedule_savetodoforoutlook.userno,
			ModDate = NOW(),
			GroupNo = GroupNo,
			Title = schedule_savetodoforoutlook.title,
			Important = schedule_savetodoforoutlook.important,
			CompleteDate = schedule_savetodoforoutlook.completedate,
			ProgressRate = schedule_savetodoforoutlook.progressrate,
			IsComplete = schedule_savetodoforoutlook.iscomplete,
			IsNotiNote = schedule_savetodoforoutlook.isnotinote,
			IsNotiMail = schedule_savetodoforoutlook.isnotimail,
			IsNotiSMS = schedule_savetodoforoutlook.isnotisms,
			IsNotiPopup = schedule_savetodoforoutlook.isnotipopup,
			NotiTimeType = schedule_savetodoforoutlook.notitimetype
		WHERE ToDoNo = ToDoNo
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
