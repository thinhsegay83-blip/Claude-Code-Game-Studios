# Game Brief: Trong — Hồi 1 · Kẻ Trắng Tay

## In your words
(Lời gốc đầy đủ của game làng Li nằm trong git, ở mốc `one-shot/trong` / `2d8a4da`. Game này thay thế nó theo lựa chọn của bạn.)

Tài liệu cốt truyện: `prototypes/trong/HANDOVER_STORY_V2.md` (HANDOVER STORY & WORLD BIBLE — Cốt Truyện Chính 4 Hồi, Thế Giới Tinh Cầu Rỗng, Sinh Vật Viễn Tưởng, Nhóm Bạn Đồng Hành, Kinh Tế Kép, thoại "tôi - cậu").

After play: bỏ phần đánh theo lượt, thiết kế lại cơ chế gameplay mới, khi mà tiến vào ột màn đấu boss thì boss sẽ đứng ở phía trên màn hình tung skill chúng ta phải né skill và đợi phản đòn. giống của undertale nhưng ta sẽ cải tiến thêm
After play: Cốt truyện = File 2 thay thế Trong · Lượt đầu = Hồi 1 file 2 + né đòn
After play: sử dụng aseprite trên máy tính để thiết kế · Ai vẽ = Claude trên máy MSI vẽ · Độ phân giải = 640×360, phóng ×2 · Đợt đầu = 4 nhân vật chính
After play: Xây dựng các gameplay giải đố cho game đi · Chọn: 1. Nghe mạch (Linh), 2. Cửa đá hát (Hồ Ly), 4. Tia sáng (Mira), 3 + 5 (Lò cua, Cân thử) · Bắt buộc? = Trộn
After play: các câu đố phải giải bằng cách tương tác, tìm manh mối sau đó giải quyết chứ không nên làm các thao tác đơn giản · Duyệt = Làm 3 câu trước · Khoá gương = Giữ, thêm tìm gương
After play: bạn hãy giành thời nghiên cứu và phát triển cơ chế giải đố · Duyệt = làm nền trước (Bốn cách hỏi + Bàn Ghép + Sổ 2.0) · tài liệu: prototypes/trong/PUZZLE_RESEARCH.md
After play: Thiết kế cơ chế đánh boss · Duyệt = làm nền + trận cua · tài liệu: prototypes/trong/BOSS_DESIGN.md
After play: review lại cơ chế đánh boss và điểm hạn chế cần cải tiến · Chọn = A+B (hỏi bằng hành động, phản đòn bấm E), D+F (nhịp mới, gục có giá), G (nhắc, hỗ trợ; chuyển Cân và Bọ để sau) · tài liệu: BOSS_DESIGN.md mục 6
After play: Làm bước 6 trong BOSS_DESIGN.md: chuyển Cân Định Giá và Bọ Ký Sinh sang engine boss mới, rồi xoá engine cũ · Duyệt = làm cả 6.1–6.5
After play: bỏ phần cân định giá đi, thay cơ chế đánh boss bằng đối đầu với boss, né chiêu trong thế giới topdown 2d sau đó thì phản công sau né tránh · Phản công = 2 lựa chọn: đánh, hoặc chữa lành / giải cứu boss, ra đòn khi boss mệt · Chữa lành = phải hiểu trước · Phím = E chữa lành, F đánh · Lượt này = trận cua trước (bản đồ top-down do phiên khác làm)
After play: Prompt vai trò: Story-to-Systems, Data-Driven, StoryStateManager cho các biến Bước 4, Event Bus, phản hồi vi mô kiểu Undertale, đề xuất cải tiến gameplay.

**Pitch:** Bạn tỉnh dậy trong một cái kén hổ phách vỡ, trắng tay và mất trí nhớ, bên trong lòng một tinh cầu rỗng; mỗi sinh vật bạn tha hay giết, mỗi đồng xu bạn tiêu hay thanh tẩy, đều viết lại câu trả lời cho câu hỏi "cậu là ai".

**Genre:** nhập vai kể chuyện màn hình ngang + đấu boss né đòn (bullet hell trong khung)

**Controls:** A/D hoặc mũi tên: đi · E: tương tác · Space/Enter: lời thoại · phím số: chọn · I: túi đồ · L: nhật ký · P: tạm dừng · M: tắt tiếng · Trong màn né: mũi tên để né, Shift để đi chậm, phím số để chọn đòn trong khoảng lặng *(guessed)*

