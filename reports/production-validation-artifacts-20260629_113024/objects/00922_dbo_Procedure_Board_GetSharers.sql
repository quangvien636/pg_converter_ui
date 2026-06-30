-- ─── PROCEDURE→FUNCTION: board_getsharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getsharers(integer);
CREATE OR REPLACE FUNCTION public.board_getsharers(
    IN contentno integer DEFAULT 4741
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT BS.DepartNo,BS.DepartName,BS.IsChild,BS.UserNo ,U.UserID AS UserName
	FROM Board_Sharers BS
	LEFT JOIN ORGANIZATION_USERS U on U.UserNo=BS.UserNo
	WHERE ContentNo = board_getsharers.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
