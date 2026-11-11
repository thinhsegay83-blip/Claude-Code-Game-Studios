# Đặc tả sprite: Trong · Hồi 1 · Đợt 1 (4 nhân vật chính)

> PROTOTYPE - NOT FOR PRODUCTION. Nguồn: `prototypes/trong/brief.md` (Look), `HANDOVER_STORY_V2.md` (nhân vật).

## 1. Khung chung

| Mục | Quy định |
|---|---|
| Độ phân giải nghệ thuật | **640×360**, game phóng **×2** lên 1280×720 (`sprite_scale` trong `config.js`) |
| Một điểm ảnh | luôn là 2×2 trên màn hình; game làm tròn vị trí theo bội 2, không bao giờ nằm lệch nửa điểm |
| Khử răng cưa | **Không.** Không dùng màu trung gian để làm mềm cạnh |
| Bảng màu | chỉ dùng `art/trong.gpl` (27 màu). Thiếu màu thì đề xuất thêm vào bảng, không tự pha |
| Viền | viền 1 điểm ảnh màu `k` ở mép ngoài; mép phía có ánh sáng có thể thay viền bằng màu bóng (sel-out) |
| Ánh sáng | từ **trên xuống, hơi chếch trước mặt**: Lõi Nhịp Tim treo giữa trời. Đổ bóng 2 tông: sáng, bóng; tối nhất là `K` |
| Hướng | vẽ **quay mặt sang phải**. Game tự lật khi đi sang trái |
| Mốc neo | **chân chạm hàng điểm ảnh cuối cùng**, nhân vật **canh giữa theo chiều ngang**. Game đặt điểm giữa đáy của khung vào vị trí đứng |
| Độ sáng | Kẻ Trắng Tay là hình **sáng nhất** màn hình (áo `w`); ba người bạn tối hơn một bậc |
| Cấm | emoji, chữ, logo; bắt chước nhân vật của game khác (Undertale hay bất kỳ game nào) |

## 2. Danh sách sprite đợt 1

| id (tên tệp) | Khung | Tag và số frame | Nhận diện (phải đọc được ở cỡ thật) |
|---|---|---|---|
| `hero` | 32×48 | `idle` 4 · `walk` 6 | Kẻ Trắng Tay: dáng mảnh, áo khoác dài bạc màu (`w`/`W`), tóc rối tối (`h`), khăn quàng hổ phách (`o`/`O`) bay sau lưng, một mảnh kén hổ phách (`y`) bám trên vai trái |
| `linh` | 32×44 | `idle` 4 · `walk` 6 | Linh: thấp, áo thợ xanh xám (`b`/`B`), kính bảo hộ đồng trên trán (`g`), ống nghe đồng vắt cổ (`g`/`G`), cờ-lê thép (`m`) bên hông; **chú cáo Mốc** (`f`/`F`) cuộn trên vai, đuôi buông xuống |
| `kael` | 48×56 | `idle` 4 · `walk` 6 | Kaelen: to lớn, giáp gốm trắng ngà (`c`/`C`) chằng chịt **vết nứt hàn vàng** (`u`, nét gãy khúc, ít nhất 3 vết), mũ giáp kín có khe mắt, **nồi súp** (`p`) đeo trên lưng |
| `mira` | 32×52 | `idle` 4 · `walk` 6 | Mira: cao, áo dài cổ cao tím (`v`/`V`), tóc đen búi cao (`n`), **bàn tính pha lê** (`x`) cầm trước người, dáng thẳng, cằm hơi ngẩng |
| `hero_face` | 48×48 | `neutral` `happy` `sad` `think` `awe` `afraid`, mỗi tag 1 frame | Chân dung hộp thoại, từ vai trở lên, quay ¾ sang phải. Mỗi nét mặt khác nhau ở **mắt và miệng** |
| `linh_face` | 48×48 | như trên | có kính đồng trên trán; Mốc thò đầu ở vai |
| `kael_face` | 48×48 | như trên | mũ giáp gốm; nét mặt đọc qua khe mắt và độ nghiêng mũ; vết hàn vàng chạy qua má |
| `mira_face` | 48×48 | như trên | búi tóc, khuyên tai pha lê |

**Thời lượng:** `idle` 180 ms/frame (thở nhẹ: vai lên xuống 1 điểm ảnh, khăn/đuôi/tóc lay), `walk` 100 ms/frame (chu kỳ 6 bước, đầu nảy 1 điểm ảnh). Chân dung không động.

**Phân biệt bằng dáng, không chỉ bằng màu:** tô đen hết 4 nhân vật thì vẫn phải nhận ra ai là ai (Kaelen to vuông và có nồi; Mira cao thẳng; Linh thấp và có Mốc trên vai; Kẻ Trắng Tay mảnh, khăn bay).

## 3. Cách vẽ (Claude trên máy MSI)

Mỗi sprite là một tệp chữ `art/maps/<id>.txt`; `art/pixelmap.lua` biến nó thành `assets/sprites/<id>.aseprite`, rồi `art/export.ps1` xuất ra PNG, JSON và `sprites.js`. Sau đó người dùng có thể mở `.aseprite` để chỉnh tay; khi đã chỉnh tay thì chạy `export.ps1 -SkipMaps` để không ghi đè.

```text
# hero.txt: mỗi dòng lưới đúng 32 ký tự, mỗi frame đúng 48 dòng
@legend k #1a1420
@legend w #f4ecdc
...
@duration idle 180
@duration walk 100
@frame idle
................................
...(48 dòng)...
@frame idle
...
@frame walk
...
```

Khoá màu (`@legend`) lấy đúng ký tự và mã màu ở cột chú thích của `art/trong.gpl`; `.` là trong suốt.

## 4. Kiểm tra trước khi giao

1. `export.ps1` chạy không lỗi; có `assets/sprites/<id>.png`, `<id>.json` và `sprites.js` mới.
2. Xuất thêm một ảnh xem trước phóng ×4 của mọi frame và **tự nhìn**: viền liền, không điểm lạc, chân không trôi giữa các frame đi, dáng 4 người khác nhau khi tô đen.
3. Mở `prototypes/trong/index.html?scene=figures`: 4 nhân vật hiện bằng sprite, đứng trên cùng đường đáy với hình vẽ code của sinh vật.
4. Ghi mỗi tệp vào `assets/provenance.yaml`: `origin: ai`, `tool: "aseprite + art/pixelmap.lua"`, `ships: true`, `placeholder: true` cho đến khi người dùng duyệt nét vẽ.
