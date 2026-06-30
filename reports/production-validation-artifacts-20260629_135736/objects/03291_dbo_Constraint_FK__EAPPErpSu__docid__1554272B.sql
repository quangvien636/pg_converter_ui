-- ─── FK: fk__eapperpsu__docid__1554272b ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eapperpsu__docid__1554272b' AND contype = 'f') THEN
        ALTER TABLE public."EAPPErpSubData" ADD CONSTRAINT fk__eapperpsu__docid__1554272b
            FOREIGN KEY (docid) REFERENCES public."EAPPDocument" (ID) ON DELETE CASCADE;
    END IF;
END;
$$;
