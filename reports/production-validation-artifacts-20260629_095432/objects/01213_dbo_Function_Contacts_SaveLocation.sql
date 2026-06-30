-- ─── FUNCTION: contacts_savelocation ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_savelocation(integer, character varying, double precision, double precision, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_savelocation(
    userno integer,
    name character varying,
    latitude double precision,
    longitude double precision,
    errorrange integer,
    description character varying,
    contactuserid integer
) RETURNS void
AS $function$
BEGIN

	IF LocationNo = 0
	BEGIN;
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
	END
	ELSE
	BEGIN;
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

		 WHERE LocationNo = LocationNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
