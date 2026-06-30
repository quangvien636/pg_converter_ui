-- ─── FUNCTION: fn_split_array ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_split_array(character varying);
CREATE OR REPLACE FUNCTION public.fn_split_array(
    string character varying
) RETURNS TABLE(
    items character varying
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
DECLARE
    index integer;
    slice character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



      SELECT index = 1
      IF String IS NULL RETURN
      WHILE index != 0
     BEGIN
         SELECT index = STRPOS(String, Delimiter)
         IF index !=0
             SELECT slice = left(String,index - 1)
         ELSE
             SELECT slice = fn_split_array.string;
         INSERT INTO Results(Items) VALUES(slice)
         SELECT String = RIGHT(String , LEN(String) - index)
         IF LEN(String) = 0 BREAK
     END   
 RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
