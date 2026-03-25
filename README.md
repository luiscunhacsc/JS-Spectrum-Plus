# JS Spectrum (ZX Spectrum 48K Emulator in the Browser)

A small, self-contained **ZX Spectrum 48K** emulator that runs entirely in the browser using a JavaScript **Z80 CPU** core.

It can load:
- a **48K ROM** (e.g., `48.rom`)
- **`.TAP`** tape images (from the `TAPs/` folder, or anywhere you choose)

---

## ✨ What’s in this repo

```
.
├─ js_spectrum.html          # Main emulator (UI + render + audio + tape loading)
├─ Z80.js                    # Z80 CPU core
├─ 48.rom                    # ZX Spectrum 48K ROM
├─ keyboard.jpg              # Keyboard overlay image (toggle with F1)
├─ TAPs/                     # Put .tap files here (optional, for organization)
└─ Screenshots and Video/
   ├─ Sample01.png .. Sample06.png
   └─ Step-by-Step Video.mp4
```

---

## 🚀 Quick start

1. Download or clone the repo
2. Open **`js_spectrum.html`** in your browser
3. Click **Start Audio** (recommended — browsers require a user gesture)
4. Click **Load ROM** and select `48.rom`
5. Click **Reset**
6. Click **Load Tape** and select a `.tap` file
7. In Spectrum BASIC: type `LOAD ""` and press **Enter**

> Tip: click the emulator screen first so it captures keyboard input.


## 🎮 Controls / Keyboard

- **F1** toggles the on-screen keyboard overlay (**`keyboard.jpg`**).
- Click inside the emulator display area to focus keyboard input.

Common mapping convention used in many Spectrum emulators:
- **PC Ctrl** → **Caps Shift**
- **PC Shift** → **Symbol Shift**

---

## 📼 TAP loading notes

Tape loading is supported via `.tap` files.
If loading fails:
- confirm you loaded the **ROM** first,
- confirm the selected file is a valid **`.tap`**,
- press **Reset**, then try again,
- type `LOAD ""` in BASIC again.

---

## 🖼️ Screenshots & Video

### Screenshots
![Sample01](Screenshots%20and%20Video/Sample01.png)
![Sample02](Screenshots%20and%20Video/Sample02.png)
![Sample03](Screenshots%20and%20Video/Sample03.png)
![Sample04](Screenshots%20and%20Video/Sample04.png)
![Sample05](Screenshots%20and%20Video/Sample05.png)
![Sample06](Screenshots%20and%20Video/Sample06.png)

### Step-by-step video (download the mp4 file in order to be able to see it)
- ▶️ **[Step-by-Step Video (MP4)](Screenshots%20and%20Video/Step-by-Step%20Video.mp4)**

---

## 🧾 License (MIT)

This project is distributed under the **MIT License**.

### Attribution
- **Z80 CPU core (`Z80.js`)**: Copyright (c) **Molly Howell** — MIT License  
- **JS Spectrum emulator code (`js_spectrum.html` and project integration)**: Copyright (c) **Luís Simões da Cunha**, 2025 — MIT License

See the `LICENSE` file for full text.

---
