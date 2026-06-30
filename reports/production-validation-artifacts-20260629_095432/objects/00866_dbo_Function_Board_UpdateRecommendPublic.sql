-- ─── FUNCTION: board_updaterecommendpublic ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updaterecommendpublic(bigint, boolean);
CREATE OR REPLACE FUNCTION public.board_updaterecommendpublic(
    contentno bigint,
    isrecommendpublic boolean
) RETURNS TABLE(
    contentno text
)
AS $function$
BEGIN



	
	UPDATE Board_Contents SET IsRecommendPublic = board_updaterecommendpublic.isrecommendpublic  WHERE ContentNo = board_updaterecommendpublic.contentno
	RETURN QUERY
	SELECT ContentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
