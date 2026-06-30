-- ─── FUNCTION: center_getbizsoftnotifymail ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getbizsoftnotifymail();
CREATE OR REPLACE FUNCTION public.center_getbizsoftnotifymail(
) RETURNS TABLE(
    rsvnno text,
    regdate text,
    reguserno text,
    module text,
    moduleno text,
    rsvnsenddate text,
    fromname text,
    fromaddr text,
    mailto text,
    cc text,
    bcc text,
    subject text,
    contents text,
    attach text,
    isonebyone text,
    ispriority text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
			RsvnNo
		  ,RegDate
		  ,RegUserNo
		  ,Module
		  ,ModuleNo
		  ,REPLACE(CONVERT(VARCHAR,RsvnSendDate,112) + CONVERT(VARCHAR,RsvnSendDate,108),':','') AS RsvnSendDate
		  ,FromName
		  ,FromAddr
		  ,MailTo
		  ,Cc
		  ,Bcc
		  ,Subject
		  ,Contents
		  ,Attach
		  ,IsOneByOne
		  ,IsPriority
	FROM BizSoftNotifyMail;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
