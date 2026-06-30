-- ─── PROCEDURE→FUNCTION: mail_updateusersetting_usesign ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updateusersetting_usesign(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_updateusersetting_usesign(
    IN userno integer,
    IN usesign boolean
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_UserSettings SET UseSign = mail_updateusersetting_usesign.usesign
    WHERE UserNo = mail_updateusersetting_usesign.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
