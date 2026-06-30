-- ─── PROCEDURE→FUNCTION: center_deletenotifymail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletenotifymail(integer);
CREATE OR REPLACE FUNCTION public.center_deletenotifymail(
    IN rsvnno integer
) RETURNS void
AS $function$
BEGIN

	DELETE
	FROM BizSoftNotifyMail
	WHERE RsvnNo = center_deletenotifymail.rsvnno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
