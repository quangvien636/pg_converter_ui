using pg_converter_ui;

namespace RegressionTests;

[TestFixture]
public class ShortVideoServiceTests
{
    string _workingDirectory = null!;

    [SetUp]
    public void Setup()
    {
        _workingDirectory = Path.Combine(Path.GetTempPath(), $"pg_converter_ui_video_test_{Guid.NewGuid():N}");
        Directory.CreateDirectory(_workingDirectory);
    }

    [TearDown]
    public void TearDown()
    {
        if (Directory.Exists(_workingDirectory))
            Directory.Delete(_workingDirectory, true);
    }

    [Test]
    public void TryCreatePlan_UsesMaxDurationAndAddsAudioLogoArguments()
    {
        var imageDir = Path.Combine(_workingDirectory, "images");
        var outDir = Path.Combine(_workingDirectory, "output");
        Directory.CreateDirectory(imageDir);
        Directory.CreateDirectory(outDir);

        for (var i = 0; i < 6; i++)
            File.WriteAllBytes(Path.Combine(imageDir, $"img_{i:00}.jpg"), [0x01, 0x02, 0x03]);

        var audio = Path.Combine(_workingDirectory, "bg.mp3");
        var logo = Path.Combine(_workingDirectory, "logo.png");
        File.WriteAllBytes(audio, [0x01, 0x02]);
        File.WriteAllBytes(logo, [0x01, 0x02]);

        var req = new ShortVideoRequest(
            "ffmpeg",
            imageDir,
            audio,
            logo,
            "Demo Watermark",
            outDir,
            SecondsPerImage: 2,
            MaxDurationSeconds: 8,
            Preset: "fast",
            AutoCreate: true);

        var ok = ShortVideoService.TryCreatePlan(req, out var plan, out var error);

        Assert.That(ok, Is.True, error);
        Assert.That(plan.ImageFiles.Count, Is.EqualTo(4));
        Assert.That(plan.TargetDuration.TotalSeconds, Is.EqualTo(8));
        Assert.That(plan.HasAudio, Is.True);
        Assert.That(plan.HasLogo, Is.True);
        Assert.That(plan.Arguments, Does.Contain("-filter_complex"));
        Assert.That(plan.Arguments, Does.Contain("-shortest"));
        Assert.That(plan.Arguments, Does.Contain("fast"));
    }

    [Test]
    public void TryCreatePlan_ReturnsErrorWhenImageFolderEmpty()
    {
        var imageDir = Path.Combine(_workingDirectory, "images");
        Directory.CreateDirectory(imageDir);

        var req = new ShortVideoRequest(
            "ffmpeg",
            imageDir,
            AudioFile: null,
            LogoFile: null,
            WatermarkText: null,
            OutputFolder: Path.Combine(_workingDirectory, "output"),
            SecondsPerImage: 2,
            MaxDurationSeconds: 20,
            Preset: "medium",
            AutoCreate: false);

        var ok = ShortVideoService.TryCreatePlan(req, out _, out var error);

        Assert.That(ok, Is.False);
        Assert.That(error, Is.EqualTo("Không tìm thấy ảnh hợp lệ trong thư mục nguồn."));
    }
}
