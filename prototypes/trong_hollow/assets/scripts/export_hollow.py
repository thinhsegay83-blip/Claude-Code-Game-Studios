"""Build all Hollow World .aseprite files, reuse curated legacy models from prototypes/trong,
and emit a unified prototypes/trong_hollow/assets.js manifest."""

import json
import pathlib
import shutil
import subprocess
import sys

ASEPRITE_EXE = r"C:\Users\thinh\aseprite-build\src-full\build\bin\aseprite.exe"
SCRIPTS_DIR = pathlib.Path(__file__).resolve().parent
ASSETS_DIR = SCRIPTS_DIR.parent
ROOT_DIR = ASSETS_DIR.parent
ASE_DIR = ASSETS_DIR / "aseprite"
SPR_DIR = ASSETS_DIR / "sprites"
LEGACY_SPR_DIR = ROOT_DIR.parent / "trong" / "assets" / "sprites"

ASE_DIR.mkdir(parents=True, exist_ok=True)
SPR_DIR.mkdir(parents=True, exist_ok=True)

LUA_BUILDERS = [
    "build_hollow_chars.lua",
    "build_hollow_world.lua",
    "build_hollow_ui.lua",
]

BG_LAYERS = {
    "bg_scrapyard": ["sky", "junk_far", "ground"],
    "bg_market":    ["sky", "stalls_far", "deck"],
    "bg_vault":     ["sky", "prism_far", "hall"],
    "bg_core":      ["sky", "spires", "floor"],
}

# Reusable Aseprite models inherited read-only from prototypes/trong/assets/sprites/
LEGACY_SPRITES = {
    "char_me":           (20, 42),
    "char_lau":          (13, 40),
    "char_mi":           (13, 33),
    "char_say":          (16, 37),
    "enemy_scorn":       (32, 60),
    "enemy_weary":       (38, 42),
    "enemy_wither":      (38, 92),
    "battle_soul":       (8, 8),
    "battle_bullets":    (8, 8),
    "env_hut":           (28, 50),
    "env_hut_moss":      (31, 54),
    "env_hut_lantern":   (30, 60),
    "env_tree":          (28, 69),
    "env_tree_willow":   (32, 73),
    "wp_world_props":    (32, 58),
    "prop_sky_book":     (14, 20),
    "prop_warm_stone":   (26, 24),
    "prop_amber_fleck":  (11, 17),
    "td_tiles":          (0, 0),
    "td_char_me":        (16, 30),
    "td_char_lau":       (11, 22),
    "td_npcs":           (14, 27),
    "td_hut_small":      (28, 46),
    "td_hut_say":        (36, 54),
    "td_hut_moss":       (30, 48),
    "td_tree":           (22, 46),
    "td_flora":          (24, 52),
    "td_arch_portal":    (22, 38),
    "td_props":          (16, 26),
}

ANCHORS = {
    "char_protag":      (20, 42),
    "comp_linh":        (20, 42),
    "comp_kael":        (24, 50),
    "comp_mira":        (19, 42),
    "boss_vaelen":      (26, 56),
    "npc_vex":          (19, 40),
    "cre_echofox":      (21, 31),
    "cre_rustcrab":     (29, 39),
    "cre_prismweaver":  (24, 33),
    "hollow_portraits": (24, 26),
    "prop_cocoon":      (32, 68),
    "prop_puddle":      (48, 17),
    "prop_scale":       (23, 58),
    "prop_campfire":    (34, 46),
    "prop_statue":      (34, 90),
    "prop_pulse_core":  (70, 70),
    "prop_leviathan":   (105, 58),
    "prop_stele_trong": (28, 74),
    "prop_solo_stove":  (26, 42),
    "prop_fox_egg":     (14, 28),
    "ui_hud_linh":      (0, 0),
    "ui_hud_kael":      (0, 0),
    "ui_hud_mira":      (0, 0),
    "ui_items":         (12, 12),
    "panel_cs01_hand":     (80, 45),
    "panel_cs02_leviathan": (80, 45),
    "panel_cs03_scale":    (80, 45),
    "panel_cs04_split":    (80, 45),
    "panel_cs05_soup":     (80, 45),
    "panel_cs06_bowl":     (80, 45),
    "panel_cs07_hearths":  (80, 45),
    "panel_cs08_puddle":   (80, 45),
    "td_char_protag":      (16, 30),
    "td_comp_linh":        (16, 30),
    "td_comp_kael":        (16, 30),
    "td_comp_mira":        (16, 30),
    "td_boss_vaelen":      (18, 36),
    "npc_syndicate_guard": (20, 44),
    "cre_parasite_mite":   (18, 22),
    "prop_debt_pillar":    (24, 62),
    "ui_boss_shield":      (0, 0),
    "ui_memoria_ring":     (32, 32),
    "ui_symbiosis_wheel":  (20, 20),
    "fx_hearth_wisp":      (12, 12),
    "fx_ambient_flora":    (16, 28),
    "fx_music_box":        (14, 24),
    **LEGACY_SPRITES,
}


