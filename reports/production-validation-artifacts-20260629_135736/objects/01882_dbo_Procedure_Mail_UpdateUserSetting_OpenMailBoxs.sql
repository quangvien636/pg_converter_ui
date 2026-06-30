-- ─── PROCEDURE→FUNCTION: mail_updateusersetting_openmailboxs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updateusersetting_openmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_updateusersetting_openmailboxs(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_UserSettings SET OpenMailBoxs = OpenMailBoxs
    WHERE UserNo = mail_updateusersetting_openmailboxs.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
