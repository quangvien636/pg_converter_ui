-- ─── FUNCTION: crewchat_deletecheckmessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletecheckmessage(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletecheckmessage(
    messageno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_CheckMessage WHERE MessageNo = crewchat_deletecheckmessage.messageno
END


/****** Object:  StoredProcedure public."CrewChat_GetChatAllMessages"    Script Date: 2021-07-05 오후 4:28:16 ******/
SET ANSI_NULLS ON;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
