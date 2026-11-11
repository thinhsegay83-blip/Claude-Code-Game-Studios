# HỒ SƠ BÀN GIAO & PHÁT TRIỂN CỐT TRUYỆN: "TRỜI TRONG"
*(Story & Narrative Design Handover Bible for Google Gemini)*

> Tài liệu này được thiết kế để bạn cung cấp trực tiếp cho **Google Gemini** (hoặc bất kỳ LLM nào) làm ngữ cảnh nền tảng (Context / System Knowledge) khi muốn viết tiếp kịch bản, mở rộng hội thoại, thiết kế nhân vật mới, đồ vật kể chuyện và các nhánh nội dung cho game **"Trời Trong"**.

---

## 1. TỔNG QUAN DỰ ÁN & TRIẾT LÝ CỐT LÕI (CORE PREMISE)

### 1.1. Khái niệm & Câu hỏi chủ đạo
- **Tên tác phẩm:** *Trời Trong* (Prototype: `prototypes/trong`).
- **Thể loại:** Nhập vai kể chuyện (Narrative RPG / Story-first Adventure) pha trộn khám phá 2D màn hình ngang và câu đố tâm lý bằng sự tự thấu hiểu.
- **Câu hỏi xuyên suốt (Dramatic Question):**
  > *"Người chơi có thấy xót khi bầu trời một ngôi làng tí hon xám xịt đi chỉ vì một câu tự trách của chính mình không?"*
- **Tư tưởng chủ đạo (Core Theme):**
  > *Bạn vừa là bầu trời của ai đó, vừa là hạt bụi trên bờ vai của ai đó. Học cách chăm sóc và tha thứ cho chính mình là cách duy nhất cứu lấy cả hai thế giới.*

### 1.2. Cấu trúc Thế Giới Lồng Nhau (Nested Realities)
Vũ trụ của *Trời Trong* không tuân theo các định luật vật lý thông thường, mà vận hành theo cấu trúc những sinh linh lồng vào nhau vô tận:
1. **Tầng Giữa (Hốc của mình - The Hollow):** Không gian nội tâm cô độc, lạnh lẽo, nơi nhân vật chính thức dậy mỗi sáng trong sự mỏi mệt, đối diện với những thói quen bỏ bê bản thân.
2. **Tầng Trong (Làng Li - The Inner Village):** Nằm sâu trong lồng ngực của Mình (đi qua vũng nước lặng). Tại đây có một ngôi làng 40 nóc nhà vỏ hạt. Bầu trời của làng Li chính là gương mặt mờ ảo của Mình. **Tâm trạng của Mình là thời tiết của họ:**
   - Khi Mình tự mắng, bi quan: Trời làng sập tối, lá rụng tả tơi, giếng cạn, đất nứt nẻ.
   - Khi Mình học cách nghỉ, dịu dàng, ăn ngủ tử tế: Nắng ấm len qua, đất mềm ra, mầm cây nhú mở mắt.
3. **Tầng Ngoài (Bờ vai Người Mang - The Giant Carrier):** Nằm bên ngoài tấm Màng mỏng ở vách Hốc. Bước ra đây, Mình ngỡ ngàng nhận ra toàn bộ thế giới của Mình chỉ là một chấm nhỏ trên bờ vai của một Người Khổng Lồ vô danh ("Người Mang"). Người Mang cũng đang gục đầu, héo hon và kiệt sức y hệt Mình.

---

## 2. GIỌNG VĂN & QUY TẮC NGÔN TỪ (TONE & VOICE BIBLE)

Khi yêu cầu Gemini viết tiếp bất kỳ đoạn văn hay lời thoại nào, **bắt buộc tuân thủ giọng điệu sau**:
- **Cảm xúc chủ đạo:** Buồn man mác, trầm mặc lúc đầu, rồi ấm dần lên, có những khoảnh khắc tĩnh lặng lay động và kỳ vĩ.
- **Ngôn ngữ:** Thuần Việt, mộc mạc, cô đọng, giàu nhịp điệu và hình ảnh thiên nhiên (hạt sương, ổ rêu, phiến đá, vách đá, ngọn lau, chuông gió, đốm hổ phách, ánh nắng mỏng).
- **Tuyệt đối tránh:**
  - Ngôn ngữ kiếm hiệp, anime cường điệu, giáo điều, sách vở self-help hay triết lý sáo rỗng.
  - Từ ngữ hiện đại, công nghệ, danh từ riêng đời thực.
  - Kêu gọi chiến đấu bạo lực, hô hào khẩu hiệu hay tiêu diệt quái vật.
- **Quy tắc đối thoại:** Nhân vật nói ngắn, sâu, có khoảng lặng ("…"). Những nỗi đau nội tâm được cụ thể hóa thành những thứ hữu hình (một chiếc bát hứng sương, một hũ hạt giống lép, một câu tự trách khắc trên mảnh vỏ cây).

