-- ─── FUNCTION: schedule_updateworktodoiscomplete ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateworktodoiscomplete(boolean, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateworktodoiscomplete(
    iscompleted boolean,
    idea character varying,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here;
	UPDATE ScheduleContents
	SET
		IsCompleted = schedule_updateworktodoiscomplete.iscompleted
		, Idea = schedule_updateworktodoiscomplete.idea
		, ModUserNo = schedule_updateworktodoiscomplete.userno
		, ModDate = NOW()
	WHERE ScheduleNo = ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
