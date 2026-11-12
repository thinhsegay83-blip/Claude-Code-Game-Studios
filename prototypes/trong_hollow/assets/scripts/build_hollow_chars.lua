-- build_hollow_chars.lua: Upgraded pixel-art characters, companions, boss, NPCs,
-- bestiary creatures, multi-direction poses (Caterpillar Follow), dissolve FX,
-- and 16 richly sculpted 48x52 expressive portraits (handover_story.md v4.3).
local DIR = debug.getinfo(1, "S").source:match("@?(.*[/\\])") or ""
local A = dofile(DIR .. "art_lib.lua")

local OUT_DIR = DIR .. "..\\aseprite\\"
local hex, mix, bayer = A.hex, A.mix, A.bayer_pick

-- ============================================================================
-- 1. CHAR_PROTAG — "Kẻ Trắng Tay" (40x48, anchor 20,42)
-- Tags: idle, walk, walk_up, walk_side, puddle, pulse, dissolve
-- ============================================================================
local function build_protag()
  local W, H = 40, 48
  local INK = hex("#181520")
  local HAIR_L, HAIR_D = hex("#eef2fa"), hex("#9eabbf")
  local SKIN_L, SKIN_D = hex("#f2d5ba"), hex("#c79b7e")
  local COAT_L, COAT_M, COAT_D = hex("#61756b"), hex("#475750"), hex("#2e3836")
  local SCARF_L, SCARF_D = hex("#e8b058"), hex("#9e6b32")
  local DEED = hex("#f7f4eb")
  local HEART_A, HEART_C = hex("#ffcb6b"), hex("#8ff5e8")

  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H)
    sh:ellipse(20, 43, 8, 3, hex("#0a0910", 120))
    local cv = A.canvas(W, H)

    local bob = (mode ~= "puddle" and (fi == 2 or fi == 3 or fi == 5)) and 1 or 0
    local crouch = (mode == "puddle") and 5 or 0
    local walk_off = 0
    if mode == "walk" or mode == "walk_up" or mode == "walk_side" or mode == "hooded_walk" then
      local offsets = { -3, -1, 2, 3, 1, -2 }
      walk_off = offsets[fi]
    end
    local is_hood = (mode == "hooded" or mode == "hooded_walk")
    local cx = 20
    local hy = 13 + bob + crouch
    local ty = 21 + bob + crouch

    -- Boots
    if mode == "puddle" then
      cv:rect(cx - 5, 36, 4, 6, hex("#2a2633"))
      cv:rect(cx + 1, 35, 5, 7, hex("#363142"))
    elseif mode == "walk_side" then
      cv:rect(cx - 3 + walk_off, 34, 4, 8, hex("#363140"))
      cv:rect(cx - 1 - walk_off, 34, 4, 8, hex("#23202b"))
    else
      local lStep = (mode == "walk" or mode == "hooded_walk") and walk_off or 0
      cv:rect(cx - 4 + lStep, 34 + ((mode == "walk_up" and walk_off > 0) and -1 or 0), 3, 8, hex("#2f2a38"))
      cv:rect(cx + 2 - lStep, 34 + ((mode == "walk_up" and walk_off < 0) and -1 or 0), 3, 8, hex("#23202b"))
    end

    if mode == "walk_up" then
      -- Rear coat silhouette + traveler backpack + hanging amber scarf tail + messy white crown hair
      cv:poly({ { cx - 7, ty }, { cx + 7, ty }, { cx + 9, ty + 15 }, { cx - 9, ty + 15 } }, function(x, y)
        return bayer(x, y, COAT_M, COAT_D, (y - ty) / 16)
      end)
      -- Woven traveler pack with rolled White Deed peeking top
      cv:rect(cx - 5, ty + 2, 10, 9, hex("#6b4c30"))
      cv:rect(cx - 4, ty + 1, 8, 2, hex("#8f6743"))
      cv:rect(cx + 2, ty + 3, 3, 4, DEED)
      -- Trailing amber scarf over shoulder blades
      cv:rect(cx - 6, ty - 2, 12, 4, SCARF_L)
      cv:rect(cx - 5, ty + 1, 3, 8, SCARF_D)
      -- Back of head completely covered in windswept silver-ivory hair!
      cv:ellipse(cx, hy + 1, 6, 7, function(x, y, nx, ny)
        return bayer(x, y, HAIR_L, HAIR_D, math.max(0, ny * 0.55 + 0.15))
      end)
      cv:poly({ { cx - 5, hy + 6 }, { cx - 2, hy + 8 }, { cx, hy + 6 }, { cx + 3, hy + 8 }, { cx + 6, hy + 5 } }, HAIR_D)
    elseif mode == "walk_side" then
      -- Side profile coat + scarf flapping back + prism silk thread on wrist
      cv:poly({ { cx - 5, ty }, { cx + 5, ty }, { cx + 7, ty + 15 }, { cx - 7, ty + 15 } }, function(x, y)
        return bayer(x, y, COAT_L, COAT_D, (x - (cx - 7)) / 14)
      end)
      cv:rect(cx - 6, ty + 7, 11, 2, hex("#5c4128"))
      cv:rect(cx + 2, ty + 6, 4, 4, DEED)
      cv:rect(cx + 3, ty + 8, 2, 2, hex("#a8f7ff")) -- silk bracelet
      cv:rect(cx - 5, ty - 2, 10, 4, SCARF_L)
      cv:rect(cx - 8, ty, 4, 6, SCARF_D) -- flapping tail behind
      -- Profile face facing right
      cv:ellipse(cx + 1, hy + 2, 5, 6, function(x, y, nx, ny) return nx < -0.2 and SKIN_D or SKIN_L end)
      cv:rect(cx + 3, hy + 2, 2, 2, hex("#2c2530")) -- single visible eye
      cv:ellipse(cx, hy - 3, 7, 5, function(x, y, nx, ny) return bayer(x, y, HAIR_L, HAIR_D, (ny + 0.4) * 0.5) end)
      cv:poly({ { cx - 6, hy - 2 }, { cx - 4, hy + 4 }, { cx + 1, hy - 2 }, { cx + 6, hy }, { cx + 7, hy - 4 } }, HAIR_L)
    else
      -- Front / Idle / Puddle / Pulse / Dissolve / Hooded (char_me homage in Acts 1-2!)
      local c_l = is_hood and hex("#f0ebe0") or COAT_L
      local c_m = is_hood and hex("#dad2c3") or COAT_M
      local c_d = is_hood and hex("#a89f91") or COAT_D
      cv:poly({ { cx - 7, ty }, { cx + 7, ty }, { cx + 9, ty + 15 - crouch }, { cx - 9, ty + 15 - crouch } }, function(x, y)
        local u = (x - (cx - 9)) / 18
        return bayer(x, y, u < 0.35 and c_l or c_m, c_d, u * 0.7)
      end)
      cv:rect(cx - 8, ty + 8, 2, 2, hex("#a8f7ff")) -- Prism-Weaver silk thread bracelet
      cv:rect(cx - 6, ty + 7, 12, 2, hex("#5c4128"))
      cv:rect(cx + 3, ty + 6, 4, 5, DEED)
      cv:rect(cx - 6, ty - 2, 12, 4, SCARF_L)
      cv:rect(cx - 5, ty + 1, 10, 2, SCARF_D)
      cv:rect(cx - 7, ty + 1, 3, 7 - math.floor(crouch / 2), SCARF_D)

      if is_hood then
        -- Classic char_me pointed ivory-sage cloak hood hiding the telltale white hair until CS_04!
        cv:poly({ { cx - 9, hy + 7 }, { cx - 8, hy - 3 }, { cx - 3, hy - 9 }, { cx + 4, hy - 9 }, { cx + 8, hy - 3 }, { cx + 9, hy + 7 } }, function(x, y)
          return bayer(x, y, hex("#f0ebe0"), hex("#bdb4a6"), (x - (cx - 9)) / 18)
        end)
        cv:poly({ { cx + 7, hy - 2 }, { cx + 11, hy + 2 }, { cx + 7, hy + 5 } }, hex("#b0a798")) -- pointed hood peak
        cv:ellipse(cx, hy + 2, 5, 5, hex("#1c1824")) -- deep shadowed hollow hood interior
        cv:set(cx - 2, hy + 2, hex("#ffe49e")); cv:set(cx + 2, hy + 2, hex("#ffe49e")) -- gentle living human eyes!
      else
        cv:ellipse(cx, hy + 2, 6, 6, function(x, y, nx, ny)
          return (ny > 0.45 or nx > 0.35) and SKIN_D or SKIN_L
        end)
        cv:rect(cx - 3, hy + 2, 2, 2, hex("#2c2530"))
        cv:rect(cx + 1, hy + 2, 2, 2, hex("#2c2530"))
        cv:ellipse(cx, hy - 3, 7, 5, function(x, y, nx, ny)
          return bayer(x, y, HAIR_L, HAIR_D, math.max(0, nx * 0.5 + ny * 0.4))
        end)
        cv:poly({ { cx - 7, hy - 2 }, { cx - 4, hy + 1 }, { cx - 2, hy - 3 }, { cx + 2, hy - 2 }, { cx + 5, hy + 1 }, { cx + 7, hy - 3 } }, HAIR_L)
      end
    end

    -- Dissolve Fading effect (`float_body_cohesion` low in Act 1 intro / Act 3 solo!)
    if mode == "dissolve" then
      for y = 0, H - 1 do
        for x = cx + 3, W - 1 do
          if cv:get(x, y) and ((x * 7 + y * 13 + fi * 5) % 5 == 0) then
            cv:set(x, y, false)
          end
        end
      end
    end

    cv:outline(INK, 120, hex("#3a3548"))

    local fx = A.canvas(W, H)
    if mode == "dissolve" then
      -- Floating 1x1 pixel stardust peeling off coat edge & rising upward
      for i = 0, 11 do
        local px = cx + 4 + ((i * 3 + fi) % 9)
        local py = 12 + ((34 - i * 3 - fi * 2) % 24)
        fx:set(px, py, (i % 2 == 0) and HEART_C or HEART_A)
      end
    elseif mode ~= "walk_up" then
      local pulse_a = (mode == "pulse") and (160 + fi * 24) or ((fi % 2 == 0) and 140 or 90)
      local r_glow = (mode == "pulse") and (4 + fi) or 5
      fx:add_glow(cx, ty + 5, r_glow, (fi % 2 == 1) and HEART_C or HEART_A, math.min(240, pulse_a))
      fx:set(cx, ty + 5, HEART_A)
      fx:set(cx + 1, ty + 4, HEART_C)
    end
    return { shadow = sh, body = cv, fx = fx }
  end

  local frames = {}
  local specs = {
    { "hooded", 4, 220 }, { "hooded_walk", 6, 120 },
    { "idle", 4, 210 }, { "walk", 6, 120 }, { "walk_up", 6, 120 },
    { "walk_side", 6, 120 }, { "puddle", 4, 240 }, { "pulse", 4, 150 }, { "dissolve", 6, 140 }
  }
  local tags, idx = {}, 1
  for _, spec in ipairs(specs) do
    local s_idx = idx
    for i = 1, spec[2] do
      frames[idx] = { duration = spec[3], cels = draw_frame(spec[1], i) }
      idx = idx + 1
    end
    table.insert(tags, { name = spec[1], from = s_idx, to = idx - 1 })
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = tags }, OUT_DIR .. "char_protag.aseprite")
end

