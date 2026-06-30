-- ─── PROCEDURE→FUNCTION: work_updateworkgrouplock ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateworkgrouplock(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateworkgrouplock(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN islock boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkGroups SET
		ModUserNo = work_updateworkgrouplock.moduserno,
		ModDate = work_updateworkgrouplock.moddate,
		IsLock = work_updateworkgrouplock.islock
	WHERE GroupNo = work_updateworkgrouplock.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
