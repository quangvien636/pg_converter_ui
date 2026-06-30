-- ─── PROCEDURE→FUNCTION: personal_savedepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.personal_savedepartment();
CREATE OR REPLACE FUNCTION public.personal_savedepartment(
) RETURNS void
AS $function$
DECLARE
    chkdepartinfo character varying;
    tempdepart character varying;
    isdefault character varying;
    seq integer;
    departno integer;
    positionno integer;
    dutyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	ChkDepartInfo := REPLACE(DepartInfo,',','');
	IF LEN(ChkDepartInfo) > 0 THEN
		
		DepartInfo := DepartInfo || '$';
		-- Row 분리 
		WHILE STRPOS(DepartInfo, '$') > 0 LOOP

			TempDepart := SUBSTRING(DepartInfo,0,STRPOS(DepartInfo, '$'));

			
			-- Column 분리
			WHILE STRPOS(',TempDepart, ') > 0 LOOP
				IF DepartCount = 0 THEN
					IsDefault := SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '));
				IF DepartCount = 1 THEN
					Seq := SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '));
				IF DepartCount = 2 THEN
					DepartNo := SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '));
				IF DepartCount = 3 THEN
					PositionNo := SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '));
				DepartCount := DepartCount + 1;
				TempDepart := SUBSTRING(TempDepart,STRPOS(',TempDepart, ')+1,LEN(TempDepart));
			END LOOP;
			DutyNo := TempDepart;
			IF Seq = -1 THEN;
				DELETE FROM Organization_BelongToDepartment WHERE UserNo = UserNo
			
				INSERT INTO Organization_BelongToDepartment
				(
					UserNo,
					IsDefault,
					DepartNo,
					PositionNo,
					DutyNo
				)
				VALUES
				(
					UserNo,
					IsDefault,
					DepartNo,
					PositionNo,
					DutyNo
				)
			END IF;
			ELSE
			
				UPDATE Organization_BelongToDepartment SET
					DepartNo = DepartNo,
					PositionNo = PositionNo,
					DutyNo = DutyNo,
					IsDefault = IsDefault
				WHERE UserNo = UserNo
				
			END IF;
			
			DepartInfo := SUBSTRING(DepartInfo,STRPOS(DepartInfo, '$')+1,LEN(DepartInfo));
		END LOOP;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
