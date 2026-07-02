# MewoText

MewoText is a high-performance, ultra-lightweight hybrid text editor. Instead of relying on heavy frameworks like Electron, it uses a custom **C backend** that serves a reactive **Angular frontend** inside a native desktop window via `webview.h`.

This architecture eliminates browser overhead while leveraging Angular's component-driven UI for fluid, real-time text processing.

## How it Works

- **C Backend (`webview.h`):** Instantiates a lightweight, cross platform webview window and handles the native desktop application shell with a minimal memory footprint.
- **Angular Frontend:** Acts as the core editor engine, capturing low-level keystroke events and handling complex text manipulation in real time.
