-- ─── PROCEDURE→FUNCTION: workingtime_savelocationoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_savelocationoutside(integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savelocationoutside(
    IN userno integer,
    IN name character varying,
    IN latitude character varying,
    IN longitude character varying,
    IN errorrange integer,
    IN description character varying,
    IN representation character varying,
    IN phonenumber character varying,
    IN p_description2 character varying,
    IN p_type integer,
    IN p_gtype integer
) RETURNS void
AS $function$
BEGIN

	IF LocationNo = 0 THEN;
		INSERT INTO WorkingTime_LocationsOutside
			   (RegUserNo
			   ,RegDate
			   ,ModUserNo
			   ,ModDate
			   ,Name
			   ,Latitude
			   ,Longitude
			   ,ErrorRange
			   ,Description
			   ,Representation
			   ,PhoneNumber
			   ,Description2
			   ,TType
			   ,GType)
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
			   ,Representation
			   ,PhoneNumber
			   ,p_Description2
			   ,p_type
			   ,p_gType
			   )
	END IF;
	ELSE;
		UPDATE WorkingTime_LocationsOutside
		   SET
			  ModUserNo = workingtime_savelocationoutside.userno
			  ,ModDate = NOW()
			  ,Name = workingtime_savelocationoutside.name
			  ,Latitude = workingtime_savelocationoutside.latitude
			  ,Longitude = workingtime_savelocationoutside.longitude
			  ,ErrorRange = workingtime_savelocationoutside.errorrange
			  ,Description = workingtime_savelocationoutside.description
			  ,Representation = workingtime_savelocationoutside.representation
			  ,PhoneNumber = workingtime_savelocationoutside.phonenumber
			  ,Description2 = workingtime_savelocationoutside.p_description2
			  ,TType = workingtime_savelocationoutside.p_type
			  ,GType = workingtime_savelocationoutside.p_gtype
		 WHERE LocationNo = LocationNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
