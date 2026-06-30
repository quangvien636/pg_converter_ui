-- ─── FUNCTION: board_setcontentsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_setcontentsetting(integer, character varying);
CREATE OR REPLACE FUNCTION public.board_setcontentsetting(
    boardno integer,
    contentsetting character varying
) RETURNS void
AS $function$
BEGIN

DELETE FROM public."Board_ContentSetting" WHERE BoardNo= board_setcontentsetting.boardno;
INSERT INTO public."Board_ContentSetting"(BoardNo,ContentSetting)VALUES( BoardNo,  ContentSetting);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
