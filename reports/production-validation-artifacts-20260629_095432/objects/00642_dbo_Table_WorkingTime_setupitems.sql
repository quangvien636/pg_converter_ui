-- ─── TABLE: WorkingTime_setupitems ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_setupitems" (
    Id serial NOT NULL,
    checkin character varying(2),
    checkout character varying(2),
    workoutside character varying(2),
    returnv character varying(2),
    wfh character varying(2),
    early character varying(2),
    nightwork character varying(2),
    extension character varying(2),
    training character varying(2),
    holiday character varying(2),
    quatertoff character varying(2),
    haftoff character varying(2),
    alloff character varying(2)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
