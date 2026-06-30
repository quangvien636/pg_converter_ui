-- ─── FUNCTION: bslg_getuserinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getuserinfo(character varying, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.bslg_getuserinfo(
    userid character varying,
    orgcd integer,
    gradetype character varying,
    langindex integer
) RETURNS TABLE(
    posfg1 text
)
AS $function$
DECLARE
    userid character varying;
    langindex character varying;
    orgcd integer;
    gradetype character varying;
    username character varying;
BEGIN
/*

set userid='chang8026'


set langindex=1


set orgcd = 1081


set gradetype = 'c001'
*/


--한국어
if langindex=4
begin

	--이름가져오기
	select username=usernm4 from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	if (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || Etc3Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else if (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || Etc3Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else
		begin
			RETURN QUERY
			select username || ' ' || Etc3Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
end
else if langindex=3
begin
	--이름가져오기
	select username=usernm3 from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	if (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || Etc2Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else if (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || Etc2Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else
		begin
			RETURN QUERY
			select username || ' ' || Etc2Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end

end

else if langindex=2
begin
	--이름가져오기
	select username=usernm2 from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	if (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || Etc1Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else if (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || Etc1Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else
		begin
			RETURN QUERY
			select username || ' ' || Etc1Cd from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end

end
else 
begin
	--이름가져오기
	select username=usernm1 from cmonusers where userid=bslg_getuserinfo.userid

	--직책가져오기
	if (select count(*) from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || CommCdNm from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg3 from cmonusers where orgcd3=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else if (select count(*) from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)<>0
		begin
			RETURN QUERY
			select username || ' ' || CommCdNm from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg2 from cmonusers where orgcd2=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end
	else
		begin
			RETURN QUERY
			select username || ' ' || CommCdNm from cmoncommcd where classcd=bslg_getuserinfo.gradetype and commcd=(select Posfg1 from cmonusers where orgcd1=bslg_getuserinfo.orgcd and userid=bslg_getuserinfo.userid)

		end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
