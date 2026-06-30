-- ─── PROCEDURE→FUNCTION: bslg_getuserinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getuserinfo(character varying, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.bslg_getuserinfo(
    IN userid character varying,
    IN orgcd integer,
    IN gradetype character varying,
    IN langindex integer
) RETURNS SETOF record
AS $function$
DECLARE
    userid character varying;
    langindex character varying;
    orgcd integer;
    gradetype character varying;
    username character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

userid := 'chang8026';
langindex := 1;
orgcd := 1081;
gradetype := 'c001';
*/


--한국어
IF langindex=4 THEN

	--이름가져오기
	SELECT usernm4 INTO username from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	IF (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || Etc3Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSIF (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || Etc3Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSE
			RETURN QUERY
			select username || ' ' || Etc3Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
END IF;
ELSIF langindex=3 THEN
	--이름가져오기
	SELECT usernm3 INTO username from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	IF (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || Etc2Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSIF (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || Etc2Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSE
			RETURN QUERY
			select username || ' ' || Etc2Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;

END IF;

ELSIF langindex=2 THEN
	--이름가져오기
	SELECT usernm2 INTO username from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	IF (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || Etc1Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSIF (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || Etc1Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSE
			RETURN QUERY
			select username || ' ' || Etc1Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;

END IF;
ELSE
	--이름가져오기
	SELECT usernm1 INTO username from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	IF (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || CommCdNm from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSIF (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0 THEN
			RETURN QUERY
			select username || ' ' || CommCdNm from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
	ELSE
			RETURN QUERY
			select username || ' ' || CommCdNm from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
