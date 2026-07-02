using System.Diagnostics;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace pg_converter_ui;

public static partial class ShortVideoService
{
    static readonly string[] _imageExtensions = [".jpg", ".jpeg", ".png", ".bmp", ".webp"];
    const string PreviewThumbnailSeekTime = "00:00:00.500";

    public static bool TryCreatePlan(ShortVideoRequest request, out ShortVideoPlan plan, out string error)
    {
        plan = null!;
        error = string.Empty;

        if (string.IsNullOrWhiteSpace(request.FfmpegPath))
        {
            error = "Thiếu đường dẫn FFmpeg.";
            return false;
        }

        if (!Directory.Exists(request.ImagesFolder))
        {
            error = "Thư mục ảnh không tồn tại.";
            return false;
        }

        var allImages = Directory
            .EnumerateFiles(request.ImagesFolder)
            .Where(f => _imageExtensions.Contains(Path.GetExtension(f), StringComparer.OrdinalIgnoreCase))
            .OrderBy(f => f, StringComparer.OrdinalIgnoreCase)
            .ToList();

        if (allImages.Count == 0)
        {
            error = "Không tìm thấy ảnh hợp lệ trong thư mục nguồn.";
            return false;
        }

        var secPerImage = Math.Clamp(request.SecondsPerImage, 1, 10);
        var maxSeconds = Math.Clamp(request.MaxDurationSeconds, 5, 300);
        // Keep total duration <= MaxDurationSeconds by using floor division.
        var maxImages = Math.Max(1, maxSeconds / secPerImage);

        var imageFiles = allImages.Take(maxImages).ToList();
        var targetSeconds = imageFiles.Count * secPerImage;

        Directory.CreateDirectory(request.OutputFolder);
        var stamp = DateTime.UtcNow.ToString("yyyyMMdd_HHmmss");
        var outputFile = Path.Combine(request.OutputFolder, $"short_video_{stamp}.mp4");
        var concatListFile = Path.Combine(Path.GetTempPath(), $"pg_converter_ui_video_{stamp}.txt");
        var previewImageFile = Path.Combine(request.OutputFolder, $"short_video_{stamp}_preview.jpg");

        var hasAudio = !string.IsNullOrWhiteSpace(request.AudioFile) && File.Exists(request.AudioFile);
        var hasLogo = !string.IsNullOrWhiteSpace(request.LogoFile) && File.Exists(request.LogoFile);
        var watermark = string.IsNullOrWhiteSpace(request.WatermarkText) ? null : request.WatermarkText.Trim();
        var arguments = BuildArguments(concatListFile, outputFile, request, hasAudio, hasLogo, targetSeconds, watermark);

        plan = new ShortVideoPlan(
            request.FfmpegPath.Trim(),
            imageFiles,
            concatListFile,
            outputFile,
            previewImageFile,
            TimeSpan.FromSeconds(targetSeconds),
            arguments,
            hasAudio,
            hasLogo,
            watermark);

        return true;
    }

    public static async Task WriteConcatListAsync(ShortVideoPlan plan, int secondsPerImage)
    {
        var escaped = plan.ImageFiles.Select(Path.GetFullPath).ToList();
        var sb = new StringBuilder();
        foreach (var file in escaped)
        {
            sb.AppendLine($"file '{file.Replace("'", "'\\''")}'");
            sb.AppendLine($"duration {secondsPerImage.ToString(CultureInfo.InvariantCulture)}");
        }

        // FFmpeg concat demuxer needs the final file repeated so the last frame duration is honored.
        if (escaped.Count > 0)
            sb.AppendLine($"file '{escaped[^1].Replace("'", "'\\''")}'");

        await File.WriteAllTextAsync(plan.ConcatListFile, sb.ToString(), Encoding.UTF8);
    }

    public static async Task<ShortVideoRenderResult> RenderAsync(
        ShortVideoPlan plan,
        Action<int>? onProgress = null,
        CancellationToken cancellationToken = default)
    {
        var logs = new StringBuilder();

        try
        {
            using var process = new Process
            {
                StartInfo = CreateStartInfo(plan),
                EnableRaisingEvents = true
            };

            process.ErrorDataReceived += (_, e) =>
            {
                if (string.IsNullOrWhiteSpace(e.Data)) return;
                logs.AppendLine(e.Data);
                var percent = TryReadProgressPercent(e.Data, plan.TargetDuration);
                if (percent.HasValue) onProgress?.Invoke(percent.Value);
            };

            if (!process.Start())
                return new ShortVideoRenderResult(false, plan.OutputFile, plan.PreviewImageFile, logs.ToString(), "Không thể khởi chạy FFmpeg.");

            process.BeginErrorReadLine();
            await process.WaitForExitAsync(cancellationToken);

            if (process.ExitCode != 0)
            {
                return new ShortVideoRenderResult(
                    false,
                    plan.OutputFile,
                    plan.PreviewImageFile,
                    logs.ToString(),
                    "FFmpeg render thất bại. Kiểm tra log chi tiết.");
            }

            onProgress?.Invoke(100);
            return new ShortVideoRenderResult(true, plan.OutputFile, plan.PreviewImageFile, logs.ToString());
        }
        catch (Exception ex)
        {
            logs.AppendLine(ex.ToString());
            return new ShortVideoRenderResult(false, plan.OutputFile, plan.PreviewImageFile, logs.ToString(), ex.Message);
        }
    }

