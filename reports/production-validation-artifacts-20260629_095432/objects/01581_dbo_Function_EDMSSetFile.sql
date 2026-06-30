-- ─── FUNCTION: edmssetfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmssetfile(character varying);
CREATE OR REPLACE FUNCTION public.edmssetfile(
    fileid character varying
) RETURNS void
AS $function$
BEGIN
		--이디엠에스테이블에 등록.;
		UPDATE	EDMSFILE
		SET		ContentId	=	@IDENTITY
		,		Length		=	Length
		WHERE	ID			=	edmssetfile.fileid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