-- ============================================================================
-- 2. COMP_LINH — "Cô Thợ Máy Thính Âm" + chú cáo Mốc (40x48, anchor 20,42)
-- Tags: idle, listen, wrench, walk_up, walk_side
-- ============================================================================
local function build_linh()
  local W, H = 40, 48
  local INK = hex("#1b151e")
  local HAIR_L, HAIR_D = hex("#613f36"), hex("#36201c")
  local SKIN_L, SKIN_D = hex("#f7dbc4"), hex("#d1a688")
  local VEST_H, VEST_L, VEST_D = hex("#db8758"), hex("#bf6e43"), hex("#854225")
  local SHIRT = hex("#efe5cf")
  local BRASS = hex("#f5ce62")
  local FOX_H, FOX_L, FOX_M, FOX_D = hex("#fcf9ff"), hex("#eae3fa"), hex("#c7b8eb"), hex("#9383b8")
  local FOX_PINK = hex("#f29cb8")

  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H)
    sh:ellipse(20, 43, 8, 3, hex("#0a0910", 120))
    local cv = A.canvas(W, H)
    local bob = (fi == 2 or fi == 3) and 1 or 0
    local walk_off = (mode == "walk_up" or mode == "walk_side") and ({ -2, 0, 2, 0 })[fi] or 0
    local cx, hy = 20, 14 + bob
    local ty = 22 + bob
    local wag = (fi % 2 == 0) and 1 or 0

    cv:rect(cx - 5 + (mode == "walk_side" and walk_off or 0), 34, 4, 8, hex("#3c4857"))
    cv:rect(cx + 1 - (mode == "walk_side" and walk_off or 0), 34, 4, 8, hex("#2d3745"))
    cv:rect(cx - 5 + (mode == "walk_side" and walk_off or 0), 40, 4, 2, hex("#4a2d1f"))
    cv:rect(cx + 1 - (mode == "walk_side" and walk_off or 0), 40, 4, 2, hex("#382117"))

    local function draw_moc(mx, my, back_view)
      -- Fluffy curved tail wrapping shoulder with golden bell tip
      cv:bezier_stroke({ mx - 2, my + 2 }, { mx - 7, my + 3 }, { mx - 6, my + 6 + wag }, FOX_M, 2, 10)
      cv:disc(mx - 6, my + 6 + wag, 1, BRASS)
      cv:set(mx - 6, my + 5 + wag, hex("#fff4b8"))
      -- Sculpted compact fox body + chest tuft + rounded head
      cv:ellipse(mx, my + 2, 4, 3, FOX_M)
      cv:ellipse(mx + 1, my + 1, 3, 2, FOX_L)
      cv:ellipse(mx, my - 2, 4, 3, function(x, y, nx, ny)
        return (ny < -0.25 and nx < 0.2) and FOX_H or ((nx > 0.35) and FOX_M or FOX_L)
      end)
      -- Clear 4-eared silhouette (inner tall pair + outer flared pair + rose tips)
      cv:line(mx - 2, my - 4, mx - 3, my - 8, FOX_L); cv:set(mx - 3, my - 8, FOX_PINK)
      cv:line(mx + 1, my - 4, mx + 2, my - 8, FOX_H); cv:set(mx + 2, my - 8, FOX_PINK)
      cv:line(mx - 4, my - 2, mx - 6, my - 5, FOX_D); cv:set(mx - 6, my - 5, FOX_PINK)
      cv:line(mx + 3, my - 2, mx + 5, my - 5, FOX_M); cv:set(mx + 5, my - 5, FOX_PINK)
      if not back_view then
        cv:set(mx - 1, my - 2, hex("#2b1e24")); cv:set(mx + 2, my - 2, hex("#2b1e24"))
        cv:set(mx + 1, my - 1, hex("#2b1e24")) -- snout
      end
    end

    if mode == "walk_up" then
      cv:poly({ { cx - 7, ty }, { cx + 7, ty }, { cx + 8, ty + 12 }, { cx - 8, ty + 12 } }, function(x, y, nx, ny)
        if x < cx - 3 or y < ty + 2 then return VEST_H end
        return (x > cx + 3 or y > ty + 9) and VEST_D or VEST_L
      end)
      cv:rect(cx - 8, ty + 6, 4, 6, hex("#4287b8")) -- blue ledger at waist
      cv:bezier_stroke({ cx - 4, ty }, { cx, ty + 4 }, { cx + 4, ty }, BRASS, 1, 10)
      -- Full back of hair + bun + goggles strap
      cv:ellipse(cx, hy, 6, 6, HAIR_L)
      cv:disc(cx + 3, hy - 6, 3, HAIR_D)
      cv:rect(cx - 6, hy - 2, 12, 2, hex("#472b24"))
      draw_moc(cx - 8, ty - 2, true)
    elseif mode == "walk_side" then
      cv:poly({ { cx - 5, ty }, { cx + 5, ty }, { cx + 5, ty + 12 }, { cx - 5, ty + 12 } }, function(x)
        return (x < cx - 1) and VEST_H or ((x > cx + 2) and VEST_D or VEST_L)
      end)
      cv:rect(cx - 6, ty + 5, 4, 6, hex("#4287b8"))
      cv:ellipse(cx + 1, hy + 2, 5, 5, SKIN_L)
      cv:set(cx + 3, hy + 2, hex("#2b1e24"))
      cv:ellipse(cx, hy - 2, 6, 5, HAIR_L)
      cv:disc(cx - 4, hy - 5, 3, HAIR_D)
      cv:rect(cx + 1, hy - 4, 4, 3, hex("#7ce8ff"))
      cv:set(cx + 2, hy - 4, hex("#ffffff"))
      draw_moc(cx - 6, ty - 2, false)
    else
      cv:rect(cx - 6, ty, 12, 13, SHIRT)
      cv:poly({ { cx - 7, ty }, { cx - 1, ty }, { cx - 1, ty + 12 }, { cx - 8, ty + 12 } }, function(x, y)
        return (x < cx - 4 or y < ty + 2) and VEST_H or VEST_L
      end)
      cv:poly({ { cx + 1, ty }, { cx + 7, ty }, { cx + 8, ty + 12 }, { cx + 1, ty + 12 } }, function(x)
        return (x > cx + 4) and VEST_D or VEST_L
      end)
      cv:rect(cx - 8, ty + 6, 4, 6, hex("#4287b8"))
      cv:set(cx - 7, ty + 7, hex("#a8dcff"))
      cv:bezier_stroke({ cx - 4, ty }, { cx, ty + 6 }, { cx + 4, ty }, BRASS, 1, 10)
      if mode == "listen" then
        cv:line(cx + 4, ty + 3, cx + 10, ty + 2, BRASS)
        cv:disc(cx + 11, ty + 2, 2, hex("#fff0b5"))
      elseif mode == "wrench" then
        local w_off = (fi % 2 == 0) and -1 or 0
        cv:line(cx + 6, ty + 6, cx + 12, ty - 2 + w_off, hex("#ccd8e8"), 2)
        cv:rect(cx + 10, ty - 5 + w_off, 5, 4, BRASS)
      end

      cv:ellipse(cx, hy + 2, 5, 5, function(x, y, nx) return nx > 0.35 and SKIN_D or SKIN_L end)
      cv:set(cx - 2, hy + 2, hex("#2b1e24"))
      cv:set(cx + 2, hy + 2, hex("#2b1e24"))
      cv:ellipse(cx, hy - 3, 6, 4, HAIR_L)
      cv:disc(cx + 3, hy - 6, 3, HAIR_D)
      cv:rect(cx - 5, hy - 4, 4, 3, hex("#7ce8ff"))
      cv:rect(cx + 1, hy - 4, 4, 3, hex("#7ce8ff"))
      cv:set(cx - 4, hy - 4, hex("#ffffff")); cv:set(cx + 2, hy - 4, hex("#ffffff"))
      cv:rect(cx - 1, hy - 3, 2, 1, BRASS)

      -- Draw Mốc last so his 4 ears & crisp silhouette sit proudly on Linh's left shoulder
      draw_moc(cx - 9, ty - 2, false)
    end

    cv:outline(INK, 120, hex("#45312c"))
    local fx = A.canvas(W, H)
    if mode == "wrench" then fx:add_glow(cx + 12, ty - 3, 6, hex("#7ce8ff"), 140) end
    return { shadow = sh, body = cv, fx = fx }
  end

  local frames, tags, idx = {}, {}, 1
  for _, spec in ipairs({ { "idle", 4, 210 }, { "listen", 4, 220 }, { "wrench", 4, 170 }, { "walk_up", 4, 160 }, { "walk_side", 4, 160 } }) do
    local s_idx = idx
    for i = 1, spec[2] do frames[idx] = { duration = spec[3], cels = draw_frame(spec[1], i) }; idx = idx + 1 end
    table.insert(tags, { name = spec[1], from = s_idx, to = idx - 1 })
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = tags }, OUT_DIR .. "comp_linh.aseprite")
end

-- ============================================================================
-- 3. COMP_KAEL — "Hiệp Sĩ Gốm Hàn Vàng" (48x56, anchor 24,50)
-- Tags: idle, soup, guard, walk_up, walk_side
-- ============================================================================
local function build_kael()
  local W, H = 48, 56
  local INK = hex("#1b1922")
  local CER_H, CER_L, CER_M, CER_D = hex("#faf6ee"), hex("#e8e2d5"), hex("#bfb7ab"), hex("#857f78")
  local GOLD_H, GOLD = hex("#fff0a8"), hex("#f5c249")
  local POT_L, POT_M, POT_D = hex("#d97c4e"), hex("#b55c36"), hex("#78371f")
  local UNDER = hex("#36303b")

  local function shade_cer(x, y, nx, ny)
    local l = (-nx * 0.45 - ny * 0.5) * 0.5 + 0.5
    if l > 0.7 then return CER_H
    elseif l > 0.45 then return CER_L
    elseif l > 0.25 then return CER_M
    else return CER_D end
  end

  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H)
    sh:ellipse(24, 51, 13, 4, hex("#0a0910", 140))
    local cv = A.canvas(W, H)
    local bob = (fi == 2 or fi == 3) and 1 or 0
    local walk_off = (mode == "walk_up" or mode == "walk_side") and ({ -2, 0, 2, 0 })[fi] or 0
    local cx, cy = 24, 16 + bob

    -- Sculpted greaves & boots with subtle Kintsugi seam
    cv:rect(cx - 7 + (mode == "walk_side" and walk_off or 0), 39, 6, 11, CER_M)
    cv:rect(cx - 7 + (mode == "walk_side" and walk_off or 0), 39, 2, 10, CER_L)
    cv:rect(cx + 1 - (mode == "walk_side" and walk_off or 0), 39, 6, 11, CER_D)
    cv:line(cx - 6, 42, cx - 2, 46, GOLD)
    cv:set(cx - 4, 44, GOLD_H)

    if mode == "walk_up" then
      -- Iconic back view: sculpted porcelain backplate with bold branching Kintsugi gold seams + copper cauldron!
      cv:poly({ { cx - 12, cy + 7 }, { cx + 12, cy + 7 }, { cx + 11, cy + 25 }, { cx - 11, cy + 25 } }, function(x, y)
        return shade_cer(x, y, (x - cx) / 12, (y - (cy + 15)) / 10)
      end)
      -- Prominent branching Kintsugi gold veins visible around cauldron rim!
      cv:line(cx - 10, cy + 9, cx - 5, cy + 16, GOLD)
      cv:line(cx - 5, cy + 16, cx - 9, cy + 24, GOLD)
      cv:line(cx + 10, cy + 10, cx + 6, cy + 18, GOLD)
      cv:line(cx + 6, cy + 18, cx + 9, cy + 24, GOLD)
      cv:set(cx - 5, cy + 16, GOLD_H); cv:set(cx + 6, cy + 18, GOLD_H)
      -- Detailed copper stew cauldron strapped to back
      cv:ellipse(cx, cy + 16, 8, 9, function(x, y, nx, ny)
        return nx < -0.25 and POT_L or (nx > 0.35 and POT_D or POT_M)
      end)
      cv:rect(cx - 7, cy + 9, 14, 2, GOLD); cv:rect(cx - 5, cy + 9, 5, 1, GOLD_H)
      cv:ellipse(cx - 12, cy + 11, 5, 5, function(x, y, nx, ny) return shade_cer(x, y, nx, ny) end)
      cv:ellipse(cx + 12, cy + 11, 5, 5, function(x, y, nx, ny) return shade_cer(x, y, nx + 0.3, ny) end)
      cv:line(cx - 10, cy + 9, cx - 13, cy + 14, GOLD)
      cv:line(cx + 10, cy + 9, cx + 12, cy + 14, GOLD)
      cv:ellipse(cx, cy + 1, 7, 7, function(x, y, nx, ny) return shade_cer(x, y, nx, ny) end)
      cv:line(cx - 4, cy - 3, cx + 4, cy + 3, GOLD); cv:set(cx, cy, GOLD_H)
    else
      if mode ~= "walk_side" then
        cv:ellipse(cx - 6, cy + 12, 8, 9, function(x, y, nx) return nx < -0.1 and POT_L or POT_D end)
        cv:rect(cx - 12, cy + 5, 12, 2, GOLD)
      else
        cv:ellipse(cx - 7, cy + 14, 7, 8, function(x, y, nx) return nx < 0 and POT_M or POT_D end)
        cv:rect(cx - 13, cy + 7, 11, 2, GOLD)
      end

      -- Sculpted curved porcelain cuirass
      local w_half = (mode == "walk_side") and 9 or 12
      cv:poly({ { cx - w_half, cy + 7 }, { cx + w_half, cy + 7 }, { cx + w_half - 2, cy + 25 }, { cx - w_half + 2, cy + 25 } }, function(x, y)
        return shade_cer(x, y, (x - cx) / w_half, (y - (cy + 14)) / 10)
      end)
      if mode ~= "walk_side" then
        cv:ellipse(cx - 12, cy + 11, 5, 5, function(x, y, nx, ny) return shade_cer(x, y, nx, ny) end)
        cv:ellipse(cx + 12, cy + 11, 5, 5, function(x, y, nx, ny) return shade_cer(x, y, nx + 0.25, ny) end)
        cv:line(cx - 14, cy + 9, cx - 10, cy + 13, GOLD)
      else
        cv:ellipse(cx, cy + 11, 5, 5, function(x, y, nx, ny) return shade_cer(x, y, nx, ny) end)
        cv:line(cx - 2, cy + 9, cx + 2, cy + 13, GOLD)
      end
      -- Rich branching Kintsugi golden seams with luminous crest
      cv:line(cx - 6, cy + 9, cx - 1, cy + 16, GOLD)
      cv:line(cx - 1, cy + 16, cx + 6, cy + 12, GOLD)
      cv:line(cx - 1, cy + 16, cx + 2, cy + 24, GOLD)
      cv:set(cx - 1, cy + 16, GOLD_H); cv:set(cx + 4, cy + 13, GOLD_H)

      -- Domed knight helm + warm amber optics
      cv:ellipse(cx + (mode == "walk_side" and 1 or 0), cy + 1, 7, 7, function(x, y, nx, ny) return shade_cer(x, y, nx, ny) end)
      cv:rect(cx - (mode == "walk_side" and 1 or 4), cy + 1, mode == "walk_side" and 7 or 8, 3, UNDER)
      cv:set(cx + (mode == "walk_side" and 4 or 2), cy + 2, hex("#ffd88a"))
      if mode ~= "walk_side" then cv:set(cx - 2, cy + 2, hex("#ffd88a")) end
      cv:line(cx - 3, cy - 4, cx + 2, cy - 1, GOLD); cv:set(cx - 1, cy - 3, GOLD_H)

      if mode == "guard" then
        cv:poly({ { cx + 5, cy + 8 }, { cx + 19, cy + 8 }, { cx + 18, cy + 25 }, { cx + 12, cy + 31 }, { cx + 6, cy + 25 } }, function(x, y)
          return shade_cer(x, y, (x - (cx + 12)) / 7, (y - (cy + 18)) / 12)
        end)
        cv:line(cx + 7, cy + 12, cx + 15, cy + 22, GOLD)
        cv:line(cx + 15, cy + 13, cx + 10, cy + 24, GOLD)
        cv:set(cx + 12, cy + 18, GOLD_H)
      elseif mode == "soup" then
        cv:ellipse(cx + 10, cy + 19, 6, 4, CER_L)
        cv:rect(cx + 6, cy + 17, 8, 2, hex("#ffd166"))
        cv:set(cx + 15, cy + 16, hex("#3a3442"))
      end
    end

    cv:outline(INK, 120, hex("#5c564f"))
    local fx = A.canvas(W, H)
    if mode == "soup" then
      local sy = cy + 12 - (fi % 3) * 2
      fx:set(cx + 9, sy, hex("#fff5d6", 190)); fx:set(cx + 11, sy - 2, hex("#fff5d6", 140))
    end
    fx:add_glow(cx, cy + 15, 8, GOLD, 65)
    return { shadow = sh, body = cv, fx = fx }
  end

  local frames, tags, idx = {}, {}, 1
  for _, spec in ipairs({ { "idle", 4, 240 }, { "soup", 4, 210 }, { "guard", 4, 210 }, { "walk_up", 4, 180 }, { "walk_side", 4, 180 } }) do
    local s_idx = idx
    for i = 1, spec[2] do frames[idx] = { duration = spec[3], cels = draw_frame(spec[1], i) }; idx = idx + 1 end
    table.insert(tags, { name = spec[1], from = s_idx, to = idx - 1 })
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = tags }, OUT_DIR .. "comp_kael.aseprite")
end

