-- ─── FUNCTION: workingtime_savesettingtime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_savesettingtime(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_savesettingtime(
    starttime character varying,
    endtime character varying,
    changemin character varying,
    lunchtimestart character varying,
    lunchtimeend character varying,
    typelunchtime character varying,
    p_in character varying,
    p_out character varying,
    p_in1 character varying,
    p_out1 character varying,
    p_check1 character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    count integer;
BEGIN

	
	IF LunchTimeStart = ''
		BEGIN SET LunchTimeStart = '0000' END
	IF LunchTimeEnd = ''
		BEGIN SET LunchTimeEnd = '0000' END
	IF TypeLunchTime = ''
		BEGIN SET TypeLunchTime = FALSE END


	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings
	WHERE SettingNo = 1
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings
		SET
			RegUserNo = UserNo,
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.starttime
		WHERE SettingNo = 1
	END
	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings
	WHERE SettingNo = 2
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings
		SET
			RegUserNo = UserNo,
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.endtime
		WHERE SettingNo = 2
	END
	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings
	WHERE SettingNo = 3
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings
		SET
			RegUserNo = UserNo,
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.changemin
		WHERE SettingNo = 3
	END

	-- LunchTimeStart
	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings
	WHERE SettingNo = 4
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings
		SET
			RegUserNo = UserNo,
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.lunchtimestart
		WHERE SettingNo = 4
	END
	
	-- LunchTimeEnd
	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings
	WHERE SettingNo = 5
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings
		SET
			RegUserNo = UserNo,
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.lunchtimeend
		WHERE SettingNo = 5
	END

	-- TypeLunchTime
	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings
	WHERE SettingNo = 6
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings
		SET
			RegUserNo = UserNo,
			RegDate = NOW(),
			SettingValue = workingtime_savesettingtime.typelunchtime
		WHERE SettingNo = 6
	END
	-- Break----------------------------------------------------------
	SELECT Count = COUNT(SettingNo) FROM WorkingTime_Settings WHERE SettingNo = 10
	
	IF Count = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_in WHERE SettingNo = 10;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_out WHERE SettingNo = 11;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_in1 WHERE SettingNo = 12;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_out1 WHERE SettingNo = 13;
		UPDATE WorkingTime_Settings SET SettingValue = workingtime_savesettingtime.p_check1 WHERE SettingNo = 14;
		UPDATE WorkingTime_Settings SET SettingValue = p_check2 WHERE SettingNo = 15
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