**Question:** Người chơi có chọn tha con cua đang nổi điên dù đánh nó nhanh hơn và được 200 Lumen không? *(guessed)*

**Hooks:** Linh hồn trong màn né là hai nhịp tim xoay quanh nhau; đạn sượt qua làm cộng hưởng, khoảng lặng giữa các đợt là lúc chọn tha hay đánh. Mọi lựa chọn đều ghi vào sổ của thế giới: sổ nợ của Linh, bát súp của Kaelen, giá chợ, vũng nước.

**Intent:** payoff builds *(you said: các câu thoại gieo hạt Hồi 1 trả lại ở Hồi 3–4)*

## Look and references
- Look: kỳ vĩ mà ấm, đời thường. 2D nhìn ngang nhiều lớp, vẽ tay phát sáng. Bầu trời là vỏ trong của tinh cầu: lục địa mọc ngược trên trời, ở giữa treo Lõi Nhịp Tim đập chậm. Thung Lũng Phế Liệu gỉ đồng và hổ phách; Chợ Nổi gỗ ấm trên lưng một cá voi xanh thẫm. Nhân vật chính sáng nhất màn hình. Dấu ấn riêng: Lõi Nhịp Tim đập theo nhịp; sau khi Linh nghe thấy nhịp thứ hai, màn hình khẽ đập đôi. Every figure drawn, no emoji, no plain circles.
- References: Undertale (đấu né đòn trong khung, tha hay giết, phản hồi vi mô) — lấy tinh thần, không lấy menu, trái tim, nhân vật hay giao diện.
- Pixel: hi-bit pixel vẽ bằng Aseprite, 640×360 phóng ×2, bảng màu `art/trong.gpl`, đặc tả `art/SPRITE_SPEC.md`; đợt 1 là 4 nhân vật chính, phần còn lại vẫn vẽ bằng code cho tới các đợt sau.
- View: 2D · Camera: nhìn ngang theo nhân vật; màn né: boss ở trên cảnh, khung né ở dưới, cảnh thế giới vẫn thấy phía sau.

## First minute
Kén hổ phách nứt, mình bò ra giữa bãi phế liệu dưới một mặt trời đang đập. Túi áo có một tờ giấy trắng. Đi vài bước, dòng chữ hiện mà không chặn bước. Một vũng nước mưa: cúi xuống, dòng chữ "Trông cậu hơi ướt và lem luốc, nhưng không sao cả" và game lưu. Một con hồ ly bốn tai đói nhìn mẩu bánh mì của mình: chia, giữ, hay bắt nó bán. Chia thì nó nhại tiếng bụng mình "Ọc… ọc…" rồi dụi đầu vào giày.

## Challenge
Phút 3–5: Cua Giáp Lò Rèn nổi điên vì mảnh sắt gỉ, đè lên Linh. Màn né đầu tiên: tia lửa rơi, xỉ sắt lăn, cột lửa báo trước. Trúng đòn mất máu; hết máu thì đứng dậy thử lại từ đầu trận (không mất gì). Tha nó cần làm dịu cơn giận rồi gỡ mảnh sắt; đánh thì nhanh hơn nhưng có giá. Về sau: Cân Định Giá nổ (né mảnh vỡ), Bọ Ký Sinh trên lưng cá voi (tuỳ chọn).

## Core loop
- Đi qua một vùng, soi vũng nước để lưu, nhặt và đọc đồ vật.
- Gặp sinh vật hay người: chọn lời, chọn tha, giúp, bán hay bắt.
- Đấu boss: né đòn trong khung, sượt đạn để tích cộng hưởng, chọn hành động trong khoảng lặng.
- Mỗi lựa chọn đổi biến của thế giới (gắn kết, sinh thái, tha hoá, Lumen, Memoria); thế giới phản hồi lặng lẽ.
- Leads: đi lại và cảnh theo walking-sim · lời thoại, lựa chọn theo visual-novel · đấu theo bullet hell trong khung · thua thì thử lại trận (không game over)
- Skeleton: StoryStateManager (dựng thật) → giá chợ, mô tả vật phẩm, lời bạn đồng hành, vũng nước, sinh vật.