-- ============================================================================
-- 4. COMP_MIRA — "Tiểu Thư Buôn Gió" (38x48, anchor 19,42)
-- Tags: idle, abacus, step, walk_up, walk_side
-- ============================================================================
local function build_mira()
  local W, H = 38, 48
  local INK = hex("#151424")
  local CLOAK_H, CLOAK_L, CLOAK_D = hex("#5771b5"), hex("#3f548c"), hex("#212a4f")
  local BERET_L, BERET_M, BERET_D = hex("#45518a"), hex("#262b4d"), hex("#181b36")
  local TRIM = hex("#f2c85b")
  local SKIN_L, SKIN_D = hex("#fae2cf"), hex("#d4ad92")
  local HAIR_L, HAIR_D = hex("#323961"), hex("#1d1e33")
  local CYS = hex("#8df5ff")

  local function shade_cloak(x, y, cx, ty, sway)
    if x < cx - 5 or (y <= ty + 3 and x < cx) then return CLOAK_H end
    if math.abs(x - (cx - 4)) <= 0 or math.abs(x - (cx + 4)) <= 0 and y > ty + 5 then return CLOAK_D end
    if x > cx + 4 + sway * 0.4 then return CLOAK_D end
    return CLOAK_L
  end

  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H)
    sh:ellipse(19, 43, 8, 3, hex("#0a0910", 120))
    local cv = A.canvas(W, H)
    local bob = (fi == 2 or fi == 3) and 1 or 0
    local cx, hy = 19, 13 + bob
    local ty = 21 + bob
    local sway = (mode == "step" or mode == "walk_side" or mode == "walk_up") and ((fi % 2 == 0) and 2 or -1) or 0

    if mode == "walk_up" then
      cv:poly({ { cx - 6, ty }, { cx + 6, ty }, { cx + 9, 40 }, { cx - 9, 40 } }, function(x, y)
        return shade_cloak(x, y, cx, ty, 0)
      end)
      cv:rect(cx - 8, 38, 16, 2, TRIM)
      -- Sleek back bob + sculpted navy beret
      cv:ellipse(cx, hy + 1, 6, 6, HAIR_D)
      cv:rect(cx - 5, hy + 4, 10, 5, HAIR_L)
      cv:poly({ { cx - 8, hy - 3 }, { cx - 4, hy - 7 }, { cx + 5, hy - 7 }, { cx + 7, hy - 3 }, { cx + 5, hy - 1 }, { cx - 6, hy - 1 } }, function(x, y)
        return y < hy - 4 and BERET_L or BERET_M
      end)
      cv:rect(cx - 6, hy - 1, 11, 1, BERET_D)
      cv:rect(cx - 4, hy - 4, 2, 1, TRIM)
    elseif mode == "walk_side" then
      cv:poly({ { cx - 5, ty }, { cx + 5, ty }, { cx + 8 + sway, 40 }, { cx - 8, 40 } }, function(x, y)
        return shade_cloak(x, y, cx, ty, sway)
      end)
      cv:rect(cx - 7, 38, 15 + math.max(0, sway), 2, TRIM)
      cv:ellipse(cx + 1, hy + 2, 5, 5, SKIN_L)
      cv:set(cx + 3, hy + 2, hex("#231f33"))
      cv:ellipse(cx, hy - 1, 6, 4, HAIR_L)
      cv:rect(cx - 5, hy - 1, 5, 8, HAIR_D)
      -- Tilted beret & brass pin
      cv:poly({ { cx - 7, hy - 3 }, { cx - 3, hy - 7 }, { cx + 6, hy - 6 }, { cx + 6, hy - 3 }, { cx - 5, hy - 2 } }, function(x, y)
        return y <= hy - 5 and BERET_L or BERET_M
      end)
      cv:rect(cx + 2, hy - 4, 2, 1, TRIM)
      cv:rect(cx + 5, ty + 5, 7, 8, TRIM)
      cv:rect(cx + 6, ty + 6, 5, 6, hex("#161d36"))
      cv:rect(cx + 7, ty + 8, 2, 1, CYS); cv:set(cx + 7, ty + 8, hex("#ffffff"))
    else
      cv:poly({ { cx - 6, ty }, { cx + 6, ty }, { cx + 9 + sway, 40 }, { cx - 9, 40 } }, function(x, y)
        return shade_cloak(x, y, cx, ty, sway)
      end)
      cv:rect(cx - 8, 38, 16 + math.max(0, sway), 2, TRIM)
      cv:rect(cx - 1, ty, 2, 16, TRIM)
      cv:set(cx, ty + 3, CYS) -- crisp collar brooch gem
      cv:ellipse(cx, hy + 2, 5, 5, function(x, y, nx) return nx > 0.35 and SKIN_D or SKIN_L end)
      cv:set(cx - 2, hy + 2, hex("#231f33")); cv:set(cx + 2, hy + 2, hex("#231f33"))
      -- Asymmetric sleek indigo bob
      cv:ellipse(cx, hy - 2, 6, 4, HAIR_D)
      cv:rect(cx + 3, hy - 3, 3, 8, HAIR_L); cv:rect(cx - 6, hy - 2, 2, 6, HAIR_D)
      -- Sculpted tilted navy beret with rim highlight & double gold pins
      cv:poly({ { cx - 8, hy - 3 }, { cx - 5, hy - 7 }, { cx + 4, hy - 7 }, { cx + 7, hy - 4 }, { cx + 5, hy - 2 }, { cx - 6, hy - 1 } }, function(x, y)
        if y <= hy - 6 or x <= cx - 5 then return BERET_L end
        return y >= hy - 2 and BERET_D or BERET_M
      end)
      cv:rect(cx - 5, hy - 1, 10, 1, BERET_D)
      cv:rect(cx + 2, hy - 4, 2, 1, TRIM); cv:set(cx + 3, hy - 3, TRIM)

      local ax, ay = cx + 7, ty + 5
      cv:rect(ax, ay, 8, 9, TRIM)
      cv:rect(ax + 1, ay + 1, 6, 7, hex("#161d36"))
      local bead_x = (mode == "abacus") and (ax + 1 + (fi % 4)) or (ax + 2)
      cv:rect(bead_x, ay + 2, 2, 1, CYS); cv:set(bead_x, ay + 2, hex("#ffffff"))
      cv:rect(ax + 5 - (fi % 2), ay + 4, 2, 1, CYS)
      cv:rect(ax + 2, ay + 6, 2, 1, CYS)
    end

    cv:outline(INK, 120, hex("#4c568a"))
    local fx = A.canvas(W, H)
    if mode == "abacus" then fx:add_glow(cx + 11, ty + 9, 6, CYS, 130) end
    return { shadow = sh, body = cv, fx = fx }
  end

  local frames, tags, idx = {}, {}, 1
  for _, spec in ipairs({ { "idle", 4, 220 }, { "abacus", 4, 170 }, { "step", 4, 180 }, { "walk_up", 4, 180 }, { "walk_side", 4, 180 } }) do
    local s_idx = idx
    for i = 1, spec[2] do frames[idx] = { duration = spec[3], cels = draw_frame(spec[1], i) }; idx = idx + 1 end
    table.insert(tags, { name = spec[1], from = s_idx, to = idx - 1 })
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = tags }, OUT_DIR .. "comp_mira.aseprite")
end

-- ============================================================================
-- 5. BOSS_VAELEN — "Đại Kiến Trúc Sư Vaelen" (52x62, anchor 26,56)
-- Tags: cabled (wired on Spire throne per v4.3!), idle, cast, old
-- ============================================================================
local function build_vaelen()
  local W, H = 52, 62
  local INK = hex("#171522")
  local ROBE_L, ROBE_M, ROBE_D = hex("#ebe8f2"), hex("#b5b0c7"), hex("#6f6a82")
  local HAIR_L, HAIR_D = hex("#eef2fa"), hex("#9ba6bd")
  local SKIN_L, SKIN_D = hex("#dbd7e3"), hex("#a49eb3")
  local GOLD_COLD = hex("#d9c27e")
  local MEMORIA = hex("#9be3ff")

  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H)
    sh:ellipse(26, 57, 13, 4, hex("#080710", 130))
    local cv = A.canvas(W, H)
    local is_old = (mode == "old")
    local is_cabled = (mode == "cabled")
    local bob = is_old and ((fi % 2 == 0) and 1 or 0) or (is_cabled and 0 or ((fi == 2 or fi == 3) and -1 or 0))
    local cx, hy = 26 + (is_old and 1 or 0), (is_old and 24 or (is_cabled and 20 or 17)) + bob
    local ty = hy + 8

    -- Overhead conduit cables siphoning Memoria straight from hollow chest up toward the Sun (v4.3!)
    if is_cabled then
      for _, dx in ipairs({ -16, -9, -3, 3, 9, 16 }) do
        cv:bezier_stroke({ cx + math.floor(dx * 0.28), ty + 7 }, { cx + dx, ty - 6 }, { cx + math.floor(dx * 1.15), 2 }, hex("#383d54"), 2, 14)
        cv:set(cx + math.floor(dx * 0.7), 6 + ((fi + math.abs(dx)) % 6), MEMORIA)
      end
      -- Obsidian throne base behind knees
      cv:rect(cx - 12, ty + 14, 24, 16, hex("#231f33"))
      cv:rect(cx - 14, ty + 12, 28, 3, hex("#3c3554"))
    end

    -- Grand architectural mantle
    cv:poly({ { cx - 8, ty }, { cx + 8, ty }, { cx + 11, 56 }, { cx - 11, 56 } }, function(x, y)
      local c1 = is_old and hex("#8e857a") or ROBE_L
      local c2 = is_old and hex("#544d47") or ROBE_D
      return bayer(x, y, c1, c2, (x - (cx - 11)) / 22)
    end)
    if not is_old then
      cv:rect(cx - 11, ty, 22, 3, ROBE_M)
      cv:rect(cx - 2, ty + 3, 4, 24, GOLD_COLD)
      -- Stark horizontal chest scar + glowing hollow cavity
      cv:line(cx - 6, ty + 8, cx + 6, ty + 8, hex("#8f3f52"), 2)
      cv:disc(cx, ty + 8, 2, MEMORIA)
    end

    -- Exact genetic mirror of Protag's face shape and hair bangs!
    cv:ellipse(cx, hy + 2, 6, 6, function(x, y, nx, ny)
      if is_old then return nx > 0.35 and hex("#b8957c") or hex("#e3c1a8") end
      return (ny > 0.45 or nx > 0.35) and SKIN_D or SKIN_L
    end)
    if is_old then
      cv:rect(cx - 3, hy + 2, 2, 1, hex("#453d38"))
      cv:rect(cx + 1, hy + 2, 2, 1, hex("#453d38"))
    else
      cv:rect(cx - 3, hy + 2, 2, 2, hex("#ffffff"))
      cv:rect(cx + 1, hy + 2, 2, 2, hex("#ffffff"))
    end
    cv:ellipse(cx, hy - 3, 7, 5, function(x, y, nx, ny)
      return bayer(x, y, HAIR_L, HAIR_D, math.max(0, nx * 0.5 + ny * 0.4))
    end)

    cv:outline(INK, 120, hex("#524d66"))

    local fx = A.canvas(W, H)
    if is_cabled then
      fx:add_glow(cx, ty + 8, 10 + (fi % 2) * 2, MEMORIA, 150)
    elseif not is_old then
      for m = 0, 2 do
        local ang = (fi / 4) * math.pi * 2 + m * 2.1
        local ox = math.floor(cx + math.cos(ang) * (mode == "cast" and 18 or 14))
        local oy = math.floor(ty + 6 + math.sin(ang) * 5)
        fx:disc(ox, oy, 2, MEMORIA); fx:set(ox, oy, hex("#ffffff"))
      end
      fx:add_glow(cx, ty + 8, mode == "cast" and 11 or 6, MEMORIA, 110)
    end
    return { shadow = sh, body = cv, fx = fx }
  end

  local frames, tags, idx = {}, {}, 1
  for _, spec in ipairs({ { "cabled", 4, 220 }, { "idle", 4, 220 }, { "cast", 4, 150 }, { "old", 4, 280 } }) do
    local s_idx = idx
    for i = 1, spec[2] do frames[idx] = { duration = spec[3], cels = draw_frame(spec[1], i) }; idx = idx + 1 end
    table.insert(tags, { name = spec[1], from = s_idx, to = idx - 1 })
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = tags }, OUT_DIR .. "boss_vaelen.aseprite")
end

