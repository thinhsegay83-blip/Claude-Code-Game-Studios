# HỒ SƠ THIẾT KẾ NHÂN VẬT, THẾ GIỚI & BÀN GIAO ART CHO DEV (`prototypes/trong_hollow/`)

> **Vai trò & Ranh giới:** Tài liệu này là phần bàn giao từ **Thiết kế (Visual / World / Character / UX Design)** gửi sang **Claude Code (Cơ chế & Lập trình Gameplay)** dựa trên kịch bản v4.3 (`handover_story.md`). Toàn bộ **87 assets** (**58** dựng mới cho *Tinh Cầu Rỗng* gồm `46` sprite sheet nhân vật/đạo cụ/UI/môi trường + `12` lớp parallax nền, cùng **29** model cũ kế thừa từ `prototypes/trong`) đã được đóng gói sẵn vào [`assets.js`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/assets.js) (`window.HOLLOW_ASSETS`), kèm dữ liệu kể chuyện Phase 2 tại [`narrative_extras.js`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/narrative_extras.js), bản đồ Top-Down tại [`topdown_blueprints.js`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_blueprints.js), [`topdown_maps.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_maps.html) và [`design_showcase.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/design_showcase.html).

---

## 1. DANH SÁCH ASSET NHÂN VẬT, ĐỒNG ĐỘI & SINH VẬT (`window.HOLLOW_ASSETS`)

*(Tỉ lệ gốc: `1x`; render `1280×720` khuyến nghị `PIXEL_SCALE = 2`, `imageSmoothingEnabled = false`. Đã bổ sung hướng quay lưng `walk_up` & đi ngang `walk_side` cho cơ chế **Caterpillar Party Follow**.)*

| Asset Key | Mã Kịch Bản | Kích thước (px) | Anchor `(ax, ay)` | Tags Hoạt Ảnh | Đặc Điểm Tạo Hình & Tín Hiệu Thị Giác |
| :--- | :--- | :---: | :---: | :--- | :--- |
| `char_protag` | `CHAR_PROTAG` | `40×48` | `(20, 42)` | `hooded` (4f), `hooded_walk` (6f), `idle` (4f), `walk` (6f), `walk_up` (6f), `walk_side` (6f), `puddle` (4f), `pulse` (4f), `dissolve` (6f) | Hồi 1–2 **trùm mũ áo choàng kiểu `char_me`** giấu mái tóc bạc; từ Hồi 3 (`CS_04`) trở đi lộ khuôn mặt giống Vaelen, Khế Ước Trắng, vòng tơ lam, đốm 2 nhịp tim & `dissolve`. |
| `comp_linh` | `COMP_LINH` | `40×48` | `(20, 42)` | `idle` (4f), `listen` (4f), `wrench` (4f), `walk_up` (4f), `walk_side` (4f) | Kính lúp trán tròn, **ống nghe đồng**, **sổ bìa xanh 5 Lumen**, chú cáo 4 tai *Mốc* trên vai trái. |
| `comp_kael` | `COMP_KAEL` | `48×56` | `(24, 50)` | `idle` (4f), `soup` (4f), `guard` (4f), `walk_up` (4f), `walk_side` (4f) | Giáp gốm trắng hàn chỉ vàng **Kintsugi**, nồi súp đồng sau lưng (`walk_up` thấy rõ lưng giáp & chỉ vàng), khiên gốm & bát súp sứt vành. |
| `comp_mira` | `COMP_MIRA` | `38×48` | `(19, 42)` | `idle` (4f), `abacus` (4f), `step` (4f), `walk_up` (4f), `walk_side` (4f) | Áo choàng chàm viền chỉ vàng, kẹp tóc vàng, bàn tính pha lê `0 Lumen`. |
| `boss_vaelen` | `BOSS_VAELEN` | `52×62` | `(26, 56)` | `cabled` (4f), `idle` (4f), `cast` (4f), `old` (4f) | Tag `cabled` ngồi trên ngai cắm **6 ống cáp truyền Memoria lên Mặt Trời**; chung khuôn mặt `char_protag` nhưng mắt trắng vô cảm; `old` là dạng ông lão hiền hậu ở True Ending. |
| `npc_vex` | `NPC_BROKER_VEX` | `38×46` | `(19, 40)` | `idle` (4f) | Áo choàng tím, kính lúp đồng một mắt, khay `Memoria`. |
| `cre_echofox` | `CRE_ECHOFOX` | `42×36` | `(21, 31)` | `idle` (4f), `chime` (4f) | 4 tai (2 chính + 2 thính âm) + chuông gió vàng ở chóp đuôi. |
| `cre_rustcrab` | `CRE_RUSTCRAB` | `58×44` | `(29, 39)` | `idle` (4f), `warm` (4f) | Mai sắt gỉ + cửa lò địa nhiệt + nét khắc 300 năm trên mai. |
| `cre_prismweaver` | `CRE_PRISMWEAVER` | `48×38` | `(24, 33)` | `idle` (4f), `weave` (4f) | 8 chân mảnh + bụng tinh thể 7 sắc nhả tơ phát sáng. |
| `npc_syndicate_guard` | `NPC_SYNDICATE_GUARD` | `40×50` | `(20, 44)` | `idle` (4f), `halberd` (4f) | Lính gác Ngân Hàng Ký Ức mặc giáp chàm, mũ kín hở khe mắt lam, cầm kích thu thuế 20% tại bến Chợ Nổi Hồi 2. |
| `cre_parasite_mite` | `CRE_PARASITE_MITE` | `36×28` | `(18, 22)` | `cling` (4f), `removed` (4f) | Bọ ký sinh hút quang trên lưng Kình Ngư Hồi 2 (`cling`); gỡ sạch chuyển thành hào quang vàng lam (`removed`) giảm 20% thuế chợ. |

