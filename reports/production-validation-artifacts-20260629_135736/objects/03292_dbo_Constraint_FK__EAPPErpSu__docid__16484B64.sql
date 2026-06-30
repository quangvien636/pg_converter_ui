-- ─── FK: fk__eapperpsu__docid__16484b64 ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eapperpsu__docid__16484b64' AND contype = 'f') THEN
        ALTER TABLE public."EAPPErpSubData" ADD CONSTRAINT fk__eapperpsu__docid__16484b64
            FOREIGN KEY (docid) REFERENCES public."EAPPDocument" (ID);
    END IF;
END;
$$;
