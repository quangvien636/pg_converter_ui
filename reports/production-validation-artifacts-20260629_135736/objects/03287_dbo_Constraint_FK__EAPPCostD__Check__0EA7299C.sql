-- ─── FK: fk__eappcostd__check__0ea7299c ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eappcostd__check__0ea7299c' AND contype = 'f') THEN
        ALTER TABLE public."EAPPCostDetail" ADD CONSTRAINT fk__eappcostd__check__0ea7299c
            FOREIGN KEY (Checkid) REFERENCES public."EAPPCostCheck" (ID);
    END IF;
END;
$$;
