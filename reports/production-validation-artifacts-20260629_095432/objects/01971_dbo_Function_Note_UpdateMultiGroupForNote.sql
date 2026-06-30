-- ─── FUNCTION: note_updatemultigroupfornote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updatemultigroupfornote(character varying, integer, uuid, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_updatemultigroupfornote(
    listnos character varying,
    usershare integer,
    groupno uuid,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    listno uuid;
    slip character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN







		IF LEN(ListNos) > 0 AND ListNos != '0'

		BEGIN BEGIN TRANSACTION UpdateGroupNosNote

			WHILE index != 0
			 BEGIN
				 SET index = STRPOS(ListNos, '#')
				 IF index !=0 BEGIN
					 SET Slip = left(ListNos,index - 1)
					 SET indexListNo = STRPOS(Slip, '|')
					 IF indexListNo = 0 BEGIN
						SET ListNo = Slip
						SET GroupType = 1
					 END
					 ELSE BEGIN
						SET ListNo = left(Slip,indexListNo - 1)
						SET GroupType = RIGHT(Slip , LEN(Slip) - indexListNo)
					 END
				 END 
				 ELSE BEGIN
					 SET ListNo = note_updatemultigroupfornote.listnos
				 END

				 IF ListNo != '00000000-0000-0000-0000-000000000000'BEGIN
					IF GroupType != 0 BEGIN;
						UPDATE Note_Share
							SET DayEdit=note_updatemultigroupfornote.daycreate,GroupNo=note_updatemultigroupfornote.groupno
							WHERE ListNo=ListNo AND UserShare=note_updatemultigroupfornote.usershare
					END
					ELSE BEGIN;
						UPDATE Note_List
							SET GroupNo = note_updatemultigroupfornote.groupno
							WHERE ListNo = ListNo AND UserNo = note_updatemultigroupfornote.usershare
					END
				END

				 SET ListNos = RIGHT(ListNos , LEN(ListNos) - index)
				 IF LEN(ListNos) = 0 BREAK
			 END  

			COMMIT TRAN UpdateGroupNosNote
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
