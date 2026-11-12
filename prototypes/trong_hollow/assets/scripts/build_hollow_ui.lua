-- build_hollow_ui.lua: Diegetic Companion HUD modules (Linh/Kaelen/Mira),
-- storytelling item icons (24x24), and 2D Pixel Cutscene Insert Panels (160x90)
-- aligned with handover_story.md v4.3.
local DIR = debug.getinfo(1, "S").source:match("@?(.*[/\\])") or ""
local A = dofile(DIR .. "art_lib.lua")

local OUT_DIR = DIR .. "..\\aseprite\\"
local hex, mix, bayer = A.hex, A.mix, A.bayer_pick

-- ============================================================================
-- 1. DIEGETIC HUD SPRITES (ui_hud_linh, ui_hud_kael, ui_hud_mira)
-- ============================================================================
local function build_hud_linh()
  local W, H = 124, 44
  local frames = {}
  for _, mode in ipairs({ "active", "low" }) do
    for fi = 1, 2 do
      local cv = A.canvas(W, H)
      -- Torn sketch-paper scrap pasted on HUD + blue debt notebook tab on left
      cv:poly({ { 3, 4 }, { 120, 3 }, { 118, 40 }, { 5, 41 } }, hex("#e8dec8"))
      cv:rect(5, 6, 18, 32, hex("#3a78a8")) -- Blue ledger cover corner
      cv:rect(8, 10, 12, 3, hex("#a8dcff"))
      cv:line(9, 17, 19, 17, hex("#f2c85b")) -- 5L debt scribble
      -- Pencil-drawn heart & jagged heartbeat line
      local hc = mode == "low" and (fi == 1 and hex("#e84a4a") or hex("#ffb066")) or hex("#e85d5d")
      cv:disc(31, 16, 4, hc); cv:disc(37, 16, 4, hc); cv:poly({ { 27, 17 }, { 41, 17 }, { 34, 25 } }, hc)
      -- 5 Sketchy charcoal/amber HP segments
      local filled = (mode == "low") and 1 or 5
      for seg = 1, 5 do
        local sx = 46 + (seg - 1) * 14
        cv:rect(sx, 12, 11, 10, hex("#30282e"))
        if seg <= filled then
          cv:rect(sx + 1, 13, 9, 8, (mode == "low") and hex("#ff5959") or hex("#ffcb6b"))
        end
      end
      -- Tiny scribbled pencil EKG wave below bars
      cv:bezier_stroke({ 46, 31 }, { 64, 27 }, { 78, 33 }, hex("#453b42"), 1, 14)
      cv:bezier_stroke({ 78, 33 }, { 92, 26 + (fi % 2) * 3 }, { 112, 31 }, hex("#453b42"), 1, 12)
      cv:outline(hex("#1c1721"), 120)
      table.insert(frames, { duration = 260, cels = { hud = cv } })
    end
  end
  A.build_sprite({ w = W, h = H, layers = { "hud" }, frames = frames, tags = { { name = "active", from = 1, to = 2 }, { name = "low", from = 3, to = 4 } } }, OUT_DIR .. "ui_hud_linh.aseprite")
end

local function build_hud_kael()
  local W, H = 108, 44
  local frames = {}
  for _, mode in ipairs({ "warm", "cold" }) do
    for fi = 1, 2 do
      local cv = A.canvas(W, H)
      cv:poly({ { 4, 4 }, { 104, 4 }, { 102, 40 }, { 6, 40 } }, hex("#26222e"))
      cv:rect(6, 6, 96, 32, hex("#362f3b"))
      -- Miniature Kintsugi copper bowl
      cv:ellipse(22, 27, 10, 6, mode == "warm" and hex("#f0ebe0") or hex("#9c9891"))
      cv:rect(15, 22, 14, 3, mode == "warm" and hex("#ffd166") or hex("#5c5a63"))
      cv:set(30, 21, hex("#26222e")) -- chipped notch
      if mode == "warm" then
        cv:line(20, 16 - fi, 22, 11 - fi, hex("#fff4c4"))
        cv:line(25, 17 - fi, 27, 12 - fi, hex("#ffe48a"))
        cv:add_glow(22, 24, 12, hex("#ff9e44"), 90)
      end
      -- Warmth hearth ember pips (Kaelen keeps you coherent!)
      for bar = 1, 4 do
        local bx = 40 + (bar - 1) * 14
        cv:rect(bx, 18, 11, 11, hex("#1d1924"))
        if mode == "warm" then
          cv:rect(bx + 1, 19, 9, 9, bar <= 3 and hex("#ff8e42") or hex("#ffd66b"))
        end
      end
      cv:outline(hex("#f5c249"), 120)
      table.insert(frames, { duration = 280, cels = { hud = cv } })
    end
  end
  A.build_sprite({ w = W, h = H, layers = { "hud" }, frames = frames, tags = { { name = "warm", from = 1, to = 2 }, { name = "cold", from = 3, to = 4 } } }, OUT_DIR .. "ui_hud_kael.aseprite")
end

local function build_hud_mira()
  local W, H = 116, 44
  local frames = {}
  for _, mode in ipairs({ "active", "zero" }) do
    for fi = 1, 2 do
      local cv = A.canvas(W, H)
      -- Polished mahogany & brass crystal abacus frame!
      cv:rect(4, 4, 108, 36, hex("#242b4d"))
      cv:rect(6, 6, 104, 32, hex("#161b33"))
      -- Top brass rod (Lumen golden beads)
      cv:line(12, 14, 82, 14, hex("#f0c259"))
      for i = 0, 3 do
        local offset = (mode == "zero") and 0 or ((i + fi) % 2 == 0 and 16 or 0)
        cv:disc(18 + i * 9 + offset, 14, 3, hex("#ffd66b"))
      end
      -- Bottom crystal rod (Memoria pale ice beads)
      cv:line(12, 28, 82, 28, hex("#f0c259"))
      for i = 0, 2 do
        cv:disc(64 + i * 7, 28, 3, hex("#8df5ff"))
      end
      -- Crisp "0L" stamp seal tag hanging at right end!
      cv:rect(88, 10, 18, 22, hex("#f0c259"))
      cv:rect(90, 12, 14, 18, hex("#1d2440"))
      cv:rect(93, 16, 4, 9, hex("#8df5ff")); cv:rect(94, 18, 2, 5, hex("#1d2440")) -- "0"
      cv:rect(99, 16, 1, 9, hex("#ffd66b")); cv:rect(99, 24, 4, 1, hex("#ffd66b")) -- "L"
      cv:outline(hex("#101221"), 120)
      table.insert(frames, { duration = 280, cels = { hud = cv } })
    end
  end
  A.build_sprite({ w = W, h = H, layers = { "hud" }, frames = frames, tags = { { name = "active", from = 1, to = 2 }, { name = "zero", from = 3, to = 4 } } }, OUT_DIR .. "ui_hud_mira.aseprite")
