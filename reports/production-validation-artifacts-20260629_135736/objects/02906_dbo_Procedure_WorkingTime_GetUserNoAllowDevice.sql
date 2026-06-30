-- ─── PROCEDURE→FUNCTION: workingtime_getusernoallowdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_getusernoallowdevice();
CREATE OR REPLACE FUNCTION public.workingtime_getusernoallowdevice(
) RETURNS void
AS $function$
DECLARE
    table_allow table(
		user_no int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	PC bit,
	MOBILE bit,
	ALLOW_DEVICE_NO INT


	CREATE TEMP TABLE TABLE_ALLOW_TEMP AS SELECT AllowDeviceNo,UserNo,ContentAllow FROM WorkingTime_AllowDevices
	WHILE EXISTS(SELECT /* TOP 1 */ * FROM TABLE_ALLOW_TEMP) LOOP
		ALLOW_DEVICE_NO := (SELECT /* TOP 1 */ AllowDeviceNo FROM TABLE_ALLOW_TEMP);
		-- parse json to table
		STRJSON := (SELECT /* TOP 1 */ ContentAllow FROM TABLE_ALLOW_TEMP);
		IF((SELECT count(StringValue) FROM public."parseJSON"(STRJSON) WHERE NAME = 'Allow' AND StringValue = TRUE) >= 1)
		BEGIN;
			INSERT INTO TABLE_ALLOW VALUES((SELECT UserNo FROM TABLE_ALLOW_TEMP WHERE AllowDeviceNo = ALLOW_DEVICE_NO))
		END;;
		DELETE FROM TABLE_ALLOW_TEMP WHERE AllowDeviceNo = ALLOW_DEVICE_NO
	END LOOP;

	DROP TABLE TABLE_ALLOW_TEMP
	SELECT * FROM TABLE_ALLOW;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
