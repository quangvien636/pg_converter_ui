-- ─── PROCEDURE→FUNCTION: mail_updatemailaccount_name ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailaccount_name(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemailaccount_name(
    IN accountno bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Accounts SET ModUserNo = mail_updatemailaccount_name.moduserno, ModDate = mail_updatemailaccount_name.moddate, Name = Name
	WHERE AccountNo = mail_updatemailaccount_name.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
