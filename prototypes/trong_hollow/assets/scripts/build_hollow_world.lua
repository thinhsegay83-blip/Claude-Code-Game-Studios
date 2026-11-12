-- build_hollow_world.lua: Overhauled 4-Act seamless parallax backgrounds & 10 richly
-- detailed landmark props for "Thế Giới Tinh Cầu Rỗng" (handover_story.md v4.3).
local DIR = debug.getinfo(1, "S").source:match("@?(.*[/\\])") or ""
local A = dofile(DIR .. "art_lib.lua")

local OUT_DIR = DIR .. "..\\aseprite\\"
local hex, mix, bayer = A.hex, A.mix, A.bayer_pick

local function hash2(x, y)
  local a = math.floor(x) * 12.9898 + math.floor(y) * 78.233
  local v = math.sin(a) * 43758.5453123
  return v - math.floor(v)
end

local function set_wrap(cv, x, y, c)
  local wx = ((math.floor(x) % cv.w) + cv.w) % cv.w
  cv:blend(wx, math.floor(y), c)
end

local function disc_wrap(cv, cx, cy, r, c)
  local r2 = (r + 0.35) * (r + 0.35)
  for y = math.floor(cy - r - 1), math.ceil(cy + r + 1) do
    for x = math.floor(cx - r - 1), math.ceil(cx + r + 1) do
      local dx, dy = x - cx, y - cy
      if dx * dx + dy * dy <= r2 then set_wrap(cv, x, y, c) end
    end
  end
end

local function bezier_wrap(cv, p0, p1, p2, c, thick, steps)
  steps = steps or 36
  local rad = thick and math.floor(thick / 2) or 0
  local prev
  for i = 0, steps do
    local t = i / steps
    local u = 1 - t
    local x = u * u * p0[1] + 2 * u * t * p1[1] + t * t * p2[1]
    local y = u * u * p0[2] + 2 * u * t * p1[2] + t * t * p2[2]
    if prev then
      local n = math.max(1, math.ceil(math.max(math.abs(x - prev[1]), math.abs(y - prev[2]))))
      for s = 0, n do
        local st = s / n
        local lx = prev[1] + (x - prev[1]) * st
        local ly = prev[2] + (y - prev[2]) * st
        if rad > 0 then disc_wrap(cv, lx, ly, rad, c) else set_wrap(cv, lx, ly, c) end
      end
    end
    prev = { x, y }
  end
end

-- ============================================================================
-- BG 1: ACT 1 — THUNG LŨNG PHẾ LIỆU TẦNG NGOÀI (bg_scrapyard.aseprite)
-- Layered vaulted ribs, hanging rusted chains, sculpted crane/cog, faceted amber
-- ============================================================================
local function build_bg_scrapyard()
  local W, H = 320, 360
  local sky = A.canvas(W, H)
  local junk_far = A.canvas(W, H)
  local ground = A.canvas(W, H)

  -- Smooth twilight ash-plum sky with soft dusk clouds & distant vaulted ribs + chains
  local c1, c2, c3 = hex("#141221"), hex("#2b2336"), hex("#593f46")
  for y = 0, 305 do
    local t = y / 305
    local col = t < 0.52 and mix(c1, c2, t / 0.52) or mix(c2, c3, (t - 0.52) / 0.48)
    local col2 = t < 0.52 and mix(c1, c2, math.min(1, t / 0.52 + 0.08)) or mix(c2, c3, math.min(1, (t - 0.52) / 0.48 + 0.08))
    for x = 0, W - 1 do sky:set(x, y, bayer(x, y, col, col2, (t * 8) % 1)) end
  end
  -- Drifting twilight cloud ribbons
  for _, cl in ipairs({ { 52, 112, 54, 10 }, { 196, 86, 62, 11 }, { 286, 134, 48, 9 } }) do
    for dx = -cl[3], cl[3] do
      for dy = -cl[4], cl[4] do
        local d = (dx * dx) / (cl[3] * cl[3]) + (dy * dy) / (cl[4] * cl[4])
        if d < 1.0 then
          local a = math.floor((1 - d) * 65)
          set_wrap(sky, cl[1] + dx, cl[2] + dy, { 112, 82, 92, a })
        end
      end
    end
  end
  -- Distant hanging rusted stone arch ribs & solid hanging iron chains
  for _, bx in ipairs({ 0, 160 }) do
    bezier_wrap(sky, { bx - 16, 305 }, { bx + 80, 42 }, { bx + 176, 305 }, hex("#231c2e", 160), 6, 52)
    bezier_wrap(sky, { bx - 14, 305 }, { bx + 80, 44 }, { bx + 174, 305 }, hex("#382c42", 120), 1, 52)
    for _, chx in ipairs({ bx + 42, bx + 112 }) do
      local len = 62 + ((chx * 5) % 44)
      for cy = 18, 18 + len, 3 do
        set_wrap(sky, chx, cy, hex("#292033", 190))
        set_wrap(sky, chx, cy + 1, hex("#47394f", 160))
        set_wrap(sky, chx + ((cy % 6 == 0) and 1 or -1), cy + 2, hex("#292033", 170))
      end
    end
  end
  -- Scattered floating warm amber embers in dusk haze
  for i = 1, 30 do
    local sx = math.floor(hash2(i, 17) * W)
    local sy = math.floor(hash2(i, 43) * 240) + 18
    sky:set(sx, sy, (i % 4 == 0) and hex("#ffd66b", 145) or hex("#9e8294", 95))
  end

  -- Left: Detailed rusted gantry crane lattice (clipped cleanly inside tower) + dangling hook chain
  junk_far:poly({ { 12, 304 }, { 34, 236 }, { 42, 236 }, { 64, 304 } }, function(x, y)
    return x < 38 and hex("#3d3145") or hex("#241c2c")
  end)
  for ry = 248, 294, 12 do
    local t = (ry - 236) / 68.0
    local lx = math.floor(34 - t * 21)
    local rx = math.floor(42 + t * 21)
    local nt = math.max(0, (ry - 10 - 236) / 68.0)
    local nlx = math.floor(34 - nt * 21)
    local nrx = math.floor(42 + nt * 21)
    junk_far:line(lx, ry, nrx, ry - 10, hex("#594661"), 1)
    junk_far:line(rx, ry, nlx, ry - 10, hex("#1c1524"), 1)
  end
  junk_far:line(36, 238, 92, 204, hex("#4a3b52"), 3)
  junk_far:line(36, 236, 92, 202, hex("#69536e"), 1)
  junk_far:bezier_stroke({ 89, 206 }, { 84, 248 }, { 86, 280 }, hex("#3b2f45"), 1, 14)
  junk_far:rect(84, 280, 5, 6, hex("#59475e"))

  -- Center: Sculpted beveled sunken giant cogwheel + broken stone viaduct arch
  junk_far:ellipse(148, 286, 37, 37, function(x, y, nx, ny)
    local d = math.sqrt(nx * nx + ny * ny)
    if d < 0.38 then return hex("#1c1724")
    elseif d < 0.5 then return hex("#4e4059")
    elseif nx + ny < -0.2 then return hex("#3d324a")
    else return hex("#272033") end
  end)
  for a = 0, 9 do
    local ang = a * math.pi / 5
    local tx, ty = 148 + math.cos(ang) * 38, 286 + math.sin(ang) * 38
    junk_far:disc(tx, ty, 4, (math.cos(ang) < 0) and hex("#594863") or hex("#31273b"))
  end
  junk_far:ellipse(134, 266, 8, 4, hex("#4c5e4b")) -- weathered moss on gear rim
  -- Cracked viaduct pier with capital & base bevel
  junk_far:rect(182, 224, 20, 80, hex("#362c3d"))
  junk_far:rect(182, 224, 5, 80, hex("#52435c"))
  junk_far:rect(177, 220, 30, 6, hex("#4f4059"))
  junk_far:rect(177, 220, 30, 2, hex("#735f7d"))
  junk_far:line(186, 250, 196, 262, hex("#211a29"))

  -- Right: Jagged scrap mound with faceted glowing amber crystals & moss tufts
  junk_far:poly({ { 218, 304 }, { 234, 282 }, { 262, 274 }, { 292, 280 }, { 312, 304 } }, function(x, y)
    return y < 284 and hex("#3d3145") or hex("#241c2c")
  end)
  -- Primary glowing amber crystal cluster
  junk_far:poly({ { 244, 290 }, { 256, 240 }, { 268, 288 } }, hex("#7a4a24"))
  junk_far:poly({ { 256, 240 }, { 247, 274 }, { 256, 286 }, { 262, 262 } }, hex("#ffbe5c"))
  junk_far:line(256, 241, 248, 272, hex("#fff2b2"))
  junk_far:poly({ { 274, 292 }, { 286, 254 }, { 296, 292 } }, hex("#5c3a1f"))
  junk_far:poly({ { 286, 254 }, { 280, 276 }, { 287, 284 } }, hex("#e08b46"))
  junk_far:add_glow(256, 260, 14, hex("#ffbe5c"), 90)
  junk_far:ellipse(238, 288, 6, 3, hex("#4d6347"))

  -- Rich cracked scrapyard ground with embedded iron plates, pebbles & amber specks
  for y = 304, H - 1 do
    local dy = y - 304
    for x = 0, W - 1 do
      local n = hash2(x, y)
      if dy == 0 then
        ground:set(x, y, n > 0.6 and hex("#94705d") or hex("#7d5e50"))
      elseif dy < 4 then
        ground:set(x, y, bayer(x, y, hex("#5e453b"), hex("#705347"), 0.4))
      else
        local c = bayer(x, y, hex("#42312e"), hex("#291f21"), dy / 56)
        if n > 0.94 then c = hex("#6b4c3d")
        elseif n < 0.025 then c = hex("#ffbe5c")
        elseif n > 0.48 and n < 0.51 and dy < 20 then c = hex("#4d5e48") end
        ground:set(x, y, c)
      end
    end
  end
  for _, px in ipairs({ 36, 128, 224 }) do
    ground:rect(px, 314, 18, 8, hex("#4f434a"))
    ground:line(px, 314, px + 17, 314, hex("#75636b"))
    ground:set(px + 2, 316, hex("#2b2329")); ground:set(px + 15, 316, hex("#2b2329"))
  end

  A.build_sprite({ w = W, h = H, layers = { "sky", "junk_far", "ground" }, frames = { { duration = 200, cels = { sky = sky, junk_far = junk_far, ground = ground } } } }, OUT_DIR .. "bg_scrapyard.aseprite")
