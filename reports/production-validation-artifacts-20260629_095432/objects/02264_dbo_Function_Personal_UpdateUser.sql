-- ─── FUNCTION: personal_updateuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_updateuser(timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.personal_updateuser(
    joindate timestamp without time zone,
    birthday timestamp without time zone,
    cellphone1 character varying,
    cellphone2 character varying,
    cellphone3 character varying,
    homezipcode1 character varying,
    homezipcode2 character varying,
    homeaddress1 character varying,
    homeaddress2 character varying,
    homephone1 character varying,
    homephone2 character varying,
    homephone3 character varying,
    sex character varying,
    hobby character varying,
    specialty character varying,
    sns character varying,
    blog character varying,
    selfintroduction character varying,
    companyphone character varying,
    extensionnumber character varying,
    photo character varying DEFAULT ''
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
