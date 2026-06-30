-- ─── FUNCTION: note_addandupdatelistnew ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addandupdatelistnew(uuid, character varying, uuid, integer, character varying, double precision, double precision, double precision, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.note_addandupdatelistnew(
    listno uuid,
    name character varying,
    groupno uuid,
    userno integer,
    description character varying,
    latitude double precision,
    longitude double precision,
    notetimezone double precision,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE',
    listuserno character varying DEFAULT NULL
) RETURNS TABLE(
    shareno text,
    usershare text,
    sharetype text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    results table (shareuser int, sharetype int);
    slip character varying;
    tempuserno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT CheckListNo = note_addandupdatelistnew.listno, TempUser = note_addandupdatelistnew.userno FROM Note_List WHERE ListNo = note_addandupdatelistnew.listno





	IF CheckListNo = '00000000-0000-0000-0000-000000000000'
	BEGIN;
		INSERT INTO Note_List (ListNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate, DayEdit, NoteTimeZoneCreate, NoteTimeZoneEdit)
						VALUES(ListNo,Name,GroupNo,UserNo,Description,Latitude,Longitude,DayCreate,DayCreate, NoteTimeZone, NoteTimeZone)

		IF LEN(ListUserNo) > 0 AND ListUserNo != '0' AND ListUserNo != 'D'
		BEGIN BEGIN TRANSACTION UpdateShareNote

			WHILE index != 0
			 BEGIN
				 SET index = STRPOS(ListUserNo, '#')
				 IF index !=0 BEGIN
					 SET Slip = left(ListUserNo,index - 1)
					 IF ISNUMERIC(Slip) = 1 BEGIN
						SET ShareUser = Slip
						SET ShareType = 2
					 END
					 ELSE BEGIN
						SET indexUser = STRPOS(Slip, '|')
						SET ShareUser = left(Slip,indexUser - 1)
						SET ShareType = RIGHT(Slip , LEN(Slip) - indexUser)
					 END
				 END 
				 ELSE BEGIN
					 SET ShareUser = note_addandupdatelistnew.listuserno
				 END

				 IF ShareUser != 0 AND ShareUser != note_addandupdatelistnew.userno BEGIN
					SET UserGroupNo = '00000000-0000-0000-0000-000000000000'
					IF ShareType = 2 BEGIN
						SELECT UserGroupNo = note_addandupdatelistnew.groupno FROM Note_Group where UserNo = ShareUser AND CheckDelete = 1
					END
					IF ListNo != '00000000-0000-0000-0000-000000000000' BEGIN;
					INSERT INTO Note_Share(ShareNo,UserNo,ListNo,DayCreate,DayEdit,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
						   VALUES(NEWID (),UserNo,ListNo,DayCreate,DayCreate,ShareUser,UserGroupNo,ShareType,DayCreate,NoteTimeZone)
					END
				END

				 SET ListUserNo = RIGHT(ListUserNo , LEN(ListUserNo) - index)
				 IF LEN(ListUserNo) = 0 BREAK
			 END  

			COMMIT TRAN UpdateShareNote
		END 
	END
	ELSE
	BEGIN ;
		UPDATE Note_List
		SET ListNo=note_addandupdatelistnew.listno,Name=note_addandupdatelistnew.name,GroupNo=note_addandupdatelistnew.groupno,Description=note_addandupdatelistnew.description,Latitude=note_addandupdatelistnew.latitude
		,Longitude=note_addandupdatelistnew.longitude,DayEdit=note_addandupdatelistnew.daycreate,NoteTimeZoneEdit=note_addandupdatelistnew.notetimezone
		WHERE ListNo=note_addandupdatelistnew.listno

		IF LEN(ListUserNo) > 0 AND ListUserNo != '0' 
		BEGIN
			IF ListUserNo = 'D'BEGIN;
				DELETE FROM Note_Share WHERE ListNo = note_addandupdatelistnew.listno
			END
			ELSE BEGIN
			BEGIN TRANSACTION UpdateShareNote
				

				SELECT TempUserNo = note_addandupdatelistnew.userno FROM Note_List WHERE ListNo = note_addandupdatelistnew.listno

				UPDATE Note_Share SET DayEdit = note_addandupdatelistnew.daycreate, IsReads = TRUE WHERE ListNo = note_addandupdatelistnew.listno AND IsReads = 2

				WHILE index != 0
				 BEGIN
					 SET index = STRPOS(ListUserNo, '#')
					 IF index !=0 BEGIN
						 SET Slip = left(ListUserNo,index - 1)
						 IF ISNUMERIC(Slip) = 1 BEGIN
							SET ShareUser = Slip
							SET ShareType = 2
						 END
						 ELSE BEGIN
							SET indexUser = STRPOS(Slip, '|')
							SET ShareUser = left(Slip,indexUser - 1)
							SET ShareType = RIGHT(Slip , LEN(Slip) - indexUser)
						 END
					 END 
					 ELSE BEGIN
						 SET ShareUser = note_addandupdatelistnew.listuserno
					 END

					 IF ShareUser != 0 BEGIN

						INSERT INTO Results(ShareUser, ShareType) VALUES(ShareUser, ShareType)
						SELECT 	IsInsert = COUNT(ShareNo) FROM Note_Share	WHERE ListNo = note_addandupdatelistnew.listno AND UserShare = ShareUser AND ShareType = ShareType

						IF IsInsert = FALSE  AND ShareUser != note_addandupdatelistnew.userno AND ShareUser != TempUserNo BEGIN
							SET UserGroupNo = '00000000-0000-0000-0000-000000000000'
							IF ShareType = 2 BEGIN
								SELECT UserGroupNo = note_addandupdatelistnew.groupno FROM Note_Group where UserNo = ShareUser AND CheckDelete = 1
							END
							IF ListNo != '00000000-0000-0000-0000-000000000000' BEGIN;
								INSERT INTO Note_Share(ShareNo,UserNo,ListNo,DayCreate,DayEdit,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
								   VALUES(NEWID (),UserNo,ListNo,DayCreate,DayCreate,ShareUser,UserGroupNo,ShareType,DayCreate,NoteTimeZone)
							END
						END
					END
					 SET ListUserNo = RIGHT(ListUserNo , LEN(ListUserNo) - index)
					 IF LEN(ListUserNo) = 0 BREAK
				 END  ;
			 		DELETE FROM Note_Share 
						WHERE ListNo = note_addandupdatelistnew.listno
							AND UserNo = note_addandupdatelistnew.userno 
							AND ShareNo NOT IN(
											SELECT ShareNo FROM (
												SELECT ShareNo, UserShare, ShareType FROM Note_Share WHERE ListNo = note_addandupdatelistnew.listno AND UserNo = note_addandupdatelistnew.userno
												) AS T, Results R
											WHERE T.UserShare = R.ShareUser AND T.ShareType = R.ShareType)

			COMMIT TRAN UpdateShareNote
			END 
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
