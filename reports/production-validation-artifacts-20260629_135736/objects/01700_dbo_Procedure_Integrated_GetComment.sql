-- ─── PROCEDURE→FUNCTION: integrated_getcomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_getcomment(integer);
CREATE OR REPLACE FUNCTION public.integrated_getcomment(
    IN integratedno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT CommentNo,C.RegUserNo,Name,C.RegDate,C.ModUserNo,C.ModDate,Content FROM Integrated_Comments C
	INNER JOIN Organization_Users U ON C.RegUserNo = U.UserNo
	WHERE IntegratedNo = integrated_getcomment.integratedno
	ORDER BY CommentNo DESC

END;


--------------------////////////////////---------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