-- ============================================================================
-- 6. NPC_VEX — Broker Chợ Đen (38x46, anchor 19,40)
-- ============================================================================
local function build_vex()
  local W, H = 38, 46
  local INK = hex("#15111c")
  local COAT_H, COAT_M, COAT_D = hex("#644a7a"), hex("#4c385e"), hex("#322342")
  local COLLAR_H, COLLAR_M = hex("#ad82d4"), hex("#7c579e")
  local GOLD_H, GOLD_M = hex("#fff0a8"), hex("#e3b74d")
  local frames = {}
  for fi = 1, 4 do
    local sh = A.canvas(W, H); sh:ellipse(19, 41, 8, 3, hex("#0a0910", 120))
    local cv = A.canvas(W, H); local bob = (fi == 2 or fi == 3) and 1 or 0
    local cx, ty = 19, 20 + bob
    -- Tailored dark-violet coat with sculpted vertical drape folds
    cv:poly({ { cx - 6, ty }, { cx + 6, ty }, { cx + 8, 40 }, { cx - 8, 40 } }, function(x)
      if x <= cx - 4 then return COAT_H end
      if math.abs(x - cx) == 3 then return COAT_D end
      return x >= cx + 4 and COAT_D or COAT_M
    end)
    -- Crisp upturned purple collar trim & golden lapel pin
    cv:poly({ { cx - 8, ty - 3 }, { cx - 3, ty + 2 }, { cx + 3, ty + 2 }, { cx + 8, ty - 3 }, { cx + 7, ty + 4 }, { cx - 7, ty + 4 } }, function(x, y)
      return (y <= ty - 2 or x <= cx - 6) and COLLAR_H or COLLAR_M
    end)
    cv:line(cx - 7, ty - 3, cx - 3, ty + 1, hex("#dfc2fa"))
    cv:line(cx + 3, ty + 1, cx + 7, ty - 3, hex("#dfc2fa"))
    cv:set(cx - 4, ty + 2, GOLD_M); cv:set(cx - 4, ty + 1, GOLD_H)
    -- Head, sharp sly eye & smirk, dark top hat with gleaming hatband
    cv:ellipse(cx, 13 + bob, 5, 5, function(x, y, nx) return nx > 0.35 and hex("#b5a3aa") or hex("#d8c8cc") end)
    cv:rect(cx - 3, 13 + bob, 2, 1, hex("#2b1e38")) -- cunning shadowed left eye
    cv:line(cx - 1, 16 + bob, cx + 3, 15 + bob, hex("#402838")) -- crooked smirk
    cv:poly({ { cx - 8, 10 + bob }, { cx + 8, 10 + bob }, { cx + 5, 6 + bob }, { cx - 5, 6 + bob } }, hex("#2b2338"))
    cv:rect(cx - 4, 7 + bob, 3, 2, hex("#413554"))
    cv:rect(cx - 5, 9 + bob, 10, 1, GOLD_M); cv:set(cx - 4, 9 + bob, GOLD_H)
    -- Sparkling brass monocle & chain
    cv:line(cx + 3, 16 + bob, cx + 2, ty + 2, GOLD_M) -- monocle chain
    cv:disc(cx + 2, 13 + bob, 3, GOLD_M); cv:set(cx, 11 + bob, GOLD_H)
    cv:disc(cx + 2, 13 + bob, 2, hex("#7ce8ff"))
    local glint = (fi == 2 or fi == 4)
    cv:set(cx + 1, 12 + bob, hex("#ffffff"))
    if glint then cv:set(cx + 2, 13 + bob, hex("#ffffff")); cv:set(cx + 3, 11 + bob, GOLD_H) end
    -- Contoured market satchel / vial tray
    cv:rect(cx - 12, ty + 9, 8, 4, hex("#7a5c32")); cv:rect(cx - 12, ty + 9, 8, 1, hex("#a8824b"))
    cv:rect(cx - 10, ty + 7, 2, 2, hex("#9be3ff")); cv:rect(cx - 7, ty + 7, 2, 2, hex("#ffd66b"))
    cv:outline(INK, 120, hex("#59446e"))
    local fx = A.canvas(W, H)
    fx:add_glow(cx + 2, 13 + bob, glint and 5 or 4, hex("#96ebff"), glint and 130 or 65)
    frames[fi] = { duration = 240, cels = { shadow = sh, body = cv, fx = fx } }
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = { { name = "idle", from = 1, to = 4 } } }, OUT_DIR .. "npc_vex.aseprite")
end

-- ============================================================================
-- 7..9. CREATURES — ECHOFOX, RUSTCRAB, PRISMWEAVER
-- ============================================================================
local function build_echofox()
  local W, H = 42, 36
  local INK = hex("#181326")
  local RIM = hex("#fcf9ff")
  local FUR_L, FUR_M, FUR_D = hex("#eee8fc"), hex("#c7b8eb"), hex("#8772bd")
  local EAR_TIP, GOLD = hex("#f29cb8"), hex("#ffd46b")
  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H); sh:ellipse(21, 32, 11, 3, hex("#0a0910", 110))
    local cv = A.canvas(W, H); local bob = (fi == 2 or fi == 3) and 1 or 0
    local cx, cy = 20, 22 + bob
    local tw = (fi % 2 == 0) and -2 or 2
    cv:bezier_stroke({ cx - 6, cy + 2 }, { cx - 14, cy - 5 + tw }, { cx - 11, cy - 11 + tw }, FUR_M, 4, 14)
    cv:disc(cx - 11, cy - 11 + tw, 2, FUR_L); cv:rect(cx - 12, cy - 7 + tw, 3, 4, GOLD)
    -- Top-left tail rim highlight
    cv:line(cx - 14, cy - 6 + tw, cx - 12, cy - 11 + tw, RIM)
    cv:set(cx - 12, cy - 12 + tw, RIM)
    -- Sculpted body with crisp top-left fur rim
    cv:ellipse(cx, cy + 2, 8, 5, function(x, y, nx, ny)
      if ny < -0.58 and nx < 0.35 then return RIM end
      return ny > 0.2 and FUR_M or FUR_L
    end)
    cv:rect(cx - 4, cy + 6, 2, 5 - bob, FUR_D); cv:rect(cx + 4, cy + 6, 2, 5 - bob, FUR_L)
    local hx, hy = cx + 7, cy - 4
    cv:ellipse(hx, hy, 5, 4, function(x, y, nx, ny) return (ny < -0.55 and nx < 0.2) and RIM or FUR_L end)
    cv:rect(hx + 3, hy, 4, 2, FUR_L); cv:set(hx + 4, hy, RIM)
    cv:set(hx + 6, hy, hex("#2c2340")); cv:set(hx + 2, hy - 1, hex("#403166"))
    cv:poly({ { hx - 3, hy - 3 }, { hx - 1, hy - 10 }, { hx + 1, hy - 3 } }, FUR_M)
    cv:poly({ { hx + 1, hy - 3 }, { hx + 3, hy - 10 }, { hx + 5, hy - 3 } }, FUR_L)
    cv:line(hx - 3, hy - 4, hx - 1, hy - 9, RIM) -- front-top ear rim highlight
    cv:line(hx + 1, hy - 4, hx + 3, hy - 9, RIM)
    cv:set(hx - 1, hy - 9, EAR_TIP); cv:set(hx + 3, hy - 9, EAR_TIP)
    cv:poly({ { hx - 5, hy - 1 }, { hx - 9, hy - 5 }, { hx - 4, hy + 1 } }, FUR_D)
    cv:poly({ { hx - 3, hy - 2 }, { hx - 7, hy - 7 }, { hx - 2, hy } }, FUR_M)
    cv:line(hx - 7, hy - 6, hx - 4, hy - 3, RIM)
    cv:set(hx - 8, hy - 5, EAR_TIP)
    cv:outline(INK, 120, hex("#7d68ad"))
    local fx = A.canvas(W, H)
    if mode == "chime" then
      fx:add_glow(cx - 11, cy - 6 + tw, 7, GOLD, 170)
      fx:set(cx - 15, cy - 10, hex("#fff4c4")); fx:set(cx - 7, cy - 12, hex("#9eefff"))
    end
    return { shadow = sh, body = cv, fx = fx }
  end
  local frames = {}
  for _, spec in ipairs({ { "idle", 4, 220 }, { "chime", 4, 150 } }) do
    for i = 1, spec[2] do table.insert(frames, { duration = spec[3], cels = draw_frame(spec[1], i) }) end
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = { { name = "idle", from = 1, to = 4 }, { name = "chime", from = 5, to = 8 } } }, OUT_DIR .. "cre_echofox.aseprite")
end

local function build_rustcrab()
  local W, H = 58, 44
  local INK = hex("#1a1210")
  local RIM = hex("#f2c59d")
  local IRON_H, IRON_L, IRON_M, IRON_D = hex("#b0866b"), hex("#8a6856"), hex("#634639"), hex("#402c24")
  local FIRE_H, FIRE_M = hex("#ffe082"), hex("#ff6e30")
  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H); sh:ellipse(29, 40, 22, 4, hex("#0a0808", 130))
    local cv = A.canvas(W, H); local bob = (fi == 2 or fi == 3) and 1 or 0
    local cx, cy = 29, 25 + bob
    for _, lx in ipairs({ -18, -12, 12, 18 }) do
      cv:line(cx + lx * 0.7, cy + 5, cx + lx, cy + 13, IRON_D, 2)
      cv:line(cx + lx, cy + 13, cx + lx + (lx < 0 and -2 or 2), 39, IRON_M, 2)
    end
    cv:ellipse(cx - 20, cy + 4, 5, 4, function(x, y, nx, ny) return (ny < -0.45 and nx < 0.25) and RIM or IRON_L end)
    cv:ellipse(cx + 20, cy + 4, 5, 4, function(x, y, nx, ny) return (ny < -0.5) and IRON_H or IRON_L end)
    cv:ellipse(cx, cy - 2, 17, 13, function(x, y, nx, ny)
      local d = nx * 0.45 + ny * 0.55
      local r2 = nx * nx + ny * ny
      if r2 >= 0.72 and ny < -0.15 and nx < 0.35 then return RIM end
      if d < -0.35 then return IRON_H end
      if d < 0.1 then return IRON_L end
      return d < 0.45 and IRON_M or IRON_D
    end)
    -- Subtle copper dome rivets & top-left highlight arc
    cv:set(cx - 12, cy - 8, RIM); cv:set(cx + 9, cy - 9, IRON_H)
    cv:line(cx - 10, cy - 8, cx - 4, cy - 9, hex("#e8b85a"))
    cv:set(cx - 7, cy - 7, hex("#e8b85a")); cv:set(cx - 5, cy - 6, hex("#e8b85a"))
    local grate_h = (mode == "warm") and 3 or 6
    cv:rect(cx - 7, cy - 1, 14, grate_h + 2, hex("#261914"))
    for gx = -5, 5, 3 do cv:rect(cx + gx, cy, 2, grate_h, (fi % 2 == 0) and FIRE_H or FIRE_M) end
    cv:set(cx - 5, cy + 8, hex("#ffd670")); cv:set(cx + 5, cy + 8, hex("#ffd670"))
    cv:outline(INK, 120, hex("#735345"))
    local fx = A.canvas(W, H)
    fx:add_glow(cx, cy + 2, mode == "warm" and 9 or 13, FIRE_M, mode == "warm" and 85 or 135)
    return { shadow = sh, body = cv, fx = fx }
  end
  local frames = {}
  for _, spec in ipairs({ { "idle", 4, 220 }, { "warm", 4, 280 } }) do
    for i = 1, spec[2] do table.insert(frames, { duration = spec[3], cels = draw_frame(spec[1], i) }) end
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = { { name = "idle", from = 1, to = 4 }, { name = "warm", from = 5, to = 8 } } }, OUT_DIR .. "cre_rustcrab.aseprite")
end

local function build_prismweaver()
  local W, H = 48, 38
  local INK = hex("#10101f")
  local RIM = hex("#ffffff")
  local RIM_C = hex("#d4fbff")
  local LEG, LEG_HI = hex("#363859"), hex("#7880ba")
  local FACETS = { hex("#8ff7ff"), hex("#d89eff"), hex("#ffe68a"), hex("#96ffbe") }
  local function draw_frame(mode, fi)
    local sh = A.canvas(W, H); sh:ellipse(24, 34, 15, 3, hex("#0a0812", 110))
    local cv = A.canvas(W, H); local bob = (fi == 2 or fi == 3) and -1 or 0
    local cx, cy = 24, 21 + bob
    for i, lx in ipairs({ -16, -12, -8, -4, 4, 8, 12, 16 }) do
      local lift = ((i + fi) % 2 == 0) and -2 or 0
      cv:line(cx + lx * 0.35, cy + 2, cx + lx * 0.75, cy - 4 + lift, LEG)
      cv:line(cx + lx * 0.75, cy - 4 + lift, cx + lx, 33, LEG)
      if lx < 0 then cv:set(math.floor(cx + lx * 0.75), cy - 4 + lift, LEG_HI) end -- crisp knee glint on left legs
    end
    local f1, f2, f3 = FACETS[((fi - 1) % 4) + 1], FACETS[(fi % 4) + 1], FACETS[((fi + 1) % 4) + 1]
    cv:poly({ { cx, cy - 11 }, { cx + 9, cy - 4 }, { cx + 7, cy + 5 }, { cx - 7, cy + 5 }, { cx - 9, cy - 4 } }, function(x, y)
      return (x < cx - 2) and f1 or ((y < cy - 2) and f2 or f3)
    end)
    -- Strong icy-white top-left crystal rim highlight for UI Bag legibility
    cv:line(cx, cy - 11, cx - 9, cy - 4, RIM)
    cv:line(cx - 9, cy - 4, cx - 7, cy + 4, RIM_C)
    cv:line(cx, cy - 10, cx, cy + 4, hex("#ffffff", 180))
    cv:disc(cx + 6, cy + 4, 3, hex("#474970"))
    cv:set(cx + 7, cy + 3, hex("#ffffff")); cv:set(cx + 8, cy + 4, hex("#8ff7ff"))
    if mode == "weave" then cv:line(cx - 10, cy + 2, cx - 21, cy - 6 - (fi % 3) * 2, hex("#a8f7ff")) end
    cv:outline(INK, 120, hex("#7d85bf"))
    local fx = A.canvas(W, H); fx:add_glow(cx, cy - 2, 12, f2, 120)
    return { shadow = sh, body = cv, fx = fx }
  end
  local frames = {}
  for _, spec in ipairs({ { "idle", 4, 210 }, { "weave", 4, 160 } }) do
    for i = 1, spec[2] do table.insert(frames, { duration = spec[3], cels = draw_frame(spec[1], i) }) end
  end
  A.build_sprite({ w = W, h = H, layers = { "shadow", "body", "fx" }, frames = frames, tags = { { name = "idle", from = 1, to = 4 }, { name = "weave", from = 5, to = 8 } } }, OUT_DIR .. "cre_prismweaver.aseprite")
