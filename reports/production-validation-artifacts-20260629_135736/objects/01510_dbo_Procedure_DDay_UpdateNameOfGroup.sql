-- ─── PROCEDURE→FUNCTION: dday_updatenameofgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_updatenameofgroup(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.dday_updatenameofgroup(
    IN groupno bigint,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_Groups SET
		ModDate = dday_updatenameofgroup.moddate,
		Name = Name
	WHERE GroupNo = dday_updatenameofgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
