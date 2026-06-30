-- ─── FUNCTION: note_addandupdatelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addandupdatelist(uuid, character varying, uuid, integer, text, double precision, double precision, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_addandupdatelist(
    listno uuid,
    name character varying,
    groupno uuid,
    userno integer,
    description text,
    latitude double precision,
    longitude double precision,
    type integer,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
BEGIN


	IF (Type = 1) BEGIN

		INSERT INTO Note_List(ListNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate, DayEdit)
		VALUES (ListNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate, DayCreate)

	END

	IF (Type = 2) BEGIN

		UPDATE Note_List SET
			ListNo = note_addandupdatelist.listno,
			Name = note_addandupdatelist.name,
			GroupNo = note_addandupdatelist.groupno,
			Description = note_addandupdatelist.description,
			Latitude = note_addandupdatelist.latitude,
			Longitude = note_addandupdatelist.longitude,
			DayEdit = note_addandupdatelist.daycreate
		WHERE ListNo = note_addandupdatelist.listno

	END

	IF (Type = 3) BEGIN

		DELETE FROM Note_List WHERE ListNo = note_addandupdatelist.listno AND UserNo = note_addandupdatelist.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
