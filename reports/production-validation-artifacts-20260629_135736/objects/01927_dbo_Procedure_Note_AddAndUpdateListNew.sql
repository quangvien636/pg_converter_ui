-- ─── PROCEDURE→FUNCTION: note_addandupdatelistnew ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_addandupdatelistnew(uuid, character varying, uuid, integer, character varying, double precision, double precision, double precision, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.note_addandupdatelistnew(
    IN listno uuid,
    IN name character varying,
    IN groupno uuid,
    IN userno integer,
    IN description character varying,
    IN latitude double precision,
    IN longitude double precision,
    IN notetimezone double precision,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE',
    IN listuserno character varying DEFAULT NULL
) RETURNS SETOF record
AS $function$
DECLARE
    results table (shareuser int, sharetype int);
    slip character varying;
    tempuserno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT ListNo, UserNo INTO checklistno, tempuser FROM Note_List WHERE ListNo = note_addandupdatelistnew.listno





	IF CheckListNo = '00000000-0000-0000-0000-000000000000' THEN;
		INSERT INTO Note_List (ListNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate, DayEdit, NoteTimeZoneCreate, NoteTimeZoneEdit)
						VALUES(ListNo,Name,GroupNo,UserNo,Description,Latitude,Longitude,DayCreate,DayCreate, NoteTimeZone, NoteTimeZone)

		IF LEN(ListUserNo) > 0 AND ListUserNo != '0' AND ListUserNo != 'D' THEN
		BEGIN BEGIN TRANSACTION UpdateShareNote

			WHILE index != 0 LOOP
				 index := STRPOS(ListUserNo, '#');
				 IF index !=0 THEN
					 Slip := left(ListUserNo,index - 1);
					 IF ISNUMERIC(Slip) = 1 THEN
						ShareUser := Slip;
						ShareType := 2;
					 END IF;
					 ELSE BEGIN
						indexUser := STRPOS(Slip, '|');
						ShareUser := left(Slip,indexUser - 1);
						ShareType := RIGHT(Slip , LEN(Slip) - indexUser);
					 END IF;
				 END LOOP;
				 ELSE BEGIN
					 ShareUser := note_addandupdatelistnew.listuserno;
				 END IF;

				 IF ShareUser != 0 AND ShareUser != note_addandupdatelistnew.userno THEN
					UserGroupNo := '00000000-0000-0000-0000-000000000000';
					IF ShareType = 2 THEN
						SELECT GroupNo INTO usergroupno FROM Note_Group where UserNo = ShareUser AND CheckDelete = 1
					END IF;
					IF ListNo != '00000000-0000-0000-0000-000000000000' THEN;
					INSERT INTO Note_Share(ShareNo,UserNo,ListNo,DayCreate,DayEdit,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
						   VALUES(NEWID (),UserNo,ListNo,DayCreate,DayCreate,ShareUser,UserGroupNo,ShareType,DayCreate,NoteTimeZone)
					END IF;
				END IF;

				 ListUserNo := RIGHT(ListUserNo , LEN(ListUserNo) - index);
				 IF LEN(ListUserNo) = 0 BREAK THEN
			 END;

			COMMIT TRAN UpdateShareNote
		END;
	END;
	ELSE;
		UPDATE Note_List
		ListNo := note_addandupdatelistnew.listno,Name=note_addandupdatelistnew.name,GroupNo=note_addandupdatelistnew.groupno,Description=note_addandupdatelistnew.description,Latitude=note_addandupdatelistnew.latitude;
		,Longitude=note_addandupdatelistnew.longitude,DayEdit=note_addandupdatelistnew.daycreate,NoteTimeZoneEdit=note_addandupdatelistnew.notetimezone
		WHERE ListNo=note_addandupdatelistnew.listno

		IF LEN(ListUserNo) > 0 AND ListUserNo != '0' THEN
			IF ListUserNo = 'D'BEGIN THEN;
				DELETE FROM Note_Share WHERE ListNo = note_addandupdatelistnew.listno
			END IF;
			ELSE BEGIN
			BEGIN TRANSACTION UpdateShareNote
				

				SELECT UserNo INTO tempuserno FROM Note_List WHERE ListNo = note_addandupdatelistnew.listno

				UPDATE Note_Share SET DayEdit = note_addandupdatelistnew.daycreate, IsReads = TRUE WHERE ListNo = note_addandupdatelistnew.listno AND IsReads = 2

				WHILE index != 0 LOOP
					 index := STRPOS(ListUserNo, '#');
					 IF index !=0 THEN
						 Slip := left(ListUserNo,index - 1);
						 IF ISNUMERIC(Slip) = 1 THEN
							ShareUser := Slip;
							ShareType := 2;
						 END IF;
						 ELSE BEGIN
							indexUser := STRPOS(Slip, '|');
							ShareUser := left(Slip,indexUser - 1);
							ShareType := RIGHT(Slip , LEN(Slip) - indexUser);
						 END IF;
					 END LOOP;
					 ELSE BEGIN
						 ShareUser := note_addandupdatelistnew.listuserno;
					 END IF;

					 IF ShareUser != 0 THEN

						INSERT INTO Results(ShareUser, ShareType) VALUES(ShareUser, ShareType)
						SELECT COUNT(ShareNo) INTO isinsert FROM Note_Share	WHERE ListNo = note_addandupdatelistnew.listno AND UserShare = ShareUser AND ShareType = ShareType

						IF IsInsert = FALSE  AND ShareUser != note_addandupdatelistnew.userno AND ShareUser != TempUserNo THEN
							UserGroupNo := '00000000-0000-0000-0000-000000000000';
							IF ShareType = 2 THEN
								SELECT GroupNo INTO usergroupno FROM Note_Group where UserNo = ShareUser AND CheckDelete = 1
							END IF;
							IF ListNo != '00000000-0000-0000-0000-000000000000' THEN;
								INSERT INTO Note_Share(ShareNo,UserNo,ListNo,DayCreate,DayEdit,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
								   VALUES(NEWID (),UserNo,ListNo,DayCreate,DayCreate,ShareUser,UserGroupNo,ShareType,DayCreate,NoteTimeZone)
							END IF;
						END IF;
					END IF;
					 ListUserNo := RIGHT(ListUserNo , LEN(ListUserNo) - index);
					 IF LEN(ListUserNo) = 0 BREAK THEN
				 END IF;;
			 		DELETE FROM Note_Share 
						WHERE ListNo = note_addandupdatelistnew.listno
							AND UserNo = note_addandupdatelistnew.userno 
							AND ShareNo NOT IN(
											SELECT ShareNo FROM (
												SELECT ShareNo, UserShare, ShareType FROM Note_Share WHERE ListNo = note_addandupdatelistnew.listno AND UserNo = note_addandupdatelistnew.userno
												) AS T, Results R
											WHERE T.UserShare = R.ShareUser AND T.ShareType = R.ShareType)

			COMMIT TRAN UpdateShareNote
			END;
		END;
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
