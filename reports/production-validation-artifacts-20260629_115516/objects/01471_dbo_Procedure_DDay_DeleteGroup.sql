-- ─── PROCEDURE→FUNCTION: dday_deletegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletegroup(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletegroup(
    IN groupno bigint
) RETURNS void
AS $function$
BEGIN

	
	--UPDATE DDay_Days SET GroupNo = 0 WHERE GroupNo = GroupNo;
	DELETE FROM DDay_Days WHERE GroupNo = dday_deletegroup.groupno;
	DELETE FROM DDay_GroupInfoOfSharedDays WHERE GroupNo = dday_deletegroup.groupno;
	DELETE FROM DDay_Groups WHERE GroupNo = dday_deletegroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
