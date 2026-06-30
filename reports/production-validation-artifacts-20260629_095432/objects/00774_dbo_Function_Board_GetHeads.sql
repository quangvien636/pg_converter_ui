-- ─── FUNCTION: board_getheads ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getheads(integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getheads(
    boardno integer,
    isdisabled boolean
) RETURNS TABLE(
    headno text,
    boardno text,
    moduserno text,
    moddate text,
    name text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	IF (IsDisabled = TRUE) BEGIN
	
		RETURN QUERY
		SELECT HeadNo, BoardNo, ModUserNo, ModDate, Name, SortNo, Enabled
		FROM Board_Heads
		ORDER BY SortNO ASC
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT HeadNo, BoardNo, ModUserNo, ModDate, Name, SortNo, Enabled
		FROM Board_Heads
		WHERE Enabled = TRUE
		ORDER BY SortNO ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