end

-- ============================================================================
-- 10. HOLLOW_PORTRAITS — 21 sculpted 48x52 expressive dialogue busts!
-- Frames 1..17: 6 human/ceramic casts; 18..21: 4 bonded creatures (Act 1-4)!
-- ============================================================================
local function build_portraits()
  local W, H = 48, 52
  local INK = hex("#16141e")
  local SCLERA = hex("#f7f4ec")

  local function draw_eyes_human(cv, iris_col, mood, pale)
    local lx, rx, ey = 18, 28, 25
    if mood == "wink_smirk" then
      -- Mira winking / side smirk!
      cv:rect(lx - 2, ey - 1, 5, 3, SCLERA); cv:rect(lx, ey - 1, 2, 2, iris_col); cv:set(lx, ey - 1, hex("#ffffff"))
      cv:line(lx - 2, ey - 3, lx + 2, ey - 4, hex("#1a1728"))
      cv:bezier_stroke({ rx - 2, ey }, { rx, ey - 2 }, { rx + 2, ey }, hex("#1a1728"), 1, 6)
      cv:line(rx - 2, ey - 4, rx + 2, ey - 3, hex("#1a1728"))
    elseif mood == "gentle_crescent" or mood == "old_smile" then
      cv:bezier_stroke({ lx - 2, ey }, { lx, ey - 2 }, { lx + 2, ey }, iris_col, 1, 6)
      cv:bezier_stroke({ rx - 2, ey }, { rx, ey - 2 }, { rx + 2, ey }, iris_col, 1, 6)
    elseif mood == "pained_shadow" then
      cv:rect(lx - 2, ey, 4, 2, hex("#2b2638")); cv:rect(rx - 2, ey, 4, 2, hex("#2b2638"))
      cv:line(lx - 2, ey - 3, lx + 2, ey - 1, hex("#4c465c"))
      cv:line(rx - 2, ey - 1, rx + 2, ey - 3, hex("#4c465c"))
    elseif mood == "cold_blank" then
      -- Blinding white hollow Vaelen eyes!
      cv:rect(lx - 2, ey - 1, 5, 3, hex("#ffffff")); cv:rect(rx - 2, ey - 1, 5, 3, hex("#ffffff"))
      cv:line(lx - 3, ey - 3, lx + 2, ey - 2, hex("#524d66"))
      cv:line(rx - 2, ey - 2, rx + 3, ey - 3, hex("#524d66"))
    elseif mood == "shock" then
      cv:rect(lx - 2, ey - 2, 5, 4, SCLERA); cv:rect(lx, ey - 1, 2, 2, iris_col)
      cv:rect(rx - 2, ey - 2, 5, 4, SCLERA); cv:rect(rx, ey - 1, 2, 2, iris_col)
      cv:set(lx - 1, ey - 1, hex("#ffffff")); cv:set(rx - 1, ey - 1, hex("#ffffff"))
      cv:line(lx - 3, ey - 5, lx + 2, ey - 6, hex("#2e2630"))
      cv:line(rx - 2, ey - 6, rx + 3, ey - 5, hex("#2e2630"))
    elseif mood == "fierce" then
      cv:rect(lx - 2, ey - 1, 5, 3, SCLERA); cv:rect(lx + 1, ey - 1, 2, 2, iris_col); cv:set(lx, ey - 1, hex("#ffffff"))
      cv:rect(rx - 2, ey - 1, 5, 3, SCLERA); cv:rect(rx, ey - 1, 2, 2, iris_col); cv:set(rx + 1, ey - 1, hex("#ffffff"))
      cv:line(lx - 3, ey - 4, lx + 3, ey - 2, hex("#201c2e"))
      cv:line(rx - 3, ey - 2, rx + 3, ey - 4, hex("#201c2e"))
    else
      -- Standard warm / teary expressive anime-pixel eyes with specular catchlight
      cv:rect(lx - 2, ey - 1, 5, 3, SCLERA); cv:rect(lx, ey - 1, 3, 3, iris_col); cv:set(lx, ey - 1, hex("#ffffff"))
      cv:rect(rx - 2, ey - 1, 5, 3, SCLERA); cv:rect(rx - 1, ey - 1, 3, 3, iris_col); cv:set(rx - 1, ey - 1, hex("#ffffff"))
      cv:line(lx - 3, ey - 3, lx + 2, ey - 3, pale and hex("#523f3c") or hex("#2a222b"))
      cv:line(rx - 2, ey - 3, rx + 3, ey - 3, pale and hex("#523f3c") or hex("#2a222b"))
    end
  end

  local specs = {
    { tag = "protag_hooded", who = "protag", mood = "hooded" },
    { tag = "protag_warm",   who = "protag", mood = "warm" },
    { tag = "protag_shock",  who = "protag", mood = "shock" },
    { tag = "protag_fading", who = "protag", mood = "fading" },
    { tag = "linh_smile",    who = "linh",   mood = "warm" },
    { tag = "linh_shock",    who = "linh",   mood = "shock" },
    { tag = "linh_teary",    who = "linh",   mood = "teary" },
    { tag = "kael_warm",     who = "kael",   mood = "warm" },
    { tag = "kael_sad",      who = "kael",   mood = "sad" },
    { tag = "kael_glow",     who = "kael",   mood = "glow" },
    { tag = "mira_smirk",    who = "mira",   mood = "wink_smirk" },
    { tag = "mira_fierce",   who = "mira",   mood = "fierce" },
    { tag = "mira_gentle",   who = "mira",   mood = "gentle_crescent" },
    { tag = "vaelen_cold",   who = "vaelen", mood = "cold_blank" },
    { tag = "vaelen_pained", who = "vaelen", mood = "pained_shadow" },
    { tag = "vaelen_old",    who = "vaelen", mood = "old_smile" },
    { tag = "vex_smug",      who = "vex",    mood = "smug" },
    { tag = "fox_happy",     who = "fox",    mood = "happy" },
    { tag = "crab_warm",     who = "crab",   mood = "warm" },
    { tag = "weaver_spark",  who = "weaver", mood = "spark" },
    { tag = "mite_clean",    who = "mite",   mood = "clean" },
  }

  local frames, tags = {}, {}
  for idx, s in ipairs(specs) do
    local cv = A.canvas(W, H)
    local who, mood = s.who, s.mood

    if who == "kael" then
      -- Kaelen's Grand Fluted Ceramic Helm & Kintsugi Neckplate!
      local cer_l = mood == "glow" and hex("#fff8e8") or (mood == "sad" and hex("#c4beb4") or hex("#f0ebe0"))
      local cer_d = mood == "sad" and hex("#7a7570") or hex("#9e978e")
      local gold = mood == "sad" and hex("#b89548") or hex("#f7cb52")
      cv:poly({ { 8, 51 }, { 12, 36 }, { 36, 36 }, { 40, 51 } }, function(x, y) return bayer(x, y, cer_l, cer_d, (x - 10) / 30) end)
      cv:rect(20, 34, 8, 5, hex("#3a3440")) -- armored throat
      -- Domed rounded knight helm (NO sharp brick box!)
      cv:poly({ { 12, 29 }, { 12, 16 }, { 17, 10 }, { 31, 10 }, { 36, 16 }, { 36, 29 }, { 30, 35 }, { 18, 35 } }, function(x, y)
        return bayer(x, y, cer_l, cer_d, (x - 12) / 26)
      end)
      -- Golden Kintsugi crack veins branching smoothly across faceplate & chest
      cv:line(14, 15, 22, 20, gold); cv:line(22, 20, 17, 29, gold)
      cv:line(27, 30, 34, 24, gold); cv:line(14, 41, 25, 47, gold)
      -- Visor slit + warm amber optics
      cv:rect(14, 20, 20, 6, hex("#2c2730"))
      if mood == "sad" then
        cv:rect(17, 23, 4, 1, hex("#b88e44")); cv:rect(27, 23, 4, 1, hex("#b88e44"))
      elseif mood == "glow" then
        cv:rect(16, 21, 5, 3, hex("#ffe480")); cv:rect(27, 21, 5, 3, hex("#ffe480"))
        cv:add_glow(24, 23, 14, gold, 110)
      else
        cv:rect(17, 21, 4, 3, hex("#ffd670")); cv:rect(27, 21, 4, 3, hex("#ffd670"))
        cv:set(18, 21, hex("#ffffff")); cv:set(28, 21, hex("#ffffff"))
      end
    elseif who == "fox" then
      -- Mốc (Echo Fox): Fluffy 4-eared pale lilac bust, rose ear tufts, golden bell, happy ^_^ eyes!
      local FUR_H, FUR_L, FUR_M, FUR_D = hex("#fcf9ff"), hex("#eee8fc"), hex("#c7b8eb"), hex("#8772bd")
      local PINK, GOLD = hex("#f29cb8"), hex("#ffd46b")
      -- Fluffed chest collar & golden tail chime curled by neck
      cv:poly({ { 11, 51 }, { 14, 38 }, { 34, 38 }, { 37, 51 } }, function(x) return x < 20 and FUR_L or FUR_M end)
      cv:poly({ { 18, 39 }, { 24, 46 }, { 30, 39 }, { 24, 49 } }, FUR_H)
      cv:bezier_stroke({ 31, 48 }, { 38, 41 }, { 39, 31 }, FUR_M, 5, 14)
      cv:disc(39, 30, 3, FUR_L); cv:disc(24, 44, 3, GOLD); cv:set(23, 43, hex("#fff4c4"))
      -- 4 expressive tall fox ears rising behind head
      cv:poly({ { 14, 21 }, { 13, 8 }, { 21, 18 } }, FUR_L); cv:poly({ { 15, 18 }, { 14, 11 }, { 19, 18 } }, PINK)
      cv:poly({ { 27, 18 }, { 35, 8 }, { 34, 21 } }, FUR_M); cv:poly({ { 29, 18 }, { 34, 11 }, { 33, 18 } }, PINK)
      cv:poly({ { 11, 27 }, { 5, 17 }, { 16, 22 } }, FUR_D); cv:line(6, 18, 12, 23, PINK)
      cv:poly({ { 32, 22 }, { 43, 17 }, { 37, 27 } }, FUR_M); cv:line(42, 18, 36, 23, PINK)
      -- Rounded fluffy fox head & cheek puffs
      cv:ellipse(24, 28, 12, 10, function(x, y, nx, ny)
        if ny < -0.5 and nx < 0.25 then return FUR_H end
        return (nx > 0.35 or ny > 0.4) and FUR_M or FUR_L
      end)
      cv:ellipse(24, 32, 6, 4, FUR_H)
      -- Happy crescent eyes ^_^ + rosy blush + tiny dark nose & ":3" grin
      cv:bezier_stroke({ 16, 26 }, { 19, 23 }, { 21, 26 }, hex("#2c2340"), 1, 8)
      cv:bezier_stroke({ 27, 26 }, { 30, 23 }, { 32, 26 }, hex("#2c2340"), 1, 8)
      cv:rect(14, 28, 4, 2, hex("#f5a6c0")); cv:rect(30, 28, 4, 2, hex("#f5a6c0"))
      cv:rect(23, 30, 2, 2, hex("#2c2340"))
      cv:bezier_stroke({ 21, 33 }, { 23, 35 }, { 24, 33 }, hex("#4d3a59"), 1, 6)
      cv:bezier_stroke({ 24, 33 }, { 26, 35 }, { 27, 33 }, hex("#4d3a59"), 1, 6)
      cv:add_glow(11, 13, 5, GOLD, 95); cv:add_glow(39, 29, 5, GOLD, 95)
    elseif who == "crab" then
      -- Cua Lò Rèn (Rustcrab): Warm boiler-copper dome, golden scar rivet, cozy hearth grin!
      local RIM, IRON_H, IRON_L, IRON_M, IRON_D = hex("#f2c59d"), hex("#b0866b"), hex("#8a6856"), hex("#634639"), hex("#402c24")
      local FIRE_H, FIRE_M = hex("#ffe082"), hex("#ff7a30")
      -- Riveted sturdy furnace pincers framing bottom left/right
      cv:ellipse(9, 43, 6, 6, function(x, y, nx, ny) return (ny < -0.45 and nx < 0.25) and RIM or IRON_L end)
      cv:ellipse(39, 43, 6, 6, IRON_M)
      -- Broad boiler dome carapace with curved top-left rim & brass forehead patch
      cv:ellipse(24, 31, 17, 16, function(x, y, nx, ny)
        local d = nx * 0.42 + ny * 0.52
        local r2 = nx * nx + ny * ny
        if r2 >= 0.74 and ny < -0.18 and nx < 0.32 then return RIM end
        if d < -0.3 then return IRON_H end
        if d < 0.12 then return IRON_L end
        return d < 0.48 and IRON_M or IRON_D
      end)
      cv:line(13, 21, 21, 19, hex("#e8b85a"))
      cv:set(16, 22, hex("#e8b85a")); cv:set(19, 23, hex("#e8b85a"))
      -- Warm glowing arched furnace grille mouth + cheerful amber eyes above
      cv:disc(16, 25, 2, hex("#ffd670")); cv:set(16, 24, hex("#ffffff"))
      cv:disc(32, 25, 2, hex("#ffd670")); cv:set(32, 24, hex("#ffffff"))
      cv:rect(13, 29, 22, 10, hex("#261914"))
      for gx = 15, 31, 4 do
        cv:rect(gx, 30, 2, 8, (gx == 19 or gx == 23 or gx == 27) and FIRE_H or FIRE_M)
      end
      cv:add_glow(24, 34, 15, FIRE_M, 95)
      cv:add_glow(19, 10, 5, hex("#fff4d6"), 85); cv:add_glow(28, 7, 4, hex("#fff4d6"), 75)
    elseif who == "weaver" then
      -- Nhện Lăng Kính (Prismweaver): Faceted crystal gem crown, crisp white bevels, sparkling multi-eyes!
      local LEG, LEG_HI = hex("#363859"), hex("#7880ba")
      -- Arched crystal-spider legs framing left & right
      for _, side in ipairs({ -1, 1 }) do
        local bx = 24 + side * 8
        cv:line(bx, 37, bx + side * 8, 25, LEG, 2)
        cv:line(bx + side * 8, 25, bx + side * 12, 46, LEG, 2)
        if side < 0 then cv:disc(bx + side * 8, 25, 1, LEG_HI) end
      end
      -- Grand multi-faceted prism crown
      cv:poly({ { 24, 6 }, { 37, 17 }, { 33, 33 }, { 15, 33 }, { 11, 17 } }, function(x, y)
        if x < 23 and y < 22 then return hex("#8ff7ff") end
        if x >= 23 and y < 22 then return hex("#d89eff") end
        return x < 24 and hex("#96ffbe") or hex("#ffe68a")
      end)
      cv:line(24, 6, 11, 17, hex("#ffffff")); cv:line(11, 17, 15, 32, hex("#d4fbff"))
      cv:line(24, 7, 24, 32, hex("#ffffff")); cv:line(12, 22, 36, 22, hex("#ffffff"))
      -- Sleek obsidian arachnid head & 4 joyful cyan jewel eyes
      cv:ellipse(24, 37, 9, 8, hex("#474970"))
      cv:ellipse(22, 35, 6, 5, hex("#5e6194"))
      cv:disc(19, 36, 2, hex("#8ff7ff")); cv:set(19, 35, hex("#ffffff"))
      cv:disc(29, 36, 2, hex("#8ff7ff")); cv:set(29, 35, hex("#ffffff"))
      cv:set(22, 33, hex("#8ff7ff")); cv:set(26, 33, hex("#8ff7ff"))
      cv:add_glow(24, 21, 15, hex("#8ff7ff"), 95)
    elseif who == "mite" then
      -- Bọ Ký Sinh (Clean/Docile Parasite Mite): Gleaming plum carapace, purified cyan pearl, peaceful eyes!
      local SHELL_H, SHELL_L, SHELL_D = hex("#a47ec4"), hex("#7d569e"), hex("#52346e")
      -- Cute tucked stubby legs at lower rim
      for _, lx in ipairs({ 13, 18, 30, 35 }) do
        cv:line(24 + (lx - 24) * 0.5, 42, lx, 48, hex("#3e2852"), 2)
      end
      -- Polished rounded dome carapace + purified cyan-gold crystal bulb on crest
      cv:ellipse(24, 33, 15, 12, function(x, y, nx, ny)
        local r2 = nx * nx + ny * ny
        if r2 >= 0.74 and ny < -0.15 and nx < 0.25 then return hex("#d4fff6") end
        return nx > 0.3 and SHELL_D or ((ny < -0.1) and SHELL_H or SHELL_L)
      end)
      cv:disc(24, 19, 6, hex("#9be3ff"))
      cv:disc(23, 18, 3, hex("#e8fcff")); cv:set(22, 17, hex("#ffffff"))
      -- Peaceful docile seafoam eyes & tiny gentle smile
      cv:disc(18, 34, 2, hex("#8ff5e8")); cv:set(18, 33, hex("#ffffff"))
      cv:disc(30, 34, 2, hex("#8ff5e8")); cv:set(30, 33, hex("#ffffff"))
      cv:bezier_stroke({ 22, 37 }, { 24, 39 }, { 26, 37 }, hex("#3c244f"), 1, 6)
      cv:add_glow(24, 19, 13, hex("#8ff5e8"), 95)
      cv:add_glow(13, 14, 4, hex("#fff4c4"), 85); cv:add_glow(35, 13, 4, hex("#8ff5e8"), 85)
    else
      -- Sculpted Human Faces with individual clothing silhouette & jawline!
      local skin_l = (who == "vaelen" and mood ~= "old_smile") and hex("#dcd8e6")
                  or (who == "linh" and mood == "shock" and hex("#e3cfd1"))
                  or (who == "mira" and hex("#fae4d2"))
                  or (who == "vex" and hex("#d8c8cc"))
                  or (mood == "old_smile" and hex("#e0bca2"))
                  or hex("#f2d5ba")
      local skin_d = mix(skin_l, hex("#6b4a42"), 0.28)

      -- Collar & Chest Bust tailored per character
      if who == "protag" then
        cv:poly({ { 8, 51 }, { 12, 36 }, { 36, 36 }, { 40, 51 } }, hex("#475750"))
        cv:poly({ { 11, 35 }, { 37, 35 }, { 34, 47 }, { 14, 47 } }, hex("#e8b058")) -- wrapped warm scarf!
        cv:bezier_stroke({ 12, 41 }, { 24, 45 }, { 36, 40 }, hex("#9e6b32"), 1, 14)
        cv:rect(30, 42, 5, 6, hex("#f7f4eb")) -- White Blank Deed corner!
      elseif who == "linh" then
        cv:poly({ { 9, 51 }, { 13, 37 }, { 35, 37 }, { 39, 51 } }, hex("#c47349"))
        cv:poly({ { 18, 37 }, { 30, 37 }, { 26, 50 }, { 22, 50 } }, hex("#e8dec8"))
        cv:bezier_stroke({ 16, 37 }, { 24, 47 }, { 32, 37 }, hex("#f2c85b"), 2, 12) -- brass stethoscope!
        -- Little 4-eared fox Mốc peeking from Linh's left shoulder!
        cv:ellipse(11, 35, 5, 4, hex("#e5dff2"))
        cv:poly({ { 7, 32 }, { 8, 27 }, { 10, 32 } }, hex("#c7b8eb"))
        cv:poly({ { 11, 32 }, { 13, 27 }, { 14, 32 } }, hex("#c7b8eb"))
        cv:set(9, 28, hex("#f29cb8")); cv:set(13, 28, hex("#f29cb8"))
      elseif who == "mira" then
        -- Graceful V-neck indigo merchant mantle with golden filigree trim!
        cv:poly({ { 10, 51 }, { 14, 36 }, { 34, 36 }, { 38, 51 } }, hex("#3f548c"))
        cv:poly({ { 17, 36 }, { 31, 36 }, { 24, 50 } }, hex("#1d2645"))
        cv:line(16, 36, 24, 50, hex("#f0c259")); cv:line(32, 36, 24, 50, hex("#f0c259"))
        cv:disc(24, 43, 2, hex("#8df5ff")) -- glowing cyan jewel clasp
      elseif who == "vaelen" then
        local c_robe = mood == "old_smile" and hex("#8e857a") or hex("#b5b0c7")
        cv:poly({ { 8, 51 }, { 12, 36 }, { 36, 36 }, { 40, 51 } }, c_robe)
        if mood ~= "old_smile" then
          cv:rect(22, 38, 4, 13, hex("#d9c27e"))
          cv:line(16, 44, 32, 44, hex("#8f3f52"), 2) -- chest surgical scar
        else
          cv:poly({ { 14, 36 }, { 34, 36 }, { 30, 51 }, { 18, 51 } }, hex("#696159"))
        end
      elseif who == "vex" then
        cv:poly({ { 8, 51 }, { 11, 35 }, { 37, 35 }, { 40, 51 } }, hex("#4c385e"))
        cv:rect(13, 35, 22, 6, hex("#75578f"))
        cv:rect(21, 38, 6, 13, hex("#e3b74d"))
      end

      -- Neck & Cheek-sculpted Tapered Head Silhouette
      cv:rect(20, 32, 8, 6, skin_d)
      local narrow = (who == "mira" or who == "linh") and 1 or 0
      cv:poly({
        { 13 + narrow, 17 }, { 35 - narrow, 17 },
        { 36 - narrow, 27 }, { 31, 34 }, { 24, 36 }, { 17, 34 }, { 12 + narrow, 27 }
      }, function(x, y)
        local edge = (x > 31 - narrow or y > 32) and 1 or 0
        return edge == 1 and skin_d or skin_l
      end)
      -- Subtle ear contours & cheek tint
      cv:rect(11 + narrow, 23, 2, 4, skin_d); cv:rect(35 - narrow, 23, 2, 4, skin_d)
      if who == "linh" or who == "mira" or (who == "protag" and mood == "warm") then
        cv:rect(14 + narrow, 27, 3, 2, mix(skin_l, hex("#eb8278"), 0.35))
        cv:rect(31 - narrow, 27, 3, 2, mix(skin_l, hex("#eb8278"), 0.35))
      end
      -- Subtle 1px nose shadow
      cv:set(24, 27, skin_d); cv:set(23, 28, skin_d)

      -- Eyes & Mouth per Character & Mood
      if who == "vex" then
        cv:rect(16, 24, 4, 2, hex("#241b30"))
        cv:disc(29, 25, 5, hex("#e3b74d")); cv:disc(29, 25, 3, hex("#96ebff")); cv:set(28, 24, hex("#ffffff"))
        cv:line(20, 31, 29, 29, hex("#402838")) -- sly smirk
      elseif who == "protag" then
        draw_eyes_human(cv, hex("#3a3242"), mood, false)
        if mood == "shock" then cv:disc(24, 31, 2, hex("#593a36"))
        elseif mood == "fading" then cv:line(21, 31, 27, 31, hex("#755147"))
        else cv:bezier_stroke({ 21, 30 }, { 24, 32 }, { 27, 30 }, hex("#754d3c"), 1, 8) end
      elseif who == "linh" then
        draw_eyes_human(cv, hex("#4a2d24"), mood, mood == "shock")
        if mood == "teary" then
          cv:set(17, 27, hex("#8ff7ff")); cv:set(29, 27, hex("#8ff7ff"))
          cv:bezier_stroke({ 20, 30 }, { 24, 33 }, { 28, 30 }, hex("#8f4a40"), 1, 8)
        elseif mood == "shock" then
          cv:rect(22, 30, 4, 2, hex("#6b3c3c"))
        else
          cv:bezier_stroke({ 20, 30 }, { 24, 33 }, { 28, 30 }, hex("#8f4a40"), 1, 8)
        end
      elseif who == "mira" then
        draw_eyes_human(cv, hex("#2b3661"), mood, false)
        if mood == "fierce" then cv:line(21, 31, 27, 30, hex("#733b3b"))
        else cv:bezier_stroke({ 21, 30 }, { 25, 32 }, { 28, 29 }, hex("#8a4b4b"), 1, 8) end
      elseif who == "vaelen" then
        draw_eyes_human(cv, hex("#453d38"), mood, true)
        if mood == "old_smile" then
          cv:bezier_stroke({ 21, 30 }, { 24, 32 }, { 27, 30 }, hex("#6e4b3e"), 1, 8)
          cv:set(15, 26, hex("#9c7864")); cv:set(32, 26, hex("#9c7864")) -- age lines
        else
          cv:line(21, 31, 27, 31, hex("#6a6480"))
          cv:line(18, 29, 17, 31, skin_d); cv:line(30, 29, 31, 31, skin_d) -- gaunt cheek hollows
        end
      end

      -- Layered Character-Defining Hair & Headwear!
      if who == "protag" and mood == "hooded" then
        -- Draped pale ivory-sage traveler cowl (inspired by classic char_me) hiding hair until Hồi 2-3 reveal!
        cv:poly({ { 9, 36 }, { 10, 14 }, { 17, 6 }, { 31, 6 }, { 38, 14 }, { 39, 36 }, { 34, 34 }, { 34, 17 }, { 24, 12 }, { 14, 17 }, { 14, 34 } }, function(x, y)
          return bayer(x, y, hex("#f0ebe0"), hex("#bdb4a6"), (x - 9) / 30)
        end)
        cv:poly({ { 14, 17 }, { 24, 12 }, { 34, 17 }, { 32, 22 }, { 16, 22 } }, hex("#201c28")) -- deep cowl forehead shadow
      elseif who == "protag" or who == "vaelen" then
        -- Shared windswept silver-ivory crest (genetic link!)
        local hl, hd = hex("#f0f4fc"), hex("#a4b2c9")
        cv:ellipse(24, 14, 13, 8, function(x, y, nx, ny) return bayer(x, y, hl, hd, (ny + 0.4) * 0.6) end)
        cv:poly({ { 11, 17 }, { 14, 23 }, { 18, 17 }, { 23, 21 }, { 26, 15 }, { 32, 21 }, { 36, 16 }, { 32, 10 }, { 15, 10 } }, hl)
        if who == "protag" and mood == "fading" then
          for y = 8, 38 do
            for x = 30, W - 1 do
              if cv:get(x, y) and ((x * 7 + y * 13) % 4 == 0) then cv:set(x, y, false) end
            end
          end
          cv:set(37, 19, hex("#8ff5e8")); cv:set(39, 14, hex("#ffcb6b")); cv:set(35, 10, hex("#8ff5e8"))
        end
      elseif who == "linh" then
        local hl, hd = hex("#6b463c"), hex("#3e2520")
        cv:disc(31, 9, 5, hd) -- high messy top bun!
        cv:ellipse(24, 14, 12, 7, hl)
        -- Soft feminine framing side locks
        cv:poly({ { 11, 16 }, { 11, 29 }, { 14, 25 }, { 15, 16 } }, hl)
        cv:poly({ { 33, 16 }, { 37, 29 }, { 34, 27 }, { 32, 16 } }, hd)
        cv:poly({ { 13, 15 }, { 18, 20 }, { 24, 16 }, { 29, 20 }, { 34, 15 }, { 30, 10 }, { 18, 10 } }, hl)
        -- Round-framed Brass Mechanic Goggles with dark strap & diagonal cyan gleam!
        cv:rect(11, 13, 26, 2, hex("#2d1d1a"))
        cv:ellipse(18, 14, 4, 4, hex("#f2c85b")); cv:ellipse(18, 14, 3, 3, hex("#7ce8ff"))
        cv:line(16, 13, 18, 15, hex("#ffffff"))
        cv:ellipse(30, 14, 4, 4, hex("#f2c85b")); cv:ellipse(30, 14, 3, 3, hex("#7ce8ff"))
        cv:line(28, 13, 30, 15, hex("#ffffff"))
      elseif who == "mira" then
        local hl, hd = hex("#2f3861"), hex("#1b1c30")
        -- Sleek asymmetric shoulder-length bob + diagonal silk bangs + double gold pins
        cv:ellipse(24, 14, 12, 8, hd)
        cv:poly({ { 11, 16 }, { 10, 35 }, { 14, 34 }, { 15, 18 } }, hd)
        cv:poly({ { 33, 16 }, { 37, 36 }, { 34, 37 }, { 31, 18 } }, hl)
        cv:poly({ { 12, 15 }, { 18, 22 }, { 26, 15 }, { 34, 20 }, { 35, 12 }, { 15, 10 } }, hl)
        cv:rect(14, 17, 4, 1, hex("#f0c259")); cv:rect(15, 19, 3, 1, hex("#f0c259"))
      elseif who == "vex" then
        cv:poly({ { 6, 17 }, { 42, 17 }, { 36, 13 }, { 29, 7 }, { 19, 7 }, { 12, 13 } }, hex("#2b2338"))
        cv:rect(13, 15, 22, 2, hex("#e3b74d"))
      end
    end

    cv:outline(INK, 120, hex("#4c465c"))
    frames[idx] = { duration = 300, cels = { portrait = cv } }
    tags[idx] = { name = s.tag, from = idx, to = idx }
  end
  A.build_sprite({ w = W, h = H, layers = { "portrait" }, frames = frames, tags = tags }, OUT_DIR .. "hollow_portraits.aseprite")
