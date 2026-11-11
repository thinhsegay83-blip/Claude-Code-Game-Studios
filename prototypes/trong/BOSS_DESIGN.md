# Thiết kế cơ chế đánh boss: Trong

> PROTOTYPE - NOT FOR PRODUCTION. Viết sau iteration 4 (`ea01a09`). Chỗ ghi *(đề xuất)* là ý của tôi, không phải của nguồn.
> Đọc cùng `PUZZLE_RESEARCH.md`: boss dùng lại Bốn cách hỏi.

## 1. Nguồn nói gì

| Nguồn | Bài học |
|---|---|
| **Toby Fox** (Undertale, Game Developer deep-dive) | Né đòn lấy cảm hứng từ Touhou và WarioWare: "những mẩu đạn nhỏ" thay đổi theo từng trận. Ông nói hệ ACT/SPARE "thường rốt cuộc chỉ là thử sai đơn giản" và lẽ ra có thể hấp dẫn, công bằng hơn; ông bù lại bằng nhiều câu chữ hài. Người chơi đã thuần thục một trận thì nên được đi tiếp, vì các trận đánh căng thẳng. |
| **Psychonauts 2** (GDC 2023) | Mỗi đòn của boss đi theo nhịp **báo trước → đánh → sơ hở** (sơ hở là lúc người chơi trả đòn). |
| **Death's Gambit** (GDC, "Readability in Boss Design") | Trận công bằng là trận **đọc được**: người chơi phải có cơ hội nhận ra mẫu đòn và cách đối phó. |
| **Bài "Boss phases: readable, learnable, beatable"** | Đòn nào cũng tự báo trước. Khó lên bằng **mật độ và tốc độ, không bằng ngẫu nhiên**. Thua thì phải hiểu vì sao. Vùng trúng nhỏ hơn hình vẽ để tránh "trúng oan". Đạn cùng cỡ, có giới hạn thời gian sống để màn hình không rối. |
| **Undertale** (theo Game Developer) | Boss là câu đố, luôn có nhiều hơn một lời giải: lời thoại, vật phẩm, hoặc tha thứ. |

## 2. Trận cua hiện tại mắc lỗi gì

- Khoảng lặng là **menu bốn nút + thanh "Giận"**: bấm "Nói khẽ" mấy lần cho thanh tụt là xong. Đúng cái thử sai mà Toby Fox thừa nhận.
- **Né và phản đòn tách rời nhau**: né cho qua đợt, rồi chọn menu. Tay giỏi không giúp gì cho việc tha.
- Ba mẫu đòn (tia lửa, xỉ, cột lửa) **không kể gì về con cua**. Đòn nào cũng có thể thuộc về bất kỳ con quái nào.
- Đánh hay tha chỉ khác nhau ở thanh máu, chưa phải hai cách hiểu con vật.

## 3. Cơ chế đề xuất: "Đánh boss là hiểu một sinh vật" *(đề xuất)*

### 3.1 Vòng một nhịp
1. **Đợt đòn** (né): mỗi đòn có 3 nhịp **báo trước ≥ 0,6 giây → đánh → sơ hở ~1 giây**.
2. **Sơ hở:** sau đòn lớn, boss mệt trong giây lát và trên khung né hiện một **điểm đau** sáng. Lao tới chạm điểm đau trong sơ hở để **phản đòn**. Phản đòn là gì tuỳ đã hiểu boss tới đâu: chưa hiểu thì chỉ "đẩy lùi", hiểu rồi thì thành "Gỡ", "Ngồi sưởi"… Người chơi phải **giỏi tay và hiểu chuyện cùng lúc**.
3. **Khoảng lặng:** dùng **Bốn cách hỏi** lên chính con boss. Mỗi câu trả lời là một manh mối ghi vào Sổ, và **mở thêm động từ phản đòn**. Không còn menu đoán mò: muốn "Gỡ mảnh sắt" thì phải hỏi ra mảnh sắt ở đâu trước.

### 3.2 Ba pha theo cảm xúc, không theo máu
| Pha | Chuyển pha khi | Mẫu đòn |
|---|---|---|
| **Giận** | đầu trận | nhanh, phủ rộng, không có chỗ an toàn rõ |
| **Đau** | đã hỏi ra nguyên nhân | đòn toả ra từ vết thương; **chỗ an toàn nằm sát vết thương**: phải dám lại gần nỗi đau |
| **Tin** | đã phản đòn đúng 2 lần | đòn thưa và chậm như một điệu múa; sơ hở dài; phản đòn cuối cùng kết thúc trận |

Đi đường **đánh** thì bỏ qua hiểu: phản đòn ở sơ hở thành "Đánh", trừ máu, boss không bao giờ sang pha Tin mà sang pha **Cùng đường** (dày, nhanh, tuyệt vọng). Thắng nhanh hơn nhưng khó né hơn, và có giá trong cốt truyện (tha hoá, sinh thái). Sự tàn nhẫn **nhìn thấy được trong mẫu đạn**.

### 3.3 Bạn đồng hành trong trận
- **Linh:** báo trước tên đòn (đã có). Pha Đau: nghe ra vết thương.
- **Kaelen:** khiên gốm đỡ một đòn mỗi trận; gắn kết ≥ 40 thì đỡ hai.
- **Mira:** định giá boss (khao khát gì, sợ gì); bán "đọc trước" mẫu đòn kế tiếp bằng Lumen.
- **Hồ ly** (chỉ khi đã chia bánh): Vọng lại ký ức của boss. Để dành cho cú lật ở Hồi 4 (handover: máu còn 1 thì cáo phát lại giọng cậu).

