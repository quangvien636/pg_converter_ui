-- ─── PROCEDURE→FUNCTION: integrated_getreplies ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_getreplies(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getreplies(
    IN contentno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ReplyNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, GroupNo, Depth, OrderNo, Content
	FROM Integrated_Replies
	WHERE ContentNo = integrated_getreplies.contentno
	ORDER BY GroupNo DESC, OrderNo ASC

END;


-----------------------// -----------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
