-- ─── PROCEDURE→FUNCTION: mail_insertmailboxsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_insertmailboxsharer(bigint, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertmailboxsharer(
    IN boxno bigint,
    IN reguserno integer,
    IN userno integer,
    IN positionno integer,
    IN departno integer,
    IN permission integer
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
