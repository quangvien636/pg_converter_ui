-- ─── FUNCTION: note_sendnote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_sendnote(character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.note_sendnote(
    contents character varying,
    touserlist character varying,
    ismail boolean DEFAULT 0 -- 메일전송
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    noteboxno integer;
    noteno integer;
    chktouserlist character varying;
    temptouserlist character varying;
    tempuserno integer;
    tempdepartno integer;
    usernolist table (
			userno int
		);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	-- 발신자의 쪽지함 여부 
	SELECT NoteBoxNo = NoteBoxNo FROM NoteBox WHERE UserNo = UserNo AND BoxType = 'O'
	
	-- 발신자 정보에 입력;
	INSERT INTO NoteList
           (SendNoteNo
           ,UserNo
           ,SendUserNo
           ,SendDate
           ,Contents
           ,NoteBoxNo
           ,IsRead
           ,ReadDate)
     VALUES
           (
           0
           ,UserNo
           ,UserNo
           ,NOW()
           ,Contents
           ,NoteBoxNo
           ,0
           ,'1900-01-01 00:00:00')
           
     SET NoteNo = lastval()
     

     SET ChkToUserList = REPLACE(ToUserList,',','')
     -- 수신 사용자 등록 처리
     IF LEN(ChkToUserList) > 0
     BEGIN
		SET ToUserList = note_sendnote.touserlist || ','
		
		WHILE STRPOS(',ToUserList, ') > 0
		BEGIN

			SET TempToUserList = SUBSTRING(ToUserList,0,STRPOS(',ToUserList, '))
			


			-- 부서 사용자 구분			
			IF STRPOS(TempToUserList, '|') > 0
			BEGIN
				SET TempDepartNo = CONVERT(INT,SUBSTRING(TempToUserList,0,STRPOS(TempToUserList, '|')))
				SET TempUserNo = 0
			END
			ELSE
			BEGIN
				SET TempDepartNo = 0
				SET TempUserNo = CONVERT(INT,TempToUserList)
			END
			-- 수신 사용자 등록;
			INSERT INTO NoteReceiveUser
			(
				NoteNo,
				UserNo,
				DepartNo
			)
			VALUES
			(
				NoteNo,
				TempUserNo,
				TempDepartNo
			)
			SET ToUserList = SUBSTRING(ToUserList,STRPOS(',ToUserList, ')+1,LEN(ToUserList))
		END
		

		-- 사용자 정보 등록 (사용자);
		INSERT INTO UserNoList
		RETURN QUERY
		SELECT UserNo 
		FROM NoteReceiveUser
		WHERE NoteNo = NoteNo
		AND DepartNo = 0
		AND UserNo <> 0
		-- 사용자 정보 등록 (부서);
		INSERT INTO UserNoList
		RETURN QUERY
		SELECT UserNo
		FROM BelongToDepartment
		WHERE DepartNo IN (SELECT DepartNo 
							FROM NoteReceiveUser 
							WHERE NoteNo = NoteNo 
							AND DepartNo <> 0
							AND UserNo = 0
						) 
		-- 수신 처리;
		INSERT INTO NoteList
		(
			SendNoteNo
           ,UserNo
           ,SendUserNo
           ,SendDate
           ,Contents
           ,NoteBoxNo
           ,IsRead
           ,ReadDate
		)
		RETURN QUERY
		SELECT
			N.NoteNo
			,U.UserNo
			,N.UserNo
			,NOW()
			,N.Contents
			,CASE WHEN U.UserNo <> UserNo THEN (SELECT NoteBoxNo FROM NoteBox B WHERE B.UserNo = U.UserNo AND BoxType = 'I') -- 타인에게 보내는 경우 
				                           ELSE (SELECT NoteBoxNo FROM NoteBox B WHERE B.UserNo = U.UserNo AND BoxType = 'M') -- 본인에게 보내는 경우
			 END
			,0
			,'1900-01-01 00:00:00'
		FROM NoteList N,
		(SELECT DISTINCT UserNo FROM UserNoList) U
		WHERE N.NoteNo = NoteNo
     END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
