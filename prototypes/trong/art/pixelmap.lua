-- PROTOTYPE - NOT FOR PRODUCTION
-- Biến một bản vẽ bằng chữ (art/maps/<id>.txt) thành file Aseprite có frame, tag và thời lượng.
-- Chạy:  aseprite -b --script-param in=art/maps/hero.txt --script-param out=assets/sprites/hero.aseprite --script art/pixelmap.lua
-- Định dạng tệp .txt (xem art/SPRITE_SPEC.md):
--   @legend <ký tự> #rrggbb     một màu; "." luôn là trong suốt
--   @duration <tag> <ms>        thời lượng mỗi frame của tag đó (mặc định 100)
--   @frame <tag>                bắt đầu một frame thuộc tag; các dòng sau là lưới điểm ảnh
--   dòng bắt đầu bằng "#" và dòng trống bị bỏ qua (trong lưới, dùng "." cho chỗ trống)
-- Các frame cùng tag phải đứng liền nhau. Mọi frame phải cùng kích thước.
-- [CHƯA CHẠY THỬ trên Aseprite thật: viết ở máy cloud không có Aseprite; Claude trên MSI chạy và sửa nếu API lệch.]

local inPath, outPath = app.params["in"], app.params["out"]
if not inPath or not outPath then error("Cần --script-param in=<tệp .txt> --script-param out=<tệp .aseprite>") end

local legend, durations, frames, cur = {}, {}, {}, nil
local n = 0
for raw in io.lines(inPath) do
  n = n + 1
  local line = raw:gsub("\r$", "")
  if line:match("^@legend") then
    local k, hex = line:match("^@legend%s+(%S)%s+#?(%x%x%x%x%x%x)")
    if not k then error(inPath .. ":" .. n .. ": @legend sai dạng, cần '@legend a #rrggbb'") end
    legend[k] = { tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16) }
  elseif line:match("^@duration") then
    local tag, ms = line:match("^@duration%s+(%S+)%s+(%d+)")
    durations[tag] = tonumber(ms)
  elseif line:match("^@frame") then
    cur = { tag = line:match("^@frame%s+(%S+)"), rows = {}, line = n }
    table.insert(frames, cur)
  elseif line:match("^#") or line:match("^%s*$") then
    -- chú thích hoặc dòng trống
  elseif cur then
    table.insert(cur.rows, line)
  end
end
if #frames == 0 then error(inPath .. ": không có @frame nào") end

local h, w = #frames[1].rows, #frames[1].rows[1]
for i, f in ipairs(frames) do
  if #f.rows ~= h then error(inPath .. ":" .. f.line .. ": frame " .. i .. " cao " .. #f.rows .. " dòng, cần " .. h) end
  for y, row in ipairs(f.rows) do
    if #row ~= w then error(inPath .. ":" .. (f.line + y) .. ": dòng rộng " .. #row .. ", cần " .. w) end
  end
end

local spr = Sprite(w, h, ColorMode.RGB)
local layer = spr.layers[1]
layer.name = "body"
for i = 2, #frames do spr:newEmptyFrame() end

for i, f in ipairs(frames) do
  local img = Image(w, h, ColorMode.RGB)
  for y, row in ipairs(f.rows) do
    for x = 1, w do
      local ch = row:sub(x, x)
      if ch ~= "." then
        local c = legend[ch]
        if not c then error(inPath .. ":" .. (f.line + y) .. ": ký tự '" .. ch .. "' chưa có @legend") end
        img:drawPixel(x - 1, y - 1, app.pixelColor.rgba(c[1], c[2], c[3], 255))
      end
    end
  end
  local cel = layer:cel(i)
  if cel then cel.image = img; cel.position = Point(0, 0) else spr:newCel(layer, i, img, Point(0, 0)) end
  spr.frames[i].duration = (durations[f.tag] or 100) / 1000
end

local i = 1
while i <= #frames do -- mỗi dãy frame cùng tag thành một tag của Aseprite
  local j = i
  while j < #frames and frames[j + 1].tag == frames[i].tag do j = j + 1 end
  local tag = spr:newTag(i, j)
  tag.name = frames[i].tag
  i = j + 1
end

spr:saveAs(outPath)
print("ok " .. outPath .. " " .. w .. "x" .. h .. " " .. #frames .. " frame")
