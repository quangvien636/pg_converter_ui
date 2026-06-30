-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimenotice(integer, integer, date, date, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimenotice(
    IN reguserno integer,
    IN timetype integer,
    IN startdate date,
    IN enddate date,
    IN locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkingTime_Notices (LocationNo,RegUserNo, RegDate, TimeType, StartDate, EndDate, Content)
	VALUES (LocationNo,RegUserNo, NOW(), TimeType, StartDate, EndDate, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
