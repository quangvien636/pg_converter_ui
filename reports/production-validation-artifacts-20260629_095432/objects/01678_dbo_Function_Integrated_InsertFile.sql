-- ─── FUNCTION: integrated_insertfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_insertfile(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.integrated_insertfile(
    contentno bigint,
    name character varying,
    size integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Integrated_Files (ContentNo, Name, Size)
	VALUES (ContentNo, Name, Size)
	

	SET FileNo = lastval()
	
	RETURN QUERY
	SELECT FileNo

END;

--------------------------------/////////////////////-------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
