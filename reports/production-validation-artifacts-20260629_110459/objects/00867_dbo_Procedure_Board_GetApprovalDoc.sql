-- ─── PROCEDURE→FUNCTION: board_getapprovaldoc ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getapprovaldoc(integer);
CREATE OR REPLACE FUNCTION public.board_getapprovaldoc(
    IN contentno integer DEFAULT 5831
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT C.ContentNo,C.Title,C.Title,C.Type,C.ApplyTo,C.DesignNo,C.BadNo,F.Name AS FileName,F.Url AS FileUrl
FROM Board_Contents C
LEFT JOIN (SELECT ContentNo,Url,Name,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=C.ContentNo AND F.Rn=1
where C.ContentNo=board_getapprovaldoc.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
