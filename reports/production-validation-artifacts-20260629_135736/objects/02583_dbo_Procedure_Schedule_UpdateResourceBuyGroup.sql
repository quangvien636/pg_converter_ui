-- ─── PROCEDURE→FUNCTION: schedule_updateresourcebuygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_updateresourcebuygroup(integer, character varying, date, integer, numeric, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcebuygroup(
    IN userno integer,
    IN companyname character varying,
    IN buydate date,
    IN buyqty integer,
    IN buyamount numeric,
    IN mainmanagerno integer,
    IN submanagerno integer,
    IN resourceno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF BuyGroupNo = 0 THEN;
		INSERT INTO ScheduleResourcesBuyGroup
		(
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			CompanyName,
			BuyDate,
			BuyQty,
			BuyAmount,
			MainManagerNo,
			SubManagerNo
		)
		VALUES
		(
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			CompanyName,
			BuyDate,
			BuyQty,
			BuyAmount,
			MainManagerNo,
			SubManagerNo
		)
		nBuyGroupNo := lastval();
		IF ResourceNo <> 0 THEN;
			UPDATE ScheduleResources
			BuyGroupNo := nBuyGroupNo;
			WHERE ResourceNo = schedule_updateresourcebuygroup.resourceno
		END IF;
		
		RETURN QUERY
		SELECT nBuyGroupNo
	END IF;
	ELSE;
		UPDATE ScheduleResourcesBuyGroup
		ModUserNo := schedule_updateresourcebuygroup.userno,;
			ModDate = NOW(),
			CompanyName = schedule_updateresourcebuygroup.companyname,
			BuyDate = schedule_updateresourcebuygroup.buydate,
			BuyQty = schedule_updateresourcebuygroup.buyqty,
			BuyAmount = schedule_updateresourcebuygroup.buyamount,
			MainManagerNo = schedule_updateresourcebuygroup.mainmanagerno,
			SubManagerNo = schedule_updateresourcebuygroup.submanagerno
		WHERE BuyGroupNo = BuyGroupNo
		
		IF ResourceNo <> 0 THEN;
			UPDATE ScheduleResources
			BuyGroupNo := BuyGroupNo;
			WHERE ResourceNo = schedule_updateresourcebuygroup.resourceno
		END IF;
		
		RETURN QUERY
		SELECT BuyGroupNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
