-- ─── FUNCTION: schedule_saveresourcesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_saveresourcesetup(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_saveresourcesetup(
    viewtype integer,
    startweek integer,
    rsvnmethod integer,
    p_can integer,
    viewcount integer DEFAULT 10
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    nusercnt integer;
BEGIN


	SELECT nUserCnt = COUNT(UserNo) FROM ScheduleResourceSetup WHERE UserNo = UserNo
	
	IF nUserCnt = 0
	BEGIN;
		INSERT INTO ScheduleResourceSetup
		(
			UserNo,
			ViewType,
			ViewCount,
			StartWeek,
			RsvnMethod,
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			can
		)
		VALUES
		(
			UserNo,
			ViewType,
			ViewCount,
			StartWeek,
			RsvnMethod,
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			p_can
		)
	END
	ELSE
	BEGIN;
		UPDATE ScheduleResourceSetup
		SET
			ViewType = schedule_saveresourcesetup.viewtype,
			ViewCount = schedule_saveresourcesetup.viewcount,
			StartWeek = schedule_saveresourcesetup.startweek,
			RsvnMethod = schedule_saveresourcesetup.rsvnmethod,
			ModUserNo = UserNo,
			ModDate = NOW(),
			can =schedule_saveresourcesetup.p_can
		WHERE UserNo = UserNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
