-- ─── FUNCTION: votesubitemmod ───────────────────────────────
DROP FUNCTION IF EXISTS public.votesubitemmod(bigint, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.votesubitemmod(
    id bigint,
    parentid integer,
    masterid integer,
    title character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTESubItem
	SET Title = votesubitemmod.title
	WHERE MasterID = votesubitemmod.masterid AND ParentID = votesubitemmod.parentid AND ID = votesubitemmod.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