### 3.4 Luật dễ đọc (bắt buộc cho mọi boss)
- Mỗi boss tối đa **4 loại đạn**, mỗi loại một hình và một màu riêng, cùng cỡ.
- Khó lên **chỉ bằng mật độ hoặc tốc độ**; vị trí ngẫu nhiên vẫn theo hạt giống cố định.
- Vùng trúng nhỏ hơn hình (đã có: 5 px). Đạn có giới hạn sống; tối đa ~120 viên một lúc.
- Bị trúng thì **viên trúng nhấp nháy lại một nhịp** để biết mình chết vì gì.
- Thua thì thử lại **từ đầu pha**, không từ đầu trận. Kaelen đỡ cậu dậy một lần mỗi trận.

### 3.5 Mẫu đòn là dữ liệu
Mỗi đòn khai báo trong `story.js` gồm: nguồn bắn (miệng, càng, vết thương, mép khung), kiểu (mưa, quạt, vòng, cột, nhắm, lăn), số viên, tốc độ, thời gian báo trước, thời gian sơ hở. Engine chỉ đọc và chạy. Thêm boss mới thì viết dữ liệu, không viết code.

## 4. Boss Hồi 1 thiết kế lại *(đề xuất)*

### 4.1 Cua Giáp Lò Rèn
- **Nguyên nhân giận:** mảnh sắt gỉ kẹt ở khớp càng trái.
- **Hỏi:**
  - *Nghe* (Linh, đang kẹt dưới càng nhưng vẫn nghe được): "Tiếng rít ở khớp càng trái". Mở pha Đau, hiện điểm đau.
  - *Soi*: thấy mảnh sắt lấp lánh. Mở động từ "Gỡ".
  - *Vọng lại* (nếu cáo đã được chia bánh): con cua nhớ một giọng rất xưa: "Đừng chạm vào, coi chừng phỏng tay nhé" (dòng khắc trên mai trong handover). Mở động từ "Ngồi sưởi"; con cua dịu nhanh gấp đôi.
- **Đòn:**
  - Giận: tia lửa rơi, xỉ lăn, cột lửa (giữ từ bản hiện tại).
  - Đau: lửa phụt thành quạt từ khớp càng, chừa khe sát càng.
  - Tin: vài tia lửa chậm rơi theo nhịp thở của lò.
- **Kết:** Gỡ mảnh sắt trong sơ hở của pha Tin.

### 4.2 Bọ Ký Sinh (phụ)
- **Hỏi:** *Nghe* ra con nào là bọ chúa (đập nhịp khác). Gỡ bọ chúa trước thì các con còn lại tự bỏ đi.
- Gỡ con thường trước vẫn thắng được, nhưng lâu hơn.

### 4.3 Cân Định Giá Linh Hồn (sống sót)
- Giữ là màn sống sót ngắn.
- Thêm: *Soi* trong lúc né thì thấy dòng chữ cổ `OVERFLOW: ORIGIN_ENTITY` hiện dần trên mặt kính, trước khi nó nổ. Gieo bí ẩn bằng chính hành động của người chơi.

### 4.4 Phác thảo Vaelen (Hồi 4, chỉ để định hướng)
- Đạn là **Đồng Xu Ký Ức**; mẫu đạn dựng lại các lựa chọn cũ của người chơi (đã bán trứng thì có loạt đạn hình trứng).
- Bốn cách hỏi lên Vaelen đều thất bại: "Ngươi không hỏi được ta. Bên trong ta không còn gì."
- Đến khi máu còn 1, hồ ly phát lại giọng cậu ở Hồi 1: "Ăn đi, đừng sợ, tôi không làm đau cậu đâu" (handover). Hồi đầy máu, mở pha cuối.

## 5. Kế hoạch làm *(chờ duyệt)*

| Bước | Việc |
|---|---|
| 1 | Engine mẫu đòn đọc từ dữ liệu: nhịp báo trước → đánh → sơ hở, điểm đau trong khung né, phản đòn bằng cách chạm điểm đau |
| 2 | Bốn cách hỏi dùng được trên boss trong khoảng lặng; manh mối mở động từ phản đòn |
| 3 | Ba pha theo cảm xúc; pha Cùng đường cho đường đánh; thử lại từ đầu pha; khiên Kaelen |
| 4 | Làm lại trận Cua Giáp Lò Rèn theo 4.1 |
| 5 | Bọ Ký Sinh (4.2) và chi tiết Soi ở Cân Định Giá (4.3) |

## Nguồn
- [Game Developer: deep-dive hệ thống đánh của Undertale](https://gamedeveloper.com/design/game-design-deep-dive-i-undertale-i-s-action-based-rpg-battles)
- [Game Developer: boss Psychonauts 2 bằng hệ "maneuver" (GDC 2023)](https://www.gamedeveloper.com/marketing/using-a-modular-system-of-maneuvers-to-design-i-psychonauts-2-i-s-boss-fights-in-a-hurry)
- [Game Developer: dễ đọc trong thiết kế boss ARPG (Death's Gambit)](https://www.gamedeveloper.com/game-platforms/designing-for-difficulty-readability-in-arpgs)
- [Boss phases: readable, learnable, beatable](https://molbv.github.io/blog/2025-07-08-boss-phases.html)
- [Game Developer: 7 trận boss đáng học](https://www.gamedeveloper.com/design/7-memorable-boss-fights-that-every-developer-should-study)
