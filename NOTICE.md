# Attribution and source history

This repository contains a modified version of Stroom's 2D and 3D math
functionality. This port was modified on 2026-10-25.

The mathematical source files in `lib/src/` are adapted from John Tsui's
Stroom project (`https://github.com/JohnXu22786/Stroom`), which is licensed
under GNU AGPL v3.0. The upstream working tree used for this port was at
`0f828e2bd3a4a7dd308af4b30f3d5e9543a182fe`.

The MathLive bridge tests in `tools/math_editor_test/` are transferred from
Stroom's `tools/math_editor_test/` at commit
`b444ece22a408fb71318e7662c8408b4412935b2`. Their assertions are retained;
only the package asset lookup and test hostname are adapted for Visual Math.

Relevant upstream history includes these original commits (author metadata and
commit objects remain in Stroom):

- `38e0415862fb521168d11cebdc6a2c1d1585bcb9` — initial 2D math drawing module
- `9a79539025a0d5b49d588aa365c6b0be7de75640` — implicit graph and expression-state fixes
- `bcaf419b626ccdb850e7ad4a6194578d5f20fe4f` — 3D interaction, rotation, and construction fixes
- `ba4add1b56eb0677a187ef1df9654c3a17ee62a1` — GeoGebra-style 3D interactions
- `1881feefa3dc77387e64a8d54ead8ef48efa040a` — 3D interaction improvements
- `00b4c8e74f5e0903f79e0935d8bac18281ec9730` — 3D construction tool catalog
- `4bbcfed32c4a23cf3fd3a2b10cdcf3d366192a92` — math input and parameter controls
- `5bb5a3939039ce3636344604bb8d7483e02bff2f` — compact math input updates
- `620123953ff39024f2d7768f988a5f490a74cf6e` — solid selection and edge styling

These commits are references to the original history, not commits imported into
this repository. Their changes are interleaved with Stroom's application and UI
work. Transferring the original commit objects as-is would bring unrelated
Stroom tree content into this repository; rewriting them into path-filtered
history would alter their object identities. This port therefore preserves
traceable source commit IDs and upstream author attribution without importing
or fabricating a partial commit history.
