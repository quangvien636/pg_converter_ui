-- ─── PROCEDURE→FUNCTION: contacts_setcontactsuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_setcontactsuser(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_setcontactsuser(
    IN lastname character varying,
    IN firstname character varying,
    IN nicname character varying,
    IN reguserno integer,
    IN memo character varying,
    IN userpic character varying,
    IN groupno character varying,
    IN share character varying,
    IN seq integer
) RETURNS SETOF record
AS $function$
DECLARE
    rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Seq = 0 THEN
		INSERT INTO ContactsUser(LastName, FirstName, CallName, RegUserNo, Memo, Photo, RegDate, ModDate, CheckDate, Share, UseYn, Important)
		VALUES(LastName,FirstName,NicName,RegUserNo,Memo,UserPic, NOW(), NOW(), NOW(), Share, 'Y', 0);
		RTN := lastval();
	ELSE
		UPDATE ContactsUser SET FirstName=contacts_setcontactsuser.firstname, LastName=contacts_setcontactsuser.lastname,CallName=contacts_setcontactsuser.nicname,Memo=contacts_setcontactsuser.memo, RegDate = NOW(), Share=contacts_setcontactsuser.share WHERE Seq=contacts_setcontactsuser.seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=contacts_setcontactsuser.reguserno AND UserSeq=contacts_setcontactsuser.seq;
		RTN := contacts_setcontactsuser.seq;
	END IF;

	CREATE TEMP TABLE tab (GroupNo integer, UserSeq integer,RegUserNo integer) ON COMMIT DROP;
	WHILE STRPOS(',GroupNo, ') > 0 LOOP
		INSERT INTO tab(GroupNo,UserSeq,RegUserNo)
		VALUES (SUBSTRING(GroupNo,0,STRPOS(',GroupNo, ')),RTN,RegUserNo);
		GroupNo := SUBSTRING(GroupNo,STRPOS(',GroupNo, ')+1,LEN(GroupNo));
	END LOOP

	INSERT INTO tab VALUES (GroupNo,RTN,RegUserNo);
	INSERT INTO ContactsGroupUser
	(GroupNo,UserSeq,RegUserNo,RegDate,ModDate)
	SELECT GroupNo, UserSeq, RegUserNo, NOW(), NOW() FROM tab;

	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.