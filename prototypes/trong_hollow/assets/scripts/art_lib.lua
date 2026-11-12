-- art_lib.lua: Pixel-art buffer & Aseprite sprite builder for "Trong"
-- Provides crisp software rasterization (curves, polygons, ellipses, Bayer dither,
-- selective darkened outlines, rim lighting, glow halos) exported cleanly to .aseprite.

local M = {}

local BAYER4 = {
  {  0,  8,  2, 10 },
  { 12,  4, 14,  6 },
  {  3, 11,  1,  9 },
  { 15,  7, 13,  5 },
}

function M.hex(s, a)
  s = s:gsub("#", "")
  local r = tonumber(s:sub(1, 2), 16)
  local g = tonumber(s:sub(3, 4), 16)
  local b = tonumber(s:sub(5, 6), 16)
  return { r, g, b, a or 255 }
end

function M.rgba(r, g, b, a)
  return {
    math.max(0, math.min(255, math.floor(r + 0.5))),
    math.max(0, math.min(255, math.floor(g + 0.5))),
    math.max(0, math.min(255, math.floor(b + 0.5))),
    math.max(0, math.min(255, math.floor((a or 255) + 0.5))),
  }
end

function M.mix(c1, c2, t)
  t = math.max(0, math.min(1, t))
  return {
    math.floor(c1[1] + (c2[1] - c1[1]) * t + 0.5),
    math.floor(c1[2] + (c2[2] - c1[2]) * t + 0.5),
    math.floor(c1[3] + (c2[3] - c1[3]) * t + 0.5),
    math.floor((c1[4] or 255) + ((c2[4] or 255) - (c1[4] or 255)) * t + 0.5),
  }
end

function M.bayer_pick(x, y, c1, c2, t)
  t = math.max(0, math.min(1, t))
  local th = (BAYER4[(math.floor(y) % 4) + 1][(math.floor(x) % 4) + 1] + 0.5) / 16.0
  return (t > th) and c2 or c1
end

local Canvas = {}
Canvas.__index = Canvas

function M.canvas(w, h)
  local px = {}
  for i = 1, w * h do px[i] = false end
  return setmetatable({ w = w, h = h, px = px }, Canvas)
end

function Canvas:clone()
  local c = M.canvas(self.w, self.h)
  for i = 1, self.w * self.h do
    local p = self.px[i]
    if p then c.px[i] = { p[1], p[2], p[3], p[4] } end
  end
  return c
end

function Canvas:inb(x, y)
  return x >= 0 and y >= 0 and x < self.w and y < self.h
end

function Canvas:get(x, y)
  x = math.floor(x); y = math.floor(y)
  if not self:inb(x, y) then return nil end
  local p = self.px[y * self.w + x + 1]
  return p or nil
end

function Canvas:set(x, y, c)
  x = math.floor(x); y = math.floor(y)
  if not self:inb(x, y) then return end
  if not c or (c[4] or 255) <= 0 then
    self.px[y * self.w + x + 1] = false
  else
    self.px[y * self.w + x + 1] = { c[1], c[2], c[3], c[4] or 255 }
  end
end

function Canvas:blend(x, y, c)
  x = math.floor(x); y = math.floor(y)
  if not self:inb(x, y) or not c then return end
  local sa = (c[4] or 255) / 255.0
  if sa <= 0 then return end
  local idx = y * self.w + x + 1
  local dst = self.px[idx]
  if not dst or sa >= 0.999 then
    self.px[idx] = { c[1], c[2], c[3], math.floor(sa * 255 + 0.5) }
    return
  end
  local da = dst[4] / 255.0
  local oa = sa + da * (1 - sa)
  if oa <= 0 then return end
  self.px[idx] = {
    math.floor((c[1] * sa + dst[1] * da * (1 - sa)) / oa + 0.5),
    math.floor((c[2] * sa + dst[2] * da * (1 - sa)) / oa + 0.5),
    math.floor((c[3] * sa + dst[3] * da * (1 - sa)) / oa + 0.5),
    math.floor(oa * 255 + 0.5),
  }
end

function Canvas:add_glow(cx, cy, r, c, max_alpha)
  max_alpha = max_alpha or 110
  local r2 = r * r
  local x0 = math.max(0, math.floor(cx - r))
  local x1 = math.min(self.w - 1, math.ceil(cx + r))
  local y0 = math.max(0, math.floor(cy - r))
  local y1 = math.min(self.h - 1, math.ceil(cy + r))
  for y = y0, y1 do
    for x = x0, x1 do
      local dx = x - cx
      local dy = y - cy
      local d2 = dx * dx + dy * dy
      if d2 <= r2 then
        local falloff = 1.0 - math.sqrt(d2) / r
        local a = falloff * falloff * max_alpha
        if a >= 8 then
          -- subtle pixel dither step for organic retro glow
          local th = BAYER4[(y % 4) + 1][(x % 4) + 1] / 16.0
          if falloff > 0.35 or (falloff * 2.5) > th then
            self:blend(x, y, { c[1], c[2], c[3], math.floor(a) })
          end
        end
      end
    end
  end