---

## 3. DANH SÁCH NHÂN VẬT & TÍNH CÁCH (CHARACTERS)

### 3.1. Các nhân vật chính
| Mã định danh | Tên hiển thị | Vai trò & Tính cách | Giọng thoại & Đặc trưng |
| :--- | :--- | :--- | :--- |
| `me` | **Mình** | Nhân vật chính. Trầm lặng, gánh nặng tâm lý sâu sắc, có thói quen tự trách bản thân ("Tại ta. Ta vô dụng."). Đang dần học cách đối thoại với nỗi đau và biết chăm sóc chính mình. | Ngắn gọn, ngập ngừng, tự chất vấn mình ("Một câu của mình. Cả một hàng cây."). |
| `mi` | **Mi** | Cô bé trông vườn mầm ở Làng Li. Ngây thơ, chân thật, nhạy cảm với thời tiết tâm trạng. Không biết sợ hãi hay nịnh bợ Trời. | Hồn nhiên, nói thẳng: "Trời ơi! Trời rơi xuống một giọt kìa!", "Mầm nhú rồi, bà ơi!". |
| `say` | **Bà Sậy** | Người già giữ Sổ Trời của làng Li. Từng trải, điềm đạm, hiểu rõ các chu kỳ cảm xúc của Trời qua nhiều mùa. | Ấm áp, kiên nhẫn, thấu hiểu: "Trời không cần vui, Trời chỉ cần đừng ghét mình.", "Nhận, chứ không phải nuốt." |
| `lau` | **Lau** | Cậu bé cầm đèn chuông làng Li, sau này đi theo đậu trên vai Mình. Là biểu tượng của sự đồng hành và lòng trắc ẩn ấm áp. | Trung thành, lạc quan, giọng nhỏ nhẹ: "Mặt Trời buồn quá...", "Trời cười kìa!", "Trời của Trời cũng buồn." |
| `giant` | **Người Mang** | Thực thể khổng lồ ở Tầng Ngoài. Gương mặt to bằng cả bầu trời, nhắm nghiền mắt vì kiệt sức. Đại diện cho những người gánh vác thế giới mà quên thương lấy thân. | Trầm, vọng, mỏi mệt: "…Tại ta. Ta vô dụng. Đến ngồi thẳng lên ta cũng không xong." |

### 3.2. Ba chướng ngại tâm lý (Thay vì "Quái vật")
Trong game, các trận đánh hoặc câu đố không phải là tiêu diệt kẻ thù, mà là hóa giải những "khối tắc nghẽn" tâm lý của chính Mình:
1. **Lời Chê (`scorn`):**
   - *Bản chất:* Tiếng nói tự phán xét bản thân (Inner Critic) rơi xuống từ những câu tự mắng của Mình. Khối đá sắc cạnh, lơ lửng, nói bằng giọng của Mình.
   - *Cách hóa giải:* Không dùng bạo lực chém giết. Nhìn thẳng vào nó, **GỌI TÊN** nó ("Ngươi chỉ là câu tự trách cũ... một lời nhắc chứ không phải bản án"). Khi được gọi đúng tên, nó sẽ nhỏ dần và tan biến.
2. **Cơn Mỏi (`weary`):**
   - *Bản chất:* Sự kiệt sức, cạn kiệt năng lượng (Burnout) đè nặng lên miệng giếng sương khiến nguồn sống làng Li bị chặn đứng.
   - *Cách hóa giải:* Về lại Hốc tự chăm sóc mình (Ngủ, Thở sâu, Nghỉ ngơi), sau đó chia sẻ hơi ấm thật lòng xuống giếng.
3. **Cơn Héo (`wither`):**
   - *Bản chất:* Sự tê liệt cảm xúc (Numbness / Apathy), đứng chắn trước lối ra Tầng Ngoài.
   - *Cách hóa giải:* Nhận ra nó vốn đã rỗng từ lâu; chỉ cần một câu nói chân thật về việc chấp nhận bản thân là nó tự rã thành tro bụi.

---

## 4. BẢN ĐỒ KHÔNG GIAN & VẬT THỂ KỂ CHUYỆN

### 4.1. Tầng Giữa (`giua`)
- **Tọa độ & Điểm nhấn:**
  - `x = 330`: **Mảnh vỏ khắc chữ (`shell`)** – Nét khắc cũ của Mình: *"Mai sẽ dậy sớm. Mai sẽ ăn tử tế. Mai."*
  - `x = 500`: **Ổ rêu (`sleep`)** – Nằm xuống ngủ mà không tự mắng mình.
  - `x = 900`: **Vũng lặng (`pool`)** – Nhìn vào thấy ngực mình mở ra một khe sáng dẫn vào làng Li.
  - `x = 1150`: **Phiến ấm (`rest`)** – Ngồi lên phiến đá ấm, học cách "không làm gì cả cũng là một việc".
  - `x = 1350`: **Bầu sương (`eat`)** – Ăn một bữa tử tế, vị sương ngọt nhẹ.
  - `x = 1700`: **Khe gió (`breathe`)** – Hít sâu, thở ra, vách Hốc phập phồng theo.
  - `x = 2300`: Nơi Cơn Héo đứng chắn.
  - `x = 2500`: **Tấm Màng (`membrane`)** – Da mỏng nhất của Hốc, có gió lùa sang Tầng Ngoài.

