-- ─── PROCEDURE→FUNCTION: sns_updatemessagechk ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.sns_updatemessagechk(integer, integer);
CREATE OR REPLACE FUNCTION public.sns_updatemessagechk(
    IN groupno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE SnsMessageChk SET IsCheck = TRUE WHERE GroupNo=sns_updatemessagechk.groupno AND UserNo=sns_updatemessagechk.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
