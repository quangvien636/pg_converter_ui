-- ─── PROCEDURE→FUNCTION: contacts_savelocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_savelocation(integer, character varying, double precision, double precision, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_savelocation(
    IN userno integer,
    IN name character varying,
    IN latitude double precision,
    IN longitude double precision,
    IN errorrange integer,
    IN description character varying,
    IN contactuserid integer,
    IN locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF LocationNo = 0 THEN
		INSERT INTO Contacts_Locations
			   (RegUserNo
			   ,RegDate
			   ,ModUserNo
			   ,ModDate
			   ,Name
			   ,Latitude
			   ,Longitude
			   ,ErrorRange
			   ,Description
			   ,ContactUserId)
		 VALUES
			   (UserNo
			   ,NOW()
			   ,UserNo
			   ,NOW()
			   ,Name
			   ,Latitude
			   ,Longitude
			   ,ErrorRange
			   ,Description
			   ,ContactUserId
			   )
	ELSE
	BEGIN
		UPDATE Contacts_Locations
		   SET
			  ModUserNo = contacts_savelocation.userno
			  ,ModDate = NOW()
			  ,Name = contacts_savelocation.name
			  ,Latitude = contacts_savelocation.latitude
			  ,Longitude = contacts_savelocation.longitude
			  ,ErrorRange = contacts_savelocation.errorrange
			  ,Description = contacts_savelocation.description
			  ,ContactUserId=contacts_savelocation.contactuserid

		 WHERE LocationNo = contacts_savelocation.locationno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.