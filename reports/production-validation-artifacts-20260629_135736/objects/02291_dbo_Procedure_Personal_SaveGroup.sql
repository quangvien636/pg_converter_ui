-- ─── PROCEDURE→FUNCTION: personal_savegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.personal_savegroup();
CREATE OR REPLACE FUNCTION public.personal_savegroup(
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupNo = -1 THEN;
		INSERT INTO PersonalGroup
			   (RegUserNo
			   ,RegDate
			   ,ModUserNo
			   ,ModDate
			   ,GroupName
			   ,Description
			   ,ShareType
			   ,DepartNo)
		 VALUES
			   (UserNo
			   ,NOW()
			   ,UserNo
			   ,NOW()
			   ,GroupName
			   ,Description
			   ,ShareType
			   ,DepartNo)
		
		GroupNo := lastval();
	END IF;
	ELSE;
		UPDATE PersonalGroup
		ModUserNo := UserNo,;
			ModDate = NOW(),
			GroupName = GroupName,
			Description = Description,
			ShareType = ShareType,
			DepartNo = DepartNo
		WHERE GroupNo = GroupNo
	END IF;
	
	UserList := UserList || ',';

	-- 기존 구성원 삭제;
	DELETE FROM PersonalGroupUser WHERE GroupNo = GroupNo
	
	WHILE STRPOS(',UserList, ') > 0 LOOP
		GroupUserNo := SUBSTRING(UserList,0,STRPOS(',UserList, '));;
		INSERT INTO PersonalGroupUser
		(
			GroupNo,
			SeqNo,
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			UserNo
		)
		VALUES
		(
			GroupNo,
			(SELECT COALESCE(MAX(SeqNo),0)+1 FROM PersonalGroupUser WHERE GroupNo = GroupNo),
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			GroupUserNo
		)
		UserList := SUBSTRING(UserList,STRPOS(',UserList, ')+1,LEN(UserList));
	END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
