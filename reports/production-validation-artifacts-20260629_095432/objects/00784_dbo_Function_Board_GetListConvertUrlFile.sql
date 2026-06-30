-- ─── FUNCTION: board_getlistconverturlfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getlistconverturlfile();
CREATE OR REPLACE FUNCTION public.board_getlistconverturlfile(
) RETURNS TABLE(
    fileno bigserial,
    contentno bigint,
    name character varying(260),
    size integer,
    url text,
    sort integer
)
AS $function$
BEGIN
RETURN QUERY
SELECT * FROM Board_Files;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
