-- ─── PROCEDURE→FUNCTION: contacts_deleteaddressall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_deleteaddressall(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deleteaddressall(
    IN seq integer,
    IN mode integer DEFAULT 1 -- 0 이면 완전삭제 1이면 비활성화 처리
) RETURNS void
AS $function$
BEGIN

	IF Mode = 0 -- 완전삭제 THEN
	
		EXEC public."Contacts_SaveContactsHistory" UserNo, Seq, 'DEL'
		
		DELETE FROM ContactsNumber WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsEmail WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsDays WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsCompany WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsAddress WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsSns WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=UserNo AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsUser WHERE RegUserNo=UserNo AND Seq=contacts_deleteaddressall.seq
	END IF;
	ELSE -- 보기만 비활성화 처리함
	BEGIN;
		UPDATE ContactsUser 
		UseYn := '',;
			ModDate = NOW(),
			DelDate = NOW()
		WHERE RegUserNo=UserNo AND Seq=contacts_deleteaddressall.seq
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
