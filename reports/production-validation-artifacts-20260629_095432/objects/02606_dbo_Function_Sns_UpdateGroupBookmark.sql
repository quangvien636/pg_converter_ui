-- ─── FUNCTION: sns_updategroupbookmark ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_updategroupbookmark(integer);
CREATE OR REPLACE FUNCTION public.sns_updategroupbookmark(
    groupuserno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    isbookmark boolean;
BEGIN



	SELECT IsBookmark=IsBookmark FROM SnsGroupUsers WHERE GroupUserNo=sns_updategroupbookmark.groupuserno
	
	IF IsBookmark = FALSE
	BEGIN
		SET IsBookmark = TRUE
	END
	ELSE
	BEGIN
		SET IsBookmark = FALSE
	END
	
	UPDATE SnsGroupUsers SET IsBookmark = IsBookmark WHERE GroupUserNo=sns_updategroupbookmark.groupuserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