end

-- ============================================================================
-- BG 2: ACT 2 — CHỢ NỔI LƯNG KÌNH NGƯ (bg_market.aseprite)
-- Fluffy multi-puff cloud sea, sunlit beams, shaded market stalls & planked deck
-- ============================================================================
local function build_bg_market()
  local W, H = 320, 360
  local sky = A.canvas(W, H)
  local stalls_far = A.canvas(W, H)
  local deck = A.canvas(W, H)

  -- Smooth cerulean-to-mist sky with subtle warm golden diagonal sunbeams
  local c1, c2, c3 = hex("#182848"), hex("#355c7d"), hex("#94bec2")
  for y = 0, 305 do
    local t = y / 305
    local col = t < 0.52 and mix(c1, c2, t / 0.52) or mix(c2, c3, (t - 0.52) / 0.48)
    local col2 = t < 0.52 and mix(c1, c2, math.min(1, t / 0.52 + 0.08)) or mix(c2, c3, math.min(1, (t - 0.52) / 0.48 + 0.08))
    for x = 0, W - 1 do sky:set(x, y, bayer(x, y, col, col2, (t * 7) % 1)) end
  end
  -- Soft angled warm sky-sunbeams
  for _, bx in ipairs({ 50, 178 }) do
    for y = 20, 290 do
      local cx = bx + y * 0.25
      local hw = 14 + (y / 290) * 16
      for dx = -math.floor(hw), math.floor(hw) do
        local f = 1 - math.abs(dx) / hw
        set_wrap(sky, cx + dx, y, { 255, 244, 212, math.floor(f * f * 24) })
      end
    end
  end
  -- Unified seamless multi-puff cloud sea (single silhouette field, zero overlap seams!)
  local puffs = {
    { 24, 287, 26, 13 }, { 54, 283, 22, 12 }, { 84, 288, 24, 12 },
    { 118, 281, 28, 14 }, { 154, 287, 25, 12 }, { 190, 282, 27, 13 },
    { 226, 288, 24, 12 }, { 260, 280, 28, 14 }, { 296, 286, 25, 13 },
  }
  for y = 264, 304 do
    for x = 0, W - 1 do
      local best_ny = nil
      for _, p in ipairs(puffs) do
        for _, ox in ipairs({ 0, -W, W }) do
          local dx = x - (p[1] + ox)
          local dy = y - p[2]
          local d = (dx * dx) / (p[3] * p[3]) + (dy * dy) / (p[4] * p[4])
          if d <= 1.0 then
            local ny = dy / p[4]
            if not best_ny or ny < best_ny then best_ny = ny end
          end
        end
      end
      if best_ny then
        local col
        if best_ny < -0.25 then
          col = hex("#fff8e8", 225)
        elseif best_ny > 0.25 then
          col = hex("#7ba3b5", 210)
        else
          col = bayer(x, y, hex("#d9eeec", 215), hex("#fff8e8", 225), 0.5 - best_ny * 1.4)
        end
        sky:blend(x, y, col)
      end
    end
  end

  -- Stall 1: Peak Spice Tent with scalloped awning folds & spice sacks
  stalls_far:poly({ { 14, 272 }, { 42, 248 }, { 70, 272 } }, function(x, y)
    local stripe = math.floor((x - 14) / 8) % 2 == 0
    return stripe and (y < 262 and hex("#de715d") or hex("#b84b3b")) or (y < 262 and hex("#f5c66b") or hex("#cc9743"))
  end)
  stalls_far:rect(18, 272, 48, 32, hex("#3f2e24"))
  stalls_far:rect(18, 272, 48, 3, hex("#261b15")) -- eave cast shadow
  stalls_far:rect(28, 277, 28, 11, hex("#ffdf88"))
  stalls_far:rect(30, 279, 24, 7, hex("#fff7d1"))
  stalls_far:ellipse(23, 297, 5, 4, hex("#8a6847")) -- spice sack

  -- Tall Leviathan Watch-Mast + Crossbeam + Crow's-nest + Glowing Hanging Lantern
  stalls_far:rect(100, 200, 6, 104, hex("#694a34"))
  stalls_far:rect(100, 200, 2, 104, hex("#8f674a"))
  stalls_far:rect(95, 214, 16, 6, hex("#4f3726")) -- crow's nest
  stalls_far:rect(85, 224, 36, 3, hex("#7d5940"))
  stalls_far:line(87, 227, 87, 242, hex("#d1b68e"))
  stalls_far:add_glow(87, 246, 11, hex("#ffb84d"), 155)
  stalls_far:rect(84, 242, 6, 7, hex("#ffe480")); stalls_far:rect(85, 243, 4, 5, hex("#fffce0"))
  stalls_far:line(106, 204, 138, 246, hex("#8c7356")) -- rigging line

  -- Stall 2: Arched Medicine & Mechanic Repair Cart (Linh's booth motif)
  stalls_far:ellipse(166, 268, 28, 14, function(x, y, nx, ny)
    return ny < -0.2 and hex("#5ba4c7") or hex("#366b8a")
  end)
  stalls_far:rect(142, 268, 48, 36, hex("#453328"))
  stalls_far:rect(142, 268, 48, 3, hex("#261b15"))
  stalls_far:rect(150, 274, 16, 11, hex("#8ff7ff")); stalls_far:rect(152, 276, 12, 7, hex("#d4fcff"))
  stalls_far:rect(172, 275, 11, 13, hex("#ffd66b"))
  stalls_far:line(142, 268, 142, 304, hex("#6e503b"), 2)

  -- Stall 3: Two-tier Silk & Abacus Gallery
  stalls_far:poly({ { 224, 262 }, { 288, 262 }, { 295, 276 }, { 218, 276 } }, function(x, y)
    return y < 269 and hex("#f0ba59") or hex("#b88232")
  end)
  stalls_far:rect(228, 276, 56, 28, hex("#453227"))
  stalls_far:rect(228, 276, 56, 3, hex("#261b15"))
  stalls_far:rect(238, 281, 13, 10, hex("#ffdf88")); stalls_far:rect(263, 281, 13, 10, hex("#ffdf88"))

  -- Festive rope & pennant flags strung cleanly across 320px
  local bcols = { hex("#f0c259"), hex("#de6b54"), hex("#7ce8ff") }
  for x = 0, W - 1, 12 do
    local sag = math.floor(math.sin((x / W) * math.pi * 4) * 5)
    local by = 247 + sag
    stalls_far:poly({ { x, by }, { x + 8, by }, { x + 4, by + 6 } }, bcols[((math.floor(x / 12)) % 3) + 1])
  end
  for x = 0, W - 1, 16 do
    stalls_far:rect(x, 292, 3, 14, hex("#6b4c37"))
    stalls_far:set(x, 292, hex("#966e50"))
  end
  stalls_far:rect(0, 294, W, 3, hex("#825e44"))
  stalls_far:rect(0, 294, W, 1, hex("#ad8160"))

  -- Detailed oak deck planking with board seams, grain & iron nail heads
  for y = 304, H - 1 do
    local dy = y - 304
    for x = 0, W - 1 do
      local row = math.floor(y / 6)
      local plank_seam = (y % 6 == 0) or ((x + row * 29) % 42 == 0)
      local n = hash2(x, y)
      if dy == 0 then deck:set(x, y, hex("#b88b65"))
      elseif dy == 1 then deck:set(x, y, hex("#8f6747"))
      elseif plank_seam then deck:set(x, y, hex("#422c1f"))
      else
        local c = bayer(x, y, hex("#755139"), hex("#593b29"), dy / 56)
        if n > 0.96 then c = hex("#8a6247") end
        deck:set(x, y, c)
      end
    end
    if y % 6 == 3 then
      for nx = (math.floor(y / 6) * 29) % 42 + 2, W - 1, 42 do
        deck:set(nx, y, hex("#2b1e16"))
      end
    end
  end

  A.build_sprite({ w = W, h = H, layers = { "sky", "stalls_far", "deck" }, frames = { { duration = 200, cels = { sky = sky, stalls_far = stalls_far, deck = deck } } } }, OUT_DIR .. "bg_market.aseprite")
end

-- ============================================================================
-- BG 3: ACT 3 — RỪNG KHÚC XẠ & HẦM NGÂN HÀNG KÝ ỨC (bg_vault.aseprite)
-- Angled prism light shafts, gothic carved pillars, multi-faceted crystals & silk
-- ============================================================================
local function build_bg_vault()
  local W, H = 320, 360
  local sky = A.canvas(W, H)
  local prism_far = A.canvas(W, H)
  local hall = A.canvas(W, H)

  local c1, c2 = hex("#0d1326"), hex("#22284a")
  for y = 0, 305 do
    local t = y / 305
    local c_a = mix(c1, c2, t)
    local c_b = mix(c1, c2, math.min(1, t + 0.08))
    for x = 0, W - 1 do sky:set(x, y, bayer(x, y, c_a, c_b, (t * 8) % 1)) end
  end
  -- Translucent diagonal prism refraction beams descending through cavern air
  for _, beam in ipairs({ { 30, 18, 120, 210, 22 }, { 172, 16, 155, 255, 28 } }) do
    for y = 0, 304 do
      local bx = beam[1] + y * 0.28
      local hw = beam[5] + (y / 304) * 14
      for dx = -math.floor(hw), math.floor(hw) do
        local f = 1 - math.abs(dx) / hw
        set_wrap(sky, bx + dx, y, { beam[2], beam[3], beam[4], math.floor(f * f * 26) })
      end
    end
  end
  for i = 1, 34 do
    local sx = math.floor(hash2(i, 61) * W)
    local sy = math.floor(hash2(i, 89) * 260) + 12
    sky:set(sx, sy, (i % 3 == 0) and hex("#8ff7ff", 140) or hex("#d89eff", 110))
  end

  -- Multi-faceted polygonal Prism Crystal Clusters
  local function draw_crystal_cluster(cx, h_scale)
    local h1 = math.floor(96 * h_scale)
    prism_far:add_glow(cx, 304 - math.floor(h1 * 0.7), 26, hex("#8ff7ff"), 70)
    -- Left amethyst shard
    prism_far:poly({ { cx - 10, 304 }, { cx - 28, 304 - math.floor(54 * h_scale) }, { cx - 18, 304 - math.floor(64 * h_scale) }, { cx + 2, 304 } }, hex("#6c418a"))
    prism_far:poly({ { cx - 28, 304 - math.floor(54 * h_scale) }, { cx - 18, 304 - math.floor(64 * h_scale) }, { cx - 10, 304 } }, hex("#b378d6"))
    -- Right cyan-violet shard
    prism_far:poly({ { cx + 8, 304 }, { cx + 26, 304 - math.floor(48 * h_scale) }, { cx + 18, 304 - math.floor(60 * h_scale) }, { cx, 304 } }, hex("#5c508f"))
    prism_far:poly({ { cx + 18, 304 - math.floor(60 * h_scale) }, { cx + 26, 304 - math.floor(48 * h_scale) }, { cx + 8, 304 } }, hex("#c296f5"))
    -- Tall central crystal spire with bright refraction facet & ridge specular
    prism_far:poly({ { cx - 13, 304 }, { cx - 7, 304 - h1 }, { cx + 2, 304 - h1 - 16 }, { cx + 11, 304 - h1 + 8 }, { cx + 15, 304 } }, hex("#412e66"))
    prism_far:poly({ { cx - 3, 304 }, { cx + 2, 304 - h1 - 16 }, { cx + 11, 304 - h1 + 8 }, { cx + 9, 304 } }, hex("#6bcbe0", 205))
    prism_far:line(cx + 2, 304 - h1 - 16, cx - 2, 304, hex("#d6fcff"))
  end

  draw_crystal_cluster(44, 1.05)
  draw_crystal_cluster(194, 0.88)

  -- Catenary spider-silk strands studded with refracting dew-pearls
  prism_far:bezier_stroke({ 44, 198 }, { 80, 222 }, { 112, 168 }, hex("#8ff7ff", 125), 1, 18)
  prism_far:bezier_stroke({ 116, 182 }, { 158, 220 }, { 194, 224 }, hex("#d89eff", 120), 1, 18)
  for _, pt in ipairs({ { 62, 208 }, { 82, 212 }, { 154, 212 }, { 174, 220 } }) do
    prism_far:set(pt[1], pt[2], hex("#ffffff", 210))
  end

  -- Carved Gothic Bank Pillars with fluted grooves, capitals & masonry cracks
  for _, px in ipairs({ 114, 272 }) do
    prism_far:rect(px - 12, 74, 24, 230, hex("#373e52"))
    prism_far:rect(px - 12, 74, 6, 230, hex("#59637d"))
    prism_far:rect(px + 6, 74, 6, 230, hex("#262b3b"))
    prism_far:line(px - 3, 82, px - 3, 294, hex("#2b3042"), 1)
    prism_far:line(px + 3, 82, px + 3, 294, hex("#262b3b"), 1)
    -- Capital & stepped plinth
    prism_far:rect(px - 17, 70, 34, 8, hex("#4b536b"))
    prism_far:rect(px - 17, 70, 34, 2, hex("#75809e"))
    prism_far:rect(px - 16, 294, 32, 10, hex("#2c3245"))
    prism_far:rect(px - 14, 291, 28, 4, hex("#40475e"))
    prism_far:ellipse(px - 6, 286, 5, 3, hex("#435c57")) -- damp moss tuft
  end

  -- Polished slate-indigo floor tiles with smooth reflected cyan/violet crystal sheen
  for y = 304, H - 1 do
    local dy = y - 304
    for x = 0, W - 1 do
      local seam = (dy == 0) or (dy % 14 == 0) or ((x + math.floor(dy / 14) * 20) % 40 == 0)
      if dy == 0 then
        hall:set(x, y, hex("#8894b0"))
      elseif seam then
        hall:set(x, y, hex("#232838"))
      else
        local c = bayer(x, y, hex("#464e63"), hex("#2b3142"), dy / 56)
        hall:set(x, y, c)
        -- Soft vertical specular reflection beneath the two crystal clusters
        for _, rcx in ipairs({ 44, 194 }) do
          local dist = math.abs(x - rcx)
          if dist < 18 and dy >= 2 and dy < 22 then
            local f = (1.0 - dist / 18.0) * (1.0 - dy / 22.0)
            local a = math.floor(f * 75)
            if a > 6 then
              hall:blend(x, y, (dist < 7) and { 143, 247, 255, a } or { 216, 158, 255, a })
            end
          end
        end
      end
    end
  end

  A.build_sprite({ w = W, h = H, layers = { "sky", "prism_far", "hall" }, frames = { { duration = 200, cels = { sky = sky, prism_far = prism_far, hall = hall } } } }, OUT_DIR .. "bg_vault.aseprite")
end

-- ============================================================================
-- BG 4: ACT 4 — ĐỈNH THÁP LÕI NHỊP TIM (bg_core.aseprite)
-- Astrolabe stone-ring halos, varied ancient monoliths & inlaid Kintsugi dais
-- ============================================================================
local function build_bg_core()
  local W, H = 320, 360
  local sky = A.canvas(W, H)
  local spires = A.canvas(W, H)
  local floor = A.canvas(W, H)

  local c1, c2 = hex("#090817"), hex("#281e42")
  for y = 0, 305 do
    local t = y / 305
    local c_a = mix(c1, c2, t)
    local c_b = mix(c1, c2, math.min(1, t + 0.08))
    for x = 0, W - 1 do sky:set(x, y, bayer(x, y, c_a, c_b, (t * 8) % 1)) end
  end
  -- Concentric ancient golden-cyan astrolabe ring halos behind the Core horizon
  for y = 40, 304 do
    for x = 0, W - 1 do
      local dx, dy = x - 160, y - 210
      local r = math.sqrt(dx * dx + dy * dy)
      if math.abs(r - 92) < 1.3 or math.abs(r - 134) < 1.1 then
        sky:blend(x, y, (math.abs(r - 92) < 1.3) and hex("#ffd66b", 85) or hex("#9be3ff", 65))
      end
    end
  end
  for i = 1, 42 do
    local sx = math.floor(hash2(i, 71) * W)
    local sy = math.floor(hash2(i, 97) * 265) + 12
    sky:set(sx, sy, (i % 3 == 0) and hex("#ffd66b", 170) or hex("#9be3ff", 130))
  end

  -- Varied ancient stepped monoliths & shattered sanctuary arches
  local mono = { { 36, 165, 11 }, { 116, 128, 13 }, { 208, 145, 12 }, { 286, 178, 10 } }
  for _, m in ipairs(mono) do
    local ox, topY, hw = m[1], m[2], m[3]
    spires:poly({ { ox - hw, 304 }, { ox - math.floor(hw * 0.45), topY }, { ox + math.floor(hw * 0.45), topY }, { ox + hw, 304 } }, function(x, y)
      return x < ox - 2 and hex("#362b54") or (x > ox + 3 and hex("#171226") or hex("#241c3b"))
    end)
    -- Glowing vertical conduit + Kintsugi ring crown
    spires:line(ox, topY + 18, ox, 294, hex("#9be3ff", 105), 1)
    spires:add_glow(ox, topY + 10, 9, hex("#ffd66b"), 115)
    spires:disc(ox, topY + 10, 3, hex("#ffd66b"))
    spires:set(ox, topY + 10, hex("#ffffff"))
    spires:rect(ox - hw + 2, 294, (hw - 2) * 2, 10, hex("#2b2245"))
  end
  -- Distant connecting stone arch bridge behind monoliths
  bezier_wrap(spires, { 36, 230 }, { 76, 198 }, { 116, 230 }, hex("#2b2342", 180), 4, 24)
  bezier_wrap(spires, { 208, 235 }, { 247, 204 }, { 286, 235 }, hex("#2b2342", 180), 4, 24)

  -- Ornate basalt dais floor with glowing Kintsugi-gold inlaid channels
  for y = 304, H - 1 do
    local dy = y - 304
    for x = 0, W - 1 do
      local seam_gold = (dy == 6 or dy == 22) or ((x % 32 == 0) and dy > 6 and dy < 22)
      if dy == 0 then floor:set(x, y, hex("#917eb8"))
      elseif dy == 1 then floor:set(x, y, hex("#5d4d80"))
      elseif seam_gold then floor:set(x, y, (x % 3 == 0) and hex("#fff0a8", 160) or hex("#e8b048", 130))
      else floor:set(x, y, bayer(x, y, hex("#271f3b"), hex("#120e1f"), dy / 56)) end
    end
  end

  A.build_sprite({ w = W, h = H, layers = { "sky", "spires", "floor" }, frames = { { duration = 200, cels = { sky = sky, spires = spires, floor = floor } } } }, OUT_DIR .. "bg_core.aseprite")
end

-- ============================================================================
-- LANDMARK PROPS (10 props: 7 upgraded + 3 new v4.3 props!)
-- ============================================================================
local function build_props()
  -- 1. prop_cocoon (64x74, anchor 32,68) — Faceted Cracked Amber Cocoon + mossy cables & rising stardust
  do
    local W, H = 64, 74
    local frames = {}
    for _, mode in ipairs({ "open", "idle" }) do
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        cv:ellipse(32, 68, 22, 4, hex("#0a0810", 115))
        -- Twisted root-cables anchoring chrysalis into scrap soil
        cv:bezier_stroke({ 10, 68 }, { 18, 60 }, { 24, 54 }, hex("#45353c"), 3, 12)
        cv:bezier_stroke({ 54, 68 }, { 46, 60 }, { 40, 54 }, hex("#382b30"), 3, 12)
        cv:ellipse(16, 64, 4, 2, hex("#526b4b"))
        -- Faceted translucent Amber Gem Chrysalis (crisp planar facets instead of coarse grid)
        cv:poly({
          { 32, 16 }, { 46, 26 }, { 50, 44 }, { 42, 62 },
          { 22, 62 }, { 14, 44 }, { 18, 26 }
        }, function(x, y)
          if x < 24 then return y < 40 and hex("#ffe694") or hex("#e8ab48")
          elseif x > 40 then return y < 40 and hex("#b86823") or hex("#824317")
          else return y < 34 and hex("#ffd66b") or hex("#d18432") end
        end)
        -- Angular crystal highlight facets
        cv:poly({ { 32, 16 }, { 21, 31 }, { 29, 36 }, { 39, 25 } }, hex("#fff5c8", 185))
        cv:line(22, 28, 32, 17, hex("#ffffff", 180))
        -- Jagged open fissure + inner cavity shadow
        if mode == "open" then
          cv:poly({ { 30, 24 }, { 37, 33 }, { 39, 51 }, { 31, 60 }, { 24, 49 }, { 25, 32 } }, hex("#1e161a"))
          cv:line(24, 34, 17, 30, hex("#2b1c18"))
          cv:line(39, 44, 48, 39, hex("#2b1c18"))
          cv:add_glow(32, 43, 12 + (fi % 2) * 3, hex("#ffe48a"), 155)
        else
          cv:line(28, 34, 35, 42, hex("#8f4d19")); cv:line(35, 42, 30, 52, hex("#8f4d19"))
          cv:add_glow(32, 43, 10 + (fi % 2) * 2, hex("#ffd066"), 115)
        end
        cv:outline(hex("#1c1412"), 120, hex("#8f5f30"))
        -- Floating 1x1 amber stardust rising from crack
        cv:set(29 + (fi % 3), 14 - fi * 2, hex("#ffe896"))
        cv:set(35 - (fi % 2), 18 - fi * 2, hex("#9be3ff"))
        table.insert(frames, { duration = 240, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "open", from = 1, to = 4 }, { name = "idle", from = 5, to = 8 } } }, OUT_DIR .. "prop_cocoon.aseprite")
  end

  -- 2. prop_puddle (96x34, anchor 48,17) — 5 tags: one, solo_fade, four, corrupt (Vaelen smile!), clear
  do
    local W, H = 96, 34
    local tags_spec = { "one", "solo_fade", "four", "corrupt", "clear" }
    local frames, tags = {}, {}
    local idx = 1
    for _, mode in ipairs(tags_spec) do
      local start_f = idx
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        local is_corr = (mode == "corrupt")
        local base_c = is_corr and hex("#2d3647") or (mode == "clear" and hex("#8cefff") or (mode == "solo_fade" and hex("#3e647d") or hex("#5ba4c9")))
        local rim_c  = is_corr and hex("#68748a") or hex("#d4f8ff")
        cv:ellipse(48, 17, 42, 13, function(x, y, nx, ny)
          local d = nx * nx + ny * ny
          if d > 0.86 then return rim_c end
          return bayer(x, y, base_c, is_corr and hex("#161b26") or hex("#22425e"), d)
        end)

        -- Distinct upside-down reflection busts inside puddle!
        local function draw_mini_refl(rx, ry, hair_c, face_c, extra)
          cv:ellipse(rx, ry + 3, 5, 4, hair_c) -- flipped hair lower/top
          cv:ellipse(rx, ry - 2, 4, 3, face_c)
          if extra == "protag" then
            cv:rect(rx - 3, ry, 2, 1, hex("#e8b058")) -- scarf glint
          elseif extra == "linh" then
            cv:rect(rx - 4, ry + 3, 3, 2, hex("#7ce8ff")); cv:rect(rx + 1, ry + 3, 3, 2, hex("#7ce8ff")) -- goggles!
          elseif extra == "kael" then
            cv:rect(rx - 4, ry - 2, 8, 2, hex("#3a3440"))
            cv:line(rx - 2, ry + 1, rx + 2, ry + 3, hex("#f5c249")) -- Kintsugi gold seam!
          elseif extra == "mira" then
            cv:set(rx + 3, ry + 2, hex("#f0c259")) -- hair clip
          end
        end

        if mode == "one" then
          draw_mini_refl(48, 16, hex("#eef2fa", 210), hex("#f2d5ba", 180), "protag")
        elseif mode == "solo_fade" then
          draw_mini_refl(48, 16, hex("#eef2fa", 160), hex("#f2d5ba", 130), "protag")
          cv:set(55 + (fi % 3), 12 - fi, hex("#8ff5e8"))
          cv:set(41 - (fi % 2), 14 - fi, hex("#ffcb6b"))
        elseif mode == "four" then
          -- 4 buddies squeezed shoulder-to-shoulder!
          draw_mini_refl(27, 17, hex("#6b463c", 200), hex("#f7dbc4", 190), "linh")
          draw_mini_refl(40, 16, hex("#f0ebe0", 220), hex("#ebe6da", 210), "kael")
          draw_mini_refl(53, 17, hex("#eef2fa", 220), hex("#f2d5ba", 200), "protag")
          draw_mini_refl(66, 17, hex("#262b4d", 200), hex("#fae4d2", 190), "mira")
        elseif mode == "corrupt" then
          -- Eerie mirror reflection of VAELEN: blank white eyes + haunting pale smile!
          cv:ellipse(48, 17, 8, 7, hex("#d4d0de", 195))
          cv:ellipse(48, 22, 9, 4, hex("#f0f4fc", 210))
          cv:rect(43, 14, 3, 2, hex("#ffffff"))
          cv:rect(50, 14, 3, 2, hex("#ffffff"))
          cv:bezier_stroke({ 44, 19 }, { 48, 21 }, { 52, 19 }, hex("#262236"), 1, 8)
        else
          cv:add_glow(48, 16, 14 + (fi % 2) * 3, hex("#fff4c4"), 150)
          draw_mini_refl(27, 17, hex("#6b463c", 230), hex("#f7dbc4", 220), "linh")
          draw_mini_refl(40, 16, hex("#f0ebe0", 240), hex("#ebe6da", 230), "kael")
          draw_mini_refl(53, 17, hex("#eef2fa", 240), hex("#f2d5ba", 230), "protag")
          draw_mini_refl(66, 17, hex("#262b4d", 230), hex("#fae4d2", 220), "mira")
        end

        if not is_corr then
          cv:line(18 + fi * 5, 10, 28 + fi * 5, 10, hex("#ffffff", 140))
        end
        frames[idx] = { duration = 260, cels = { prop = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = mode, from = start_f, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = tags }, OUT_DIR .. "prop_puddle.aseprite")
  end

  -- 3. prop_scale (46x64, anchor 23,58)
  do
    local W, H = 46, 64
    local frames = {}
    for _, mode in ipairs({ "intact", "overflow" }) do
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        local g = hex("#f0c259")
        cv:rect(21, 14, 4, 44, hex("#6b6278"))
        cv:rect(14, 55, 18, 5, hex("#4c4657"))
        local tilt = (mode == "overflow") and -4 or 0
        cv:line(6, 18 + tilt, 40, 18 - tilt, g, 2)
        cv:line(8, 19 + tilt, 5, 32 + tilt, hex("#d4dce8")); cv:rect(2, 32 + tilt, 10, 3, g)
        cv:line(38, 19 - tilt, 41, 32 - tilt, hex("#d4dce8")); cv:rect(34, 32 - tilt, 10, 3, g)
        if mode == "overflow" then
          cv:add_glow(23, 16, 12 + fi * 2, hex("#8ff7ff"), 180)
          cv:set(20 - fi * 2, 10, hex("#ffd66b")); cv:set(26 + fi * 2, 12, hex("#8ff7ff"))
        end
        cv:outline(hex("#181522"), 120)
        table.insert(frames, { duration = 220, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "intact", from = 1, to = 4 }, { name = "overflow", from = 5, to = 8 } } }, OUT_DIR .. "prop_scale.aseprite")
  end

  -- 4. prop_campfire (68x52, anchor 34,46) — Stone hearth, split logs, tripod, stew pot + 4 bowls
  do
    local W, H = 68, 52
    local frames = {}
    for _, mode in ipairs({ "warm", "cold" }) do
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        cv:ellipse(33, 46, 26, 4, hex("#0a0810", 115))
        -- Hearth stones & stacked firewood
        for _, sx in ipairs({ 25, 29, 34, 39 }) do cv:ellipse(sx, 45, 3, 2, hex("#595e6b")) end
        cv:line(27, 43, 40, 44, hex("#4f3322"), 2)
        cv:line(28, 44, 39, 41, hex("#6b4730"), 2)
        -- Tripod wooden legs + top lashings
        cv:line(18, 44, 31, 14, hex("#69462f"), 2); cv:line(48, 44, 35, 14, hex("#4a3020"), 2)
        cv:rect(30, 14, 6, 3, hex("#d9b377"))
        -- Glazed copper/terracotta stew pot + brass rim + steam
        cv:ellipse(33, 28, 9, 7, function(x, y, nx) return nx < -0.25 and hex("#c96b44") or (nx > 0.35 and hex("#7a371f") or hex("#a85232")) end)
        cv:rect(26, 21, 14, 2, hex("#f0c259")); cv:rect(28, 21, 6, 1, hex("#fff0a8"))
        for bi, bx in ipairs({ 10, 20, 48, 57 }) do
          cv:ellipse(bx, 45, 4, 2, hex("#ece7db"))
          if mode == "warm" then cv:rect(bx - 2, 43, 4, 1, hex("#ffd166")) end
          if bi == 1 then cv:set(bx + 3, 43, hex("#2b2633")) end
        end
        if mode == "warm" then
          local fh = 6 + (fi % 2) * 3
          local sway = (fi == 2 and 1) or (fi == 4 and -1) or 0
          cv:poly({ { 27, 43 }, { 33 + sway, 43 - fh }, { 39, 43 } }, hex("#ff7733"))
          cv:poly({ { 30, 43 }, { 33 + sway, 45 - fh }, { 36, 43 } }, hex("#ffe480"))
          cv:set(33 + sway, 46 - fh, hex("#ffffff"))
          cv:add_glow(33, 38, 17, hex("#ff9e44"), 120)
          cv:set(31 + (fi % 3), 18 - fi, hex("#fff5d6", 150))
        else
          cv:ellipse(33, 44, 7, 2, hex("#545b6b"))
          cv:set(32, 38 - (fi % 3), hex("#888e9c", 110))
        end
        table.insert(frames, { duration = 200, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "warm", from = 1, to = 4 }, { name = "cold", from = 5, to = 8 } } }, OUT_DIR .. "prop_campfire.aseprite")
  end

  -- 5. prop_statue (68x98, anchor 34,90) — Bức Tượng Đá Vaelen
  do
    local W, H = 68, 98
    local cv = A.canvas(W, H)
    local S_L, S_M, S_D = hex("#adb5c9"), hex("#788096"), hex("#474d61")
    cv:rect(14, 80, 40, 12, S_D); cv:rect(16, 78, 36, 4, S_M)
    cv:poly({ { 20, 78 }, { 23, 34 }, { 45, 34 }, { 48, 78 } }, function(x, y) return bayer(x, y, S_L, S_D, (x - 20) / 28) end)
    cv:ellipse(34, 22, 10, 11, S_M); cv:ellipse(34, 15, 11, 6, S_L)
    cv:rect(28, 22, 3, 2, hex("#1a1c26")); cv:rect(37, 22, 3, 2, hex("#1a1c26"))
    cv:line(27, 46, 41, 46, hex("#2b2e3d"), 2)
    cv:outline(hex("#181a24"), 120)
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = { { duration = 300, cels = { prop = cv } } }, tags = { { name = "idle", from = 1, to = 1 } } }, OUT_DIR .. "prop_statue.aseprite")
  end

  -- 6. prop_pulse_core (140x140, anchor 70,70) — Mặt Trời Sinh Học
  do
    local W, H = 140, 140
    local frames = {}
    for _, mode in ipairs({ "warm", "strained" }) do
      for fi = 1, 6 do
        local cv = A.canvas(W, H)
        local cx, cy = 70, 70
        local beat = (fi == 2 or fi == 5) and 3 or 0
        local c_core = (mode == "warm") and hex("#fff8d6") or hex("#e0e6f5")
        local c_ring = (mode == "warm") and hex("#ffbe5c") or hex("#7aa3d4")
        local c_bio  = (mode == "warm") and hex("#7df5de") or hex("#9e87c4")
        cv:add_glow(cx, cy, 56 + beat * 3, c_ring, mode == "warm" and 160 or 110)
        cv:ellipse(cx, cy, 24 + beat, 24 + beat, function(x, y, nx, ny)
          local d = math.sqrt(nx * nx + ny * ny)
          return d < 0.6 and c_core or bayer(x, y, c_ring, c_bio, d)
        end)
        for ri = 0, 7 do
          local ang = ri * math.pi / 4 + fi * (math.pi / 12)
          local px, py = cx + math.cos(ang) * (36 + beat), cy + math.sin(ang) * (36 + beat)
          cv:disc(px, py, 3, (ri % 2 == 0) and c_bio or c_core)
        end
        table.insert(frames, { duration = 180, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "warm", from = 1, to = 6 }, { name = "strained", from = 7, to = 12 } } }, OUT_DIR .. "prop_pulse_core.aseprite")
  end

  -- 7. prop_leviathan (210x96, anchor 105,58) — Colossal 500-Year-Old Biological Sky-Whale!
  -- Smooth organic hull shading, sweeping curved pectoral fin, barnacle clusters, rope lashings & wise eye
  do
    local W, H = 210, 96
    local frames = {}
    for fi = 1, 4 do
      local cv = A.canvas(W, H)
      local dy = (fi == 2 or fi == 3) and 1 or 0
      -- Smooth sculpted whale hull curving gracefully from tail (left) to brow (right)
      cv:poly({
        { 14, 46 + dy }, { 52, 23 + dy }, { 126, 19 + dy }, { 182, 32 + dy },
        { 202, 54 + dy }, { 186, 74 + dy }, { 116, 82 + dy }, { 36, 75 + dy }
      }, function(x, y)
        local ny = (y - (21 + dy)) / 61
        local speck = hash2(x, y)
        if ny < 0.22 then return speck > 0.72 and hex("#5b8dad") or hex("#477294")
        elseif ny < 0.56 then return speck > 0.78 and hex("#3c6282") or hex("#2e4d69")
        elseif ny < 0.84 then return hex("#223a52")
        else return hex("#17273b") end
      end)
      -- Subtle dorsal highlight ridge
      cv:bezier_stroke({ 26, 38 + dy }, { 104, 18 + dy }, { 180, 34 + dy }, hex("#6c9ec2"), 1, 28)
      -- Ventral baleen pleated throat grooves (iconic Leviathan trait!)
      for gx = 148, 194, 5 do
        cv:line(gx, 60 + dy, gx - 11, 74 + dy, hex("#93c4d1"))
        cv:line(gx + 1, 60 + dy, gx - 10, 74 + dy, hex("#1a2b40"))
      end
      -- Detailed mossy dorsal barnacle clusters
      for _, bx in ipairs({ 48, 88, 134 }) do
        cv:ellipse(bx, 23 + dy, 9, 4, hex("#596356"))
        cv:ellipse(bx - 2, 22 + dy, 5, 2, hex("#8c9e7e"))
        cv:ellipse(bx + 4, 24 + dy, 3, 2, hex("#434d42"))
      end
      -- Hemp lashings & oak struts strapping Market Deck onto Leviathan's back
      for _, sx in ipairs({ 64, 112 }) do
        cv:rect(sx - 3, 12, 6, 22 + dy, hex("#734f38"))
        cv:rect(sx - 3, 12, 2, 22 + dy, hex("#94694d"))
        cv:rect(sx - 5, 22 + dy, 10, 3, hex("#d9b377"))
        cv:rect(sx - 4, 22 + dy, 4, 1, hex("#fff0b5"))
      end
      -- Gracefully curved Pectoral Fin with luminous turquoise rim
      cv:poly({ { 94, 62 + dy }, { 78, 78 + dy }, { 56, 89 + dy }, { 42, 86 + dy }, { 58, 72 + dy }, { 74, 58 + dy } }, function(x, y)
        return y > 78 + dy and hex("#1f3852") or hex("#2e5173")
      end)
      cv:bezier_stroke({ 93, 62 + dy }, { 76, 78 + dy }, { 55, 88 + dy }, hex("#8ff7ff"), 1, 18)
      -- Glowing Turquoise Bioluminescent Constellation Stripes along flank
      for i = 0, 6 do
        local rx = 40 + i * 19
        local ry = 44 + math.floor(math.sin(i * 0.7) * 5) + dy
        cv:ellipse(rx, ry, 4, 2, hex("#7ce8ff", 190))
        cv:set(rx, ry, hex("#ffffff"))
      end
      -- Wise ancient golden-jade Whale Eye (blinks softly on fi==4!)
      cv:ellipse(166, 44 + dy, 9, 6, hex("#132033"))
      if fi == 4 then
        cv:line(159, 44 + dy, 173, 44 + dy, hex("#b3ffe8"))
      else
        cv:disc(167, 44 + dy, 4, hex("#6fe3c4"))
        cv:disc(168, 44 + dy, 2, hex("#fff4c4"))
        cv:set(166, 42 + dy, hex("#ffffff"))
        cv:add_glow(167, 44 + dy, 9, hex("#8ff7ff"), 115)
      end
      cv:outline(hex("#121a29"), 120, hex("#3a5975"))
      frames[fi] = { duration = 360, cels = { prop = cv } }
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "idle", from = 1, to = 4 } } }, OUT_DIR .. "prop_leviathan.aseprite")
  end

  -- 8. prop_stele_trong (56x80, anchor 28,74) — Carved moss-trimmed ancient stone stele "TRONG"
  do
    local W, H = 56, 80
    local frames = {}
    for _, mode in ipairs({ "rusted", "cleaned" }) do
      for fi = 1, 2 do
        local cv = A.canvas(W, H)
        cv:ellipse(28, 74, 20, 4, hex("#0a0810", 120))
        cv:rect(10, 64, 36, 12, hex("#383a4d")); cv:rect(13, 61, 30, 4, hex("#595d75"))
        cv:rect(13, 61, 30, 1, hex("#7d83a1"))
        cv:poly({ { 15, 62 }, { 17, 16 }, { 28, 10 }, { 39, 16 }, { 41, 62 } }, function(x, y)
          local n = hash2(x, y)
          if x < 21 then return n > 0.7 and hex("#8a91ab") or hex("#737a94")
          elseif x > 34 then return hex("#404559")
          else return n > 0.78 and hex("#686f87") or hex("#545b70") end
        end)
        -- Moss tufts at base & side scroll trim
        cv:ellipse(17, 61, 4, 2, hex("#4e694a")); cv:ellipse(39, 61, 3, 2, hex("#435940"))
        cv:line(18, 22, 18, 54, hex("#3a3f52")); cv:line(38, 22, 38, 54, hex("#3a3f52"))
        local g_col = (mode == "cleaned") and hex("#ffe885") or hex("#615650")
        -- Crisp pixel glyph "TRONG" across stele center
        cv:rect(18, 30, 4, 1, g_col); cv:rect(19, 30, 2, 6, g_col)
        cv:rect(23, 30, 1, 6, g_col); cv:rect(23, 30, 3, 3, g_col); cv:set(25, 34, g_col); cv:set(26, 35, g_col)
        cv:rect(28, 30, 3, 6, g_col); cv:set(29, 32, hex("#474c61")); cv:set(29, 33, hex("#474c61"))
        cv:rect(32, 30, 1, 6, g_col); cv:set(33, 31, g_col); cv:set(34, 33, g_col); cv:rect(35, 30, 1, 6, g_col)
        cv:rect(37, 30, 3, 1, g_col); cv:rect(37, 30, 1, 6, g_col); cv:rect(37, 35, 3, 1, g_col); cv:rect(39, 33, 1, 3, g_col)
        if mode == "rusted" then
          cv:rect(22, 27, 14, 2, hex("#7a5948", 185))
        else
          cv:add_glow(28, 33, 14 + fi * 2, hex("#ffd66b"), 150)
        end
        cv:outline(hex("#181924"), 120, hex("#6a708a"))
        table.insert(frames, { duration = 320, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "rusted", from = 1, to = 2 }, { name = "cleaned", from = 3, to = 4 } } }, OUT_DIR .. "prop_stele_trong.aseprite")
  end

  -- 9. prop_solo_stove (52x48, anchor 26,42) — Bếp Đá Bỏ Hoang & Nồi Súp Cháy Khê Hồi 3
  do
    local W, H = 52, 48
    local frames = {}
    for _, mode in ipairs({ "cold", "burnt" }) do
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        -- Cracked abandoned subterranean stone stove
        cv:poly({ { 10, 42 }, { 14, 26 }, { 38, 26 }, { 42, 42 } }, function(x, y) return bayer(x, y, hex("#595e70"), hex("#333645"), (x - 10) / 32) end)
        cv:rect(21, 33, 10, 8, mode == "burnt" and hex("#7a2f1d") or hex("#222430"))
        -- Charred iron pot overflowing green scallions when `burnt`!
        cv:ellipse(26, 23, 10, 5, hex("#36323d"))
        cv:rect(18, 19, 16, 2, hex("#4f4959"))
        if mode == "burnt" then
          -- Untidy green spring-onion blades poking out + thick charcoal black smoke puffs!
          cv:line(20, 19, 16, 15, hex("#6fc965")); cv:line(28, 19, 34, 15, hex("#6fc965")); cv:line(24, 19, 25, 14, hex("#8ce67c"))
          local sy = 10 - (fi % 4) * 2
          cv:disc(25 + (fi % 2), sy, 4, hex("#221f29", 190))
          cv:disc(29 - (fi % 2), sy - 5, 3, hex("#3b3745", 150))
        end
        cv:outline(hex("#15141c"), 120)
        table.insert(frames, { duration = 220, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "cold", from = 1, to = 4 }, { name = "burnt", from = 5, to = 8 } } }, OUT_DIR .. "prop_solo_stove.aseprite")
  end

  -- 10. prop_fox_egg (28x32, anchor 14,28) — Quả Trứng Hồ Ly Hoàng Gia (`ITEM_ROYAL_FOX_EGG`)
  do
    local W, H = 28, 32
    local frames = {}
    for _, mode in ipairs({ "idle", "chime" }) do
      for fi = 1, 2 do
        local cv = A.canvas(W, H)
        cv:ellipse(14, 27, 10, 3, hex("#5e3654")) -- plum velvet bazaar cushion
        cv:ellipse(14, 17, 7, 9, function(x, y, nx, ny) return bayer(x, y, hex("#fff5e8"), hex("#d6c2d4"), nx * 0.5 + ny * 0.4) end)
        cv:line(10, 14, 18, 18, hex("#f0c259")); cv:set(14, 16, hex("#8ff7ff"))
        if mode == "chime" then
          cv:add_glow(14, 16, 8 + fi * 2, hex("#ffd46b"), 140)
          cv:set(6, 10 - fi, hex("#fff4c4")); cv:set(22, 12 - fi, hex("#8ff7ff"))
        end
        cv:outline(hex("#1c1524"), 120)
        table.insert(frames, { duration = 260, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "idle", from = 1, to = 2 }, { name = "chime", from = 3, to = 4 } } }, OUT_DIR .. "prop_fox_egg.aseprite")
  end

  -- 11. prop_debt_pillar (48x72, anchor 24,62) — Trụ Cân Đối Nợ 4 góc Đấu Trường Vaelen (Hồi 4)
  do
    local W, H = 48, 72
    local frames = {}
    for _, mode in ipairs({ "locked", "shattered" }) do
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        local floatY = (fi == 2 or fi == 3) and -1 or 0
        cv:ellipse(24, 62, 18, 4, hex("#080812", 125))
        -- Stepped basalt plinth with top bevels
        cv:rect(8, 56, 32, 8, hex("#262b3d")); cv:rect(8, 56, 32, 2, hex("#4e5673"))
        cv:rect(12, 50, 24, 6, hex("#363d54")); cv:rect(12, 50, 24, 1, hex("#5e6787"))
        if mode == "locked" then
          -- Tall obsidian Syndicate obelisk + cold cyan Memoria crystal conduit
          cv:poly({ { 15, 49 }, { 17, 24 }, { 31, 24 }, { 33, 49 } }, function(x, y)
            if x < 20 then return hex("#576282")
            elseif x > 28 then return hex("#232838")
            else return hex("#3b4259") end
          end)
          cv:rect(17, 23, 14, 3, hex("#f0c259")); cv:rect(18, 23, 6, 1, hex("#fff0a8"))
          cv:line(24, 27, 24, 47, hex("#8ff7ff"), 2)
          -- Hovering cyan Memoria crystal prism at apex
          cv:add_glow(24, 14 + floatY, 14 + (fi % 2) * 2, hex("#8df5ff"), 165)
          cv:poly({ { 24, 5 + floatY }, { 31, 14 + floatY }, { 24, 22 + floatY }, { 17, 14 + floatY } }, hex("#9be3ff"))
          cv:poly({ { 24, 8 + floatY }, { 28, 14 + floatY }, { 24, 19 + floatY }, { 20, 14 + floatY } }, hex("#e8fcff"))
        else
          -- Shattered base repaired with Kintsugi gold cracks + calm 0L golden seal ember!
          cv:poly({ { 15, 49 }, { 16, 36 }, { 21, 33 }, { 26, 38 }, { 32, 34 }, { 33, 49 } }, function(x, y)
            return x < 21 and hex("#505975") or hex("#31374a")
          end)
          cv:line(18, 48, 25, 37, hex("#f5c249")); cv:line(27, 47, 30, 36, hex("#fff0a8"))
          cv:add_glow(24, 26 + floatY, 15, hex("#ffcb6b"), 150)
          cv:ellipse(24, 26 + floatY, 6, 4, hex("#f0c259")); cv:disc(24, 26 + floatY, 2, hex("#8ff5e8"))
          cv:set(17, 20 - fi, hex("#ffd66b")); cv:set(30, 18 - fi, hex("#8ff5e8")); cv:set(23, 12 - fi, hex("#fff4c4"))
        end
        cv:outline(hex("#12131f"), 120, hex("#5e6787"))
        table.insert(frames, { duration = 220, cels = { prop = cv } })
      end
    end
    A.build_sprite({ w = W, h = H, layers = { "prop" }, frames = frames, tags = { { name = "locked", from = 1, to = 4 }, { name = "shattered", from = 5, to = 8 } } }, OUT_DIR .. "prop_debt_pillar.aseprite")
  end
