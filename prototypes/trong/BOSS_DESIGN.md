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

## 6. Review sau iteration 5 (`c317659`)

### 6.1 Số đo (máy tự đánh trận cua, `bossmeasure.js`)
| Đường | Tổng | Theo pha |
|---|---|---|
| Tha, có cáo | 44,4 giây | Giận 8,5 · Đau 12,9 · Tin 23 |
| Tha, không cáo | 37,1 giây | Giận 8,5 · Đau 12,9 · Tin 15,7 |
| Đánh | 64,1 giây (khoảng 36 giây chờ khoảng lặng hết giờ) | Giận 14,1 · Cùng đường 49,9 |
| Tha, né ở góc xa | không xong sau 600 giây: 55 lần sơ hở, chạm được 1 | |

- Góc xa nhất đến điểm đau: 390 px, tức 1,69 giây ở 230 px/giây. Sơ hở chỉ dài 1,4 giây.
- Mỗi đòn có 21 viên (mưa) đến 29 viên (quạt). Trúng 7 lần thì gục.

### 6.2 Hạn chế
1. **"Hiểu" vẫn là menu.** Khoảng lặng liệt kê sẵn mọi câu hỏi, bấm lần lượt là xong. Đây vẫn là kiểu thử sai đơn giản, chỉ đổi tên.
2. **Không chạy kịp tới vòng sáng.** Sơ hở ngắn hơn quãng đường xa nhất.
3. **Phản đòn tự động.** Đi ngang qua vòng là phản đòn; ở pha Đau, lối an toàn dẫn thẳng vào vòng.
4. **Nhịp đứt.** 4–5 khoảng lặng, mỗi cái tối đa 9 giây. Pha Tin dài gần gấp đôi pha Đau. Đánh chậm hơn tha, trái với 3.2. Đường có cáo chậm hơn đường không cáo, nên lựa chọn tốt bị phạt. Một lần "Ngồi sưởi" đã đủ `trust_need`.
5. **Báo trước chỉ bằng chữ**, không có âm thanh hay động tác riêng.
6. **Con cua gần như không đổi hình theo pha.**
7. **Gục không mất gì**, thử lại miễn phí.
8. **Không ai nhắc ở pha Tin** khi chưa Soi.
9. **Hai engine song song.** Cân và Bọ còn chạy luật cũ.
10. **Thiếu hỗ trợ tiếp cận.** Không có né chậm; vòng sáng chỉ phân biệt bằng màu.

### 6.3 Cải tiến đã duyệt
- **A. Hỏi bằng hành động, không bằng menu** (hạn chế 1, 4).
  - *Nghe:* đứng gần khớp càng đủ 1,5 giây trong lúc né thì Linh nghe ra.
  - *Soi:* chạm ánh kim loé lên ở khớp càng lúc lò bừng.
  - *Vọng lại:* cáo tự lên tiếng khi cậu trúng đòn lần đầu.
  - Khoảng lặng chỉ còn để chọn ý định.
- **B. Vòng sáng hiện trước, phản đòn bấm E** (hạn chế 2, 3). Vòng hiện mờ trong giây cuối của đòn; phản đòn phải bấm E khi đứng trong vòng.
- **D. Nhịp mới** (hạn chế 4).
  - Khoảng lặng chỉ mở khi có điều mới để quyết, tối đa 4 giây.
  - Pha Tin chỉ có một điệu múa rồi tới sơ hở cuối.
  - Cân lại để đánh nhanh hơn tha, và đường có cáo không chậm hơn đường không cáo.
- **F. Gục có giá trong truyện** (hạn chế 7). Linh băng bó và ghi thêm nợ vào sổ xanh (`linh_fee`, câu đùa 5 Lumen của handover).
- **G. Nhắc, thống nhất engine, hỗ trợ** (hạn chế 8, 9, 10).
  - Linh nhắc ở pha Tin.
  - Cân và Bọ chuyển sang engine mới (kèm 4.2 và 4.3).
  - Thêm né chậm trong menu tạm dừng.
  - Vòng sáng có hình dạng, không chỉ màu.
- *Chưa làm:* C (âm thanh báo trước) và E (cua đổi hình theo pha).

