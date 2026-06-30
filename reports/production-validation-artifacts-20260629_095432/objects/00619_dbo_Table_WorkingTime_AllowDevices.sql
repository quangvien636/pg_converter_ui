-- ─── TABLE: WorkingTime_AllowDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_AllowDevices" (
    AllowDeviceNo serial NOT NULL,
    DepartNo integer NOT NULL,
    UserNo integer NOT NULL PRIMARY KEY,
    ContentAllow text NOT NULL,
    ModDate timestamp without time zone,
    RegDate timestamp without time zone,
    IsUserFull boolean,
    DeviceId character varying(2000) NOT NULL,
    verson character varying(100),
    SessionID character(32)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