## Goal & fail state
- Đích: hết Hồi 1 — sau đêm lửa trại, Linh nghe thấy hai nhịp tim; màn kết Hồi 1 tóm tắt những gì thế giới đã ghi về cậu.
- Thua: hết máu trong màn né thì thử lại trận đó; không có game over.

## Features
- [x] Hai vùng nhìn ngang: Thung Lũng Phế Liệu và Chợ Nổi Lưng Kình Ngư, bầu trời tinh cầu rỗng với Lõi Nhịp Tim đập
- [x] Màn né đòn: boss ở trên, khung né ở dưới, linh hồn hai nhịp tim, sượt đạn tích cộng hưởng, khoảng lặng chọn hành động, tha hoặc đánh
- [x] 2 trận đấu: Cua Giáp Lò Rèn (boss, đấu trường top-down), Bọ Ký Sinh (tuỳ chọn); Cân Định Giá nổ thành cảnh kể
- [x] StoryStateManager + Event Bus giữ đủ biến Bước 4 của handover; giá chợ, mô tả vật phẩm, lời bạn đồng hành, vũng nước đổi theo
- [x] Vũng nước lưu game với dòng chữ theo giai đoạn và theo tha hoá; túi đồ với mô tả đổi theo lựa chọn; Thanh Tẩy đồng xu ký ức
- [x] Ba bạn đồng hành Linh, Kaelen, Mira với câu thoại gieo hạt Hồi 1; Kịch bản 1 (Chợ Đen) và Kịch bản 2 (Lửa Trại) theo đúng lời handover
- [x] Sinh vật: Hồ Ly Âm Bản, Cua Giáp Lò Rèn, Kình Ngư Ngược Gió, mỗi con một tương tác nhỏ; sổ xanh nợ của Linh trên giao diện

- [x] Câu đố tìm manh mối + Sổ manh mối (phím J): Cửa Đá Hát (ghép thứ tự ký tự từ câu khắc trên cửa và 5 ống sắt rải khắp thung lũng; cáo được chia bánh thì ngân nốt đầu và cuối), Cây cầu gãy (nhận ra mảnh sắt gỡ từ càng cua là cái chốt; tha cua thì nó nung, giết thì đốt Lõi Lửa), Khoá Gương Chợ Đen (bắt buộc: tìm 2 tấm gương bị giấu theo lời đố của Mira, đặt đúng hốc, xoay đúng chiều). Mỗi câu +1 Mảnh Phản Chiếu
- [x] Bốn cách hỏi thế giới: Nghe (Linh) · Định giá (Mira) · Vọng lại (hồ ly, chỉ khi đã chia bánh) · Soi; Bàn Ghép (câu chuyện bị khuyết, từ khoá nhặt được, xác nhận theo từng câu, sai 3 lần thì bạn đồng hành gợi cách hỏi, Mira bán đáp án một ô); Sổ 2.0 (hồ sơ, câu hỏi mở, vùng còn manh mối, từ khoá)
- [x] Rương người thợ cũ: xưởng rèn bỏ hoang, 7 vật hỏi được, 2 câu ghép, có từ khoá mồi; +1 Mảnh Phản Chiếu, +40 Lumen
- [x] Đánh boss là hiểu một sinh vật: nhịp báo trước → đánh → sơ hở, chạm vòng sáng để phản đòn theo ý định; khoảng lặng dùng Bốn cách hỏi lên chính boss (mở pha, mở động từ); ba pha Giận → Đau → Tin, Đánh là sang Cùng đường không quay lại; thử lại từ đầu pha; viên trúng nhấp nháy lại; khiên Kaelen
- [x] Trận Cua Giáp Lò Rèn làm lại: Linh nghe ra chỗ đau, Soi thấy mảnh sắt, hồ ly vọng lại giọng xưa mở Ngồi sưởi; pha Đau: khe an toàn sát vết thương
- [x] Boss sau review: hiểu bằng hành động trong lúc né (đứng gần khớp càng để Linh nghe, chạm ánh kim lúc lò bừng để Soi, hồ ly tự vọng lại khi cậu trúng đòn hoặc khi sang pha Đau); vòng sáng hiện mờ 1 giây trước sơ hở, phản đòn phải bấm E trong vòng; khoảng lặng chỉ mở khi có điều mới (tối đa 4 giây, chỉ định ý); gục thì Linh băng bó và ghi nợ vào sổ xanh; Linh nhắc ở pha Tin; Né chậm trong menu tạm dừng (phím N); vòng sáng phân biệt bằng hình (nét đứt, nét liền, hình thoi), không chỉ bằng màu
- [x] Chuyển Cân Định Giá và Bọ Ký Sinh sang engine boss (Soi thấy OVERFLOW, Nghe ra bọ chúa), xoá engine cũ; sau đó Cân thành cảnh kể (lượt 8)
- [x] Đánh boss top-down: cậu và Cua Giáp Lò Rèn chung một khoảng đất; chiêu vẽ vùng đỏ trên đất rồi mới cháy; đi 8 hướng, Space lướt né, né sát đầy Cộng hưởng; boss mệt sau mỗi chuỗi chiêu: E chữa lành ở khớp càng (phải Nghe trước, gỡ mảnh sắt cần Soi), F đánh (hỏi lại lần đầu); Nghe, Soi, Vọng lại bằng hành động
- [ ] Bọ Ký Sinh sang đấu trường top-down, xoá engine khung né
- [x] Đường ống sprite Aseprite: bản vẽ chữ → .aseprite → PNG + JSON → sprites.js; game dùng sprite khi có, vẽ bằng code khi chưa
- [ ] Sprite Aseprite cho Kẻ Trắng Tay, Linh & Mốc, Kaelen, Mira: đứng, đi, 6 nét mặt chân dung (vẽ trên máy MSI)