end

build_protag()
build_linh()
build_kael()
build_mira()
build_vaelen()
build_vex()
build_echofox()
build_rustcrab()
build_prismweaver()
build_portraits()

-- ============================================================================
-- 11. TOP-DOWN 3/4 MULTI-DIRECTIONAL SPRITES FOR 4-ACT MAP & CATERPILLAR TRAIL
-- (32x36, anchor 16,30 — upgraded rim-lighting, billowing hems, crisp Kintsugi,
-- expressive Mốc fox, and layered shadows!)
-- ============================================================================
local function build_td_party()
  local W, H = 32, 36
  local INK = hex("#171520")

  -- Helper: draw crisp Top-Down 3/4 sprite given direction + character style
  local function emit_td_char(name, specs, drawer)
    local frames, tags, idx = {}, {}, 1
    for _, sp in ipairs(specs) do
      local s_idx = idx
      for fi = 1, sp[2] do
        local sh = A.canvas(W, H); sh:ellipse(16, 31, 8, 3, hex("#06060c", 145))
        local cv = A.canvas(W, H)
        drawer(cv, sp[1], fi)
        cv:outline(INK, 120, hex("#3d384d"))
        frames[idx] = { duration = sp[3], cels = { shadow = sh, body = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = sp[1], from = s_idx, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "shadow", "body" }, frames = frames, tags = tags }, OUT_DIR .. name .. ".aseprite")
  end

  -- 1. td_char_protag (Hooded down/up/side in Act 1-2 + Unmasked down/up/side + dissolve!)
  emit_td_char("td_char_protag", {
    { "hooded_down", 4, 150 }, { "hooded_up", 4, 150 }, { "hooded_side", 4, 150 },
    { "down_walk", 4, 150 }, { "up_walk", 4, 150 }, { "side_walk", 4, 150 }, { "dissolve", 4, 150 },
  }, function(cv, mode, fi)
    local step = (fi == 2 and -1) or (fi == 4 and 1) or 0
    local hem_sway = (fi == 2 and -1) or (fi == 4 and 1) or 0
    local is_hood = mode:sub(1, 6) == "hooded"
    local dir = (mode:find("up") and "up") or (mode:find("side") and "side") or "down"
    local bob = (fi == 2 or fi == 4) and 1 or 0
    local cx, hy, ty = 16, 11 + bob, 17 + bob

    -- Stepping boots
    if dir == "side" then
      cv:rect(cx - 2 + step * 2, 27, 3, 5, hex("#2f2a3b"))
      cv:rect(cx - 2 - step * 2, 27, 3, 5, hex("#1d1a26"))
    else
      cv:rect(cx - 4, 27 + (fi == 2 and -1 or 0), 3, 5, hex("#2f2a3b"))
      cv:rect(cx + 1, 27 + (fi == 4 and -1 or 0), 3, 5, hex("#211d29"))
    end

    -- Flowing coat / traveler cloak with top-left rim light & swaying hem folds
    local c_hi = is_hood and hex("#fffaf0") or hex("#677d72")
    local c1 = is_hood and hex("#f0ebe0") or hex("#475750")
    local c2 = is_hood and hex("#bdb3a0") or hex("#2b3634")
    local w_top = (dir == "side") and 4 or 5
    local w_bot = (dir == "side") and 6 or 7
    cv:poly({
      { cx - w_top, ty }, { cx + w_top, ty },
      { cx + w_bot + hem_sway, 29 }, { cx - w_bot + hem_sway, 29 }
    }, function(x, y)
      local u = (x - (cx - w_bot)) / (w_bot * 2)
      if u < 0.22 then return c_hi end
      return bayer(x, y, c1, c2, u * 0.85)
    end)
    -- Coat fold crease
    cv:line(cx - 2 + hem_sway, ty + 3, cx - 3 + hem_sway, 28, c2)

    -- Layered amber scarf + fluttering tail
    cv:rect(cx - w_top, ty, w_top * 2, 3, hex("#f5c469"))
    cv:rect(cx - w_top, ty + 2, w_top * 2, 1, hex("#ab7435"))
    if dir == "side" then
      cv:rect(cx - 8 - math.abs(hem_sway), ty + 1, 4, 5, hex("#c98a42"))
    elseif dir == "up" then
      cv:rect(cx - 5, ty + 2, 3, 7 + (fi % 2), hex("#c98a42"))
    else
      cv:rect(cx - 5, ty + 2, 2, 5, hex("#c98a42"))
    end

    if dir ~= "up" then
      cv:set(cx, ty + 5, hex("#ffd678")); cv:set(cx + 1, ty + 4, hex("#8ff5e8")) -- double heartbeat glow
      cv:rect(cx + 2, ty + 6, 3, 3, hex("#f7f4eb")) -- White Deed corner
    else
      cv:rect(cx - 4, ty + 2, 8, 6, hex("#755336")) -- traveler pack
      cv:rect(cx - 3, ty + 1, 6, 2, hex("#9c724d"))
      cv:rect(cx + 1, ty + 3, 2, 3, hex("#f7f4eb"))
    end

    -- Head / Hood with rim highlight
    if is_hood then
      cv:poly({ { cx - 7, hy + 5 }, { cx - 6, hy - 3 }, { cx, hy - 6 }, { cx + 6, hy - 3 }, { cx + 7, hy + 5 } }, function(x, y)
        return (x < cx - 2 or y < hy - 3) and c_hi or bayer(x, y, c1, c2, (x - (cx - 7)) / 14)
      end)
      if dir == "down" then
        cv:ellipse(cx, hy + 2, 4, 3, hex("#1a1622"))
        cv:set(cx - 2, hy + 2, hex("#ffe49e")); cv:set(cx + 2, hy + 2, hex("#ffe49e"))
      elseif dir == "side" then
        cv:rect(cx + 1, hy, 4, 4, hex("#1a1622")); cv:set(cx + 3, hy + 2, hex("#ffe49e"))
      else
        cv:line(cx, hy - 5, cx, hy + 4, c2)
      end
    else
      if dir == "up" then
        cv:ellipse(cx, hy + 1, 5, 5, function(x, y, nx, ny)
          return ny < -0.2 and hex("#ffffff") or (ny > 0.35 and hex("#b0bdd4") or hex("#eef2fa"))
        end)
      else
        cv:ellipse(cx + (dir == "side" and 1 or 0), hy + 1, 5, 5, function(x, y, nx)
          return nx > 0.35 and hex("#cfa488") or hex("#f2d5ba")
        end)
        if dir == "down" then cv:set(cx - 2, hy + 2, hex("#2c2530")); cv:set(cx + 2, hy + 2, hex("#2c2530"))
        else cv:set(cx + 3, hy + 2, hex("#2c2530")) end
        cv:ellipse(cx, hy - 2, 6, 4, function(x, y, nx, ny)
          return ny < -0.2 and hex("#ffffff") or hex("#dde4f2")
        end)
        cv:set(cx - 3, hy, hex("#eef2fa")); cv:set(cx + 3, hy, hex("#c2cde0"))
      end
    end
    if mode == "dissolve" then
      for y = 10, 29 do for x = 18, 25 do if cv:get(x, y) and ((x * 5 + y * 7 + fi) % 3 == 0) then cv:set(x, y, false) end end end
      cv:set(22 + (fi % 2), 14 - fi * 2, hex("#8ff5e8")); cv:set(24, 18 - fi, hex("#ffcb6b"))
      cv:set(20, 10 - (fi % 3), hex("#fff4c4"))
    end
  end)

  -- 2. td_comp_linh (Down / Up / Side + clearly sculpted 4-eared fox Mốc wagging tail on shoulder!)
  emit_td_char("td_comp_linh", { { "down_walk", 4, 150 }, { "up_walk", 4, 150 }, { "side_walk", 4, 150 } }, function(cv, mode, fi)
    local step = (fi == 2 and -1) or (fi == 4 and 1) or 0
    local sway = (fi == 2 and -1) or (fi == 4 and 1) or 0
    local dir = (mode:find("up") and "up") or (mode:find("side") and "side") or "down"
    local bob = (fi == 2 or fi == 4) and 1 or 0
    local cx, hy, ty = 16, 11 + bob, 17 + bob

    -- Boots & pants
    cv:rect(cx - 4 + (dir == "side" and step or 0), 27 + (fi == 2 and -1 or 0), 3, 5, hex("#435263"))
    cv:rect(cx + 1 - (dir == "side" and step or 0), 27 + (fi == 4 and -1 or 0), 3, 5, hex("#2b3442"))

    -- Shaded terracotta mechanic vest + inner cream shirt + swaying hem
    cv:poly({ { cx - 5, ty }, { cx + 5, ty }, { cx + 6 + sway, 29 }, { cx - 6 + sway, 29 } }, function(x, y)
      local u = (x - (cx - 6)) / 12
      if u < 0.25 then return hex("#de8b5f")
      elseif u > 0.72 then return hex("#874427")
      else return hex("#c47349") end
    end)
    if dir ~= "up" then
      cv:rect(cx - 2, ty + 1, 4, 6, hex("#efe6d1")) -- cream shirt collar V
      cv:rect(cx - 1, ty + 2, 2, 1, hex("#f2c85b")) -- brass clasp
    end
    cv:rect(cx - 6, ty + 5, 3, 5, hex("#4287b8")); cv:set(cx - 5, ty + 6, hex("#a8dcff")) -- blue 5L ledger

    -- Clearly sculpted Mốc fox peeking out over left shoulder & wagging bushy tail!
    local mx, my = cx - 7, ty - 2
    local tail_wag = (fi % 2 == 0) and -1 or 1
    -- Bushy tail with gold band
    cv:line(mx - 2, my + 2, mx - 5, my + 4 + tail_wag, hex("#b9aad9"), 2)
    cv:set(mx - 4, my + 3 + tail_wag, hex("#f2c85b"))
    -- Fox head & white snout
    cv:ellipse(mx, my, 4, 3, function(x, y, nx) return nx < 0 and hex("#f5f0ff") or hex("#cfc3eb") end)
    cv:set(mx - 2, my, hex("#2a203d")) -- tiny dark fox eye
    -- 4 distinct pink-tipped ears
    cv:line(mx - 2, my - 2, mx - 3, my - 6, hex("#c7b8eb")); cv:set(mx - 3, my - 6, hex("#f29cb8"))
    cv:line(mx, my - 3, mx + 1, my - 6, hex("#e5dff2")); cv:set(mx + 1, my - 6, hex("#f29cb8"))

    if dir == "up" then
      cv:ellipse(cx, hy + 1, 5, 5, function(x, y, nx) return nx < -0.2 and hex("#6e493f") or hex("#4f332c") end)
      cv:disc(cx + 2, hy - 3, 2, hex("#36201c"))
    else
      cv:ellipse(cx + (dir == "side" and 1 or 0), hy + 1, 4, 4, function(x, y, nx) return nx > 0.3 and hex("#d1a688") or hex("#f7dbc4") end)
      if dir == "down" then cv:set(cx - 2, hy + 2, hex("#2b1e24")); cv:set(cx + 2, hy + 2, hex("#2b1e24"))
      else cv:set(cx + 3, hy + 2, hex("#2b1e24")) end
      cv:ellipse(cx, hy - 2, 5, 3, hex("#593a32")); cv:disc(cx + 2, hy - 4, 2, hex("#36201c"))
      cv:rect(cx - 4, hy - 3, 3, 2, hex("#7ce8ff")); cv:set(cx - 4, hy - 3, hex("#ffffff"))
      cv:rect(cx + 1, hy - 3, 3, 2, hex("#7ce8ff")); cv:set(cx + 1, hy - 3, hex("#ffffff"))
    end
  end)

  -- 3. td_comp_kael (Sculpted broad Kintsugi ceramic knight + bold golden crack veins front & back!)
  emit_td_char("td_comp_kael", { { "down_walk", 4, 170 }, { "up_walk", 4, 170 }, { "side_walk", 4, 170 } }, function(cv, mode, fi)
    local step = (fi == 2 and -1) or (fi == 4 and 1) or 0
    local dir = (mode:find("up") and "up") or (mode:find("side") and "side") or "down"
    local bob = (fi == 2 or fi == 4) and 1 or 0
    local cx, cy = 16, 11 + bob
    local GOLD_H, GOLD = hex("#fff0a8"), hex("#f5c249")

    -- Armored greaves
    cv:rect(cx - 5 + (dir == "side" and step or 0), 27 + (fi == 2 and -1 or 0), 4, 5, hex("#9c968e"))
    cv:rect(cx + 1 - (dir == "side" and step or 0), 27 + (fi == 4 and -1 or 0), 4, 5, hex("#6b6662"))

    -- Tapered sculpted porcelain cuirass + rounded shoulder pauldrons (no boxy brick!)
    local w_top = (dir == "side") and 6 or 8
    local w_bot = (dir == "side") and 5 or 6
    cv:poly({ { cx - w_top, cy + 5 }, { cx + w_top, cy + 5 }, { cx + w_bot, 28 }, { cx - w_bot, 28 } }, function(x, y)
      local u = (x - (cx - w_top)) / (w_top * 2)
      if u < 0.25 then return hex("#fcf8f0")
      elseif u > 0.72 then return hex("#9e9890")
      else return hex("#ebe5d8") end
    end)
    if dir ~= "side" then
      cv:ellipse(cx - 8, cy + 8, 3, 3, hex("#faf6ee"))
      cv:ellipse(cx + 8, cy + 8, 3, 3, hex("#aba49b"))
      cv:line(cx - 9, cy + 7, cx - 6, cy + 10, GOLD)
    end

    if dir == "up" then
      -- Clear branching Kintsugi gold cracks on backplate + detailed copper cauldron
      cv:line(cx - 6, cy + 6, cx - 3, cy + 14, GOLD)
      cv:line(cx - 3, cy + 14, cx - 6, cy + 21, GOLD)
      cv:line(cx + 6, cy + 7, cx + 4, cy + 15, GOLD)
      cv:set(cx - 3, cy + 14, GOLD_H); cv:set(cx + 4, cy + 15, GOLD_H)
      cv:ellipse(cx, cy + 12, 5, 5, function(x, y, nx) return nx < 0 and hex("#d97c4e") or hex("#8a4024") end)
      cv:rect(cx - 4, cy + 7, 8, 2, GOLD); cv:rect(cx - 3, cy + 7, 3, 1, GOLD_H)
    else
      -- Prominent branching Kintsugi golden seams across chest & pauldron!
      cv:line(cx - 5, cy + 7, cx - 1, cy + 12, GOLD)
      cv:line(cx - 1, cy + 12, cx + 5, cy + 9, GOLD)
      cv:line(cx - 1, cy + 12, cx + 1, cy + 17, GOLD)
      cv:set(cx - 1, cy + 12, GOLD_H)
    end

    -- Rounded fluted helm with warm amber optics + golden forehead crack
    cv:ellipse(cx, cy, 5, 5, function(x, y, nx) return nx < -0.2 and hex("#fcf8f0") or (nx > 0.3 and hex("#9e9890") or hex("#ebe5d8")) end)
    cv:line(cx - 2, cy - 4, cx + 1, cy - 1, GOLD)
    if dir ~= "up" then
      cv:rect(cx - 3 + (dir == "side" and 2 or 0), cy, dir == "side" and 5 or 6, 2, hex("#2b2630"))
      cv:set(cx - 1 + (dir == "side" and 2 or 0), cy + 1, hex("#ffd88a"))
      if dir == "down" then cv:set(cx + 2, cy + 1, hex("#ffd88a")) end
    end
  end)

  -- 4. td_comp_mira (Flowing pleated indigo cloak, gold trim, layered bob, crystal abacus!)
  emit_td_char("td_comp_mira", { { "down_walk", 4, 150 }, { "up_walk", 4, 150 }, { "side_walk", 4, 150 } }, function(cv, mode, fi)
    local sway = (fi == 2 and -1) or (fi == 4 and 1) or 0
    local dir = (mode:find("up") and "up") or (mode:find("side") and "side") or "down"
    local bob = (fi == 2 or fi == 4) and 1 or 0
    local cx, hy, ty = 16, 11 + bob, 17 + bob

    -- Swaying pleated indigo merchant cloak
    cv:poly({ { cx - 4, ty }, { cx + 4, ty }, { cx + 7 + sway, 30 }, { cx - 7 + sway, 30 } }, function(x, y)
      local u = (x - (cx - 7)) / 14
      if u < 0.25 then return hex("#5570b5")
      elseif u > 0.72 then return hex("#202a52")
      else return hex("#3f548c") end
    end)
    -- Pleat shadow & ornate gold trim collar + scalloped hem
    cv:line(cx + sway, ty + 2, cx + sway, 28, hex("#263363"))
    cv:rect(cx - 6 + sway, 28, 12, 2, hex("#f0c259"))
    cv:set(cx - 3 + sway, 28, hex("#fff0a8"))
    if dir ~= "up" then
      cv:rect(cx - 2, ty, 4, 2, hex("#f0c259")) -- gold collar clasp
      local ay = ty + 4 + (fi % 2)
      cv:rect(cx + 4, ay, 5, 6, hex("#f0c259"))
      cv:rect(cx + 5, ay + 1, 3, 4, hex("#1d2642"))
      cv:set(cx + 6, ay + 2, hex("#8df5ff")); cv:set(cx + 7, ay + 4, hex("#8df5ff"))
    end
    if dir == "up" then
      cv:ellipse(cx, hy + 1, 5, 5, function(x, y, nx) return nx < -0.2 and hex("#36314d") or hex("#221e33") end)
      cv:rect(cx + 2, hy - 1, 2, 1, hex("#f0c259"))
    else
      cv:ellipse(cx + (dir == "side" and 1 or 0), hy + 1, 4, 4, function(x, y, nx) return nx > 0.3 and hex("#d4ad92") or hex("#fae2cf") end)
      if dir == "down" then cv:set(cx - 2, hy + 2, hex("#231f33")); cv:set(cx + 2, hy + 2, hex("#231f33"))
      else cv:set(cx + 3, hy + 2, hex("#231f33")) end
      cv:ellipse(cx, hy - 2, 5, 3, hex("#2c2842"))
      cv:rect(cx + 2, hy - 2, 2, 1, hex("#f0c259"))
    end
  end)
