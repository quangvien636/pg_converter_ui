-- ─── FUNCTION: schedule_updateresourcebuygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresourcebuygroup(integer, character varying, date, integer, numeric, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcebuygroup(
    userno integer,
    companyname character varying,
    buydate date,
    buyqty integer,
    buyamount numeric,
    mainmanagerno integer,
    submanagerno integer,
    resourceno integer DEFAULT 0
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF BuyGroupNo = 0 
	BEGIN;
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
		SET nBuyGroupNo = lastval()
		
		IF ResourceNo <> 0
		BEGIN;
			UPDATE ScheduleResources
			SET
				BuyGroupNo = nBuyGroupNo
			WHERE ResourceNo = schedule_updateresourcebuygroup.resourceno
		END 
		
		RETURN QUERY
		SELECT nBuyGroupNo
	END
	ELSE
	BEGIN;
		UPDATE ScheduleResourcesBuyGroup
		SET
			ModUserNo = schedule_updateresourcebuygroup.userno,
			ModDate = NOW(),
			CompanyName = schedule_updateresourcebuygroup.companyname,
			BuyDate = schedule_updateresourcebuygroup.buydate,
			BuyQty = schedule_updateresourcebuygroup.buyqty,
			BuyAmount = schedule_updateresourcebuygroup.buyamount,
			MainManagerNo = schedule_updateresourcebuygroup.mainmanagerno,
			SubManagerNo = schedule_updateresourcebuygroup.submanagerno
		WHERE BuyGroupNo = BuyGroupNo
		
		IF ResourceNo <> 0
		BEGIN;
			UPDATE ScheduleResources
			SET
				BuyGroupNo = BuyGroupNo
			WHERE ResourceNo = schedule_updateresourcebuygroup.resourceno
		END 
		
		RETURN QUERY
		SELECT BuyGroupNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