    public static async Task<bool> GeneratePreviewAsync(string ffmpegPath, string outputVideo, string previewFile, CancellationToken cancellationToken = default)
    {
        var info = new ProcessStartInfo
        {
            FileName = ffmpegPath,
            RedirectStandardError = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        info.ArgumentList.Add("-y");
        info.ArgumentList.Add("-ss");
        info.ArgumentList.Add(PreviewThumbnailSeekTime);
        info.ArgumentList.Add("-i");
        info.ArgumentList.Add(outputVideo);
        info.ArgumentList.Add("-vframes");
        info.ArgumentList.Add("1");
        info.ArgumentList.Add(previewFile);

        using var p = Process.Start(info);
        if (p is null) return false;

        await p.WaitForExitAsync(cancellationToken);
        return p.ExitCode == 0 && File.Exists(previewFile);
    }

    static ProcessStartInfo CreateStartInfo(ShortVideoPlan plan)
    {
        var info = new ProcessStartInfo
        {
            FileName = plan.FfmpegPath,
            RedirectStandardError = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        foreach (var arg in plan.Arguments)
            info.ArgumentList.Add(arg);

        return info;
    }

    static List<string> BuildArguments(
        string concatListFile,
        string outputFile,
        ShortVideoRequest request,
        bool hasAudio,
        bool hasLogo,
        int targetSeconds,
        string? watermarkText)
    {
        var args = new List<string>
        {
            "-y",
            "-f", "concat",
            "-safe", "0",
            "-i", concatListFile
        };

        var audioInputIndex = -1;
        if (hasAudio)
        {
            audioInputIndex = 1;
            // Loop audio indefinitely; -shortest below ensures output still stops with video duration.
            args.AddRange(["-stream_loop", "-1", "-i", request.AudioFile!]);
        }

        var logoInputIndex = -1;
        if (hasLogo)
        {
            logoInputIndex = hasAudio ? 2 : 1;
            args.AddRange(["-i", request.LogoFile!]);
        }

        var baseFilter = "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,format=yuv420p";

        if (hasLogo)
        {
            var complex = new StringBuilder();
            complex.Append($"[0:v]{baseFilter}[base];");
            complex.Append($"[{logoInputIndex}:v]scale=160:-1[logo];");
            complex.Append("[base][logo]overlay=W-w-20:H-h-20[logoed]");

            if (!string.IsNullOrWhiteSpace(watermarkText))
            {
                complex.Append($";[logoed]drawtext=text='{EscapeText(watermarkText)}':fontcolor=white:fontsize=28:x=20:y=H-th-20[vout]");
            }
            else
            {
                // Explicit no-op pass-through so both branches consistently output [vout].
                complex.Append(";[logoed]null[vout]");
            }

            args.AddRange(["-filter_complex", complex.ToString(), "-map", "[vout]"]);
        }
        else
        {
            var vf = new StringBuilder(baseFilter);
            if (!string.IsNullOrWhiteSpace(watermarkText))
                vf.Append($",drawtext=text='{EscapeText(watermarkText)}':fontcolor=white:fontsize=28:x=20:y=H-th-20");

            args.AddRange(["-vf", vf.ToString()]);
        }

        if (hasAudio)
        {
            args.AddRange(["-map", $"{audioInputIndex}:a:0", "-c:a", "aac", "-b:a", "128k", "-shortest"]);
        }
        else
        {
            args.Add("-an");
        }

        args.AddRange([
            "-c:v", "libx264",
            "-preset", string.IsNullOrWhiteSpace(request.Preset) ? "medium" : request.Preset,
            "-r", "30",
            "-pix_fmt", "yuv420p",
            "-movflags", "+faststart",
            "-t", targetSeconds.ToString(CultureInfo.InvariantCulture),
            outputFile
        ]);

        return args;
    }

    static string EscapeText(string text) =>
        text
            .Replace("\\", "\\\\", StringComparison.Ordinal)
            .Replace(":", "\\:", StringComparison.Ordinal)
            .Replace("'", "\\'", StringComparison.Ordinal);

    static int? TryReadProgressPercent(string line, TimeSpan targetDuration)
    {
        if (targetDuration <= TimeSpan.Zero) return null;

        var match = TimeRegex().Match(line);
        if (!match.Success) return null;

        if (!TimeSpan.TryParse(match.Groups[1].Value, CultureInfo.InvariantCulture, out var current))
            return null;

        var pct = (int)Math.Round(current.TotalSeconds / targetDuration.TotalSeconds * 100.0);
        return Math.Clamp(pct, 0, 100);
    }

    [GeneratedRegex(@"time=(\d{2}:\d{2}:\d{2}(?:\.\d+)?)")]
    private static partial Regex TimeRegex();
}
