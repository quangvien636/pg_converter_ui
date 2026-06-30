-- ─── FUNCTION: votesubitemdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.votesubitemdel(bigint);
CREATE OR REPLACE FUNCTION public.votesubitemdel(
    id bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTESubItem WHERE ID = votesubitemdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
