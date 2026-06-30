-- ─── PROCEDURE→FUNCTION: schedule_updateworktodoiscomplete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_updateworktodoiscomplete(boolean, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateworktodoiscomplete(
    IN iscompleted boolean,
    IN idea character varying,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here;
	UPDATE ScheduleContents
	IsCompleted := schedule_updateworktodoiscomplete.iscompleted;
		, Idea = schedule_updateworktodoiscomplete.idea
		, ModUserNo = schedule_updateworktodoiscomplete.userno
		, ModDate = NOW()
	WHERE ScheduleNo = ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
