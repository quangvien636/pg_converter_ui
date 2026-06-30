-- ─── PROCEDURE→FUNCTION: noticesyn_updatedivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updatedivision(integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updatedivision(
    IN divisionno integer,
    IN userno integer
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
