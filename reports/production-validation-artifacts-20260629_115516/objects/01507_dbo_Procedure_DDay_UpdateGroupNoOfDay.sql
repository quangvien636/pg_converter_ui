-- ─── PROCEDURE→FUNCTION: dday_updategroupnoofday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_updategroupnoofday(bigint, integer, timestamp without time zone, bigint);
CREATE OR REPLACE FUNCTION public.dday_updategroupnoofday(
    IN dayno bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno bigint
) RETURNS void
AS $function$
DECLARE
    reguserno integer;
    count integer;
BEGIN



	RegUserNo := (SELECT RegUserNo FROM DDay_Days WHERE DayNo = dday_updategroupnoofday.dayno);
	IF RegUserNo = dday_updategroupnoofday.moduserno THEN

		UPDATE DDay_Days SET
			ModUserNo = dday_updategroupnoofday.moduserno,
			ModDate = dday_updategroupnoofday.moddate,
			GroupNo = dday_updategroupnoofday.groupno
		WHERE DayNo = dday_updategroupnoofday.dayno

	END IF;

	ELSE BEGIN
	

		Count := (SELECT COUNT(*) FROM DDay_GroupInfoOfSharedDays WHERE DayNo = dday_updategroupnoofday.dayno AND UserNo = dday_updategroupnoofday.moduserno);
		IF Count = 0 THEN

			INSERT INTO DDay_GroupInfoOfSharedDays (DayNo, UserNo, GroupNo) VALUES (DayNo, ModUserNo, GroupNo)

		END IF;

		ELSE BEGIN

			UPDATE DDay_GroupInfoOfSharedDays SET
				GroupNo = dday_updategroupnoofday.groupno
			WHERE DayNo = dday_updategroupnoofday.dayno AND UserNo = dday_updategroupnoofday.moduserno

		END;

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
