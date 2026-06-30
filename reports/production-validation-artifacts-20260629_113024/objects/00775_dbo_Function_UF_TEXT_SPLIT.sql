-- ─── FUNCTION: uf_text_split ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_text_split();
CREATE OR REPLACE FUNCTION public.uf_text_split(
) RETURNS TABLE(
    position integer,
    value character varying
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
DECLARE
    index integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
  
    -- Declare the return variable here   

    -- Add the T-SQL statements to compute the return value here   
    SET INDEX = -1   
       
    WHILE (LEN(text) > 0)   
    BEGIN  
        SET INDEX = STRPOS(TEXT, DELIMITER )   
           
        IF (INDEX = 0) AND (LEN(TEXT) > 0)   
        BEGIN  ;
            INSERT INTO STRINGS VALUES (TEXT)   
            BREAK   
        END  
           
        IF (INDEX > 1)   
        BEGIN  ;
            INSERT INTO STRINGS VALUES (LEFT(TEXT, INDEX - 1))   
            SET TEXT = RIGHT(TEXT, (LEN(TEXT) - INDEX))   
        END  
        ELSE  
            SET TEXT = RIGHT(TEXT, (LEN(TEXT) - INDEX))    
    END  
  
    -- Return the result of the function   
    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