## Your systems
- đấu boss né đòn và phản đòn · in the slice
- StoryStateManager / biến cốt truyện · in the slice
- kinh tế Lumen / Memoria · thin stand-in
- bạn đồng hành, gắn kết · thin stand-in
- sinh vật, sinh thái · thin stand-in
- vũng nước lưu game · in the slice
- giải đố · in the slice
- Mảnh Phản Chiếu (0–12) · thin stand-in: 3 mảnh từ câu đố + thanh tẩy Memoria *(guessed: handover không nói nguồn)*
- Cân Thử (ma trận suy luận), Cửa Đá Hát dạng ngôn ngữ ký tự · later
- Hồi 2–4 · later

## Keep
-

## Avoid
- Câu đố chỉ là thao tác đơn giản *(you said: các câu đố phải giải bằng cách tương tác, tìm manh mối sau đó giải quyết)*
- Copy Undertale: tên, nhân vật, trái tim đỏ, menu FIGHT/ACT/ITEM/MERCY, nhạc, giao diện
- Ngôn ngữ kiếm hiệp, anime cường điệu, self-help sáo rỗng

## Out of scope
- Hồi 2, Hồi 3, Hồi 4 và ba kết thúc lớn: grow it
- Mở khoá dòng chữ trên Khế Ước khi đủ Mảnh Phản Chiếu (Hồi 4): add it as a feature
- Cân Thử, Cửa Đá Hát dạng ngôn ngữ ký tự, ghi chép độ khó trên máy (PUZZLE_RESEARCH.md mục 7): add it as a feature
- Chợ cung–cầu đầy đủ, đầu tư Khu Chợ Di Động: add it as a feature
- Đòn phối hợp tổ đội (Combo Assist): add it as a feature
- Nuôi và cộng sinh sinh vật lâu dài: grow it

## Build order
1. Lát cắt Hồi 1: thung lũng → hồ ly → cua (né đòn) → Kaelen và Mira → Chợ Nổi → cân nổ (né) → Chợ Đen → lửa trại → hết Hồi 1.
2. Mảnh Phản Chiếu và Bọ Ký Sinh đầy đủ, chợ cung–cầu.
3. Hồi 2.

---
**Kill condition:** sau hai vòng chỉnh, màn né vẫn chỉ là né cho qua, không ai dừng lại nghĩ có nên tha con cua. *(guessed)*

**Who it's for / what they feel:** người thích game kể chuyện có lựa chọn đạo đức nhỏ; thấy một câu đùa "5 Lumen" ở đầu game làm mình nghẹn ở cuối. *(guessed)*

**Games you love / don't:** Undertale (né đòn trong khung, tha hay giết, thế giới nhớ mình).
