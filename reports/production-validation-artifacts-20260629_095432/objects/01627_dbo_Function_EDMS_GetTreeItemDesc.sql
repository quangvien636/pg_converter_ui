-- ─── FUNCTION: edms_gettreeitemdesc ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_gettreeitemdesc();
CREATE OR REPLACE FUNCTION public.edms_gettreeitemdesc(
) RETURNS TABLE(
    col1 text,
    desc2 text,
    desc3 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT Desc1, Desc2, Desc3 FROM EDMSTreeItemDesc WHERE Id = Id And DivID = DivId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
