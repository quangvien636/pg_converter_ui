-- ─── TABLE: CrewChat_AndroidDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_AndroidDevices" (
    DeviceNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DeviceID character varying(2000) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    NotifyEnable boolean,
    NotifySound boolean,
    NotifyVibrate boolean,
    NotifyUseTime boolean,
    NotifyStartTime character varying(50),
    NotifyEndTime character varying(50),
    NotifyConfirmOnline boolean,
    TimeZoneOffset integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
