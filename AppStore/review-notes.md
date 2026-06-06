# App Review Notes

KauMae AI is a fashion decision-support app for users who want help deciding whether to buy a clothing item.

## Reviewer Flow

1. Open the app.
2. Review the sample profile and sample candidate item.
3. Tap "買う前にチェック".
4. The app shows a recommendation score, a buy/skip/alternative decision, reasons, and suggested outfit items.
5. After free checks are exhausted, the app presents a Pro subscription paywall.

## AI And Advice Limitations

The app provides fashion advice and shopping decision support. It does not guarantee exact sizing, physical fit, health outcomes, attractiveness, or purchase satisfaction.

## Privacy

Photos are used only to support clothing analysis and app functionality. The MVP stores sample data locally. Future server-side AI processing will disclose upload behavior, retention, deletion, and third-party processors in the privacy policy before release.

## In-App Purchase

Digital checks, Pro access, and future image generation credits will use Apple In-App Purchase. Product identifiers should be configured in App Store Connect before release:

- `kaumae.pro.monthly`
- `kaumae.checks.10`
- `kaumae.images.10`
