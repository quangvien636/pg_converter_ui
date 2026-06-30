-- ─── FUNCTION: crewchat_allimageattachfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_allimageattachfiles();
CREATE OR REPLACE FUNCTION public.crewchat_allimageattachfiles(
) RETURNS TABLE(
    attachno serial,
    filename character varying(300),
    fullpath character varying(1000),
    type integer,
    size bigint,
    regdate timestamp without time zone,
    thumpath character varying(1000),
    thumbwidth integer,
    thumbheight integer,
    roomno bigint
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM CrewChat_Attach
	WHERE Type=1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
