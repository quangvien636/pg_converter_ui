-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimemessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimemessage(integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimemessage(
    IN reguserno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkingTimeMessages(RegUserNo, RegDate, Message)
	VALUES(RegUserNo, NOW(), Message);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
