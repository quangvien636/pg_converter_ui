-- ─── FUNCTION: schedule_deleteresourcecategories ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresourcecategories(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcecategories(
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResourceCategories
	SET
		ModUserNo = schedule_deleteresourcecategories.userno,
		ModDate = NOW(),
		Enabled = FALSE
	WHERE CategoryNo = CategoryNo
	
	UPDATE ScheduleResources
	SET 
		Enabled = FALSE
	WHERE CategoryNo = CategoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
