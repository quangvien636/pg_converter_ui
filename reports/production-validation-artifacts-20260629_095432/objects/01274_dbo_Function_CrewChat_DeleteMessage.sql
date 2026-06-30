-- ─── FUNCTION: crewchat_deletemessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletemessage(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletemessage(
    messageno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_Messages WHERE MessageNo = crewchat_deletemessage.messageno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
