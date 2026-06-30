-- ─── FUNCTION: mail_insertmailboxsharer ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailboxsharer(bigint, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertmailboxsharer(
    boxno bigint,
    reguserno integer,
    userno integer,
    positionno integer,
    departno integer,
    permission integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_MailBoxSharers
	VALUES(BoxNo, RegUserNo, UserNo, PositionNo, DepartNo, Permission)
	
	UPDATE Mail_MailBoxs SET IsShare = TRUE WHERE BoxNo = mail_insertmailboxsharer.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
