-- ─── PROCEDURE→FUNCTION: schedule_updatedivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatedivision(integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updatedivision(
    IN divisionno integer,
    IN name character varying,
    IN nameen character varying,
    IN namejp character varying,
    IN namech character varying,
    IN namevn character varying
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleDivisions
	Name := schedule_updatedivision.name,;
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
