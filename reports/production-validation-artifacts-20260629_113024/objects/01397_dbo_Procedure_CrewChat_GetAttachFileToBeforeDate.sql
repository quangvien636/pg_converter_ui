-- ─── PROCEDURE→FUNCTION: crewchat_getattachfiletobeforedate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_getattachfiletobeforedate(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfiletobeforedate(
    IN date timestamp without time zone
) RETURNS void
AS $function$
BEGIN

    -- INSERT INTO statements for procedure here
	SELECT AttachNo, FileName, FullPath, Type FROM CrewChat_Attach
	WHERE RegDate < crewchat_getattachfiletobeforedate.date
END;


/****** Object:  StoredProcedure public."CrewChat_DeleteMessage"    Script Date: 2021-07-05 오후 4:36:22 ******/
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
