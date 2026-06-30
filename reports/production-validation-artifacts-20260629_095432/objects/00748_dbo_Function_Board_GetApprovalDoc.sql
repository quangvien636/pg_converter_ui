-- ─── FUNCTION: board_getapprovaldoc ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getapprovaldoc(integer);
CREATE OR REPLACE FUNCTION public.board_getapprovaldoc(
    contentno integer DEFAULT 5831
) RETURNS TABLE(
    contentno text,
    url text,
    name text,
    rn text
)
AS $function$
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