### Bộ 21 Chân Dung Thoại Biểu Cảm (`hollow_portraits`, `48×52`, anchor `(24, 26)`)

| Nhân vật | Tags trong `hollow_portraits` | Ánh xạ gợi ý theo `handover_story.md` YAML cues |
| :--- | :--- | :--- |
| `CHAR_PROTAG` | `protag_hooded`, `protag_warm`, `protag_shock`, `protag_fading` | `protag_hooded` cho Hồi 1–2 trước khi lột mũ; `protag_shock` tại `CS_04`; `protag_fading` khi `float_body_cohesion < 0.5`. |
| `COMP_LINH` | `linh_smile`, `linh_shock`, `linh_teary` | `linh_shock` -> `PORTRAIT_LINH_PALE_TREMBLING`; `linh_teary` -> `PORTRAIT_LINH_TEARY_SNIFFLE_SMILE` / `POUT_BLUSH_TEARY`. |
| `COMP_KAEL` | `kael_warm`, `kael_sad`, `kael_glow` | `kael_sad` -> `PORTRAIT_KAEL_CALM_SAD` / `EYES_CLOSED`; `kael_glow` -> `PORTRAIT_KAEL_GOLDEN_GLOW`. |
| `COMP_MIRA` | `mira_smirk`, `mira_fierce`, `mira_gentle` | `mira_smirk` -> `PORTRAIT_MIRA_WINK_ABACUS`; `mira_fierce` -> `PORTRAIT_MIRA_FIERCE_DETERMINED`; `mira_gentle` -> `PORTRAIT_MIRA_GENTLE_SMILE`. |
| `BOSS_VAELEN` | `vaelen_cold`, `vaelen_pained`, `vaelen_old` | `vaelen_cold` -> `PORTRAIT_VAELEN_HOLLOW_EYES`; `vaelen_pained` -> `PORTRAIT_VAELEN_PAINED_SHADOW`; `vaelen_old` -> True Ending. |
| `NPC_VEX` | `vex_smug` | `PORTRAIT_VEX_SMIRK_GLASSES`. |
| `BESTIARY` (4 sinh vật) | `fox_happy`, `crab_warm`, `weaver_spark`, `mite_clean` | Chân dung 4 sinh vật cộng sinh (`CRE_ECHOFOX`, `CRE_RUSTCRAB`, `CRE_PRISMWEAVER`, `CRE_PARASITE_MITE`) trong tab `J · Túi & SV` (fallback sang chân dung đồng đội/Protag nếu thiếu). |

---

## 2. DIEGETIC HUD, ICON VẬT PHẨM & 2D PIXEL INSERT PANELS (v4.3)

1. **3 Cụm HUD Nội Tại (`scale: 0.5–1.0`, góc trên phải / cạnh khung thoại; ẨN SẠCH khi `flag_party_separated == true` và bay vào khôi phục trong `CS_06_FOURTH_BOWL`):**
   - `ui_hud_linh` (`124×44`, anchor `0,0`, tags: `active`, `low`): Thanh HP nét vẽ chì trên giấy xé + gáy sổ xanh `5L`.
   - `ui_hud_kael` (`108×44`, anchor `0,0`, tags: `warm`, `cold`): Bát súp gốm hàn vàng bốc khói giữ thanh Hơi Ấm.
   - `ui_hud_mira` (`116×44`, anchor `0,0`, tags: `active`, `zero`): Bàn tính pha lê đếm `Lumen`/`Memoria` + thẻ đóng dấu `0L`.