### 4.2. Tầng Trong (`trong`)
- **Tọa độ & Điểm nhấn:**
  - `x = 190`: **Cột sáng (`pillar`)** – Cột ánh sáng leo ngược về lại Hốc.
  - `x = 450`: **Vườn mầm & Mi (`mi`)**.
  - `x = 700`: **Hũ hạt giống lép (`jar`)** – Nhãn viết: *"Gieo khi Trời khá hơn."*
  - `x = 1000`: **Bà Sậy & Nhà Sổ Trời (`say`)**.
  - `x = 1120`: **Sổ Trời (`book`)** – Cuốn sách ghi thời tiết tâm trạng qua các mùa.
  - `x = 1500`: Nơi Lời Chê chặn bãi ruộng (`scorn`).
  - `x = 1900`: **Bát hứng sương (`bowl`)** – Bát con hứng được một giọt sương cho ngày trời nặng.
  - `x = 2450`: **Giếng sương (`well`)** – Bị Cơn Mỏi đè nghẽn.

### 4.3. Tầng Ngoài (`ngoai`)
- **Tọa độ & Điểm nhấn:**
  - `x = 900`: **Vảy sáng đã tắt (`fleck`)** – Một đốm hổ phách nguội lạnh rơi trên vai, soi kỹ thấy có vân như mái nhà vỏ hạt của một ngôi làng xa xưa.
  - `x = 1760`: **Vành tai Người Mang (`ear`)** – Nơi đứng gọi vào tâm thức của Người Mang.
  - Bầu trời: Gương mặt nhắm mắt khổng lồ của Người Mang.

---

## 5. HỆ THỐNG KỸ THUẬT KỊCH BẢN TRONG CODE (`story.js`)

Khi yêu cầu Gemini sinh code hoặc kịch bản mới, Gemini cần trả về đúng định dạng dữ liệu của engine sau:

### 5.1. Cấu trúc một Scene (Cảnh thoại)
Mỗi scene trong `window.STORY.scenes` là một mảng các bước:
```javascript
my_scene_id: [
  // 1. Câu thoại đơn:
  // w: 'me' | 'mi' | 'say' | 'lau' | 'giant' | 'scorn' | 'weary' | 'wither'
  // f: 'neutral' | 'happy' | 'sad' | 'think' | 'awe' | 'afraid' | 'speak'
  // t: string hoặc function(state) => string
  { w: 'mi', f: 'happy', t: 'Trời ơi, mầm của cháu hé rồi!' },

  // 2. Lựa chọn (Choice) tác động đến tâm trạng và cờ kịch bản:
  // m: 'kind' (+12) | 'harsh' (-15) | 'deflect' (-8) | 'small' (+5) | 'none' (0)
  // set: [flagName, flagValue]
  // go: sceneId nhảy tiếp theo
  { c: [
    { t: 'Ta mệt, Mi ạ. Mệt thì trời nặng. Ta đang học cách nghỉ.', m: 'kind', set: ['c1', 'kind'], go: 'mi_kind' },
    { t: 'Tại ta. Ta vô dụng, dậy cũng không xong.', m: 'harsh', set: ['c1', 'blame'], go: 'mi_blame' },
  ] },

  // 3. Lệnh chuyển cảnh hoặc thực thi:
  { do: 'travel:trong' },   // Đi xuyên tầng
  { do: 'goal:village' },    // Đổi mục tiêu nhiệm vụ
  { do: 'save' },            // Tự động lưu
  { do: 'resolve:scorn' },   // Hóa giải câu đố/địch mà không cần đánh
  { do: 'ending:trong' },    // Kích hoạt kết thúc game

  // 4. Nhảy cảnh trực tiếp:
  { go: 'next_scene_id' },

  // 5. Điều kiện hiển thị (Condition):
  { w: 'lau', f: 'awe', when: s => s.flags.lau, t: 'Trên vai Trời ấm thật.' }
]
```

### 5.2. Các nấc Tâm Trạng (`state.mood`: 0 đến 100)
- `0`: **Tắt** (Thế giới Trong sụp đổ, game over)
- `1..20`: **Nặng**
- `21..40`: **Đục**
- `41..60`: **Lặng**
- `61..80`: **Ấm**
- `81..100`: **Trong**

