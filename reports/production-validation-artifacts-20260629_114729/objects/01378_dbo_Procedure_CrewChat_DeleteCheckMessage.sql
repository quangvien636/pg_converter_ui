-- ─── PROCEDURE→FUNCTION: crewchat_deletecheckmessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletecheckmessage(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletecheckmessage(
    IN messageno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_CheckMessage WHERE MessageNo = crewchat_deletecheckmessage.messageno
END;


/****** Object:  StoredProcedure public."CrewChat_GetChatAllMessages"    Script Date: 2021-07-05 오후 4:28:16 ******/
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
