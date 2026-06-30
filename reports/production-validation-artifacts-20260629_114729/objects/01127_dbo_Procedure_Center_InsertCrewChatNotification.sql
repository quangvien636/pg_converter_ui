-- ─── PROCEDURE→FUNCTION: center_insertcrewchatnotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertcrewchatnotification(integer);
CREATE OR REPLACE FUNCTION public.center_insertcrewchatnotification(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	
	INSERT INTO Center_CrewChatNotification (UserNo,Message,RegDate)
	VALUES (UserNo,Message,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
