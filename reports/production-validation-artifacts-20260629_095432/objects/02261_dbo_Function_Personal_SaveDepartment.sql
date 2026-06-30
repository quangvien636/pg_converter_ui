-- ─── FUNCTION: personal_savedepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_savedepartment();
CREATE OR REPLACE FUNCTION public.personal_savedepartment(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
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


	SET ChkDepartInfo = REPLACE(DepartInfo,',','')
	
	IF LEN(ChkDepartInfo) > 0
	BEGIN
		
		SET DepartInfo = DepartInfo || '$'
		
		-- Row 분리 
		WHILE STRPOS(DepartInfo, '$') > 0
		BEGIN

			SET TempDepart = SUBSTRING(DepartInfo,0,STRPOS(DepartInfo, '$'))
			






			
			-- Column 분리
			WHILE STRPOS(',TempDepart, ') > 0
			BEGIN
				IF DepartCount = 0
					SET IsDefault = SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '))
				IF DepartCount = 1
					SET Seq = SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '))
				IF DepartCount = 2
					SET DepartNo = SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '))
				IF DepartCount = 3
					SET PositionNo = SUBSTRING(TempDepart,0,STRPOS(',TempDepart, '))	
				
				SET DepartCount = DepartCount + 1
				SET TempDepart = SUBSTRING(TempDepart,STRPOS(',TempDepart, ')+1,LEN(TempDepart))
			END
			SET DutyNo = TempDepart
			
			IF Seq = -1
			BEGIN;
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
			END
			ELSE
			BEGIN
			
				UPDATE Organization_BelongToDepartment SET
					DepartNo = DepartNo,
					PositionNo = PositionNo,
					DutyNo = DutyNo,
					IsDefault = IsDefault
				WHERE UserNo = UserNo
				
			END
			
			SET DepartInfo = SUBSTRING(DepartInfo,STRPOS(DepartInfo, '$')+1,LEN(DepartInfo))
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
