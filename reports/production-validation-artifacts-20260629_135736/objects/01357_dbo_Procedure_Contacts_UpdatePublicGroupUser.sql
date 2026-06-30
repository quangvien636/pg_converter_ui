-- ─── PROCEDURE→FUNCTION: contacts_updatepublicgroupuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatepublicgroupuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatepublicgroupuser(
    IN userno integer DEFAULT 70,
    IN groupno integer DEFAULT 8,
    IN userseq integer DEFAULT 7999
) RETURNS void
AS $function$
BEGIN

	UPDATE Contact_ShareGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatepublicgroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatepublicgroupuser.userseq;
	DELETE FROM ContactsGroupUser  WHERE   UserSeq=contacts_updatepublicgroupuser.userseq 
	IF EXISTS(SELECT No FROM Contact_PublicGroupUser PG WHERE PG.PublicGroupNo=contacts_updatepublicgroupuser.groupno AND  PG.UserSeq=contacts_updatepublicgroupuser.userseq AND IsDelete= FALSE  );
		UPDATE Contact_PublicGroupUser SET PublicGroupNo=contacts_updatepublicgroupuser.groupno,UserSeq=contacts_updatepublicgroupuser.userseq,ModUserNo=contacts_updatepublicgroupuser.userno,ModDate=NOW() WHERE PublicGroupNo=contacts_updatepublicgroupuser.groupno AND  UserSeq=contacts_updatepublicgroupuser.userseq AND IsDelete= FALSE 
	ELSE;
		INSERT INTO Contact_PublicGroupUser(PublicGroupNo,UserSeq,RegUserNo,ModUserNo) VALUES(GroupNo,UserSeq,UserNo,UserNo);
	SELECT No FROM Contact_PublicGroupUser PG WHERE PG.PublicGroupNo=contacts_updatepublicgroupuser.groupno AND  PG.UserSeq=contacts_updatepublicgroupuser.userseq AND IsDelete= FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