end

function Canvas:rect(x, y, w, h, c)
  for py = math.floor(y), math.floor(y + h - 1) do
    for px = math.floor(x), math.floor(x + w - 1) do
      self:blend(px, py, c)
    end
  end
end

function Canvas:line(x0, y0, x1, y1, c, thick)
  x0 = math.floor(x0 + 0.5); y0 = math.floor(y0 + 0.5)
  x1 = math.floor(x1 + 0.5); y1 = math.floor(y1 + 0.5)
  local dx = math.abs(x1 - x0)
  local dy = -math.abs(y1 - y0)
  local sx = x0 < x1 and 1 or -1
  local sy = y0 < y1 and 1 or -1
  local err = dx + dy
  local rad = thick and math.floor(thick / 2) or 0
  while true do
    if rad > 0 then
      self:disc(x0, y0, rad, c)
    else
      self:blend(x0, y0, c)
    end
    if x0 == x1 and y0 == y1 then break end
    local e2 = 2 * err
    if e2 >= dy then err = err + dy; x0 = x0 + sx end
    if e2 <= dx then err = err + dx; y0 = y0 + sy end
  end
end

function Canvas:disc(cx, cy, r, c)
  local r2 = (r + 0.35) * (r + 0.35)
  for y = math.floor(cy - r - 1), math.ceil(cy + r + 1) do
    for x = math.floor(cx - r - 1), math.ceil(cx + r + 1) do
      local dx = x - cx
      local dy = y - cy
      if dx * dx + dy * dy <= r2 then
        self:blend(x, y, c)
      end
    end
  end
end

function Canvas:ellipse(cx, cy, rx, ry, c_or_fn)
  if rx <= 0 or ry <= 0 then return end
  local x0 = math.max(0, math.floor(cx - rx - 1))
  local x1 = math.min(self.w - 1, math.ceil(cx + rx + 1))
  local y0 = math.max(0, math.floor(cy - ry - 1))
  local y1 = math.min(self.h - 1, math.ceil(cy + ry + 1))
  for y = y0, y1 do
    for x = x0, x1 do
      local nx = (x - cx) / rx
      local ny = (y - cy) / ry
      if nx * nx + ny * ny <= 1.0 then
        local c
        if type(c_or_fn) == "function" then c = c_or_fn(x, y, nx, ny) else c = c_or_fn end
        if c then self:blend(x, y, c) end
      end
    end
  end
end

