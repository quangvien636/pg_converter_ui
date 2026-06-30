-- ─── FUNCTION: votemasterdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.votemasterdel(integer);
CREATE OR REPLACE FUNCTION public.votemasterdel(
    id integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTEMaster WHERE ID = votemasterdel.id;
	DELETE FROM VOTEQuestionnaire WHERE MasterID = votemasterdel.id;
	DELETE FROM VOTEItem WHERE ParentID = votemasterdel.id;
	DELETE FROM VOTESubItem WHERE MasterID = votemasterdel.id;
	DELETE FROM VOTEResult WHERE MasterID = votemasterdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
