-- ─── FUNCTION: board_insertfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertfile(bigint, character varying, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_insertfile(
    contentno bigint DEFAULT 5785,
    name character varying DEFAULT '2023-T5-2X(VN-SB)(9).pdf',
    size integer DEFAULT 107432,
    filepath character varying DEFAULT '/_Repository/_Board/Attach/5785/2023-T5-2X(VN-SB)(9).pdf',
    sort integer DEFAULT 0
) RETURNS TABLE(
    fileno text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Board_Files (ContentNo, Name, Size,Url,Sort)
	VALUES (ContentNo, Name, Size,FilePath,Sort)
	

	SET FileNo = lastval()
	
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
