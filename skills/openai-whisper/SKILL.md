---
name: openai-whisper
description: Local speech-to-text with the Whisper CLI (no API key).
homepage: https://openai.com/research/whisper
metadata:
  {
    "openclaw":
      {
        "emoji": "🎙️",
        "requires": { "bins": ["whisper"] },
        "install":
          [
            {
              "id": "brew",
              "kind": "brew",
              "formula": "openai-whisper",
              "bins": ["whisper"],
              "label": "Install OpenAI Whisper (brew)",
            },
          ],
      },
  }
---

# Whisper (CLI)

Use `whisper` to transcribe audio locally.

Quick start

- `whisper /path/audio.mp3 --model medium --output_format txt --output_dir .`
- `whisper /path/audio.m4a --task translate --output_format srt`

Notes

- Models download to `~/.cache/whisper` on first run.
- `--model` defaults to `turbo` on this install.
- Use smaller models for speed, larger for accuracy.

## Script de transcrição

```bash
{baseDir}/scripts/transcribe.sh /path/to/audio.ogg
{baseDir}/scripts/transcribe.sh /path/to/audio.ogg --model medium --out /tmp/output.txt
```

Flags:

- `--model`: Modelo whisper (base, small, medium, large, turbo). Padrão: base
- `--out`: Arquivo de saída. Padrão: <input>.txt
- `--language`: Idioma do áudio (pt, en, es, etc.)
