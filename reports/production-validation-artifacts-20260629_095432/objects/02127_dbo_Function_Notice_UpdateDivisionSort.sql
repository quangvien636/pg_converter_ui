-- ─── FUNCTION: notice_updatedivisionsort ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updatedivisionsort(integer);
CREATE OR REPLACE FUNCTION public.notice_updatedivisionsort(
    sort integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here;
	UPDATE NoticeDivisions
	SET
		Sort = notice_updatedivisionsort.sort
	WHERE DivisionNo = DivisionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
