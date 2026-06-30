-- ─── FK: fk__eappcostd__maste__0f9b4dd5 ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eappcostd__maste__0f9b4dd5' AND contype = 'f') THEN
        ALTER TABLE public."EAPPCostDetail" ADD CONSTRAINT fk__eappcostd__maste__0f9b4dd5
            FOREIGN KEY (Masterid) REFERENCES public."EAPPCostMaster" (ID);
    END IF;
END;
$$;