end

-- ============================================================================
-- 2. UI_ITEMS — 7 Storytelling Inventory Icons (24x24, anchor 12,12)
-- ============================================================================
local function build_items()
  local W, H = 24, 24
  local INK = hex("#16141f")
  local specs = { "deed_blank", "deed_lit", "soup_clean", "soup_burnt", "memoria_coin", "lumen_coin", "prism_thread" }
  local frames, tags = {}, {}

  for idx, mode in ipairs(specs) do
    local cv = A.canvas(W, H)
    if mode == "deed_blank" or mode == "deed_lit" then
      cv:poly({ { 5, 4 }, { 19, 4 }, { 19, 20 }, { 5, 20 } }, hex("#f7f4eb"))
      cv:rect(5, 17, 14, 3, hex("#ded6c6"))
      if mode == "deed_lit" then
        for y = 7, 14, 2 do cv:line(7, y, 16, y, hex("#f0a838")) end
        cv:add_glow(12, 12, 8, hex("#ffd66b"), 140)
      end
    elseif mode == "soup_clean" or mode == "soup_burnt" then
      cv:ellipse(12, 15, 8, 5, hex("#f0ebe0"))
      cv:rect(6, 12, 12, 3, mode == "soup_clean" and hex("#ffd166") or hex("#453d38"))
      cv:set(18, 12, hex("#201c28")) -- chipped rim!
      if mode == "soup_burnt" then
        cv:line(9, 12, 7, 8, hex("#6fc965")); cv:line(14, 12, 17, 8, hex("#6fc965"))
        cv:disc(12, 7, 2, hex("#36313d", 200))
      else
        cv:line(10, 8, 10, 5, hex("#fff4c4")); cv:line(14, 9, 14, 5, hex("#ffe48a"))
      end
    elseif mode == "memoria_coin" then
      cv:disc(12, 12, 7, hex("#8df5ff"))
      cv:disc(12, 12, 5, hex("#45799e"))
      cv:rect(11, 9, 2, 6, hex("#e8fcff"))
    elseif mode == "lumen_coin" then
      cv:disc(12, 12, 7, hex("#ffd452"))
      cv:disc(12, 12, 5, hex("#c48229"))
      cv:disc(12, 12, 2, hex("#fff4c4"))
    elseif mode == "prism_thread" then
      cv:ellipse(12, 12, 7, 7, hex("#8ff7ff"))
      cv:ellipse(12, 12, 4, 4, hex("#16141f", 0))
      cv:line(6, 9, 18, 9, hex("#d89eff")); cv:line(6, 15, 18, 15, hex("#ffe68a"))
      cv:add_glow(12, 12, 8, hex("#8ff7ff"), 120)
    end
    cv:outline(INK, 120)
    frames[idx] = { duration = 300, cels = { icon = cv } }
    tags[idx] = { name = mode, from = idx, to = idx }
  end
  A.build_sprite({ w = W, h = H, layers = { "icon" }, frames = frames, tags = tags }, OUT_DIR .. "ui_items.aseprite")
end

