-- ─── PROCEDURE→FUNCTION: schedule_savetodoforoutlook ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.schedule_savetodoforoutlook(character varying, character varying, integer, character varying, date, boolean, integer, integer, boolean, boolean, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_savetodoforoutlook(
    IN folderentryid character varying,
    IN foldername character varying,
    IN userno integer,
    IN title character varying,
    IN completedate date,
    IN iscomplete boolean,
    IN progressrate integer,
    IN important integer DEFAULT 1,
    IN isnotinote boolean DEFAULT FALSE,
    IN isnotimail boolean DEFAULT FALSE,
    IN isnotisms boolean DEFAULT FALSE,
    IN isnotipopup boolean DEFAULT FALSE,
    IN notitimetype integer DEFAULT 1
) RETURNS SETOF record
AS $function$
DECLARE
    groupcnt integer;
    groupno integer;
    todocnt integer;
    chktodono character varying;
    todono integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN






	SELECT  INTO  FROM ScheduleToDoGroupsOutlook
	WHERE UserNo = schedule_savetodoforoutlook.userno
	AND FolderEntryID = schedule_savetodoforoutlook.folderentryid
	
	SELECT  INTO  FROM ScheduleToDosOutlook
	WHERE UserNo = schedule_savetodoforoutlook.userno
	AND OutlookEntryID = OutlookEntryID
	
	IF LEN(FolderEntryID) > 0 THEN
		IF GroupCnt = 0 THEN;
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
			GroupNo := lastval();;
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
		END IF;
		ELSE
			SELECT  INTO  FROM ScheduleToDoGroupsOutlook
			WHERE UserNo = schedule_savetodoforoutlook.userno
			AND FolderEntryID = schedule_savetodoforoutlook.folderentryid
			
			UPDATE ScheduleToDoGroups
			Name := schedule_savetodoforoutlook.foldername;
			WHERE GroupNo = GroupNo
		END IF;
	END IF;
	ELSE
		GroupNo := 0;
	END IF;
	
	IF ToDoCNT = 0 THEN
	
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
		
		ToDoNo := lastval();;
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
	END IF;
	ELSE
		SELECT ToDoNo INTO todono FROM ScheduleToDosOutlook
		WHERE UserNo = schedule_savetodoforoutlook.userno 
		AND OutlookEntryID = OutlookEntryID
		
		UPDATE ScheduleToDos
		ModUserNo := schedule_savetodoforoutlook.userno,;
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
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
