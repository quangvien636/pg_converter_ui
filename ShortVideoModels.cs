namespace pg_converter_ui;

public sealed record ShortVideoRequest(
    string FfmpegPath,
    string ImagesFolder,
    string? AudioFile,
    string? LogoFile,
    string? WatermarkText,
    string OutputFolder,
    int SecondsPerImage,
    int MaxDurationSeconds,
    string Preset,
    bool AutoCreate);

public sealed record ShortVideoPlan(
    string FfmpegPath,
    IReadOnlyList<string> ImageFiles,
    string ConcatListFile,
    string OutputFile,
    string PreviewImageFile,
    TimeSpan TargetDuration,
    IReadOnlyList<string> Arguments,
    bool HasAudio,
    bool HasLogo,
    string? WatermarkText);

public sealed record ShortVideoRenderResult(
    bool Success,
    string OutputFile,
    string PreviewImageFile,
    string LogText,
    string? ErrorMessage = null);