end

build_td_party()

-- ============================================================================
-- 12. SYNDICATE GUARD, WHALE PARASITE MITE & TOP-DOWN VAELEN REFLECTION
-- ============================================================================
local function build_extra_entities()
  -- 1. npc_syndicate_guard (40x50, anchor 20,44) — Lính gác Thương Đoàn Ngân Hàng Ký Ức
  do
    local W, H = 40, 50
    local INK = hex("#12131f")
    local frames, tags, idx = {}, {}, 1
    for _, sp in ipairs({ { "idle", 4, 240 }, { "halberd", 4, 180 } }) do
      local s_idx = idx
      for fi = 1, sp[2] do
        local sh = A.canvas(W, H); sh:ellipse(20, 45, 9, 3, hex("#080810", 125))
        local cv = A.canvas(W, H)
        local bob = (fi == 2 or fi == 3) and 1 or 0
        local cx, ty = 20, 19 + bob
        cv:rect(cx - 5, 36, 4, 8, hex("#232838")); cv:rect(cx + 1, 36, 4, 8, hex("#1a1e2b"))
        -- Stern slate-cobalt bank uniform & brass debt scale badge
        cv:poly({ { cx - 8, ty }, { cx + 8, ty }, { cx + 9, 38 }, { cx - 9, 38 } }, function(x, y) return bayer(x, y, hex("#4c5775"), hex("#2c3247"), (x - (cx - 9)) / 18) end)
        cv:rect(cx - 2, ty + 4, 4, 4, hex("#f0c259")); cv:set(cx, ty + 5, hex("#9be3ff"))
        -- Tall visorless iron shako helmet + cold frost slit
        cv:ellipse(cx, 12 + bob, 6, 7, hex("#3c4359"))
        cv:rect(cx - 5, 6 + bob, 10, 5, hex("#232738"))
        cv:rect(cx - 4, 12 + bob, 8, 2, hex("#8ff7ff"))
        -- Tax-Ledger Halberd / Debt Pike
        local tilt = (sp[1] == "halberd") and ((fi % 2 == 0) and 2 or 0) or 0
        cv:line(cx + 10, 44, cx + 10 - tilt, 6, hex("#8f99ad"), 2)
        cv:poly({ { cx + 8 - tilt, 7 }, { cx + 14 - tilt, 10 }, { cx + 10 - tilt, 17 } }, hex("#9be3ff"))
        cv:outline(INK, 120, hex("#59627d"))
        frames[idx] = { duration = sp[3], cels = { shadow = sh, body = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = sp[1], from = s_idx, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "shadow", "body" }, frames = frames, tags = tags }, OUT_DIR .. "npc_syndicate_guard.aseprite")
  end

  -- 2. cre_parasite_mite (36x28, anchor 18,22) — Bọ Ký Sinh hút quang trên lưng Kình Ngư (Hồi 2)
  do
    local W, H = 36, 28
    local frames, tags, idx = {}, {}, 1
    for _, mode in ipairs({ "cling", "removed" }) do
      local s_idx = idx
      for fi = 1, 4 do
        local cv = A.canvas(W, H)
        local cx, cy = 18, 16
        if mode == "cling" then
          local pulse = (fi % 2 == 0) and 1 or 0
          for _, lx in ipairs({ -10, -5, 5, 10 }) do cv:line(cx + lx * 0.5, cy + 2, cx + lx, cy + 7, hex("#382645"), 2) end
          cv:ellipse(cx, cy, 9, 6, function(x, y, nx) return nx > 0.2 and hex("#523466") or hex("#7d4c8c") end)
          cv:disc(cx, cy - 1, 3 + pulse, hex("#9be3ff")) -- stolen whale aether!
          cv:set(cx - 4, cy + 2, hex("#ff6e6e")); cv:set(cx + 4, cy + 2, hex("#ff6e6e"))
          cv:outline(hex("#181020"), 120)
        else
          -- Cleared whale skin glowing calm seafoam-gold after mite removal!
          cv:add_glow(cx, cy, 10 + (fi % 2) * 3, hex("#8ff5e8"), 150)
          cv:disc(cx, cy, 3, hex("#fff4c4"))
          cv:set(cx - 5, cy - 3 - fi, hex("#8ff5e8")); cv:set(cx + 5, cy - 2 - fi, hex("#ffd66b"))
        end
        frames[idx] = { duration = 220, cels = { body = cv } }
        idx = idx + 1
      end
      table.insert(tags, { name = mode, from = s_idx, to = idx - 1 })
    end
    A.build_sprite({ w = W, h = H, layers = { "body" }, frames = frames, tags = tags }, OUT_DIR .. "cre_parasite_mite.aseprite")
  end

  -- 3. td_boss_vaelen (36x42, anchor 18,36) — Bóng Top-Down dùng cho nháy sấm 0.1s dưới nước Hồi 3!
  do
    local W, H = 36, 42
    local frames = {}
    for fi = 1, 2 do
      local sh = A.canvas(W, H)
      sh:ellipse(18, 37, 9, 3, hex("#06050e", 145))
      local cv = A.canvas(W, H)
      local cx = 18
      -- Flowing architectural ivory-lavender mantle with rim light & gold stole
      cv:poly({ { cx - 6, 17 }, { cx + 6, 17 }, { cx + 9, 36 }, { cx - 9, 36 } }, function(x, y)
        local u = (x - (cx - 9)) / 18
        if u < 0.22 then return hex("#f2effa")
        elseif u > 0.72 then return hex("#9e97b5")
        else return hex("#d8d3e8") end
      end)
      cv:rect(cx - 8, 17, 16, 2, hex("#b5b0c7")) -- shoulder mantle collar
      cv:rect(cx - 2, 18, 4, 17, hex("#e3c87b"))
      -- Stark horizontal surgical chest scar + cold Memoria core pulse
      cv:line(cx - 5, 23, cx + 5, 23, hex("#8f3f52"), 2)
      cv:disc(cx, 23, 1, fi == 1 and hex("#9be3ff") or hex("#ffffff"))
      -- Sculpted gaunt face + piercing white-cyan hollow eyes + tall swept silver locks
      cv:ellipse(cx, 12, 5, 5, function(x, y, nx) return nx > 0.3 and hex("#b6b0c7") or hex("#e8e4f2") end)
      cv:line(cx - 4, 11, cx - 1, 12, hex("#524d66"))
      cv:line(cx + 1, 12, cx + 4, 11, hex("#524d66"))
      cv:rect(cx - 3, 12, 2, 2, hex("#ffffff")); cv:rect(cx + 1, 12, 2, 2, hex("#ffffff"))
      cv:ellipse(cx, 7, 6, 4, function(x, y, nx, ny) return ny < 0 and hex("#ffffff") or hex("#cfd8eb") end)
      cv:poly({ { cx - 6, 9 }, { cx - 3, 12 }, { cx, 8 }, { cx + 3, 12 }, { cx + 6, 9 }, { cx + 4, 5 }, { cx - 4, 5 } }, hex("#eef2fa"))
      cv:outline(hex("#151320"), 120, hex("#595270"))
      frames[fi] = { duration = 200, cels = { shadow = sh, body = cv } }
    end
    A.build_sprite({ w = W, h = H, layers = { "shadow", "body" }, frames = frames, tags = { { name = "down", from = 1, to = 2 } } }, OUT_DIR .. "td_boss_vaelen.aseprite")
  end
end

build_extra_entities()
print("BUILD_HOLLOW_CHARS_OK")
