-- ─── PROCEDURE→FUNCTION: schedule_saveresourcesetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_saveresourcesetup(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_saveresourcesetup(
    IN viewtype integer,
    IN startweek integer,
    IN rsvnmethod integer,
    IN p_can integer,
    IN viewcount integer DEFAULT 10
) RETURNS SETOF record
AS $function$
DECLARE
    nusercnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT COUNT(UserNo) INTO nusercnt FROM ScheduleResourceSetup WHERE UserNo = UserNo
	
	IF nUserCnt = 0 THEN;
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
	END IF;
	ELSE;
		UPDATE ScheduleResourceSetup
		ViewType := schedule_saveresourcesetup.viewtype,;
			ViewCount = schedule_saveresourcesetup.viewcount,
			StartWeek = schedule_saveresourcesetup.startweek,
			RsvnMethod = schedule_saveresourcesetup.rsvnmethod,
			ModUserNo = UserNo,
			ModDate = NOW(),
			can =schedule_saveresourcesetup.p_can
		WHERE UserNo = UserNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
