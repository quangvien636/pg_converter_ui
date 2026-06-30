-- ─── FUNCTION: schedule_saveddaystag ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_saveddaystag(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_saveddaystag(
    groupno integer,
    tagimageno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	
	SELECT COUNT = COUNT(TagImageNo) FROM ScheduleDdaysTag
	WHERE UserNo = UserNo AND GroupNo = schedule_saveddaystag.groupno
	
	IF COUNT = 0
	BEGIN;
		INSERT INTO ScheduleDdaysTag
			   (UserNo
			   ,GroupNo
			   ,TagImageNo)
		 VALUES
			   (UserNo,
				GroupNo,
				TagImageNo)
	END
	ELSE
	BEGIN;
		UPDATE 	ScheduleDdaysTag
		SET
			TagImageNo = schedule_saveddaystag.tagimageno
		WHERE UserNo = UserNo
		AND GroupNo = schedule_saveddaystag.groupno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
