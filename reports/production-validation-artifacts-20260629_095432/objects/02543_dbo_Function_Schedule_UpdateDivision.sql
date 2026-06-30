-- ─── FUNCTION: schedule_updatedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatedivision(integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updatedivision(
    divisionno integer,
    name character varying,
    nameen character varying,
    namejp character varying,
    namech character varying,
    namevn character varying
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleDivisions
	SET
		Name = schedule_updatedivision.name,
		NameEn = schedule_updatedivision.nameen,
		NameJp = schedule_updatedivision.namejp,
		NameCh = schedule_updatedivision.namech,
		NameVn = schedule_updatedivision.namevn,
		Color = Color,
		ModUserNo = UserNo,
		ModDate = NOW()
	WHERE DivisionNo = schedule_updatedivision.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
