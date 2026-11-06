# ZoomLens

You join a meeting late, someone is sharing a dense chart, and you'd rather not interrupt everyone to ask what it means. ZoomLens is a panel inside Zoom where you can ask about the shared screen, and only you see the answer.

I'm building it for the Next Lab Zoom Fellowship at Arizona State University. The [project site](https://zoomlens.vercel.app) has a demo with scripted answers.

## From screen share to answer

Zoom sends a video stream through RTMS. The server keeps enough H.264 video to produce a complete frame, then uses FFmpeg to turn it into a JPEG. The image and your question go to an Anthropic vision model. The answer returns over a WebSocket connection to your panel.

Built with **Node.js, Express, Zoom’s Apps and RTMS SDKs, WebSockets, and FFmpeg**, with plain JavaScript in the panel.

The server checks participant identity using signed Zoom data and sends replies only to the participant who asked. It receives screen sharing, not meeting audio, camera video, chat, or transcripts. Images and questions are sent to the model provider without redaction; saved screen content is deleted after 24 hours. See the [privacy notes](docs/privacy.md).

## Where it stands

The panel loads in real meetings and `startRTMS` succeeds, but Zoom events stopped reaching my server after 29 September 2026. That live-stream issue remains unresolved. The host switch has been tested with a simulated Zoom client; demos use a labeled local-display fallback.

Two optional accessibility modes describe screen changes and flag colors that may be difficult to distinguish. Local image checks decide when to request a model description. Neither mode has been tested with its intended users yet ([design notes](docs/accessibility.md)).

## Run locally

Requires Node.js 22.9+, FFmpeg, a configured Zoom Marketplace app, and an Anthropic API key.

```bash
npm ci
cp .env.example .env
npm start
npm test
```

Set the Zoom credentials, webhook secret, API key, and vision model in `.env`. The server defaults to port 8080. Zoom needs a stable HTTPS address; [deployment instructions](docs/deploy.md) cover that setup. `/healthz` shows when Zoom last reached the server.

Tests check session isolation, host controls, rate limits, accessibility triggers, and retention. They do not call the model or measure answer accuracy.

[Full guide](GUIDE.md) · [Live meeting checklist](docs/live-test.md) · [Panel protocol](docs/protocol.md) · [Marketplace notes](docs/marketplace.md)

[Privacy Policy](https://zoomlens.vercel.app/privacy.html) · [Terms](https://zoomlens.vercel.app/terms.html) · [Support](https://zoomlens.vercel.app/support.html)

Built on Zoom’s RTMS JavaScript quickstart; its attribution remains in [LICENSE](LICENSE).
