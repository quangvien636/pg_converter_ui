-- ─── FUNCTION: workingtime_getusernoallowdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getusernoallowdevice();
CREATE OR REPLACE FUNCTION public.workingtime_getusernoallowdevice(
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
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


	SELECT AllowDeviceNo,UserNo,ContentAllow INTO #TABLE_ALLOW_TEMP FROM WorkingTime_AllowDevices
	WHILE EXISTS(SELECT /* TOP 1 */ * FROM #TABLE_ALLOW_TEMP)
	BEGIN
		SET ALLOW_DEVICE_NO = (SELECT /* TOP 1 */ AllowDeviceNo FROM #TABLE_ALLOW_TEMP)
	
		-- parse json to table
		SET STRJSON = (SELECT /* TOP 1 */ ContentAllow FROM #TABLE_ALLOW_TEMP)

		IF((SELECT count(StringValue) FROM public."parseJSON"(STRJSON) WHERE NAME = 'Allow' AND StringValue = TRUE) >= 1)
		BEGIN;
			INSERT INTO TABLE_ALLOW VALUES((SELECT UserNo FROM #TABLE_ALLOW_TEMP WHERE AllowDeviceNo = ALLOW_DEVICE_NO))
		END
		DELETE #TABLE_ALLOW_TEMP WHERE AllowDeviceNo = ALLOW_DEVICE_NO
	END

	DROP TABLE #TABLE_ALLOW_TEMP
	SELECT * FROM TABLE_ALLOW;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
