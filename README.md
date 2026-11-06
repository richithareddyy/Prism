# ZoomLens

You join a meeting late, someone is sharing a dense chart, and you'd rather not interrupt everyone to ask what it means. ZoomLens is a panel inside Zoom where you can ask about the shared screen, and only you see the answer.

I'm building it for the Next Lab Zoom Fellowship at Arizona State University. The [project site](https://zoomlens.vercel.app) has a demo with scripted answers.

```text
Zoom RTMS → H.264 buffer → FFmpeg → JPEG → Anthropic vision API
                                               ↓
Zoom panel ← session-scoped WebSocket reply ← answer.js
```

Node.js, Express, the Zoom Apps and RTMS SDKs, WebSockets, and FFmpeg. The panel is plain JavaScript.

## How it works

An arbitrary chunk of H.264 can't be decoded on its own, so `framebuffer.js` keeps the parameter sets plus everything since the latest keyframe, which is always a decodable clip. `decode.js` turns that into a JPEG of the current frame on demand, and `answer.js` sends it to the model with the question. Follow-ups include the previous answer and a fresh image.

Every participant runs their own copy of the panel, so anything the panel enforces can be changed by whoever runs it. That's why privacy lives on the server: identity comes from Zoom's app context and signed webhooks, each connection is bound to one participant, and answers go back to the session that asked. The host's off switch works the same way, with the host identified from Zoom's signed `meeting.rtms_started` event.

Only the screen share is received, never audio, camera video, chat, or transcripts. Images and questions do go to the model provider, without redaction ([privacy notes](docs/privacy.md)).

## Status

The panel loads in real meetings and `startRTMS` succeeds, but Zoom events stopped reaching my server after 29 September 2026, and I'm still working out why. Until that's resolved, the host switch and anything else that needs the live stream have only been tested with a simulated Zoom client. Demos use the local-display fallback, and answers say so.

## Accessibility work

**Announce changes** describes meaningful screen changes for people who can't see them, and **Color Assist** flags colors that could be confused and has answers name things by label, value, or position. Both are opt-in. A 64x36 greyscale fingerprint and local color analysis (CIEDE2000, simulated color vision deficiencies) decide when to call the model at all.

Neither mode has been tried with the people it's for yet. The [accessibility notes](docs/accessibility.md) cover the design and development measurements.

## Run locally

Requires Node.js 22.9+, a configured Zoom Marketplace app, and an Anthropic API key.

```bash
npm ci
cp .env.example .env
npm start
```

Fill in the Zoom credentials, webhook secret, API key, and supported vision model in `.env`. The server defaults to port 8080; Zoom needs an HTTPS address that stays up, since it revalidates the webhook every 72 hours. See [deployment](docs/deploy.md) for the complete configuration, and `/healthz` to see when Zoom last reached the server.

## Accessibility work

**Announce changes** describes meaningful screen changes. **Color Assist** identifies potentially confusing colors and encourages explanations using labels, values, and position. Both are opt-in. Image fingerprints and color analysis limit unnecessary model calls.

These modes have not yet been evaluated with their intended users. The [accessibility notes](docs/accessibility.md) explain the implementation and development measurements.

## Tests

`npm test` runs eight scripts covering trust, session isolation, rate limits, change detection, color analysis, the watch loop, retention, and host control. They don't call the model, and answer accuracy has no automated evaluation.

Local-display and recorded-video fallbacks are opt-in and meant for controlled demos. Saved screen content is deleted after 24 hours.

[Privacy](docs/privacy.md) · [Panel protocol](docs/protocol.md) · [Full setup and limitations](GUIDE.md) · [Marketplace notes](docs/marketplace.md) · [Live meeting test](docs/live-test.md)

Public pages: [Privacy Policy](https://zoomlens.vercel.app/privacy.html) · [Terms of Use](https://zoomlens.vercel.app/terms.html) · [Guide](https://zoomlens.vercel.app/guide.html) · [Support](https://zoomlens.vercel.app/support.html)

Built on Zoom’s RTMS JavaScript quickstart; its attribution remains in [LICENSE](LICENSE).
