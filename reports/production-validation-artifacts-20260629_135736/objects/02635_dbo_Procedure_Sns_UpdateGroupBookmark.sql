-- ─── PROCEDURE→FUNCTION: sns_updategroupbookmark ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_updategroupbookmark(integer);
CREATE OR REPLACE FUNCTION public.sns_updategroupbookmark(
    IN groupuserno integer
) RETURNS SETOF record
AS $function$
DECLARE
    isbookmark boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT IsBookmark INTO isbookmark FROM SnsGroupUsers WHERE GroupUserNo=sns_updategroupbookmark.groupuserno
	
	IF IsBookmark = FALSE THEN
		IsBookmark := 1;
	END IF;
	ELSE
		IsBookmark := 0;
	END IF;
	
	UPDATE SnsGroupUsers SET IsBookmark = IsBookmark WHERE GroupUserNo=sns_updategroupbookmark.groupuserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
