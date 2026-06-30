-- ─── FUNCTION: voteitemdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteitemdel(integer);
CREATE OR REPLACE FUNCTION public.voteitemdel(
    id integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTEItem WHERE ID = voteitemdel.id;
	DELETE FROM VOTESubItem WHERE ParentID = voteitemdel.id;
	DELETE FROM VOTEResult WHERE ParentID = voteitemdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
