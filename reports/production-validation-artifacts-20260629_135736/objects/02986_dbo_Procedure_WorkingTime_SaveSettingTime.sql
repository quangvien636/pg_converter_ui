-- ─── PROCEDURE→FUNCTION: workingtime_savesettingtime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_savesettingtime(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_savesettingtime(
    IN starttime character varying,
    IN endtime character varying,
    IN changemin character varying,
    IN lunchtimestart character varying,
    IN lunchtimeend character varying,
    IN typelunchtime character varying,
    IN p_in character varying,
    IN p_out character varying,
    IN p_in1 character varying,
    IN p_out1 character varying,
    IN p_check1 character varying
) RETURNS SETOF record
AS $function$
DECLARE
    count integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF LunchTimeStart = '' THEN
		BEGIN SET LunchTimeStart = '0000' END
	IF LunchTimeEnd = '' THEN
		BEGIN SET LunchTimeEnd = '0000' END
	IF TypeLunchTime = '' THEN
		BEGIN SET TypeLunchTime = FALSE END


	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings
	WHERE SettingNo = 1
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings
		(
			SettingNo,
			RegUserNo,
			RegDate,
			SettingValue
		)
		VALUES
		(
			1,
			UserNo,
			NOW(),
			StartTime
		)
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings
		RegUserNo := UserNo,;
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.starttime
		WHERE SettingNo = 1
	END IF;
	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings
	WHERE SettingNo = 2
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings
		(
			SettingNo,
			RegUserNo,
			RegDate,
			SettingValue
		)
		VALUES
		(
			2,
			UserNo,
			NOW(),
			EndTime
		)
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings
		RegUserNo := UserNo,;
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.endtime
		WHERE SettingNo = 2
	END IF;
	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings
	WHERE SettingNo = 3
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings
		(
			SettingNo,
			RegUserNo,
			RegDate,
			SettingValue
		)
		VALUES
		(
			3,
			UserNo,
			NOW(),
			ChangeMin
		)
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings
		RegUserNo := UserNo,;
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.changemin
		WHERE SettingNo = 3
	END IF;

	-- LunchTimeStart
	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings
	WHERE SettingNo = 4
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings
		(
			SettingNo,
			RegUserNo,
			RegDate,
			SettingValue
		)
		VALUES
		(
			4,
			UserNo,
			NOW(),
			LunchTimeStart
		)
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings
		RegUserNo := UserNo,;
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.lunchtimestart
		WHERE SettingNo = 4
	END IF;
	
	-- LunchTimeEnd
	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings
	WHERE SettingNo = 5
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings
		(
			SettingNo,
			RegUserNo,
			RegDate,
			SettingValue
		)
		VALUES
		(
			5,
			UserNo,
			NOW(),
			LunchTimeEnd
		)
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings
		RegUserNo := UserNo,;
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.lunchtimeend
		WHERE SettingNo = 5
	END IF;

	-- TypeLunchTime
	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings
	WHERE SettingNo = 6
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings
		(
			SettingNo,
			RegUserNo,
			RegDate,
			SettingValue
		)
		VALUES
		(
			6,
			UserNo,
			NOW(),
			TypeLunchTime
		)
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings
		RegUserNo := UserNo,;
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.typelunchtime
		WHERE SettingNo = 6
	END IF;
	-- Break----------------------------------------------------------
	SELECT COUNT(SettingNo) INTO count FROM WorkingTime_Settings WHERE SettingNo = 10
	
	IF Count = 0 THEN;
		INSERT INTO WorkingTime_Settings(SettingNo,RegUserNo,RegDate,SettingValue)
		RETURN QUERY
		select 10, UserNo, NOW(), p_in UNION ALL
		RETURN QUERY
		select 11, UserNo, NOW(), p_out UNION ALL
		RETURN QUERY
		select 12, UserNo, NOW(), p_in1 UNION ALL
		RETURN QUERY
		select 13, UserNo, NOW(), p_out1 UNION ALL
		RETURN QUERY
		select 14, UserNo, NOW(), p_check1 UNION ALL
		RETURN QUERY
		select 15, UserNo, NOW(), p_check2
	END IF;
	ELSE;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_in WHERE SettingNo = 10;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_out WHERE SettingNo = 11;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_in1 WHERE SettingNo = 12;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_out1 WHERE SettingNo = 13;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_check1 WHERE SettingNo = 14;
		UPDATE WorkingTime_Settings SET SettingValue = p_check2 WHERE SettingNo = 15
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
