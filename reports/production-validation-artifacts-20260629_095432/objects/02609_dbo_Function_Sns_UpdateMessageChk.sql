-- ─── FUNCTION: sns_updatemessagechk ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_updatemessagechk(integer, integer);
CREATE OR REPLACE FUNCTION public.sns_updatemessagechk(
    groupno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE SnsMessageChk SET IsCheck = TRUE WHERE GroupNo=sns_updatemessagechk.groupno AND UserNo=sns_updatemessagechk.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
