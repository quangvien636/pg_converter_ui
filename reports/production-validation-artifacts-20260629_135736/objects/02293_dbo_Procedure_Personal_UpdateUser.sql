-- ─── PROCEDURE→FUNCTION: personal_updateuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.personal_updateuser(timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.personal_updateuser(
    IN joindate timestamp without time zone,
    IN birthday timestamp without time zone,
    IN cellphone1 character varying,
    IN cellphone2 character varying,
    IN cellphone3 character varying,
    IN homezipcode1 character varying,
    IN homezipcode2 character varying,
    IN homeaddress1 character varying,
    IN homeaddress2 character varying,
    IN homephone1 character varying,
    IN homephone2 character varying,
    IN homephone3 character varying,
    IN sex character varying,
    IN hobby character varying,
    IN specialty character varying,
    IN sns character varying,
    IN blog character varying,
    IN selfintroduction character varying,
    IN companyphone character varying,
    IN extensionnumber character varying,
    IN photo character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	SET
      ModUserNo = UserNo
      ,ModDate = NOW()
      ,JoinDate = personal_updateuser.joindate
      ,Birthday = personal_updateuser.birthday
      ,CellPhone1 = personal_updateuser.cellphone1
      ,CellPhone2 = personal_updateuser.cellphone2
      ,CellPhone3 = personal_updateuser.cellphone3
      ,HomeZipCode1 = personal_updateuser.homezipcode1
      ,HomeZipCode2 = personal_updateuser.homezipcode2
      ,HomeAddress1 = personal_updateuser.homeaddress1
      ,HomeAddress2 = personal_updateuser.homeaddress2
      ,HomePhone1 = personal_updateuser.homephone1
      ,HomePhone2 = personal_updateuser.homephone2
      ,HomePhone3 = personal_updateuser.homephone3
      ,Sex = personal_updateuser.sex
      ,Hobby = personal_updateuser.hobby
      ,Specialty = personal_updateuser.specialty
      ,SelfIntroduction = personal_updateuser.selfintroduction
      ,ExtensionNumber = personal_updateuser.extensionnumber
      ,Photo = personal_updateuser.photo
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
