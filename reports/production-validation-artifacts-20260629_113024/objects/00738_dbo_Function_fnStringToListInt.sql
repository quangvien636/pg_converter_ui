-- ─── FUNCTION: fnstringtolistint ───────────────────────────────
DROP FUNCTION IF EXISTS public.fnstringtolistint();
CREATE OR REPLACE FUNCTION public.fnstringtolistint(
) RETURNS TABLE(
    item integer
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



    SET List = LTRIM(RTRIM(List))+ ','
    SET Pos = STRPOS(', List, 1, ')

    WHILE Pos > 0
    BEGIN
        SET item = LTRIM(RTRIM(LEFT(List, Pos - 1)))
        IF item <> ''
        BEGIN;
            INSERT INTO ParsedList (item) 
            VALUES (CAST(item AS int))
        END
        SET List = RIGHT(List, LEN(List) - Pos)
        SET Pos = STRPOS(', List, 1, ')
    END

    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
