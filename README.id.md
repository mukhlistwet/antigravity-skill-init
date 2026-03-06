# 🧠 Antigravity Skill Init

🌐 Bahasa: [English](README.md) | Bahasa Indonesia

Setup skill personal untuk **Google Antigravity** — di-fork dari [supercent-io/skills-template](https://github.com/supercent-io/skills-template) dengan TOON auto-injection dan custom workflow skill.

## Ringkasan

| Item         | Detail                                     |
| ------------ | ------------------------------------------ |
| Skills       | **72** di 11 kategori (+1 custom)          |
| Sumber       | `supercent-io/skills-template` v2026-03-06 |
| Platform     | Google Antigravity (Gemini)                |
| Auto-inject  | ✅ Format TOON via `GEMINI.md`             |
| Skill Custom | `antigravity-dev-workflow`                 |

## Fitur

- **🔄 TOON Auto-Injection** — Katalog skill otomatis di-load setiap sesi Antigravity
- **📋 Aturan Wajib** — Agent selalu cari skill yang relevan sebelum mengerjakan task
- **🎯 Pemilihan Pintar** — Prioritas matching 5 level (exact → tag → kategori)
- **🛠️ Custom Workflow** — Alur pengembangan end-to-end: Plan → Build → Verify
- **🔀 Sinkronisasi Upstream** — Tarik update skill terbaru dari supercent-io kapan saja

## Setup Cepat

### 1. Clone Repository

```bash
git clone git@github.com:mukhlistwet/antigravity-skill-init.git <direktori-kamu>
cd <direktori-kamu>
```

### 2. Jalankan Script TOON Inject

```powershell
mkdir -Force "$env:USERPROFILE\.gemini\scripts"
Copy-Item "toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Sync
```

### 3. Verifikasi

```powershell
(Get-ChildItem -Directory "$env:USERPROFILE\.gemini\skills").Count  # Harus: 72
Test-Path "$env:USERPROFILE\.gemini\GEMINI.md"                      # Harus: True
```

### 4. Selesai!

Buka project apapun di Antigravity — skill otomatis terdeteksi.

## Cara Kerja

### Arsitektur Dua Lapis

| Lapis       | Apa                          | Kapan                  | Token               |
| ----------- | ---------------------------- | ---------------------- | ------------------- |
| **Lapis 1** | Katalog skill di `GEMINI.md` | Setiap sesi            | ~3.700              |
| **Lapis 2** | Isi lengkap `SKILL.md`       | Saat cocok dengan task | ~292/skill (maks 3) |

### Deteksi Otomatis

Tidak perlu prompt khusus. Agent akan:

1. Baca katalog di awal sesi
2. Cocokkan task kamu dengan tag/nama skill
3. Load `SKILL.md` yang relevan
4. Ikuti instruksi skill

### Penggunaan Eksplisit

Kamu juga bisa sebut langsung:

```
"Buat REST API, refer skill api-design"
"Debug error ini, pakai skill debugging"
"Review code, refer skill code-review"
```

## Struktur Direktori

```
.
├── .agent-skills/                  # 72 folder skill (sumber)
│   ├── antigravity-dev-workflow/   # ⭐ Skill custom
│   ├── skills.json                 # Manifest lengkap
│   ├── skills.toon                 # Katalog format TOON
│   └── [71 folder upstream]/
├── docs/                           # Dokumentasi tool utama
├── toon-skill-inject.ps1           # 🔧 Script regenerasi katalog
├── README.md                       # English
└── README.id.md                    # File ini (Bahasa Indonesia)
```

## Kategori Skill (72 Total)

| Kategori           | Jumlah | Skill Utama                                                             |
| ------------------ | ------ | ----------------------------------------------------------------------- |
| Agent Development  | 7      | `bmad-orchestrator`, `agentic-workflow`, `prompt-repetition`            |
| Backend            | 5      | `api-design`, `authentication-setup`, `database-schema-design`          |
| Frontend           | 7      | `design-system`, `react-best-practices`, `responsive-design`            |
| Code Quality       | 5      | `debugging`, `code-review`, `code-refactoring`                          |
| Infrastructure     | 10     | `deployment-automation`, `firebase-ai-logic`, `security-best-practices` |
| Documentation      | 4      | `technical-writing`, `changelog-maintenance`                            |
| Project Management | 4      | `task-planning`, `task-estimation`                                      |
| Search & Analysis  | 4      | `codebase-search`, `data-analysis`                                      |
| Creative Media     | 3      | `image-generation`, `video-production`                                  |
| Marketing          | 1      | `marketing-automation`                                                  |
| Utilities          | 22     | `antigravity-dev-workflow` ⭐, `ohmg`, `jeo`, `ralph`, `plannotator`    |

## Skill Utama untuk Antigravity

| Skill                             | Deskripsi                                             |
| --------------------------------- | ----------------------------------------------------- |
| **`antigravity-dev-workflow`** ⭐ | Alur kerja terstruktur: Plan → Build → Verify         |
| **`ohmg`**                        | Orkestrator multi-agent untuk Gemini/Antigravity      |
| **`jeo`**                         | Orkestrasi lengkap: Plan → Execute → Verify → Cleanup |
| **`ralph`**                       | Loop sampai lulus — pengembangan berbasis spesifikasi |
| **`plannotator`**                 | Review visual sebelum coding                          |

## Path Global

Setelah menjalankan script inject, skill disinkronkan ke:

| Path                                      | Fungsi                                   |
| ----------------------------------------- | ---------------------------------------- |
| `~/.agent-skills/`                        | Kanonik (lintas platform)                |
| `~/.gemini/skills/`                       | Global Antigravity                       |
| `~/.gemini/GEMINI.md`                     | Katalog + aturan yang di-inject otomatis |
| `~/.gemini/scripts/toon-skill-inject.ps1` | Script global                            |

## Setup di Perangkat Lain

### Prasyarat

- Node.js v18+, Git, Google Antigravity terinstall

### Langkah-langkah

```powershell
# 1. Clone
git clone git@github.com:mukhlistwet/antigravity-skill-init.git "C:\Skills"
cd "C:\Skills"

# 2. Edit RepoPath di script (jika path clone berbeda)
# Default: m:\Project\2026\Pribadi\Skill\.agent-skills

# 3. Jalankan script inject
mkdir -Force "$env:USERPROFILE\.gemini\scripts"
Copy-Item "toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Source ".\.agent-skills" -Sync

# 4. Verifikasi
(Get-ChildItem -Directory "$env:USERPROFILE\.gemini\skills").Count  # 72
```

### Setup Sekali Jalan (One-Liner)

```powershell
git clone git@github.com:mukhlistwet/antigravity-skill-init.git "$env:TEMP\skills"; Copy-Item "$env:TEMP\skills\toon-skill-inject.ps1" "$env:USERPROFILE\.gemini\scripts\" -Force; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\scripts\toon-skill-inject.ps1" -Source "$env:TEMP\skills\.agent-skills" -Sync
```

## Pemeliharaan

### Update dari Upstream

```bash
git fetch upstream
git merge upstream/main
git push origin main
# Lalu jalankan ulang script inject
powershell -ExecutionPolicy Bypass -File "~\.gemini\scripts\toon-skill-inject.ps1" -Sync
```

### Tambah Skill Custom

1. Buat folder: `.agent-skills/<nama-skill>/SKILL.md`
2. Tambahkan ke `$categoryMap` di `toon-skill-inject.ps1` (opsional)
3. Jalankan: `powershell -ExecutionPolicy Bypass -File "~\.gemini\scripts\toon-skill-inject.ps1" -Sync`

### Parameter Script

| Parameter   | Default                      | Deskripsi                      |
| ----------- | ---------------------------- | ------------------------------ |
| `-Source`   | `~/.gemini/skills`           | Direktori sumber skill         |
| `-Output`   | `~/.gemini/GEMINI.md`        | File output katalog            |
| `-RepoPath` | `m:\...\Skill\.agent-skills` | Sumber repo untuk sinkronisasi |
| `-Sync`     | `false`                      | Salin dari repo + regenerasi   |

## Kredit

- **Upstream**: [supercent-io/skills-template](https://github.com/supercent-io/skills-template) (71 skills)
- **Skills CLI**: [vercel-labs/skills](https://github.com/vercel-labs/skills)
- **Custom**: `antigravity-dev-workflow` oleh [@mukhlistwet](https://github.com/mukhlistwet)

---

_Setup: 2026-03-06 · 72 Skills · Format TOON · Siap Antigravity_
