-- ─── FUNCTION: crewchat_getattachfiletobeforedate ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getattachfiletobeforedate(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfiletobeforedate(
    date timestamp without time zone
) RETURNS void
AS $function$
BEGIN

    -- INSERT INTO statements for procedure here
	SELECT AttachNo, FileName, FullPath, Type FROM CrewChat_Attach
	WHERE RegDate < crewchat_getattachfiletobeforedate.date
END


/****** Object:  StoredProcedure public."CrewChat_DeleteMessage"    Script Date: 2021-07-05 오후 4:36:22 ******/
SET ANSI_NULLS ON;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
