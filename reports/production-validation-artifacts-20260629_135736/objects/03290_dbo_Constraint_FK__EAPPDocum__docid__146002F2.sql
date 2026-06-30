-- ─── FK: fk__eappdocum__docid__146002f2 ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eappdocum__docid__146002f2' AND contype = 'f') THEN
        ALTER TABLE public."EAPPDocumentSubData" ADD CONSTRAINT fk__eappdocum__docid__146002f2
            FOREIGN KEY (docid) REFERENCES public."EAPPDocument" (ID);
    END IF;
END;
$$;
