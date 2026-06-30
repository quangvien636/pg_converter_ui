-- ─── PROCEDURE→FUNCTION: contacts_deleteaddressall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_deleteaddressall(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deleteaddressall(
    IN userno integer,
    IN seq integer,
    IN mode integer DEFAULT 1
) RETURNS void
AS $function$
BEGIN

	IF Mode = 0 THEN -- 완전삭제

		EXEC public."Contacts_SaveContactsHistory" UserNo, Seq, 'DEL';

		DELETE FROM ContactsNumber WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsEmail WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsDays WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsCompany WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsAddress WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsSns WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsUser WHERE RegUserNo=contacts_deleteaddressall.userno AND Seq=contacts_deleteaddressall.seq
	ELSE
	    -- 보기만 비활성화 처리함;
	END IF;
	BEGIN
		UPDATE ContactsUser
		SET
			UseYn = '',
			ModDate = NOW(),
			DelDate = NOW()
		WHERE RegUserNo=contacts_deleteaddressall.userno AND Seq=contacts_deleteaddressall.seq
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.