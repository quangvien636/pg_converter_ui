-- ─── FUNCTION: udf_striphtml ───────────────────────────────
DROP FUNCTION IF EXISTS public.udf_striphtml();
CREATE OR REPLACE FUNCTION public.udf_striphtml(
) RETURNS character varying
AS $function$
DECLARE
    start integer;
    end integer;
    length integer;
BEGIN




    SET Start = STRPOS(HTMLText, '<')
    SET End = STRPOS(HTMLText,CHARINDEX('<',HTMLText, '>'))
    SET Length = (End - Start) || 1
    WHILE Start > 0 AND End > 0 AND Length > 0
    BEGIN
        SET HTMLText = STUFF(HTMLText,Start,Length,'')
        SET Start = STRPOS(HTMLText, '<')
        SET End = STRPOS(HTMLText,CHARINDEX('<',HTMLText, '>'))
        SET Length = (End - Start) || 1
		
    END
	SET HTMLText = replace(replace(replace(HTMLText, '&amp;', ''), '&nbsp;', ' '), '&#x20;', ' ')
    RETURN LTRIM(RTRIM(HTMLText));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
