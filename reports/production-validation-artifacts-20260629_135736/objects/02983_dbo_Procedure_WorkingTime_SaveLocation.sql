-- ─── PROCEDURE→FUNCTION: workingtime_savelocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_savelocation(integer, character varying, double precision, double precision, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_savelocation(
    IN userno integer,
    IN name character varying,
    IN latitude double precision,
    IN longitude double precision,
    IN errorrange integer,
    IN p_type integer,
    IN p_gtype integer,
    IN description character varying DEFAULT '',
    IN p_description2 character varying DEFAULT '',
    IN p_representation character varying DEFAULT '',
    IN p_phonenumber character varying DEFAULT '',
    IN p_unos character varying DEFAULT '',
    IN p_dnos character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	IF LocationNo = 0 THEN;
		INSERT INTO WorkingTime_Locations
			   (RegUserNo
			   ,RegDate
			   ,ModUserNo
			   ,ModDate
			   ,Name
			   ,Latitude
			   ,Longitude
			   ,ErrorRange
			   ,Description
			   ,Description2
			   ,Representation
			   ,PhoneNumber
			   ,TType
			   ,GType,uids,dids)
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
			   ,p_Description2
			   ,p_Representation
			   ,p_PhoneNumber
			   ,p_type
			   ,p_gType,p_Unos,p_Dnos
			   )
	END IF;
	ELSE;
		UPDATE WorkingTime_Locations
		   SET
			  ModUserNo = workingtime_savelocation.userno
			  ,ModDate = NOW()
			  ,Name = workingtime_savelocation.name
			  ,Latitude = workingtime_savelocation.latitude
			  ,Longitude = workingtime_savelocation.longitude
			  ,ErrorRange = workingtime_savelocation.errorrange
			  ,Description = workingtime_savelocation.description
			  ,Description2 = workingtime_savelocation.p_description2
			  ,Representation = workingtime_savelocation.p_representation
			  ,PhoneNumber = workingtime_savelocation.p_phonenumber
			  ,TType = workingtime_savelocation.p_type
			  ,GType = workingtime_savelocation.p_gtype
			  ,uids = workingtime_savelocation.p_unos
			  ,dids =workingtime_savelocation.p_dnos
		 WHERE LocationNo = LocationNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