2. **Icon Vật Phẩm (`ui_items`, `24×24`, anchor `(12, 12)`):**
   - 7 tags: `deed_blank` (`ITEM_BLANK_DEED` Hồi 1), `deed_lit` (hiện chữ Hồi 4), `soup_clean` (`ITEM_KAEL_SOUP`), `soup_burnt` (Hồi 3 tự nấu), `memoria_coin` (`ITEM_STRAY_MEMORIA`), `lumen_coin`, `prism_thread`.
3. **Đủ 8/8 2D Pixel Close-Up Insert Panels (`160×90`, anchor `(80, 45)`, tag `idle` — phóng giữa dải Letterbox 12% & Dual-Pulse UI):**
   - `panel_cs01_hand` (`CS_01_AWAKENING`): Bàn tay tan pixel sáng được Linh nắm cổ tay dán băng cá nhân hình ngôi sao.
   - `panel_cs02_leviathan` (`CS_02_LEVIATHAN_DAWN`): Bốn bóng nhỏ & Cáo Mốc trên mũi Kình Ngư ngắm bình minh Mặt Trời Sinh Học.
   - `panel_cs03_scale` (`CS_03_ZERO_LUMEN`): Cân Định Giá nổ chớp bên bàn tính pha lê nơi tay Mira gẩy hạt về vạch `0`.
   - `panel_cs04_split` (`CS_04_STATUE_REVEAL`): Split-screen 1:1 mặt tượng đá Vaelen vs mặt cậu + hộp nhạc vỡ.
   - `panel_cs05_soup` (`CS_05_BURNT_SOUP`): Nồi súp cháy khê ngập hành lá trên bếp lạnh Độc Hành Hồi 3.1 & giọt nước mắt tắt than.
   - `panel_cs06_bowl` (`CS_06_FOURTH_BOWL`): Bàn tay gốm Kintsugi đặt bát súp thứ 4 bên trái dưới mưa + sổ xanh gạch `MIỄN PHÍ`.
   - `panel_cs07_hearths` (`CS_07_MILLION_HEARTHS`): Bốn bàn tay có cổ áo chạm chung tờ Khế Ước Trắng rực sáng giữa muôn vạn đốm lửa trại.
   - `panel_cs08_puddle` (`CS_08_STILL_YOU`): Vũng nước trong vắt phản chiếu cả 4 gương mặt tươi cười ở True Ending.
