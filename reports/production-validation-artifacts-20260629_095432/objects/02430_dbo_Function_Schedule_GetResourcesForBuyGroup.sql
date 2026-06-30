-- ─── FUNCTION: schedule_getresourcesforbuygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcesforbuygroup(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourcesforbuygroup(
    pagesize integer DEFAULT 10,
    currpage integer DEFAULT 1
) RETURNS TABLE(
    rownum text,
    resourceno text,
    name text,
    description text,
    status text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		*
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY ResourceNo ASC) AS RowNum,
			ResourceNo,
			Name,
			Description,
			CASE WHEN IsDisposed = TRUE THEN '폐기'
				 WHEN IsRepair = TRUE THEN '수리중'
				 WHEN Enabled = TRUE THEN '사용가능'
				 ELSE '사용불가'
			END AS Status
		FROM ScheduleResources
		WHERE BuyGroupNo = BuyGroupNo
	) A
	WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
