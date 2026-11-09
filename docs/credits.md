# Credits

Prism is an independent student project built during the Next Lab Zoom
Fellowship at Arizona State University. It isn't a Zoom product, and Zoom
hasn't reviewed or endorsed it. Zoom, Zoom Apps and RTMS are Zoom's names for
its own products.

## Where it started

The first version was set up from Zoom's RTMS quickstart sample for Node.js,
which is MIT licensed. Its `.gitignore`, `.env.example` layout and the first
`index.js` came from there; the code has since been rewritten.

## Software Prism uses

| Package | Used for | License |
|---|---|---|
| [`@zoom/rtms`](https://www.npmjs.com/package/@zoom/rtms) | Receiving the meeting's screen share | MIT |
| Zoom Apps SDK, loaded from `appssdk.zoom.us` | Opening as a panel in the meeting, and the Start button | Zoom's developer terms |
| [`@anthropic-ai/sdk`](https://www.npmjs.com/package/@anthropic-ai/sdk) | Asking Anthropic's model about the screen | MIT |
| [`express`](https://expressjs.com) | The web server | MIT |
| [`ws`](https://github.com/websockets/ws) | The panel's live connection | MIT |
| [`ffmpeg-static`](https://github.com/eugeneware/ffmpeg-static), which ships [FFmpeg](https://ffmpeg.org) | Turning screen-share video into a still image | GPL-3.0-or-later |

FFmpeg runs as a separate program that Prism calls, not as linked code. A
container image built from the `Dockerfile` includes the FFmpeg binary, so
publishing that image means meeting FFmpeg's license terms for the binary;
running it as a service does not.

## Methods

Color Assist uses published color science, implemented from the papers:

- Machado, Oliveira and Fernandes (2009), "A Physiologically-based Model for
  Simulation of Color Vision Deficiency", for how colors look with
  protanopia, deuteranopia and tritanopia.
- Sharma, Wu and Dalal (2005), "The CIEDE2000 Color-Difference Formula", for
  how far apart two colors look. `test-colors.js` checks it against their
  published test values.
