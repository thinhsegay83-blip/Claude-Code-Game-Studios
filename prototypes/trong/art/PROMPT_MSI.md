# Prompt cho Claude Code trên máy MSI: vẽ sprite đợt 1 bằng Aseprite

> PROTOTYPE - NOT FOR PRODUCTION. Dán toàn bộ khối dưới đây vào Claude Code mở **trên máy MSI**, trong thư mục repo `Claude-Code-Game-Studios`, sau khi đã `git pull` nhánh `claude/awesome-fermi-b3iszg`.

```text
Bạn vẽ sprite pixel cho game "Trong" (prototypes/trong) bằng Aseprite cài trên máy này. Trả lời tôi bằng tiếng Việt, gọn.

ĐỌC TRƯỚC (đừng đọc cả repo):
- prototypes/trong/art/SPRITE_SPEC.md   ← quy định bắt buộc: khung, bảng màu, tag, neo, ánh sáng, cách kiểm tra
- prototypes/trong/art/trong.gpl        ← 27 màu, cột chú thích là ký tự khoá
- prototypes/trong/art/pixelmap.lua     ← biến art/maps/<id>.txt thành .aseprite
- prototypes/trong/art/export.ps1       ← dựng + xuất PNG/JSON + sprites.js
- prototypes/trong/brief.md, mục "Look and references"

BƯỚC 0 · Kiểm tra máy, DỪNG nếu thiếu:
- Tìm Aseprite: `aseprite --version`, hoặc C:\Program Files\Aseprite\Aseprite.exe, hoặc ...\Steam\steamapps\common\Aseprite\Aseprite.exe.
- Không có Aseprite thì DỪNG và báo tôi. KHÔNG tự cài, không tải bản lậu: Aseprite là phần mềm trả phí.
- Hỏi tôi trước mọi thao tác xoá file hay cài gói.

BƯỚC 1 · Thử đường ống với một sprite nhỏ:
- Viết art/maps/hero.txt chỉ với 1 frame `idle` để thử, chạy `.\art\export.ps1` trong thư mục prototypes/trong.
- pixelmap.lua và export.ps1 được viết ở máy cloud KHÔNG có Aseprite, chưa chạy thử lần nào. Nếu lỗi API (newEmptyFrame, newCel, newTag, saveAs, cờ CLI), sửa hai tệp đó cho đúng phiên bản Aseprite trên máy, ghi lại đã sửa gì.

BƯỚC 2 · Vẽ đợt 1 (đúng SPRITE_SPEC.md mục 2):
- hero, linh, kael, mira: idle 4 frame + walk 6 frame.
- hero_face, linh_face, kael_face, mira_face: 6 nét mặt (neutral happy sad think awe afraid), 48×48.
- Vẽ bằng lưới ký tự trong art/maps/<id>.txt. Mỗi dòng lưới phải đúng chiều rộng khung, mỗi frame đúng chiều cao.
- Làm từng nhân vật một: vẽ, xuất, XEM ảnh, sửa, rồi mới sang người kế.

BƯỚC 3 · Tự nhìn và sửa (bắt buộc, không bỏ qua):
- Xuất ảnh xem trước phóng ×4 của mọi frame (ví dụ `aseprite -b <id>.aseprite --scale 4 --sheet preview_<id>.png`), mở ra NHÌN.
- Đạt khi: viền liền, không điểm lạc, chân không trôi giữa các frame walk, tô đen cả 4 người vẫn nhận ra từng người (Kaelen to vuông có nồi; Mira cao thẳng; Linh thấp có Mốc; Kẻ Trắng Tay mảnh, khăn bay), 6 nét mặt khác nhau rõ ở mắt và miệng.
- Mở prototypes/trong/index.html?scene=figures bằng trình duyệt, chụp màn hình, xem 4 nhân vật đã là sprite và đứng đúng đường đáy.

BƯỚC 4 · Ghi nguồn gốc và bàn giao:
- Thêm mỗi tệp trong assets/sprites vào prototypes/trong/assets/provenance.yaml: origin: ai, tool: "aseprite + art/pixelmap.lua", ships: true, placeholder: true.
- Không xoá ảnh preview_*.png vào repo: để chúng ở thư mục tạm.
- Hỏi tôi trước khi commit. Khi tôi đồng ý: commit đúng các tệp đã đổi, thông điệp "art: sprite đợt 1 (4 nhân vật) bằng Aseprite", rồi push nhánh claude/awesome-fermi-b3iszg.
- Báo lại: tệp nào mới/đổi, đã sửa gì ở pixelmap.lua/export.ps1, ảnh chụp scene=figures, và chỗ nào bạn chưa ưng ý.

KHÔNG ĐƯỢC: dùng màu ngoài trong.gpl, khử răng cưa, chép nhân vật của game khác (kể cả Undertale), sửa index.html/story.js/config.js (game đã tự nạp sprite khi có).
```