end

-- ============================================================================
-- NEW: FX_AMBIENT_FLORA (32x32, anchor 16,28) — 4 animated ambient props
-- Tags (4f each): lantern_sway (Hồi 2), prism_crystal (Hồi 3), scrap_blossom (Hồi 1), core_ember (Hồi 4)
-- ============================================================================
local function build_ambient_flora()
  local W, H = 32, 32
  local frames, tags = {}, {}
  local function push(tag, list, dur)
    local f0 = #frames + 1
    for _, cels in ipairs(list) do frames[#frames + 1] = { duration = dur, cels = cels } end
    tags[#tags + 1] = { name = tag, from = f0, to = #frames }
  end

  -- 1) lantern_sway (4f): Đèn lồng gió Hồi 2
  do
    local list = {}
    for fi = 1, 4 do
      local gl, cv = A.canvas(W, H), A.canvas(W, H)
      local sw = (fi == 2 and 1) or (fi == 4 and -1) or 0
      cv:ellipse(14, 28, 6, 2, hex("#0a0812", 110))
      cv:rect(10, 8, 2, 20, hex("#6b4c37"))
      cv:rect(10, 8, 1, 20, hex("#8f674a"))
      cv:rect(10, 7, 10, 2, hex("#7d5940"))
      cv:line(19, 9, 19 + sw, 13, hex("#d9b377"))
      local lx = 19 + sw
      gl:add_glow(lx, 17, 9 + (fi % 2), hex("#ffb84d"), 125)
      cv:rect(lx - 3, 13, 6, 2, hex("#473022"))
      cv:rect(lx - 3, 15, 6, 5, hex("#ffd66b"))
      cv:rect(lx - 2, 16, 4, 3, hex("#fff8d6"))
      cv:rect(lx - 2, 20, 4, 1, hex("#473022"))
      cv:line(lx, 21, lx + sw, 23, hex("#de6b54"))
      cv:outline(hex("#1c1410"), 120)
      list[#list + 1] = { glow = gl, prop = cv }
    end
    push("lantern_sway", list, 210)
  end

  -- 2) prism_crystal (4f): Tinh thể lam tím Hồi 3
  do
    local list = {}
    for fi = 1, 4 do
      local gl, cv = A.canvas(W, H), A.canvas(W, H)
      local pulse = (fi == 2 or fi == 3) and 1 or 0
      gl:add_glow(16, 18, 10 + pulse * 2, hex("#8ff7ff"), 110)
      cv:ellipse(16, 27, 8, 3, hex("#262b3d"))
      -- Left amethyst shard
      cv:poly({ { 13, 26 }, { 8, 15 }, { 11, 13 }, { 16, 26 } }, hex("#9e63c7"))
      -- Main cyan prism
      cv:poly({ { 13, 26 }, { 14, 10 }, { 17, 7 }, { 21, 13 }, { 19, 26 } }, function(x, y)
        return x < 17 and hex("#8ff7ff") or hex("#4e87b5")
      end)
      -- Small violet shard right
      cv:poly({ { 18, 26 }, { 23, 16 }, { 25, 19 }, { 21, 26 } }, hex("#d89eff"))
      cv:line(15, 11, 17, 8, hex("#ffffff"))
      if fi == 1 or fi == 3 then gl:set(12, 9, hex("#ffffff")) else gl:set(22, 12, hex("#d89eff")) end
      cv:outline(hex("#101122"), 120)
      list[#list + 1] = { glow = gl, prop = cv }
    end
    push("prism_crystal", list, 220)
  end

  -- 3) scrap_blossom (4f): Khóm hoa dại mọc từ phế liệu hổ phách Hồi 1
  do
    local list = {}
    for fi = 1, 4 do
      local gl, cv = A.canvas(W, H), A.canvas(W, H)
      local sw = (fi == 2 and 1) or (fi == 4 and -1) or 0
      cv:ellipse(16, 28, 7, 2, hex("#0a0810", 110))
      -- Rusted cog fragment & glowing amber crumb at base
      cv:ellipse(16, 26, 7, 3, hex("#4a3a45"))
      cv:poly({ { 17, 26 }, { 20, 22 }, { 23, 26 } }, hex("#e8a84c"))
      gl:add_glow(19, 23, 6, hex("#ffbe5c"), 80)
      -- Swaying tender stems & sage leaves
      cv:line(14, 25, 12 + sw, 17, hex("#5c8549"))
      cv:line(16, 25, 16 + sw, 14, hex("#75a65b"))
      cv:line(18, 25, 20 + sw, 18, hex("#5c8549"))
      cv:rect(12, 22, 3, 2, hex("#87b86e")); cv:rect(17, 21, 3, 2, hex("#6a9652"))
      -- Wildflower blossoms
      cv:disc(12 + sw, 16, 2, hex("#ffd66b")); cv:set(12 + sw, 16, hex("#fff8d6"))
      cv:disc(16 + sw, 13, 2, hex("#ffad6b")); cv:set(16 + sw, 13, hex("#fff5c8"))
      cv:disc(20 + sw, 17, 1, hex("#ffe480"))
      cv:outline(hex("#1c1614"), 120)
      list[#list + 1] = { glow = gl, prop = cv }
    end
    push("scrap_blossom", list, 240)
  end

  -- 4) core_ember (4f): Đài lửa vàng ấm Hồi 4
  do
    local list = {}
    for fi = 1, 4 do
      local gl, cv = A.canvas(W, H), A.canvas(W, H)
      local bob = (fi == 2 or fi == 3) and -1 or 0
      cv:ellipse(16, 28, 6, 2, hex("#080710", 120))
      -- Miniature dark basalt & gold brazier pedestal
      cv:rect(12, 24, 8, 4, hex("#2b2342"))
      cv:rect(11, 21, 10, 3, hex("#433863"))
      cv:rect(11, 21, 10, 1, hex("#f0c259"))
      -- Serene floating golden-cyan hearth flame
      gl:add_glow(16, 15 + bob, 9 + (fi % 2), hex("#ffd66b"), 135)
      cv:poly({ { 13, 18 + bob }, { 16, 10 + bob }, { 19, 18 + bob } }, hex("#ffae42"))
      cv:poly({ { 14, 18 + bob }, { 16, 13 + bob }, { 18, 18 + bob } }, hex("#fff4c4"))
      cv:set(16, 16 + bob, hex("#8ff5e8"))
      gl:set(14 + (fi % 3), 9 - (fi % 2), hex("#ffe896"))
      cv:outline(hex("#120e1f"), 120)
      list[#list + 1] = { glow = gl, prop = cv }
    end
    push("core_ember", list, 200)
  end

  A.build_sprite({ w = W, h = H, layers = { "glow", "prop" }, frames = frames, tags = tags }, OUT_DIR .. "fx_ambient_flora.aseprite")
end

-- ============================================================================
-- 7. FX_MUSIC_BOX — "Hộp Nhạc Đàn" (28x28, anchor 14,24)
-- Tags: intact (4f, open warm brass lid + floating musical notes),
--       shattered (4f, cracked box + loose gears beside Vaelen statue)
-- ============================================================================
local function build_music_box()
  local W, H = 28, 28
  local INK = hex("#181114")
  local WOOD_L, WOOD_M, WOOD_D = hex("#7d4c34"), hex("#543022"), hex("#331c15")
  local BRASS_H, BRASS_M, BRASS_D = hex("#fff0a8"), hex("#e8b84b"), hex("#966c28")
  local VELVET = hex("#361a30")
  local frames, tags, idx = {}, {}, 1

  local function draw_note(cv, x, y, col_hi, col_lo)
    cv:rect(x, y, 2, 2, col_hi)
    cv:set(x, y + 2, hex("#8f4f12"))
    cv:set(x + 1, y + 1, col_lo)
    cv:line(x + 1, y, x + 1, y - 4, col_hi)
    cv:set(x + 2, y - 4, col_hi)
    cv:set(x + 3, y - 3, col_lo)
  end

  -- 1) intact (4f)
  do
    local s_idx = idx
    for fi = 1, 4 do
      local sh, gl, cv = A.canvas(W, H), A.canvas(W, H), A.canvas(W, H)
      sh:ellipse(14, 24, 9, 3, hex("#08060c", 130))

      -- Warm harmonic glow spilling from open music box
      local gp = (fi == 2 or fi == 3) and 1 or 0
      gl:add_glow(14, 15, 10 + gp * 2, hex("#ffd66b"), 145)
      gl:add_glow(14, 13, 6, hex("#fff4c4"), 110)

      -- Tilted open hinged lid (behind box)
      cv:poly({ { 6, 15 }, { 8, 8 }, { 19, 8 }, { 21, 15 } }, function(x)
        return x < 11 and WOOD_L or WOOD_M
      end)
      cv:rect(8, 8, 11, 1, BRASS_H)
      cv:poly({ { 8, 14 }, { 9, 10 }, { 18, 10 }, { 19, 14 } }, hex("#4a243d")) -- burgundy lid silk

      -- Main music box chest (x=6..21, y=15..24)
      cv:rect(6, 15, 16, 9, WOOD_D)
      cv:rect(7, 16, 8, 7, WOOD_M)
      cv:rect(7, 16, 4, 6, WOOD_L)
      -- Velvet recessed chamber & turning brass cylinder comb
      cv:rect(8, 14, 12, 3, VELVET)
      local cyl_tick = (fi % 2 == 0) and 1 or 0
      cv:rect(9, 14, 9, 2, BRASS_M)
      cv:set(10 + cyl_tick, 14, BRASS_H); cv:set(14 + cyl_tick, 14, BRASS_H); cv:set(17 - cyl_tick, 15, BRASS_D)

      -- Brass corner brackets, trim & key clasp
      cv:rect(6, 15, 16, 1, BRASS_M); cv:rect(6, 23, 16, 1, BRASS_D)
      cv:rect(6, 16, 1, 7, BRASS_M); cv:rect(21, 16, 1, 7, BRASS_D)
      cv:rect(12, 16, 4, 3, BRASS_M); cv:set(13, 17, BRASS_H); cv:set(14, 18, INK)
      cv:set(7, 15, BRASS_H) -- top-left metallic glint

      cv:outline(INK, 120)

      -- Luminous floating musical notes above open lid (un-outlined on glow layer so crisp & airy!)
      local n1y = 9 - ((fi - 1) % 4)
      local n2y = 7 - ((fi + 1) % 4)
      draw_note(gl, 8 + (fi % 2), n1y, hex("#fff6cc"), hex("#ffd452"))
      draw_note(gl, 17 - (fi % 2), n2y, hex("#ffe68a"), hex("#f5a638"))
      gl:set(13, 3 + (fi % 3), hex("#ffffff"))

      frames[idx] = { duration = 210, cels = { shadow = sh, glow = gl, prop = cv } }
      idx = idx + 1
    end
    table.insert(tags, { name = "intact", from = s_idx, to = idx - 1 })
  end

  -- 2) shattered (4f)
  do
    local s_idx = idx
    for fi = 1, 4 do
      local sh, gl, cv = A.canvas(W, H), A.canvas(W, H), A.canvas(W, H)
      sh:ellipse(14, 24, 11, 3, hex("#08060c", 130))

      -- Faint cold dying memory flicker inside the broken box
      if fi == 1 or fi == 3 then
        gl:add_glow(13, 18, 6, hex("#7ea8c4"), 75)
        gl:set(11, 15, hex("#b8e6ff"))
      else
        gl:add_glow(13, 18, 5, hex("#5d7e99"), 45)
        gl:set(15, 14 - (fi % 2), hex("#94bed9"))
      end

      -- Detached snapped lid resting crookedly behind right
      cv:poly({ { 15, 20 }, { 19, 13 }, { 25, 16 }, { 22, 22 } }, WOOD_D)
      cv:line(19, 13, 25, 16, BRASS_D)

      -- Cracked left-leaning base chest (split corner & dead velvet)
      cv:poly({ { 6, 23 }, { 6, 17 }, { 14, 16 }, { 18, 18 }, { 18, 24 }, { 7, 24 } }, WOOD_M)
      cv:rect(7, 17, 7, 5, WOOD_L)
      cv:poly({ { 8, 17 }, { 14, 17 }, { 16, 19 }, { 9, 19 } }, hex("#231521"))
      -- Jagged crack across front face & bent brass clasp
      cv:line(10, 17, 12, 20, INK); cv:line(12, 20, 11, 23, INK)
      cv:rect(14, 18, 3, 2, BRASS_D)
      cv:rect(6, 23, 12, 1, BRASS_D)

      -- Loose scattered brass gears & uncoiled spring spilling onto floor
      cv:disc(5, 23, 2, BRASS_M); cv:set(5, 23, WOOD_D); cv:set(4, 21, BRASS_H) -- left toothed gear
      cv:disc(22, 23, 2, BRASS_D); cv:set(22, 23, INK); cv:set(23, 21, BRASS_M) -- right gear
      cv:bezier_stroke({ 12, 18 }, { 17, 23 }, { 21, 20 }, BRASS_H, 1, 7) -- sprung brass coil

      cv:outline(INK, 120)
      frames[idx] = { duration = 260, cels = { shadow = sh, glow = gl, prop = cv } }
      idx = idx + 1
    end
    table.insert(tags, { name = "shattered", from = s_idx, to = idx - 1 })
  end

  A.build_sprite({ w = W, h = H, layers = { "shadow", "glow", "prop" }, frames = frames, tags = tags }, OUT_DIR .. "fx_music_box.aseprite")
end

build_bg_scrapyard()
build_bg_market()
build_bg_vault()
build_bg_core()
build_props()
build_ambient_flora()
build_music_box()
print("BUILD_HOLLOW_WORLD_OK")