---

## 6. BỐN KẾT THÚC HIỆN TẠI (CANON ENDINGS)

1. **Trời Trong (`ending:trong`):**
   - *Lựa chọn:* Kể cho Người Mang nghe về làng Li, về Mi, về Lau, rồi quay về Hốc ăn một bữa tử tế vì cả hai.
   - *Ý nghĩa:* Người Mang hít một hơi sâu, vách Hốc ấm lên. Dưới làng bà Sậy ghi chữ "Trong". Chăm lấy mình là việc lớn nhất làm được cho cả hai.
2. **Gánh Trời (`ending:ganh`):**
   - *Lựa chọn:* Ép Người Mang phải gắng gượng, gồng mình lên vì bao nhiêu sinh mạng đang trông cậy.
   - *Ý nghĩa:* Thế giới sáng lên được một mùa nhưng nóng căng, như sắp nứt vỡ. Không ai có thể nở hoa mãi vì sợ hãi.
3. **Hạt Bụi Đi Mãi (`ending:bui`):**
   - *Lựa chọn:* Chào Người Mang rồi bỏ đi tiếp ra tầng ngoài cùng, mong tìm một nơi không có ai buồn.
   - *Ý nghĩa:* Đi mãi qua các bờ vai vô tận. Làng Li xa dần. Trên vai mình, Lau hỏi khẽ: *"Bao giờ mình về?"*.
4. **Trời Tắt (`ending:tat`):**
   - *Kích hoạt:* Tâm trạng chạm đáy (`mood <= 0`).
   - *Ý nghĩa:* Trời làng Li tối hẳn. Không ai ác cả, Mình chỉ quên mất rằng có một thế giới đang sống nhờ cách mình đối xử với bản thân. Trang cuối Sổ Trời để trắng.

---

## 7. CÁC HƯỚNG MỞ RỘNG TIỀM NĂNG (GỢI Ý CHO BẠN & GEMINI)

Dưới đây là các chủ đề bạn có thể giao cho Gemini mở rộng ngay:

### Hướng 1: Thêm NPC mới & Nhiệm vụ phụ tại Làng Li
- **Bác Nấu Sương (`thao`):** Một người thu gom sương đọng dưới rễ cây để nấu canh cho cả làng. Nhờ Mình tìm hiểu xem vì sao bầu sương ở Tầng Giữa dạo này cạn (do Mình quên ăn/uống tử tế).
- **Đứa trẻ nhặt lá rụng (`nan`):** Đứa bé đếm từng chiếc lá rụng mỗi khi Mình thở dài.
- **Thợ đan vỏ hạt (`khe`):** Người vá lại những mái nhà bị nứt mỗi khi trời chuyển mùa lạnh.

### Hướng 2: Thiết kế thêm các "Chướng Ngại Tâm Lý" mới
- **Lời So Sánh (`envy` / `compare`):** Một chiếc gương nứt lơ lửng phản chiếu hình bóng những "bầu trời khác" rực rỡ hơn Mình.
  - *Cách hóa giải:* Nhận ra mỗi thế giới có một mùa riêng, chấp nhận nhịp điệu của chính mình.
- **Nỗi Vội Vã (`rush`):** Một cơn lốc cát xám cuốn người chơi phải chạy liên tục không được dừng lại.
  - *Cách hóa giải:* Đứng yên hoàn toàn giữa cơn lốc, hít một hơi thật sâu.

### Hướng 3: Thêm các di vật & ghi chép môi trường (Environmental Lore)
- Những mẩu giấy kẹp trong khe đá Tầng Giữa ghi lại những ngày Mình từng vui vẻ, giải thích vì sao Hốc bị nguội lạnh.
- Những tàn tích trên bờ vai Người Mang chứng minh Người Mang cũng từng là một đứa trẻ có ngôi làng của riêng mình.

---

## 8. PROMPT MẪU ĐỂ COPY-PASTE CHO GEMINI

Khi làm việc với Gemini, bạn có thể copy đoạn mở đầu sau:

> *"Tôi đang phát triển cốt truyện cho tựa game 'Trời Trong' (thuộc dự án Claude-Code-Game-Studios). Dưới đây là tài liệu hồ sơ bàn giao thế giới, giọng văn và cấu trúc kỹ thuật của game (kèm theo file HANDOVER_STORY.md). Hãy đọc kỹ tài liệu này, sau đó giúp tôi thực hiện nhiệm vụ sau: [ĐIỀN YÊU CẦU CỦA BẠN VÀO ĐÂY, ví dụ: Viết thêm 2 NPC mới cho Làng Li và các đoạn hội thoại có lựa chọn bằng đúng cú pháp story.js]."*

---
*Tài liệu được lập ngày 11/11/2026 cho nhánh `art/aseprite-redesign`.*
