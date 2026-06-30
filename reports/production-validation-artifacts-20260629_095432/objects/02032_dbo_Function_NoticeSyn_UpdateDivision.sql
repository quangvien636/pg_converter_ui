-- ─── FUNCTION: noticesyn_updatedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updatedivision(integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updatedivision(
    divisionno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE NoticeSyn_Divisions SET Name = Name, ModDate = NOW(), ModUserNo = noticesyn_updatedivision.userno
	WHERE DivisionNo = noticesyn_updatedivision.divisionno
	
END;


----------------------.////////////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