def run_aseprite(args):
    res = subprocess.run([ASEPRITE_EXE, "--batch", *args], capture_output=True, text=True)
    if res.returncode != 0:
        print(res.stdout)
        print(res.stderr, file=sys.stderr)
        raise RuntimeError(f"Aseprite failed ({res.returncode}): {' '.join(args)}")
    if res.stdout.strip():
        print(res.stdout.strip())


def parse_sheet_manifest(stem, json_path):
    data = json.loads(json_path.read_text(encoding="utf-8"))
    frames = [
        {
            "name": fr["filename"],
            "x": fr["frame"]["x"],
            "y": fr["frame"]["y"],
            "w": fr["frame"]["w"],
            "h": fr["frame"]["h"],
            "dur": fr.get("duration", 200),
        }
        for fr in data["frames"]
    ]
    tags = {tg["name"]: {"from": tg["from"], "to": tg["to"]} for tg in data.get("meta", {}).get("frameTags", [])}
    ax, ay = ANCHORS.get(stem, (frames[0]["w"] // 2, frames[0]["h"] // 2))
    return {
        "src": f"assets/sprites/{stem}.png",
        "w": frames[0]["w"],
        "h": frames[0]["h"],
        "ax": ax,
        "ay": ay,
        "frames": frames,
        "tags": tags,
    }


def main():
    for lua_name in LUA_BUILDERS:
        print(f"Running {lua_name}...")
        run_aseprite(["--script", str(SCRIPTS_DIR / lua_name)])

    manifest = {}
    for ase_path in sorted(ASE_DIR.glob("*.aseprite")):
        stem = ase_path.stem
        if stem in BG_LAYERS:
            for lname in BG_LAYERS[stem]:
                key = f"{stem}_{lname}"
                layer_png = SPR_DIR / f"{key}.png"
                run_aseprite([str(ase_path), "--layer", lname, "--save-as", str(layer_png)])
                manifest[key] = {
                    "src": f"assets/sprites/{key}.png",
                    "w": 320,
                    "h": 360,
                    "ax": 0,
                    "ay": 0,
                    "frames": [{"name": lname, "x": 0, "y": 0, "w": 320, "h": 360, "dur": 200}],
                    "tags": {},
                }
            continue

        png_path = SPR_DIR / f"{stem}.png"
        json_path = SPR_DIR / f"{stem}.json"
        run_aseprite([
            str(ase_path),
            "--sheet-type", "horizontal",
            "--sheet", str(png_path),
            "--data", str(json_path),
            "--format", "json-array",
            "--list-tags",
        ])
        manifest[stem] = parse_sheet_manifest(stem, json_path)

    # Copy & register inherited legacy models from prototypes/trong/assets/sprites/
    legacy_count = 0
    for stem in sorted(LEGACY_SPRITES):
        src_png = LEGACY_SPR_DIR / f"{stem}.png"
        src_json = LEGACY_SPR_DIR / f"{stem}.json"
        if not (src_png.exists() and src_json.exists()):
            raise FileNotFoundError(f"Missing legacy asset in {LEGACY_SPR_DIR}: {stem}")
        dst_png = SPR_DIR / f"{stem}.png"
        dst_json = SPR_DIR / f"{stem}.json"
        shutil.copy2(src_png, dst_png)
        shutil.copy2(src_json, dst_json)
        manifest[stem] = parse_sheet_manifest(stem, dst_json)
        legacy_count += 1

    assets_js = ROOT_DIR / "assets.js"
    assets_js.write_text(
        "// Auto-generated from Hollow Aseprite builders + inherited trong models via export_hollow.py\n"
        f"window.HOLLOW_ASSETS = {json.dumps(manifest, ensure_ascii=False, indent=2)};\n",
        encoding="utf-8",
    )
    print(f"Wrote {assets_js} with {len(manifest)} sprites (including {legacy_count} inherited legacy models).")


if __name__ == "__main__":
    main()