### 6.4 Sau iteration 6 (A, B, D, F và phần nhắc, hỗ trợ của G)
| Đường | Trước | Sau |
|---|---|---|
| Tha, có cáo | 44,4 giây | **27,6 giây** |
| Tha, không cáo | 37,1 giây | 35,4 giây |
| Đánh | 64,1 giây | **24,9 giây** |
| Tha, đi bộ thật từ góc xa | 1/55 lần chạm được vòng | **5/5 lần** (48,2 giây) |
| Số khoảng lặng | 5 | 1–3 |

- Hai lỗi lộ ra khi đo, đã sửa:
  - Chọn "Gỡ" quá sớm ở pha Đau thì kẹt mãi, vì không còn khoảng lặng nào để đổi ý. Giờ phản đòn không có tác dụng cũng mở khoảng lặng.
  - Người né giỏi không bao giờ trúng đòn nên hồ ly không lên tiếng. Giờ hồ ly cũng lên tiếng khi trận sang pha Đau.
- Còn lại của G: chuyển Cân và Bọ sang engine mới (kèm 4.2 và 4.3). Đã làm ở iteration 7 (6.5).

### 6.5 Sau iteration 7: một engine cho mọi trận
- Engine boss nay có ba kiểu trận, chọn bằng `mode` trong `story.js`:
  - `understand` (cua): hiểu một sinh vật, như mục 6.4.
  - `survive` (Cân Định Giá): sống sót qua một đòn dài 8 giây. Chữ cổ loé lên ngay chỗ mảnh kính bắn ra; chạm 3 lần là đọc đủ `OVERFLOW: ORIGIN_ENTITY`, ghi vào Sổ. Gục thì Kaelen kéo ra, trận vẫn kết (biến cố truyện, không thể thua).
  - `bugs` (Bọ Ký Sinh): mỗi con một vòng sáng. Đứng sát một con 1,2 giây thì Linh nghe ra nhịp. Con đầu đàn chọn theo hạt giống.
- Engine cũ đã xoá (khoảng 190 dòng), cùng với `S.fights` và hai thông số `wave_time`, `quiet_time`.

| Trận | Đường | Thời gian |
|---|---|---|
| Cân | đứng yên né | 12,8 giây, không đọc được chữ |
| Cân | đi tới chữ loé | 12,8 giây, đọc đủ, có manh mối |
| Bọ | nghe rồi gỡ đầu đàn trước | **9,3 giây**, gỡ 1 con |
| Bọ | gỡ con thường trước | 24,6 giây, gỡ 3 con |
| Cua | cả 4 đường | không đổi so với 6.4 |

- Lỗi lộ ra khi đo, đã sửa:
  - Dữ liệu cua thiếu khai báo máu, nên thanh máu pha Cùng đường làm sập game.
  - Gỡ đầu đàn sau cùng bị tính là gỡ đầu đàn trước.

## 7. Đánh boss top-down (iteration 8)

Người dùng đổi hướng: bỏ khung né có "linh hồn", cậu đối đầu trực tiếp với boss trên mặt đất nhìn từ trên xuống. Boss mệt thì ra đòn, chọn **Đánh** hoặc **Chữa lành / giải cứu**. Trận Cân Định Giá bỏ, thành cảnh kể.

### 7.1 Luật
- **Đấu trường:** một khoảng đất nhìn theo góc 3/4 (đất nhìn từ trên, người đứng thẳng; ai ở thấp hơn trên màn hình thì vẽ đè lên). Đi 8 hướng (WASD). **Space lướt né**: bất tử 0,24 giây, hồi 0,55 giây.
- **Chiêu:** vẽ vùng đỏ trên đất, lõi đầy dần, báo trước ≥ 0,6 giây rồi mới cháy. Chiêu vừa trúng mình nhấp nháy lại.
- **Né sát:** lướt đúng lúc một vùng cháy trúng chỗ mình thì +35 Cộng hưởng. Cộng hưởng đầy thì **lần Chữa lành kế gấp đôi**. Cộng hưởng không nhân đôi Đánh: hai nhịp tim đồng điệu là để chữa.
- **Boss mệt:** hết một chuỗi chiêu (2 chiêu; pha Tin 1 chiêu), con cua thở dốc 4,5 giây (pha Tin 5 giây).
  - **E: Chữa lành**, phải đứng ở khớp càng trái. Chưa Nghe: không có tác dụng. Pha Đau: tin cậu thêm +1 (+2 nếu hồ ly đã Vọng lại). Pha Tin, đã Soi: gỡ mảnh sắt, cứu nó. Pha Tin, chưa Soi: nó chờ nhưng cậu không biết gỡ gì.
  - **F: Đánh**, đứng sát thân. Lần đầu hỏi lại. Đánh rồi sang Cùng đường, không quay lại.
