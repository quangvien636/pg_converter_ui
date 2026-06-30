-- ─── FUNCTION: mail_insertmailtag ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailtag(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertmailtag(
    userno integer,
    imageno integer
) RETURNS TABLE(
    tagno text
)
AS $function$
DECLARE
    tagno bigint;
BEGIN


	INSERT INTO Mail_MailTags (UserNo, ImageNo, Name, TotalCount, UnReadCount)
	VALUES (UserNo, ImageNo, Name, 0, 0)
	

	SET TagNo = lastval()
	
	RETURN QUERY
	SELECT TagNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
