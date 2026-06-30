-- ─── FUNCTION: notice_updatedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updatedivision(integer, integer);
CREATE OR REPLACE FUNCTION public.notice_updatedivision(
    divisionno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE NoticeDivisions SET Name = Name, ModDate = NOW(), ModUserNo = notice_updatedivision.userno
	WHERE DivisionNo = notice_updatedivision.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