- **Hiểu bằng hành động:**
  - Nghe: đứng sát khớp càng 1,5 giây (cộng dồn); có sóng âm chỉ chỗ.
  - Soi: đứng sát khớp càng lúc lò bừng; ánh kim loé trên càng.
  - Vọng lại: hồ ly lên tiếng khi cậu trúng chiêu lần đầu hoặc khi sang pha Đau.
- Gục: Linh băng bó, ghi nợ sổ xanh, thử lại từ đầu pha. Giữ: khiên Kaelen, Né chậm, tạm dừng giữa trận, Sổ (J).

### 7.2 Chiêu của Cua Giáp Lò Rèn
| Pha | Chiêu | Cách né |
|---|---|---|
| Giận | Đập càng: 3 quạt nhắm vào chỗ cậu đứng | đi ngang khỏi quạt |
| Giận | Mưa lửa: 9 đốm, cứ 3 đốm có 1 rơi đúng chỗ cậu | đi tiếp, đừng đứng yên |
| Giận | Xỉ lăn: 4 làn ngang, luôn trống 1 làn, có mũi tên hướng lăn | đứng vào làn trống |
| Đau | Quạt lửa: phủ cả khoảng đất trừ túi sát vết thương | lại sát nỗi đau |
| Tin | Lửa thở: 4 đốm chậm, tránh xa vết thương | dễ, như điệu múa |
| Cùng đường | đập càng, xỉ, mưa, quạt: nhanh hơn ×1,4, nhiều hơn ×1,4 | khó |

### 7.3 Số đo
| Đường | Thời gian | Bot né thật trúng |
|---|---|---|
| Đánh | **22 giây** (2 đòn) | 5 lần |
| Tha, có cáo | 30,8 giây | 1 lần |
| Tha, không cáo | 39,5 giây | 3 lần |

- Đứng yên không né: gục 3 lần trong 60 giây, ghi nợ 15 Lumen.
- Đi bộ từ góc xa tới khớp càng mất 3,5 giây, nên boss mệt 4,5 giây (dư 1 giây; lướt còn nhanh hơn).
- Lỗi lộ ra khi đo, đã sửa: Cộng hưởng nhân đôi Đánh làm 1 đòn là chết, bỏ qua cả pha Cùng đường.

### 7.4 Còn lại
- Bọ Ký Sinh còn chạy engine khung né cũ (nhánh `bugs`); chuyển sang đấu trường ở lượt sau rồi xoá hẳn engine khung (cả nhánh `understand` không còn ai dùng).
- Bản đồ đi lại top-down: người dùng giao cho một phiên Claude Code khác.

## Nguồn
- [Game Developer: deep-dive hệ thống đánh của Undertale](https://gamedeveloper.com/design/game-design-deep-dive-i-undertale-i-s-action-based-rpg-battles)
- [Game Developer: boss Psychonauts 2 bằng hệ "maneuver" (GDC 2023)](https://www.gamedeveloper.com/marketing/using-a-modular-system-of-maneuvers-to-design-i-psychonauts-2-i-s-boss-fights-in-a-hurry)
- [Game Developer: dễ đọc trong thiết kế boss ARPG (Death's Gambit)](https://www.gamedeveloper.com/game-platforms/designing-for-difficulty-readability-in-arpgs)
- [Boss phases: readable, learnable, beatable](https://molbv.github.io/blog/2025-07-08-boss-phases.html)
- [Game Developer: 7 trận boss đáng học](https://www.gamedeveloper.com/design/7-memorable-boss-fights-that-every-developer-should-study)