4. **Quy chuẩn Cutscene Điện Ảnh (đã dựng mẫu trực quan trong [`design_showcase.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/design_showcase.html) phím `C`):**
   - **Letterbox 12% Matte:** Hai dải đen `#040508` cao `86px` (`12%` của `720px`) trên và dưới, tự động ẩn HUD thường để tập trung vào Insert Panel `160×90`.
   - **Song Mạch Nội Tâm (Dual-Pulse Inner Voice):** Trình bày hai khung đối thoại song song tranh luận trực tiếp dưới panel: `[NHỊP KIẾN TRÚC - 60 BPM]` (khung vuông góc sắc cạnh `#9be3ff`, font monospace `Cascadia Mono`, chu kỳ `1.00s`) đối lập với `[NHỊP CỘNG SINH - 85 BPM]` (khung bo tròn viền vàng kép `#ffcb6b`, font serif `Sitka Text`, chu kỳ `0.71s`).
5. **Đạo cụ Kỷ Vật & UI Vòng Cộng Sinh Phase 2 (`85 -> 87` assets):**
   - `fx_music_box` (`28×28`, anchor `(14, 24)`, `8f`): Hộp Nhạc Kỷ Vật Của Mẹ Linh với 2 tags: `intact` (`0..3`, hộp gỗ đồng thau mở nắp phát nốt nhạc vàng ở Hồi 2 & True Ending) và `shattered` (`4..7`, vỡ bánh răng dưới chân tượng Vaelen ở Hồi 3 & Hollow Syndicate).
   - `ui_symbiosis_wheel` (`40×40`, anchor `(20, 20)`, `6f`): 3 biểu tượng cho **Vòng Hành Động Cộng Sinh (`TopDownSymbiosisWheel`)**, mỗi tag gồm 2 frame (`idle`/`pulse`): `listen` (`0..1`, tai + sóng âm lam), `feed` (`2..3`, ổ bánh vàng + ánh sáng), `heal` (`4..5`, bàn tay + lá thuốc lục ngọc).

---

## 3. ĐỒNG BỘ TỌA ĐỘ 4 HỒI & ĐẠO CỤ THẾ GIỚI (`WORLD_W` khớp 1:1 với `design_showcase.html`)

*(Mặt đất chuẩn `gy = 610`. Mặt Trời Sinh Học `prop_pulse_core` treo giữa bầu trời: `warm` ở Cộng Sinh, `strained` ở Tha Hóa.)*

- **Hồi 1 — Thung Lũng Phế Liệu (`act1`, `WORLD_W = 2400`, `coreScale = 0.72`):**
  - Parallax: `bg_scrapyard_sky`, `bg_scrapyard_junk_far`, `bg_scrapyard_ground`.
  - Điểm đặt: `x=280` `prop_cocoon` (`open`), `x=680` `prop_puddle` (`one`), `x=1120` `cre_rustcrab` (`warm`), `x=1480` `comp_linh` (`listen`), `x=1860` `cre_echofox` (`chime`).
- **Hồi 2 — Chợ Nổi Lưng Kình Ngư (`act2`, `WORLD_W = 2400`, `coreScale = 0.85`):**
  - Parallax: `bg_market_sky`, `bg_market_stalls_far`, `bg_market_deck`.
  - Điểm đặt: `x=320, yOff=+44 (lớp tiền cảnh mũi sàn)` `prop_leviathan` (`idle` — 210×96 với râu tấm sừng, vây & mắt phát quang), `x=430, yOff=+26 (tiền cảnh thân Kình Ngư)` `cre_parasite_mite` (`cling`/`removed` nhiệm vụ giảm 20% thuế chợ), `x=640` `npc_syndicate_guard` (`halberd`), `x=760` `prop_scale` (`overflow`), `x=1160` `npc_vex`, `x=1260` `prop_fox_egg` (`chime`), `x=1410` `comp_mira` (`abacus`), `x=1660` `prop_campfire` (`warm`), `x=1800` `comp_kael` (`soup`), `x=2040` `prop_puddle` (`four` / `corrupt`).
- **Hồi 3 — Rừng Khúc Xạ & Hầm Ngầm (`act3`, `WORLD_W = 2400`, `coreScale = 0.78`, mưa bụi sắt):**
  - Parallax: `bg_vault_sky`, `bg_vault_prism_far` (khối tinh thể đa giác & tơ khúc xạ + cột Ngân Hàng), `bg_vault_hall`.
  - Điểm đặt: `x=420` `cre_prismweaver` (`weave`), `x=740` `prop_solo_stove` (`burnt` khi Độc Hành Hồi 3.1 / `cold` khi Đoàn Tụ), `x=1040` `prop_statue` (`idle`), `x=1580` `prop_campfire` (`warm`/`cold`), `x=1700` `comp_kael`, `x=1810` `comp_linh`, `x=1910` `comp_mira` (cả 3 ẩn khi `flag_party_separated == true`), `x=2060` `prop_puddle` (`solo_fade` / `four` / `corrupt`).
- **Hồi 4 — Đỉnh Tháp Lõi Nhịp Tim (`act4`, `WORLD_W = 2000`, `coreScale = 1.55`):**
  - Parallax: `bg_core_sky`, `bg_core_spires`, `bg_core_floor`.
  - Điểm đặt: `x=320` `prop_stele_trong` (**Tấm Bia Cổ "TRONG"** — `rusted` -> `cleaned`), `x=560` `prop_puddle` (`clear` / `corrupt`), `x=880` `comp_kael` (`guard`), `x=990` `comp_linh` (`wrench`), `x=1100` `comp_mira` (`step`), `x=1210` `cre_echofox` (`chime`), `x=1540` `boss_vaelen` (`cabled` ở Tha Hóa/trước trận -> `old` ở True Ending).

---

## 4. QUY CHUẨN TYPOGRAPHY (ĐÃ KHẮC PHỤC LỖI DẤU TIẾNG VIỆT)
- `Sitka Display` (`600 SemiBold`): Tên hồi, tên vùng, tên trùm, tiêu đề cutscene.
- `Sitka Text` (`500 Regular` / `italic 400`): Lời thoại chính & suy nghĩ vũng nước lưu game.
- `Candara` (`600–700`): Nhãn đồng đội, nút hành động, gợi ý tương tác.
- `Cascadia Mono` (`600`): Chỉ số `Lumen`, `Memoria`, `HP`, `Corruption / Eco`.

---

## 5. KHO 29 MODEL CŨ KẾ THỪA TỪ `prototypes/trong/` (SẴN SÀNG TRONG `window.HOLLOW_ASSETS`)

Claude Code có thể dùng trực tiếp các sprite sau đây mà không cần vẽ mới:

| Nhóm Asset | Keys trong `window.HOLLOW_ASSETS` | Kích thước | Tags & Vai trò trong *Thế Giới Tinh Cầu Rỗng* |
| :--- | :--- | :---: | :--- |
| **Chiến đấu Undertale & Vệ Binh** | `battle_soul`, `battle_bullets`, `enemy_scorn`, `enemy_weary`, `enemy_wither` | `16×16`, `64×68`–`76×98` | `battle_soul` (`idle`, `hurt`, `focus`) cho né đạn đấu Vaelen; `battle_bullets` (`shard`, `orb`, `leaf`, `thorn`); 3 `enemy_*` (`idle`, `charge`, `attack`) làm **Vệ Binh Thu Hồi Nợ** ở Hồi 3 & 4. |
| **Kit Bản đồ Top-Down 3/4** | `td_tiles` (53 tiles), `td_hut_small`, `td_hut_say`, `td_hut_moss`, `td_arch_portal`, `td_tree`, `td_flora`, `td_props` (31 props) | `16×16`–`72×64` | Lắp ngay bản đồ **2D Pixel Top-Down** (`grass_*`, `path_*`, `wood_*`, `water`, `bridge`, `cavern_*`, `desk_ledger`, `bookshelf`, `stove_tea`, `well_broken`/`free`, `lantern_post`). |
| **Nhân vật & Cư dân Cổ** | `char_me`, `char_lau`, `char_mi`, `char_say`, `td_char_me`, `td_char_lau`, `td_npcs` | `22×26`–`40×48` | `td_char_me` đủ 3 hướng `down_idle/walk`, `up_idle/walk`, `side_idle/walk`; `char_me/lau/mi/say` & `td_npcs` làm **Cư dân Tinh Cầu / Quá khứ** hoặc bản phác nguyên mẫu gốc của *Trong*. |
| **Nhà, Cây & Đạo cụ Thế giới** | `env_hut`, `env_hut_moss`, `env_hut_lantern`, `env_tree`, `env_tree_willow`, `wp_world_props`, `prop_sky_book`, `prop_warm_stone`, `prop_amber_fleck` | `22×20`–`64×78` | Quán trọ đèn lồng Hồi 2 (`env_hut_lantern`), trạm rêu Hồi 1 (`env_hut_moss`), `wp_world_props` (`bell_tower`, `leaf_boat`, `brazier_cold`/`lit`, `amber_shrine`, `root_sprout`, `stone_lantern`). |

---

## 6. BẢN ĐỒ TOP-DOWN 4 HỒI & BỘ NHÂN VẬT CATERPILLAR (`topdown_blueprints.js` + `topdown_maps.html`)

- **Sprite Đội hình & Trùm Top-Down 3/4 mới (`32×36`, anchor `(16, 30)` & `td_boss_vaelen` `36×42`, anchor `(18, 36)`):**
  - `td_char_protag`: `hooded_down`, `hooded_up`, `hooded_side` (Hồi 1–2 trùm mũ kiểu `char_me`), `down_walk`, `up_walk`, `side_walk` (sau khi gặp tượng Vaelen lộ tóc bạc), và `dissolve` (Hồi 3 Độc Hành).
  - `td_comp_linh`, `td_comp_kael`, `td_comp_mira`: đủ 3 hướng `down_walk`, `up_walk`, `side_walk` bám theo hàng `PositionHistoryQueue` (`stride = (idx + 1) * 12`). Khi người chơi dừng gấp, `td_comp_linh` chạm nhẹ vào lưng và hiện dấu `!` trong `0.75s`.
  - `td_boss_vaelen`: sprite phản chiếu Top-Down của Đại Kiến Trúc Sư (`down`, 2f).
- **File dữ liệu Tilemap ([`topdown_blueprints.js`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_blueprints.js)):** Xuất sẵn ma trận lưới ký tự + `tileLegend` (`16×16` tile phóng `2x = 32×32px`) cho cả 4 Hồi: `act1` `44×22`; `act2` `46×22` sàn gỗ trên lưng Kình Ngư với điểm `spawn` tại `(14.5, 11.2)` giữa quảng trường (đội hình Caterpillar 4 người đứng thoáng không bị `prop_leviathan` che), `fx_music_box` (`intact`) đặt tại `(32.3, 9.2)` trước hiên Quán Trọ tách khỏi `prop_campfire` `(30.5, 10.8)`, cùng `cre_parasite_mite` + `npc_syndicate_guard`; `act3` `46×22` hầm ngầm mở rộng cầu bắc `cccc` thành 2 hàng (`rows 4–5`), `prop_solo_stove` ở `(19.5, 5.5)` và `fx_music_box` (`shattered`) tại `(15.0, 11.0)` cạnh `prop_statue` `(16.5, 10.5)`; `act4` `42×22` Đấu Trường 4 Trụ Khiên Nợ `prop_debt_pillar` ở `(x=10/31, y=7.1/16.5)` tránh bị HUD che tại spawn.
- **Vũng Nước Phản Chiếu Lật Y & Nháy Sấm 0.1s (`Top-Down Flipped Reflection`):** Trong [`topdown_maps.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_maps.html), khi lại gần `prop_puddle` (`< 110px`), hệ thống vẽ bóng sprite lật Y (`flipY: true`). Riêng **Hồi 3** có cơ chế nháy sấm sét chu kỳ (`0.14s` mỗi `3.2s` hoặc bật thử bằng phím `F`) tráo bóng phản chiếu thành `td_boss_vaelen` lật Y kèm tia sét lam!

---

## 7. UI ĐẤU TRÙM VAELEN HỒI 4 & THANH TẨY 2.5s (`B · Boss Hồi 4` + Hồi 4 Top-Down)

1. **4 Assets Dựng Mới cho Trùm Cuối (`80 -> 84` assets):**
   - `prop_debt_pillar` (`48×72`, anchor `(24, 62)`): Trụ Cân Đối Nợ tại 4 góc đấu trường với tags `locked` (tinh thể Memoria lam nối dây laser về Vaelen) và `shattered` (vết hàn vàng Kintsugi + ấn `0L`).
   - `ui_boss_shield` (`180×42`, anchor `(0, 0)`): Thanh khiên trùm ở đỉnh giữa màn hình (`shielded_4`, `shielded_2`, `broken`, `purified`), tránh đụng HUD trái/phải.
   - `ui_memoria_ring` (`64×64`, anchor `(32, 32)`): Vòng radial giữ phím `Space` **`2.5s`** (`idle`, `purify`, `burst`) dùng cho `MemoriaPurificationHold`.
   - `fx_hearth_wisp` (`24×24`, anchor `(12, 12)`): Đốm Lửa Trại Cộng Hưởng (`gold`, `mint`) thay thế 6 dây cáp tháp khi kích hoạt `CS_07_TEN_THOUSAND_HEARTHS`.
2. **Màn Thiết Kế Chuyên Biệt (`B · Boss Hồi 4` trong [`design_showcase.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/design_showcase.html)) & Hồi 4 Tương Tác ([`topdown_maps.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_maps.html)):**
   - Cho phép giữ `[Space 2.5s]` bóp vỡ đồng `CUR_MEMORIA` / phá Trụ Nợ cạnh bên; nhấn `P` hoặc `E` phá lần lượt 4 Trụ Khiên Nợ (`4 -> 2 -> Sập Khiên`); nhấn `F` / `B` **Đốt Khế Ước Trắng (`CS_07`)** cắt đứt 6 cáp trên trời, hóa thành 16+ `fx_hearth_wisp`, triệu hồi *Hồ Ly Âm Bản*, *Cua Giáp Lò Rèn*, *Nhện Khúc Xạ* cùng `boss_vaelen` (`old`).

---

## 8. NÂNG CẤP MỸ THUẬT MÔI TRƯỜNG, BIỂN MÂY & ÁNH SÁNG ĐIỂM 2D (`85` assets)

- **Sprite trang trí môi trường mới (`fx_ambient_flora`, `32×32`, anchor `(16, 28)`):** 4 tags 4-frame (`lantern_sway` Hồi 2, `prism_crystal` Hồi 3, `scrap_blossom` Hồi 1, `core_ember` Hồi 4) được rải qua `decor` không chắn đường trong [`topdown_blueprints.js`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_blueprints.js) & [`design_showcase.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/design_showcase.html).
- **Parallax 12 lớp & Nhân vật nâng cấp:** Tầng mây mượt trên biển mây Hồi 2, vòm cổng xích Hồi 1, tia khúc xạ & cột Hồi 3, astrolabe Hồi 4; `prop_leviathan` da cá voi mịn nhắm/mở mắt; bộ Top-Down (`td_char_protag`, `td_comp_linh` có cáo *Mốc* 4 tai, `td_comp_kael` giáp gốm Kintsugi, `td_comp_mira`, `td_boss_vaelen`) có bóng đổ tiếp đất và chi tiết sắc nét hơn.
- **Biển Mây Hồi 2 & Lighting Juice (`topdown_maps.html` + `design_showcase.html`):** Thay ô `'~'` Hồi 2 bằng biển mây 3 tầng trôi parallax + tia nắng; ánh sáng điểm `lighter` quanh đèn, lửa trại, trụ nợ, tinh thể & đèn đội đầu Linh ở Hồi 3; bụi bước chân, sóng gợn vũng nước, và hạt `Pixel Dissolve` (`1×1`–`2×2`) trên vai Protag ở Hồi 1 & Hồi 3 Độc Hành.

---

## 9. HÀNH TRANG KỂ CHUYỆN, VÒNG CỘNG SINH TOP-DOWN, 3 KẾT THÚC & BẢNG STATE FLAGS v4.3 (`87` assets)

1. **Nguồn dữ liệu kể chuyện Phase 2 ([`narrative_extras.js`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/narrative_extras.js), `window.HOLLOW_NARRATIVE_EXTRAS`):**
   - `ITEMS_LORE` (**7 vật phẩm** khớp `ui_items`): `deed_blank` (*Tờ Khế Ước Trắng*), `deed_lit` (*Khế Ước Cộng Sinh Gốc*), `soup_clean` (*Bát Súp Nấm Ít Hành*), `soup_burnt` (*Nồi Súp Cháy Khê*), `memoria_coin` (*Đồng Xu Ký Ức Lẻ*), `lumen_coin` (*Đồng Quang Minh (Lumen)*), `prism_thread` (*Vòng Tơ Nhện Khúc Xạ*) — mỗi vật phẩm có 3 lớp lời kể theo ngữ cảnh (`descEarly`, `descSolo`, `descAct4`; riêng `memoria_coin` có thêm `descPurify` khi bóp vỡ/thanh tẩy `2.5s`).
   - `BESTIARY_SPECS` (**4 sinh vật**): `cre_echofox` (`fox_happy`), `cre_rustcrab` (`crab_warm`), `cre_prismweaver` (`weaver_spark`), `cre_parasite_mite` (`mite_clean`) — gồm `econHarvest`, `econSymbiosis`, 3 phản ứng `wheel.{listen, feed, heal}` và `act4Payoff`.
   - `ENDINGS_DATA` (**3 kết thúc**):
     - `TRUE_SYMBIOSIS_ENDING` (*Bàn Ăn Bốn Người Trên Lưng Kình Ngư*): `int_clue_fragments_found >= 9 && var_architect_corruption < 30 && var_eco_balance >= 70`.
     - `FREEDOM_ENDING` (*Chuyến Tàu Đi Tiếp*): `30 <= var_architect_corruption < 70`.
     - `HOLLOW_SYNDICATE_ENDING` (*Vị Chủ Tịch Mới*): `var_architect_corruption >= 70`.
   - `STATE_FLAGS_TABLE` (**10 biến đồng bộ** Phần V v4.3).

2. **Hai màn Showcase mới trong [`design_showcase.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/design_showcase.html) (thanh 16 pills HUD gọn trên 1 hàng `W = 1280px`):**
   - **Tab `J · Túi & Sinh Vật` (`KeyJ`, `view = 'bag'`):** Cột trái chọn 1 trong 7 vật phẩm `ui_items` (`ArrowLeft`/`ArrowRight` hoặc click), chuyển 3 ngữ cảnh (`Hồi 1: Khởi Đầu` / `Hồi 3: Độc Hành` / `Hồi 4: Lõi Tim`) và giữ `Space 2.5s` (hoặc bấm `⚡ Thanh Tẩy 2.5s`) bóp vỡ `memoria_coin`; cột phải duyệt 4 sinh vật (`ArrowUp`/`ArrowDown` hoặc click) kèm chân dung `hollow_portraits` 21 tags và thử 3 nút `ui_symbiosis_wheel`.
   - **Tab `O · 3 Kết Thúc` (`KeyO`, `view = 'endings'`):** 3 khung Diorama song song dựng bằng sprite thật (`env_hut_lantern`/`env_hut_moss`, `fx_music_box`, `prop_campfire`, `prop_puddle`, `boss_vaelen`, `fx_hearth_wisp`) + câu thoại vũng nước + bảng 10 `STATE_FLAGS_TABLE` bên dưới.
   - **Test API `window.hollowShowcase`:** bổ sung `setView('bag' | 'endings')`, `selectItem(idx)`, `selectBeast(idx)`, `setBagContext(c)`, `pickWheel(actOrIdx)`.

3. **Vòng Hành Động Cộng Sinh `TopDownSymbiosisWheel` trong [`topdown_maps.html`](file:///C:/Users/thinh/.gemini/antigravity/scratch/Claude-Code-Game-Studios/prototypes/trong_hollow/topdown_maps.html):**
   - Khi đứng gần sinh vật (`< 76px`), hiện gợi ý `G · Vòng Cộng Sinh` phía trên nhãn `E`.
   - Nhấn **`G`** mở vòng 3 nút `ui_symbiosis_wheel` quanh sinh vật (`[1]` *Lắng Nghe*, `[2]` *Cho Ăn / Soi*, `[3]` *Chữa Trị*); chỉ bắt phím `1`/`2`/`3` (hoặc mũi tên/`A`/`D`/`W` + `Enter`/`Space`/`E` hoặc click) **khi wheel đang mở** — bình thường `1..4` vẫn chuyển Map Hồi 1..4.
   - Khi chọn hành động: phát hạt sáng màu tương ứng, hiện bong bóng `beastBubble` từ `BESTIARY_SPECS` (tạm ẩn prompt `E`/`G` để không che chữ), và kích hoạt biến đổi thế giới (`heal` trên `cre_parasite_mite` -> `state.miteRemoved = true` giảm 20% thuế chợ; `feed` trên `cre_rustcrab` -> `state.corrupt = false`).
   - **Test API `window.topdownDesign`:** bổ sung `openWheel()`, `pickWheel(action)`.

4. **Bảng Đồng Bộ 10 Biến `STATE_FLAGS_TABLE` (Phần V · v4.3):**

| Biến hệ thống | Kiểu | Mặc định | Vai trò & Điều kiện kích hoạt |
| :--- | :---: | :---: | :--- |
| `enum_cutscene_state` | `Enum` | `'GAMEPLAY'` | Điều phối chuyển mượt Letterbox 12% & Insert Panel `160×90` (`CS_01..CS_08`) không cắt màn hình đen. |
| `flag_party_separated` | `Bool` | `false` | Bật ở đầu Hồi 3: tháo đội hình Caterpillar sau lưng & ẩn sạch cả 3 cụm Diegetic HUD. |
| `bool_hud_*` | `Bool` | `true` | Bộ 3 cờ `linh_hp` / `mira_econ` / `kael_warmth`; tắt ở Độc Hành Hồi 3 và bay vào sáng lại tại `CS_06`. |
| `float_body_cohesion` | `Float` | `1.0` | Độ kết tụ điểm ảnh Protag (`1.0 -> 0.0`); giảm khi đi một mình trong tối, hồi phục bên lửa trại. |
| `int_voice_dominance` | `Int` | `0` | Cán cân 2 giọng nội tâm: *Nhịp Kiến Trúc* (`60 BPM`) đối trọng *Nhịp Cộng Sinh* (`85 BPM`). |
| `int_puddle_check_count` | `Int` | `0` | Số lần soi Vũng Nước Lưu Game để kích hoạt mô tả tiến hóa theo từng hồi. |
| `var_free_merchant_network` | `Int` | `0` | Sức mạnh mạng lưới thương đoàn tự do giúp Mira phá 4 Trụ Cân Đối Nợ tại Hồi 4. |
| `var_architect_corruption` | `Int` | `0` | Chỉ số Tha Hóa (`0..100`): `<30` mở *True Symbiosis*, `30..69` ra *Freedom*, `>=70` dẫn tới *Hollow Syndicate*. |
| `var_eco_balance` | `Int` | `60` | Cân bằng sinh thái (`>=70` nở nấm sáng, cầu tơ, giảm 20% thuế Kình Ngư; `<=30` tắt đèn thực vật). |
| `int_clue_fragments_found` | `Int` | `0` | Số mảnh manh mối tìm được (`>=9` kết hợp `var_architect_corruption < 30` mở lựa chọn Đốt Khế Ước `CS_07`). |



