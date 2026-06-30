-- ─── PROCEDURE→FUNCTION: note_addandupdatelist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_addandupdatelist(uuid, character varying, uuid, integer, text, double precision, double precision, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_addandupdatelist(
    IN listno uuid,
    IN name character varying,
    IN groupno uuid,
    IN userno integer,
    IN description text,
    IN latitude double precision,
    IN longitude double precision,
    IN type integer,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
BEGIN


	IF Type = 1 THEN

		INSERT INTO Note_List(ListNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate, DayEdit)
		VALUES (ListNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate, DayCreate)

	END IF;

	IF Type = 2 THEN

		UPDATE Note_List SET
			ListNo = note_addandupdatelist.listno,
			Name = note_addandupdatelist.name,
			GroupNo = note_addandupdatelist.groupno,
			Description = note_addandupdatelist.description,
			Latitude = note_addandupdatelist.latitude,
			Longitude = note_addandupdatelist.longitude,
			DayEdit = note_addandupdatelist.daycreate
		WHERE ListNo = note_addandupdatelist.listno

	END IF;

	IF Type = 3 THEN

		DELETE FROM Note_List WHERE ListNo = note_addandupdatelist.listno AND UserNo = note_addandupdatelist.userno

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
