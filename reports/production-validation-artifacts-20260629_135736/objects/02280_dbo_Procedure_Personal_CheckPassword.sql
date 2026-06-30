-- ─── PROCEDURE→FUNCTION: personal_checkpassword ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.personal_checkpassword(character varying, character varying);
CREATE OR REPLACE FUNCTION public.personal_checkpassword(
    IN oldpwd character varying,
    IN newpwd1 character varying
) RETURNS SETOF record
AS $function$
DECLARE
    userid character varying;
    password character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	UserId := (SUBSTRING(UserID,0,STRPOS(UserId, '@')), Password = Password FROM Organization_Users WHERE UserNo = UserNo);
	-- 비밀번호에 아이디가 있으면
	IF STRPOS(NewPWD1, UserId) > 0 THEN
		RETURN QUERY
		SELECT -94
	END IF;
	ELSE
		-- 기존 비밀번호가 맞으면
		IF OldPWD = Password THEN
			-- 새비밀번호가 같으면
			IF NewPWD1 = NewPWD2 THEN
				-- 기존과 새 비밀번호가 틀릴 경우에만 업데이트
				IF OldPWD <> personal_checkpassword.newpwd1 THEN
					RETURN QUERY
					SELECT 1
				END IF;
				ELSE
					RETURN QUERY
					SELECT -93
				END IF;
			END IF;
			ELSE
				RETURN QUERY
				SELECT -92
			END IF;
		END IF;
		ELSE
			RETURN QUERY
			SELECT -91
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