function Canvas:poly(pts, c_or_fn)
  local n = #pts
  if n < 3 then return end
  local miny, maxy = pts[1][2], pts[1][2]
  for i = 2, n do
    if pts[i][2] < miny then miny = pts[i][2] end
    if pts[i][2] > maxy then maxy = pts[i][2] end
  end
  miny = math.max(0, math.floor(miny))
  maxy = math.min(self.h - 1, math.ceil(maxy))
  for y = miny, maxy do
    local py = y + 0.5
    local xs = {}
    local j = n
    for i = 1, n do
      local yi, yj = pts[i][2], pts[j][2]
      local xi, xj = pts[i][1], pts[j][1]
      if ((yi <= py and yj > py) or (yj <= py and yi > py)) then
        xs[#xs + 1] = xi + (py - yi) / (yj - yi) * (xj - xi)
      end
      j = i
    end
    table.sort(xs)
    for k = 1, #xs - 1, 2 do
      local x0 = math.max(0, math.floor(xs[k] + 0.5))
      local x1 = math.min(self.w - 1, math.floor(xs[k + 1] - 0.5))
      for x = x0, x1 do
        local c
        if type(c_or_fn) == "function" then c = c_or_fn(x, y) else c = c_or_fn end
        if c then self:blend(x, y, c) end
      end
    end
  end
end

function Canvas:quad_bezier_pts(p0, p1, p2, steps)
  steps = steps or 16
  local out = {}
  for i = 0, steps do
    local t = i / steps
    local u = 1 - t
    local x = u * u * p0[1] + 2 * u * t * p1[1] + t * t * p2[1]
    local y = u * u * p0[2] + 2 * u * t * p1[2] + t * t * p2[2]
    out[#out + 1] = { x, y }
  end
  return out
end

function Canvas:bezier_stroke(p0, p1, p2, c, thick, steps)
  local pts = self:quad_bezier_pts(p0, p1, p2, steps or 18)
  for i = 1, #pts - 1 do
    self:line(pts[i][1], pts[i][2], pts[i + 1][1], pts[i + 1][2], c, thick)
  end
end

-- Add 1px pixel-art outline around opaque pixels (4-neighborhood for crisp pixel art)
function Canvas:outline(ink_color, alpha_thresh, selout_top)
  alpha_thresh = alpha_thresh or 100
  local snap = self:clone()
  for y = 0, self.h - 1 do
    for x = 0, self.w - 1 do
      local p = snap:get(x, y)
      if not p or p[4] < alpha_thresh then
        local up    = snap:get(x, y - 1)
        local down  = snap:get(x, y + 1)
        local left  = snap:get(x - 1, y)
        local right = snap:get(x + 1, y)
        local has_u = up and up[4] >= alpha_thresh
        local has_d = down and down[4] >= alpha_thresh
        local has_l = left and left[4] >= alpha_thresh
        local has_r = right and right[4] >= alpha_thresh
        if has_u or has_d or has_l or has_r then
          local col = ink_color
          if selout_top and has_d and not has_u then
            col = selout_top
          end
          self:set(x, y, col)
        end
      end
    end
  end
end

-- Apply directional rim-light / top-left highlight and bottom-right shadow to existing silhouette
function Canvas:shade_silhouette(light_col, shadow_col, dx, dy, alpha_thresh)
  dx = dx or -1; dy = dy or -1
  alpha_thresh = alpha_thresh or 180
  local snap = self:clone()
  for y = 0, self.h - 1 do
    for x = 0, self.w - 1 do
      local p = snap:get(x, y)
      if p and p[4] >= alpha_thresh then
        local nl = snap:get(x + dx, y + dy)
        local ns = snap:get(x - dx, y - dy)
        if light_col and (not nl or nl[4] < alpha_thresh) then
          self:set(x, y, M.mix(p, light_col, 0.55))
        elseif shadow_col and (not ns or ns[4] < alpha_thresh) then
          self:set(x, y, M.mix(p, shadow_col, 0.45))
        end
      end
    end
  end
end

-- Stamp another canvas onto this one
function Canvas:stamp(other, ox, oy, flip_x)
  ox = math.floor(ox or 0); oy = math.floor(oy or 0)
  for y = 0, other.h - 1 do
    for x = 0, other.w - 1 do
      local sx = flip_x and (other.w - 1 - x) or x
      local p = other:get(sx, y)
      if p then
        self:blend(ox + x, oy + y, p)
      end
    end
  end
end

function Canvas:to_image()
  local img = Image(self.w, self.h, ColorMode.RGBA)
  local rgba = app.pixelColor.rgba
  for y = 0, self.h - 1 do
    local row = y * self.w + 1
    for x = 0, self.w - 1 do
      local p = self.px[row + x]
      if p and p[4] > 0 then
        img:putPixel(x, y, rgba(p[1], p[2], p[3], p[4]))
      end
    end
  end
  return img
end

-- Build a multi-layer, multi-frame, tagged Aseprite Sprite from a spec table:
-- spec = {
--   w = 40, h = 48,
--   layers = { "shadow", "body", ... },
--   frames = {
--     { duration = 180, cels = { shadow = canvas, body = canvas, ... } },
--     ...
--   },
--   tags = {
--     { name = "idle", from = 1, to = 4 },
--   },
--   palette = { c1, c2, ... } -- optional
-- }
function M.build_sprite(spec, out_ase_path)
  local spr = Sprite(spec.w, spec.h, ColorMode.RGBA)
  if spec.palette and #spec.palette > 0 then
    local pal = Palette(#spec.palette)
    for i, c in ipairs(spec.palette) do
      pal:setColor(i - 1, Color{ r = c[1], g = c[2], b = c[3], a = c[4] or 255 })
    end
    spr:setPalette(pal)
  end

  local layers = {}
  spr.layers[1].name = spec.layers[1]
  layers[spec.layers[1]] = spr.layers[1]
  for i = 2, #spec.layers do
    local l = spr:newLayer()
    l.name = spec.layers[i]
    layers[spec.layers[i]] = l
  end

  for f_idx, fspec in ipairs(spec.frames) do
    local frame
    if f_idx == 1 then
      frame = spr.frames[1]
    else
      frame = spr:newEmptyFrame(f_idx)
    end
    frame.duration = (fspec.duration or 150) / 1000.0
    for _, lname in ipairs(spec.layers) do
      local cbuf = fspec.cels[lname]
      if cbuf then
        local img = cbuf:to_image()
        if f_idx == 1 and lname == spec.layers[1] then
          spr.cels[1].image = img
          spr.cels[1].position = Point(0, 0)
        else
          spr:newCel(layers[lname], frame, img, Point(0, 0))
        end
      end
    end
  end

  if spec.tags then
    for _, t in ipairs(spec.tags) do
      local tag = spr:newTag(t.from, t.to)
      tag.name = t.name
      if t.aniDir then tag.aniDir = t.aniDir end
    end
  end

  spr:saveAs(out_ase_path)
  spr:close()
end

return M
