-- ─── PROCEDURE→FUNCTION: organization_updateuser_photo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateuser_photo(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateuser_photo(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN userphoto boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Users SET
		ModUserNo = organization_updateuser_photo.moduserno,
		ModDate = organization_updateuser_photo.moddate,
		UserPhoto = organization_updateuser_photo.userphoto,
		Photo = Photo
	WHERE UserNo = organization_updateuser_photo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
