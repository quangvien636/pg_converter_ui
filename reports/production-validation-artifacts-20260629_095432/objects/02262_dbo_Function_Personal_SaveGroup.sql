-- ─── FUNCTION: personal_savegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_savegroup();
CREATE OR REPLACE FUNCTION public.personal_savegroup(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupNo = -1
	BEGIN;
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
		
		SET GroupNo = lastval()
		
		
	END
	ELSE
	BEGIN;
		UPDATE PersonalGroup
		SET
			ModUserNo = UserNo,
			ModDate = NOW(),
			GroupName = GroupName,
			Description = Description,
			ShareType = ShareType,
			DepartNo = DepartNo
		WHERE GroupNo = GroupNo
	END
	
	SET UserList = UserList || ',';
	

	-- 기존 구성원 삭제;
	DELETE FROM PersonalGroupUser WHERE GroupNo = GroupNo
	
	WHILE STRPOS(',UserList, ') > 0
	BEGIN
		SET GroupUserNo = SUBSTRING(UserList,0,STRPOS(',UserList, '))
		
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
		SET UserList = SUBSTRING(UserList,STRPOS(',UserList, ')+1,LEN(UserList))
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
