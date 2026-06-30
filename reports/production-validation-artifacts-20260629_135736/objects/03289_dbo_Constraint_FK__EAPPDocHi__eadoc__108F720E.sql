-- ─── FK: fk__eappdochi__eadoc__108f720e ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eappdochi__eadoc__108f720e' AND contype = 'f') THEN
        ALTER TABLE public."EAPPDocHistory" ADD CONSTRAINT fk__eappdochi__eadoc__108f720e
            FOREIGN KEY (eadocid) REFERENCES public."EAPPDocument" (ID) ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END;
$$;
