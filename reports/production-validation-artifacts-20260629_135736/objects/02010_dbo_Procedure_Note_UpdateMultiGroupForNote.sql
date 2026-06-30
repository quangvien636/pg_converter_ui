-- ─── PROCEDURE→FUNCTION: note_updatemultigroupfornote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_updatemultigroupfornote(character varying, integer, uuid, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_updatemultigroupfornote(
    IN listnos character varying,
    IN usershare integer,
    IN groupno uuid,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
DECLARE
    listno uuid;
    slip character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN







		IF LEN(ListNos) > 0 AND ListNos != '0' THEN

		BEGIN BEGIN TRANSACTION UpdateGroupNosNote

			WHILE index != 0 LOOP
				 index := STRPOS(ListNos, '#');
				 IF index !=0 THEN
					 Slip := left(ListNos,index - 1);
					 indexListNo := STRPOS(Slip, '|');
					 IF indexListNo = 0 THEN
						ListNo := Slip;
						GroupType := 1;
					 END IF;
					 ELSE BEGIN
						ListNo := left(Slip,indexListNo - 1);
						GroupType := RIGHT(Slip , LEN(Slip) - indexListNo);
					 END IF;
				 END LOOP;
				 ELSE BEGIN
					 ListNo := note_updatemultigroupfornote.listnos;
				 END;

				 IF ListNo != '00000000-0000-0000-0000-000000000000'BEGIN THEN
					IF GroupType != 0 THEN;
						UPDATE Note_Share
							DayEdit := note_updatemultigroupfornote.daycreate,GroupNo=note_updatemultigroupfornote.groupno;
							WHERE ListNo=ListNo AND UserShare=note_updatemultigroupfornote.usershare
					END IF;
					ELSE BEGIN;
						UPDATE Note_List
							GroupNo := note_updatemultigroupfornote.groupno;
							WHERE ListNo = ListNo AND UserNo = note_updatemultigroupfornote.usershare
					END IF;
				END;

				 ListNos := RIGHT(ListNos , LEN(ListNos) - index);
				 IF LEN(ListNos) = 0 BREAK THEN
			 END;

			COMMIT TRAN UpdateGroupNosNote
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