-- ============================================================================
-- 3. 2D PIXEL CLOSE-UP INSERT PANELS (160x90, anchor 80,45) — CS_01, CS_04, CS_06
-- ============================================================================
local function build_insert_panels()
  local W, H = 160, 90

  -- PANEL CS_01: "Bàn Tay Tan Thành Bụi Sáng & Băng Cá Nhân Ngôi Sao"
  do
    local cv = A.canvas(W, H)
    cv:rect(0, 0, W, H, hex("#161522"))
    cv:add_glow(82, 48, 52, hex("#ffbe5c"), 80)
    -- Player's coat cuff + dissolving wrist & palm reaching from left
    cv:poly({ { 2, 54 }, { 30, 48 }, { 34, 68 }, { 2, 76 } }, hex("#475750"))
    cv:poly({ { 28, 49 }, { 64, 44 }, { 78, 42 }, { 78, 58 }, { 64, 60 }, { 32, 66 } }, function(x, y)
      return bayer(x, y, hex("#f2d5ba"), hex("#c79b7e"), (y - 44) / 22)
    end)
    -- Open fingers slightly trembling & shedding 1x1 glowing amber/cyan stardust pixels!
    cv:line(76, 43, 91, 39, hex("#f2d5ba"), 2); cv:line(78, 48, 94, 46, hex("#f2d5ba"), 2)
    cv:line(77, 53, 91, 53, hex("#e5c2a3"), 2); cv:line(73, 58, 86, 61, hex("#c79b7e"), 2)
    for i = 0, 22 do
      local sx = 64 + (i * 5) % 38
      local sy = 42 - (i * 4) % 28
      cv:set(sx, sy, (i % 2 == 0) and hex("#ffcb6b") or hex("#8ff5e8"))
    end
    -- Linh's grease-smudged coat cuff & hand clasping Protag's wrist from top-right
    cv:poly({ { 158, 12 }, { 126, 24 }, { 132, 44 }, { 158, 34 } }, hex("#c47349"))
    cv:poly({ { 126, 25 }, { 88, 36 }, { 74, 42 }, { 82, 54 }, { 96, 52 }, { 132, 42 } }, function(x, y)
      return bayer(x, y, hex("#f7dbc4"), hex("#d1a688"), (y - 25) / 26)
    end)
    -- Gripping fingers of Linh wrapped gently around wrist edge + grease smudges
    cv:ellipse(80, 41, 6, 3, hex("#f7dbc4")); cv:set(104, 38, hex("#7d5240")); cv:set(112, 34, hex("#7d5240"))
    -- Bright Star-Printed Band-Aid pasted straight over fading crack!
    cv:poly({ { 62, 42 }, { 84, 38 }, { 86, 50 }, { 64, 54 } }, hex("#ffe480"))
    cv:outline(hex("#181520"), 120)
    cv:rect(72, 44, 4, 4, hex("#e85d5d")); cv:set(73, 45, hex("#ffffff"))
    cv:rect(0, 0, W, 2, hex("#f0c259")); cv:rect(0, H - 2, W, 2, hex("#f0c259"))
    cv:rect(0, 0, 2, H, hex("#f0c259")); cv:rect(W - 2, 0, 2, H, hex("#f0c259"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs01_hand.aseprite")
  end

  -- PANEL CS_04: Split-Screen 1:1 — Statue of Vaelen vs Shocked Protagonist + Shattered Music Box
  do
    local cv = A.canvas(W, H)
    -- Left Half (x=0..78): Sculpted Cold Marble Half-Face + neck + stone hair locks
    cv:rect(0, 0, 79, H, hex("#131829"))
    cv:rect(60, 68, 19, 22, hex("#5e667d")) -- neck
    cv:poly({ { 26, 22 }, { 78, 16 }, { 78, 72 }, { 56, 70 }, { 38, 60 }, { 26, 42 } }, function(x, y)
      return bayer(x, y, hex("#adb5c9"), hex("#5e667d"), (78 - x) / 56)
    end)
    cv:poly({ { 20, 26 }, { 30, 8 }, { 78, 6 }, { 78, 28 }, { 62, 24 }, { 50, 34 }, { 34, 24 } }, hex("#cfd7eb"))
    cv:rect(46, 36, 15, 5, hex("#1a1c26")); cv:line(42, 32, 64, 34, hex("#474d61"), 2) -- deep carved brow
    cv:line(62, 58, 78, 58, hex("#2b2e3d"), 2) -- cold chiselled lips

    -- Right Half (x=81..159): Identical Mirrored Jaw & Tousled Hair — Warm Living & Shocked!
    cv:rect(81, 0, 79, H, hex("#1f1721"))
    cv:rect(81, 68, 19, 22, hex("#c79b7e"))
    cv:poly({ { 81, 16 }, { 134, 22 }, { 134, 42 }, { 122, 60 }, { 104, 70 }, { 81, 72 } }, function(x, y)
      return bayer(x, y, hex("#f2d5ba"), hex("#b8886e"), (x - 81) / 56)
    end)
    cv:poly({ { 81, 6 }, { 130, 8 }, { 140, 26 }, { 126, 24 }, { 110, 34 }, { 98, 24 }, { 81, 28 } }, hex("#eef2fa"))
    cv:rect(98, 35, 16, 8, hex("#f7f4ec")) -- wide shocked sclera!
    cv:disc(104, 39, 2, hex("#2c2530")); cv:set(103, 38, hex("#ffffff"))
    cv:line(96, 30, 116, 33, hex("#4c465c"), 2) -- raised stunned brow
    cv:ellipse(84, 59, 6, 4, hex("#593a36")) -- parted gasped mouth

    -- Center glowing mirror crack + shattered golden music box drum below!
    cv:rect(78, 0, 4, H, hex("#8ff7ff"))
    cv:ellipse(80, 79, 10, 7, hex("#f0c259")); cv:line(71, 75, 89, 84, hex("#131829"), 2)
    cv:set(66, 82, hex("#ffe480")); cv:set(94, 76, hex("#8ff7ff"))
    cv:rect(0, 0, W, 2, hex("#9be3ff")); cv:rect(0, H - 2, W, 2, hex("#9be3ff"))
    cv:rect(0, 0, 2, H, hex("#9be3ff")); cv:rect(W - 2, 0, 2, H, hex("#9be3ff"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs04_split.aseprite")
  end

  -- PANEL CS_06: Kaelen's Giant Kintsugi Hands Setting Fourth Bowl Left + Linh's "MIỄN PHÍ" Ledger
  do
    local cv = A.canvas(W, H)
    cv:rect(0, 0, W, H, hex("#181520"))
    cv:add_glow(132, 30, 56, hex("#ff9e44"), 110)
    -- Diagonal iron rain streaks in dark night upper backdrop
    for rx = 12, 148, 22 do cv:line(rx, 4, rx - 5, 18, hex("#87a2bd", 80)) end
    cv:rect(0, 56, W, 34, hex("#38323d"))
    -- Massive Kintsugi Porcelain Wrist + Curved Ceramic Fingers Holding Fourth Bowl!
    cv:poly({ { 6, 26 }, { 32, 42 }, { 38, 60 }, { 10, 62 } }, hex("#e8e2d5"))
    cv:ellipse(39, 51, 8, 4, hex("#d6cfc2")) -- heavy ceramic thumb resting on rim
    cv:ellipse(37, 58, 7, 3, hex("#c7c1b8")) -- lower fingers
    cv:line(14, 34, 29, 51, hex("#f5c249")) -- golden Kintsugi vein!
    -- Steaming chipped fourth bowl set lovingly on the left
    cv:ellipse(58, 56, 22, 12, hex("#f0ebe0"))
    cv:ellipse(58, 52, 18, 7, hex("#ffd166"))
    cv:set(77, 50, hex("#181520")); cv:set(76, 51, hex("#181520")) -- chip on rim!
    cv:line(52, 38, 54, 28, hex("#fff5d6")); cv:line(62, 40, 64, 30, hex("#ffe48a"))
    -- Right side: Linh's Blue Debt Ledger with "5L" scribbled out in red + wooden spoon
    cv:poly({ { 98, 42 }, { 148, 38 }, { 150, 82 }, { 100, 86 } }, hex("#3c78a8"))
    cv:rect(104, 46, 38, 32, hex("#ede6d5"))
    cv:line(108, 53, 138, 51, hex("#6b626e"))
    cv:line(108, 61, 136, 69, hex("#e85d5d"), 2); cv:line(136, 61, 108, 69, hex("#e85d5d"), 2)
    cv:rect(0, 0, W, 2, hex("#f0c259")); cv:rect(0, H - 2, W, 2, hex("#f0c259"))
    cv:rect(0, 0, 2, H, hex("#f0c259")); cv:rect(W - 2, 0, 2, H, hex("#f0c259"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs06_bowl.aseprite")
  end

  -- PANEL CS_02: "Bình Minh Trong Lòng Tinh Cầu" (Panorama 4 bóng nhỏ trên lưng Kình Ngư ngắm Lõi Nhịp Tim)
  do
    local cv = A.canvas(W, H)
    local c1, c2 = hex("#15223d"), hex("#5e9aa8")
    for y = 0, H - 1 do for x = 0, W - 1 do cv:set(x, y, bayer(x, y, c1, c2, y / H)) end end
    -- Giant Biological Sun suspended in hollow vault sky!
    cv:add_glow(80, 24, 34, hex("#ffcb6b"), 140)
    cv:disc(80, 24, 11, hex("#7df5de")); cv:disc(80, 24, 7, hex("#fff8d6"))
    -- Distant inverted stone arches hanging from sky roof
    cv:poly({ { 10, 2 }, { 32, 2 }, { 24, 18 } }, hex("#1b2640"))
    cv:poly({ { 126, 2 }, { 150, 2 }, { 136, 20 } }, hex("#1b2640"))
    -- Towering whale silhouette deck curved below amidst sea of clouds
    cv:ellipse(30, 82, 36, 12, hex("#e3f2ed", 140)); cv:ellipse(130, 82, 38, 12, hex("#e3f2ed", 140))
    cv:poly({ { 4, 64 }, { 56, 56 }, { 114, 58 }, { 156, 72 }, { 156, 88 }, { 4, 88 } }, hex("#2c4c6b"))
    cv:line(24, 62, 134, 64, hex("#4a799e"), 1)
    -- Distant mist spout plume rising left of bow
    cv:bezier_stroke({ 22, 58 }, { 18, 42 }, { 10, 32 }, hex("#9cf5e8", 160), 1, 10)
    cv:bezier_stroke({ 23, 58 }, { 28, 40 }, { 34, 34 }, hex("#ffffff", 130), 1, 8)
    cv:rect(28, 54, 102, 4, hex("#734f38")); cv:rect(30, 52, 98, 2, hex("#8c6244")) -- wooden bow promenade
    -- 4 distinct human/companion silhouettes + little Fox Moc on wooden railing!
    cv:ellipse(60, 48, 3, 5, hex("#d9d4c9")); cv:disc(60, 41, 3, hex("#f0ebe0")) -- Kael wide shoulders
    cv:ellipse(67, 50, 2, 4, hex("#a85838")); cv:disc(67, 45, 2, hex("#c47349")) -- Linh
    cv:disc(71, 51, 2, hex("#ff8f36")) -- little Fox Moc!
    cv:ellipse(77, 49, 3, 4, hex("#e8edf5")); cv:disc(77, 44, 3, hex("#f5f7fc")) -- Hooded Protag
    cv:ellipse(85, 50, 2, 4, hex("#262f52")); cv:disc(85, 45, 2, hex("#3f548c")) -- Mira beret
    cv:rect(0, 0, W, 2, hex("#8ff7ff")); cv:rect(0, H - 2, W, 2, hex("#8ff7ff"))
    cv:rect(0, 0, 2, H, hex("#8ff7ff")); cv:rect(W - 2, 0, 2, H, hex("#8ff7ff"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs02_leviathan.aseprite")
  end

  -- PANEL CS_03: "Mệnh Giá 0 Lumen" (Cân nổ tóe chớp & bàn tay Mira gẩy bàn tính dừng vạch 0)
  do
    local cv = A.canvas(W, H)
    cv:rect(0, 0, W, H, hex("#161b30"))
    -- Exploding Appraisal Scale silhouette bursting sparks in background left (with hanging pans!)
    cv:add_glow(36, 38, 30, hex("#8ff7ff"), 140)
    cv:line(36, 18, 36, 68, hex("#8f99ad"), 3)
    cv:rect(26, 66, 20, 4, hex("#6b7488"))
    cv:line(20, 42, 52, 26, hex("#f0c259"), 2)
    cv:line(20, 42, 16, 54, hex("#b8c2d4"), 1); cv:line(20, 42, 24, 54, hex("#b8c2d4"), 1); cv:rect(14, 54, 12, 3, hex("#f0c259"))
    cv:line(52, 26, 48, 38, hex("#b8c2d4"), 1); cv:line(52, 26, 56, 38, hex("#b8c2d4"), 1); cv:rect(46, 38, 12, 3, hex("#f0c259"))
    cv:set(22, 22, hex("#ffffff")); cv:set(54, 42, hex("#ffd66b")); cv:set(44, 14, hex("#8ff7ff"))
    -- Foreground right: Huge crisp Crystal Abacus + Mira's sleeved hand pinching bead cleanly to "0"!
    cv:rect(68, 18, 72, 54, hex("#f0c259")); cv:rect(72, 22, 64, 46, hex("#13182b"))
    for _, ry in ipairs({ 33, 47, 58 }) do cv:line(76, ry, 132, ry, hex("#c49a3f")) end
    cv:disc(82, 33, 4, hex("#8df5ff")); cv:disc(120, 47, 4, hex("#ffd66b")); cv:disc(84, 58, 4, hex("#8df5ff"))
    -- Bold glowing "0" numeral beside final bead
    cv:rect(112, 25, 13, 15, hex("#8df5ff")); cv:rect(115, 28, 7, 9, hex("#13182b"))
    -- Mira's navy sleeve cuff + forearm + thumb & finger pinching bead at bar 1
    cv:poly({ { 158, 44 }, { 142, 39 }, { 140, 56 }, { 158, 60 } }, hex("#283052"))
    cv:poly({ { 142, 41 }, { 126, 37 }, { 124, 50 }, { 140, 54 } }, hex("#fae2cf"))
    cv:line(126, 39, 114, 34, hex("#fae2cf"), 3) -- index finger pinching!
    cv:line(126, 46, 118, 43, hex("#f2ccb2"), 2) -- thumb underneath
    cv:rect(0, 0, W, 2, hex("#8df5ff")); cv:rect(0, H - 2, W, 2, hex("#8df5ff"))
    cv:rect(0, 0, 2, H, hex("#8df5ff")); cv:rect(W - 2, 0, 2, H, hex("#8df5ff"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs03_scale.aseprite")
  end

  -- PANEL CS_05: "Nồi Súp Khê Đầy Hành" (Nồi sắt khét đen bốc khói, hành cắt khúc nổi lều phều & giọt lệ tắt đốm than)
  do
    local cv = A.canvas(W, H)
    cv:rect(0, 0, W, H, hex("#10111a"))
    -- Abandoned dark hearth brick & grate + single dying ember glow below pot
    cv:rect(28, 60, 104, 26, hex("#2a2836")); cv:rect(30, 60, 100, 2, hex("#434054"))
    cv:rect(66, 66, 28, 14, hex("#171520"))
    cv:add_glow(80, 75, 16, hex("#ff6e30"), 110)
    cv:disc(80, 75, 4, hex("#6b2c20")); cv:disc(79, 74, 2, hex("#ff8a3b"))
    -- Scorched cast-iron pot rim + olive broth with messy floating scallion slices & wooden spoon
    cv:ellipse(80, 46, 35, 16, hex("#2b2933")); cv:ellipse(80, 40, 30, 10, hex("#4e4c5e"))
    cv:ellipse(80, 41, 26, 8, hex("#404538"))
    cv:rect(62, 39, 5, 2, hex("#7ce070")); cv:rect(73, 43, 6, 2, hex("#63ba59"))
    cv:rect(84, 38, 5, 2, hex("#7ce070")); cv:rect(69, 36, 4, 2, hex("#8ef082"))
    cv:line(62, 41, 56, 32, hex("#63ba59"), 2); cv:line(92, 42, 98, 33, hex("#7ce070"), 2)
    -- Curled faint grey-blue smoke wisps
    cv:bezier_stroke({ 68, 32 }, { 62, 22 }, { 74, 12 }, hex("#525061", 160), 2, 12)
    cv:bezier_stroke({ 86, 30 }, { 94, 20 }, { 82, 10 }, hex("#3f3d4d", 140), 2, 12)
    -- Trembling wooden spoon dipped with falling bright teardrop onto last ember!
    cv:line(98, 38, 140, 14, hex("#8c623c"), 3)
    cv:set(79, 58, hex("#8ff7ff")); cv:set(79, 64, hex("#d4fcff")); cv:disc(79, 71, 2, hex("#7ce8ff"))
    cv:rect(0, 0, W, 2, hex("#68748a")); cv:rect(0, H - 2, W, 2, hex("#68748a"))
    cv:rect(0, 0, 2, H, hex("#68748a")); cv:rect(W - 2, 0, 2, H, hex("#68748a"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs05_soup.aseprite")
  end

  -- PANEL CS_07: "Muôn Vạn Đốm Lửa Trại" (4 bàn tay có cổ áo & ngón nắm chặt Khế Ước vàng rực + muôn vạn đốm sáng)
  do
    local cv = A.canvas(W, H)
    cv:rect(0, 0, W, H, hex("#121024"))
    -- Central blazing Blank Deed turning golden skyward!
    cv:add_glow(80, 34, 52, hex("#ffcb6b"), 155)
    cv:poly({ { 64, 15 }, { 96, 14 }, { 94, 53 }, { 66, 54 } }, hex("#fff9eb"))
    for y = 21, 39, 5 do cv:line(70, y, 89, y, hex("#f0a838")) end
    cv:disc(80, 46, 4, hex("#eb5e4b")); cv:set(80, 46, hex("#ffd66b")) -- warm seal ember on parchment!
    -- Helper to draw real sleeved arm + palm + overlapping fingers!
    -- 1. Protag (bottom-left): Emerald cloak cuff + warm dithered forearm + fingers
    cv:poly({ { 2, 72 }, { 34, 58 }, { 40, 72 }, { 6, 88 } }, hex("#375249"))
    cv:poly({ { 34, 59 }, { 62, 47 }, { 68, 56 }, { 40, 71 } }, hex("#f2d5ba"))
    cv:line(61, 48, 70, 45, hex("#e3bfa1"), 2); cv:line(63, 52, 71, 50, hex("#f2d5ba"), 2)
    -- 2. Kael (lower-mid-left): Dark apron cuff + offwhite ceramic forearm + gold Kintsugi vein
    cv:poly({ { 42, 88 }, { 56, 65 }, { 68, 70 }, { 56, 88 } }, hex("#3c3542"))
    cv:poly({ { 56, 66 }, { 69, 49 }, { 77, 54 }, { 68, 71 } }, hex("#e8e2d5"))
    cv:line(62, 65, 72, 52, hex("#f5c249"))
    cv:line(69, 50, 73, 44, hex("#ded6c5"), 2); cv:line(73, 52, 77, 46, hex("#e8e2d5"), 2)
    -- 3. Linh (lower-mid-right): Terracotta sleeve cuff + peach hand & thumb
    cv:poly({ { 112, 88 }, { 96, 65 }, { 108, 62 }, { 126, 88 } }, hex("#b0623d"))
    cv:poly({ { 96, 66 }, { 84, 50 }, { 94, 47 }, { 107, 63 } }, hex("#f7dbc4"))
    cv:line(84, 50, 81, 44, hex("#f7dbc4"), 2); cv:line(89, 49, 86, 43, hex("#ebd0b7"), 2)
    -- 4. Mira (bottom-right): Navy sleeve + gold button + glowing cyan ring + fingers
    cv:poly({ { 158, 70 }, { 126, 58 }, { 120, 72 }, { 154, 88 } }, hex("#262b4d"))
    cv:set(126, 65, hex("#f0c259"))
    cv:poly({ { 126, 59 }, { 97, 47 }, { 92, 56 }, { 120, 70 } }, hex("#fae2cf"))
    cv:line(98, 48, 89, 45, hex("#fae2cf"), 2); cv:line(96, 52, 88, 50, hex("#f0cfb8"), 2)
    cv:set(95, 51, hex("#8df5ff"))
    -- Thousands of tiny warm hearth fireflies scattering into night horizon!
    for i = 0, 28 do
      local px = (i * 19 + 11) % (W - 8) + 4
      local py = (i * 11 + 5) % 44 + 4
      cv:set(px, py, (i % 3 == 0) and hex("#8ff5e8") or hex("#ffd66b"))
    end
    cv:rect(0, 0, W, 2, hex("#ffd66b")); cv:rect(0, H - 2, W, 2, hex("#ffd66b"))
    cv:rect(0, 0, 2, H, hex("#ffd66b")); cv:rect(W - 2, 0, 2, H, hex("#ffd66b"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs07_hearths.aseprite")
  end

  -- PANEL CS_08: "Sau Tất Cả, Vẫn Là Cậu" (Vũng nước trong vắt phản chiếu cả 4 gương mặt đặc trưng tươi cười!)
  do
    local cv = A.canvas(W, H)
    cv:rect(0, 0, W, H, hex("#1e3142"))
    -- Warm wooden dock edge along top + rippling clear sunlit water ellipse below
    cv:rect(0, 0, W, 11, hex("#6b4a35")); cv:rect(0, 10, W, 2, hex("#ffd66b"))
    cv:ellipse(80, 52, 70, 32, function(x, y, nx, ny)
      local d = nx * nx + ny * ny
      return d > 0.90 and hex("#d4f8ff") or bayer(x, y, hex("#96f2ff"), hex("#3e87ad"), d)
    end)
    -- Subtle surface water shimmer ripples
    cv:line(24, 68, 52, 68, hex("#e3fcff", 160), 1); cv:line(106, 70, 134, 70, hex("#e3fcff", 160), 1)
    cv:line(62, 76, 98, 76, hex("#d4f8ff", 140), 1)
    -- 1. Linh (brown messy hair, cyan aviator goggles pushed on head, big toothy happy wink)
    cv:ellipse(34, 58, 9, 4, hex("#c47349")); cv:ellipse(34, 46, 10, 10, hex("#f7dbc4"))
    cv:ellipse(34, 38, 11, 5, hex("#6b463c")); cv:disc(29, 36, 3, hex("#7ce8ff")); cv:disc(39, 36, 3, hex("#7ce8ff"))
    cv:line(29, 44, 32, 43, hex("#231f33")); cv:rect(36, 43, 3, 3, hex("#231f33"))
    cv:bezier_stroke({ 30, 49 }, { 34, 53 }, { 38, 49 }, hex("#8f4a40"), 1, 6)
    -- 2. Kael (porcelain white face, Kintsugi gold hairline crack, warm amber rectangle goggles & collar)
    cv:ellipse(64, 58, 10, 4, hex("#d9d4c9")); cv:ellipse(64, 46, 10, 10, hex("#ebe6da"))
    cv:ellipse(64, 37, 11, 5, hex("#f0ebe0")); cv:line(59, 36, 68, 41, hex("#f5c249"))
    cv:rect(57, 43, 14, 4, hex("#3a3440")); cv:rect(59, 44, 3, 2, hex("#ffd670")); cv:rect(66, 44, 3, 2, hex("#ffd670"))
    cv:line(61, 50, 67, 50, hex("#8f6f52"))
    -- 3. Protag (silver tousled bangs, emerald collar, wide bright eyes — unmasked!)
    cv:ellipse(96, 58, 9, 4, hex("#375249")); cv:ellipse(96, 46, 10, 10, hex("#f2d5ba"))
    cv:poly({ { 85, 41 }, { 90, 32 }, { 102, 32 }, { 107, 41 }, { 100, 39 }, { 95, 43 }, { 90, 39 } }, hex("#eef2fa"))
    cv:rect(90, 44, 3, 3, hex("#1a2b42")); cv:rect(99, 44, 3, 3, hex("#1a2b42"))
    cv:set(91, 44, hex("#8df5ff")); cv:set(100, 44, hex("#8df5ff"))
    cv:bezier_stroke({ 92, 50 }, { 96, 53 }, { 100, 50 }, hex("#8f4a40"), 1, 6)
    -- 4. Mira (tilted dark navy beret with gold syndicate pin, calm slight smile)
    cv:ellipse(126, 58, 9, 4, hex("#262b4d")); cv:ellipse(126, 46, 10, 10, hex("#fae2cf"))
    cv:ellipse(126, 37, 12, 5, hex("#262b4d")); cv:rect(131, 36, 4, 2, hex("#f0c259"))
    cv:rect(121, 44, 2, 2, hex("#231f33")); cv:rect(129, 44, 2, 2, hex("#231f33"))
    cv:bezier_stroke({ 123, 50 }, { 126, 51 }, { 129, 50 }, hex("#733b3b"), 1, 4)
    cv:add_glow(80, 52, 42, hex("#fff4c4"), 75)
    cv:rect(0, 0, W, 2, hex("#ffd66b")); cv:rect(0, H - 2, W, 2, hex("#ffd66b"))
    cv:rect(0, 0, 2, H, hex("#ffd66b")); cv:rect(W - 2, 0, 2, H, hex("#ffd66b"))
    A.build_sprite({ w = W, h = H, layers = { "panel" }, frames = { { duration = 300, cels = { panel = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "panel_cs08_puddle.aseprite")
  end
end

build_hud_linh()
build_hud_kael()
build_hud_mira()
build_items()
build_insert_panels()

-- ============================================================================
-- 4. BOSS ARENA ACT 4 UI & MEMORIA PURIFICATION SPRITES
--    (ui_boss_shield, ui_memoria_ring, fx_hearth_wisp)
-- ============================================================================
local function build_boss_act4_ui()
  -- 1. ui_boss_shield (180x42, anchor 0,0) — Thanh Khiên Nợ 4 Trụ & Lõi Mặt Trời Vaelen
  do
    local W, H = 180, 42
    local frames, tags, idx = {}, {}, 1
    local modes = {
      { name = "shielded_4", rem = 4 },
      { name = "shielded_2", rem = 2 },
      { name = "broken",     rem = 0 },
      { name = "purified",   rem = -1 },
    }
    for _, m in ipairs(modes) do
      local s_idx = idx
      for fi = 1, 2 do
        local cv = A.canvas(W, H)
        local borderCol = (m.rem == -1) and hex("#ffcb6b") or (m.rem == 0 and hex("#f0a838") or hex("#8df5ff"))
        local bgCol     = (m.rem == -1) and hex("#24171e") or hex("#121629")
        cv:rect(2, 4, W - 4, H - 8, borderCol)
        cv:rect(4, 6, W - 8, H - 12, bgCol)
        -- 4 Corner Pillar Diamonds: 2 on left (18, 36), 2 on right (144, 162)
        local pxs = { 18, 36, 144, 162 }
        for pi, px in ipairs(pxs) do
          local broken = (m.rem == -1) or (pi > m.rem)
          local pc = broken and hex("#ffd66b") or hex("#8ff7ff")
          cv:poly({ { px, 13 }, { px + 6, 21 }, { px, 29 }, { px - 6, 21 } }, pc)
          if broken then
            -- Gold 0L dot inside shattered pillar slot!
            cv:disc(px, 21, 2, hex("#24171e")); cv:set(px, 21, hex("#8ff5e8"))
          end
        end
        -- Center Vaelen Core Dome / Exposed Heart / Purified Hearth Emblem (x=54..126)
        cv:rect(50, 12, 80, 18, hex("#0a0d18"))
        if m.rem > 0 then
          local segW = math.floor(72 * (m.rem / 4))
          cv:rect(54, 15, 72, 12, hex("#1d2642"))
          cv:rect(54, 15, segW, 12, hex("#6adbf2"))
          -- Shield bars slicing across bar
          for sx = 58, 122, 8 do cv:line(sx, 14, sx + 2, 28, hex("#d4fcff")) end
        elseif m.rem == 0 then
          -- Exposed pulsing core!
          local r = 5 + fi
          cv:add_glow(90, 21, 18, hex("#eb5e4b"), 140)
          cv:rect(54, 16, 72, 10, hex("#3b1a22"))
          cv:disc(90, 21, r, hex("#ffcb6b")); cv:disc(90, 21, 3, hex("#ff6e6e"))
        else
          -- Purified: Ten Thousand Hearths golden flame bar!
          cv:add_glow(90, 21, 24, hex("#ffcb6b"), 155)
          cv:rect(54, 15, 72, 12, hex("#ffb64d"))
          cv:disc(72, 21, 3 + (fi % 2), hex("#fff4c4")); cv:disc(90, 21, 4 + (fi % 2), hex("#8ff5e8")); cv:disc(108, 21, 3 + (fi % 2), hex("#fff4c4"))
        end
        cv:outline(hex("#0c0d14"), 120)
        frames[idx] = { duration = 240, cels = { ui = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = m.name, from = s_idx, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "ui" }, frames = frames, tags = tags }, OUT_DIR .. "ui_boss_shield.aseprite")
  end

  -- 2. ui_memoria_ring (64x64, anchor 32,32) — Vòng Giữ 2.5s Thanh Tẩy Xu Ký Ức
  do
    local W, H = 64, 64
    local frames, tags, idx = {}, {}, 1
    for _, sp in ipairs({ { "idle", 2, 260 }, { "purify", 4, 180 }, { "burst", 4, 180 } }) do
      local s_idx = idx
      for fi = 1, sp[2] do
        local cv = A.canvas(W, H)
        local cx, cy = 32, 32
        if sp[1] == "idle" then
          cv:ellipse(cx, cy, 24, 24, function(x, y, nx, ny)
            local d = math.sqrt(nx * nx + ny * ny)
            return (d >= 0.85 and d <= 0.96) and hex("#687694") or nil
          end)
          cv:disc(cx, cy, 13, hex("#8df5ff")); cv:disc(cx, cy, 9, hex("#4b809c"))
          cv:rect(cx - 3, cy - 4, 6, 8, hex("#d4fcff")) -- crisp cold coin imprint
        elseif sp[1] == "purify" then
          local frac = fi / 4
          cv:add_glow(cx, cy, 20 + fi * 2, hex("#ffcb6b"), 130)
          cv:ellipse(cx, cy, 25, 25, function(x, y, nx, ny)
            local d = math.sqrt(nx * nx + ny * ny)
            if d < 0.82 or d > 0.98 then return nil end
            local ang = (math.atan(ny, nx) + math.pi * 0.5) / (math.pi * 2)
            if ang < 0 then ang = ang + 1 end
            return ang <= frac and hex("#ffcb6b") or hex("#30384f")
          end)
          cv:disc(cx, cy, 13, hex("#8df5ff"))
          -- Cracking amber fissure growing across Memoria coin!
          cv:line(cx - 8, cy - 7, cx + 6, cy + 8, hex("#ffd66b"), 2)
          if fi >= 2 then cv:line(cx + 8, cy - 5, cx - 5, cy + 7, hex("#fff4c4"), 1) end
          cv:disc(cx, cy, 4 + fi, hex("#fff4c4", 160))
        else
          -- Shattered Memoria releasing warm hearth wind particles!
          cv:add_glow(cx, cy, 26 - fi * 2, hex("#ffd66b"), 145)
          for s = 1, 8 do
            local ang = (s / 8) * math.pi * 2 + fi * 0.35
            local rad = 8 + fi * 4
            local px = math.floor(cx + math.cos(ang) * rad)
            local py = math.floor(cy + math.sin(ang) * rad)
            cv:disc(px, py, 2, (s % 2 == 0) and hex("#8ff5e8") or hex("#ffd66b"))
          end
          cv:disc(cx, cy, math.max(1, 6 - fi), hex("#ffffff"))
        end
        frames[idx] = { duration = sp[3], cels = { ui = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = sp[1], from = s_idx, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "ui" }, frames = frames, tags = tags }, OUT_DIR .. "ui_memoria_ring.aseprite")
  end

  -- 3. fx_hearth_wisp (24x24, anchor 12,12) — Đốm Lửa Trại Cộng Hưởng bay khắp trời Hồi 4
  do
    local W, H = 24, 24
    local frames, tags, idx = {}, {}, 1
    for _, kind in ipairs({ "gold", "mint" }) do
      local s_idx = idx
      local cOuter = (kind == "gold") and hex("#ff9e44") or hex("#6ee8d8")
      local cCore  = (kind == "gold") and hex("#fff4c4") or hex("#e8fffb")
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        local sway = (fi == 2 and -1) or (fi == 4 and 1) or 0
        cv:add_glow(12, 12, 9 + (fi % 2) * 2, cOuter, 175)
        cv:poly({ { 12 + sway, 4 }, { 16, 13 }, { 12, 18 }, { 8, 13 } }, cOuter)
        cv:disc(12, 13, 3, cCore)
        cv:set(12 + sway, 2 + (fi % 2), cCore)
        frames[idx] = { duration = 180, cels = { fx = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = kind, from = s_idx, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "fx" }, frames = frames, tags = tags }, OUT_DIR .. "fx_hearth_wisp.aseprite")
  end
end

-- ============================================================================
-- 8. UI_SYMBIOSIS_WHEEL — Top-Down Symbiosis Wheel Icons (40x40, anchor 20,20)
-- Tags: listen (2f), feed (2f), heal (2f) — frame 1=idle, frame 2=pulse
-- ============================================================================
local function build_symbiosis_wheel()
  local W, H = 40, 40
  local INK = hex("#0e101c")
  local frames, tags, idx = {}, {}, 1

  local function draw_medallion(fx, bg, rim_col, accent_col, is_pulse)
    if is_pulse then
      fx:add_glow(20, 20, 19, accent_col, 155)
    else
      fx:add_glow(20, 20, 15, accent_col, 55)
    end
    bg:disc(20, 20, 16, hex("#191d2e"))
    bg:disc(20, 20, 14, hex("#121524"))
    -- Crisp bevelled ring accent around medallion edge
    for deg = 0, 355, 6 do
      local rad = deg * math.pi / 180
      local rx = math.floor(20 + math.cos(rad) * 15 + 0.5)
      local ry = math.floor(20 + math.sin(rad) * 15 + 0.5)
      local col = (deg >= 190 and deg <= 320) and accent_col or rim_col
      bg:set(rx, ry, col)
    end
    if is_pulse then
      for deg = 0, 355, 10 do
        local rad = deg * math.pi / 180
        local rx = math.floor(20 + math.cos(rad) * 16 + 0.5)
        local ry = math.floor(20 + math.sin(rad) * 16 + 0.5)
        bg:set(rx, ry, accent_col)
      end
    end
    bg:outline(INK, 120)
  end

  -- 1) listen (2f): Stylized acoustic Ear + Cyan-Blue Soundwaves
  do
    local s_idx = idx
    for fi = 1, 2 do
      local is_pulse = (fi == 2)
      local fx, bg, cv = A.canvas(W, H), A.canvas(W, H), A.canvas(W, H)
      local c_wave = is_pulse and hex("#c7f9ff") or hex("#5ce1ff")
      local c_wave_d = is_pulse and hex("#5ce1ff") or hex("#2a8cb8")
      draw_medallion(fx, bg, hex("#324563"), c_wave, is_pulse)

      -- Ear silhouette on left-center (x=10..19, y=12..28)
      cv:poly({ { 11, 18 }, { 12, 13 }, { 16, 12 }, { 19, 15 }, { 18, 22 }, { 15, 27 }, { 12, 27 }, { 11, 23 } }, function(x, y)
        return (x <= 13 or y <= 14) and hex("#fae4d2") or hex("#d1a188")
      end)
      cv:poly({ { 13, 16 }, { 16, 15 }, { 17, 19 }, { 14, 24 }, { 13, 21 } }, hex("#7a5552"))
      cv:line(14, 17, 15, 21, hex("#c99680"))

      -- Concentric cyan soundwave arcs curving right
      local sh = is_pulse and 1 or 0
      cv:bezier_stroke({ 20 + sh, 16 }, { 23 + sh, 20 }, { 20 + sh, 24 }, c_wave, 1, 10)
      cv:bezier_stroke({ 23 + sh, 13 }, { 27 + sh, 20 }, { 23 + sh, 27 }, c_wave, 2, 14)
      if is_pulse then
        cv:bezier_stroke({ 26, 11 }, { 30, 20 }, { 26, 29 }, c_wave_d, 1, 16)
        fx:set(28, 12, hex("#ffffff")); fx:set(29, 27, hex("#c7f9ff"))
      end

      cv:outline(INK, 120)
      frames[idx] = { duration = is_pulse and 190 or 250, cels = { fx = fx, shadow = bg, body = cv } }
      idx = idx + 1
    end
    table.insert(tags, { name = "listen", from = s_idx, to = idx - 1 })
  end

  -- 2) feed (2f): Golden Scored Bread Loaf & Warm Crumb Light
  do
    local s_idx = idx
    for fi = 1, 2 do
      local is_pulse = (fi == 2)
      local fx, bg, cv = A.canvas(W, H), A.canvas(W, H), A.canvas(W, H)
      local c_hi = is_pulse and hex("#fff4b8") or hex("#ffd66b")
      draw_medallion(fx, bg, hex("#6b4c28"), c_hi, is_pulse)

      -- Main warm golden bread loaf (x=9..29, y=17..27)
      cv:poly({ { 9, 25 }, { 10, 19 }, { 15, 16 }, { 24, 16 }, { 29, 20 }, { 29, 26 }, { 11, 27 } }, function(x, y)
        if y <= 19 then return hex("#f5bc4c") end
        if y >= 25 then return hex("#8c4b1e") end
        return hex("#cc7c2c")
      end)
      -- Warm creamy crumb cut edge & diagonal wheat slashes
      cv:ellipse(25, 23, 4, 3, hex("#ffe9a6"))
      cv:ellipse(25, 24, 2, 1, hex("#e8b658"))
      cv:line(13, 18, 16, 20, hex("#fff0b8")); cv:line(18, 17, 21, 19, hex("#fff0b8"))

      -- Rising warm golden light sparkles
      fx:add_glow(20, 19, is_pulse and 11 or 7, hex("#ffcf54"), is_pulse and 150 or 90)
      fx:set(15, 12 - (is_pulse and 1 or 0), c_hi)
      fx:set(21, 10 - (is_pulse and 1 or 0), hex("#ffffff"))
      fx:set(25, 13, hex("#ffd66b"))
      if is_pulse then
        fx:rect(19, 9, 3, 1, hex("#ffffff")); fx:rect(20, 8, 1, 3, hex("#ffffff"))
      end

      cv:outline(INK, 120)
      frames[idx] = { duration = is_pulse and 190 or 250, cels = { fx = fx, shadow = bg, body = cv } }
      idx = idx + 1
    end
    table.insert(tags, { name = "feed", from = s_idx, to = idx - 1 })
  end

  -- 3) heal (2f): Cupped Caring Hand + Jade Medicinal Leaf
  do
    local s_idx = idx
    for fi = 1, 2 do
      local is_pulse = (fi == 2)
      local fx, bg, cv = A.canvas(W, H), A.canvas(W, H), A.canvas(W, H)
      local c_jade = is_pulse and hex("#8cffca") or hex("#4be39a")
      draw_medallion(fx, bg, hex("#265946"), c_jade, is_pulse)

      -- Cupped open hand at bottom (x=10..29, y=22..30)
      cv:poly({ { 10, 26 }, { 14, 24 }, { 21, 26 }, { 28, 22 }, { 30, 24 }, { 24, 29 }, { 13, 29 } }, function(x, y)
        return y <= 26 and hex("#fae0ca") or hex("#c99476")
      end)
      cv:rect(9, 25, 4, 4, hex("#334a54")) -- sleeve cuff

      -- Vibrant jade medicinal leaf resting above palm (y=10..23)
      cv:poly({ { 16, 21 }, { 15, 14 }, { 22, 10 }, { 26, 12 }, { 24, 19 }, { 19, 23 } }, function(x, y)
        return (x + y < 37) and hex("#4be39a") or hex("#1e965f")
      end)
      -- Crisp central leaf vein & dew sheen
      cv:line(16, 22, 23, 12, hex("#d4ffea"))
      cv:line(18, 18, 21, 17, hex("#a8ffd6"))
      cv:set(17, 15, hex("#ffffff"))

      -- Emerald healing cross motes
      fx:add_glow(20, 16, is_pulse and 11 or 7, hex("#4be39a"), is_pulse and 155 or 90)
      fx:rect(12, 12, 3, 1, c_jade); fx:rect(13, 11, 1, 3, c_jade)
      if is_pulse then
        fx:rect(26, 14, 3, 1, hex("#ffffff")); fx:rect(27, 13, 1, 3, hex("#ffffff"))
        fx:set(19, 8, hex("#b8ffe0"))
      end

      cv:outline(INK, 120)
      frames[idx] = { duration = is_pulse and 190 or 250, cels = { fx = fx, shadow = bg, body = cv } }
      idx = idx + 1
    end
    table.insert(tags, { name = "heal", from = s_idx, to = idx - 1 })
  end

  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = tags }, OUT_DIR .. "ui_symbiosis_wheel.aseprite")
end

build_boss_act4_ui()
build_symbiosis_wheel()
print("BUILD_HOLLOW_UI_OK")
