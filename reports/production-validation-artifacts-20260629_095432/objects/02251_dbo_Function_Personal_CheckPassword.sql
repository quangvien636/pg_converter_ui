-- ─── FUNCTION: personal_checkpassword ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_checkpassword(character varying, character varying);
CREATE OR REPLACE FUNCTION public.personal_checkpassword(
    oldpwd character varying,
    newpwd1 character varying
) RETURNS TABLE(
    col1 text,
    col2 text
)
AS $function$
DECLARE
    userid character varying;
    password character varying;
BEGIN



	SELECT UserId = SUBSTRING(UserID,0,STRPOS(UserId, '@')), Password = Password FROM Organization_Users WHERE UserNo = UserNo
	-- 비밀번호에 아이디가 있으면
	IF (STRPOS(NewPWD1, UserId) > 0)
	BEGIN
		RETURN QUERY
		SELECT -94
	END
	ELSE
	BEGIN
		-- 기존 비밀번호가 맞으면
		IF OldPWD = Password
		BEGIN
			-- 새비밀번호가 같으면
			IF NewPWD1 = NewPWD2
			BEGIN
				-- 기존과 새 비밀번호가 틀릴 경우에만 업데이트
				IF OldPWD <> personal_checkpassword.newpwd1
				BEGIN
					RETURN QUERY
					SELECT 1
				END
				ELSE
				BEGIN
					RETURN QUERY
					SELECT -93
				END
			END
			ELSE
			BEGIN
				RETURN QUERY
				SELECT -92
			END 
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT -91
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
