// PROTOTYPE - NOT FOR PRODUCTION
// Question: Người chơi có chọn tha con cua đang nổi điên dù đánh nó nhanh hơn và được 200 Lumen không?
// Date: 2026-11-12
// Every word the player reads, and the layout of each place: data only, no logic.
// Source: prototypes/trong/HANDOVER_STORY_V2.md. Lines quoted from it are kept word for word and
// marked "handover". Lines marked "guessed" fill a gap the handover leaves; change them freely.
//
// A scene is a list of steps:
//   {w, f, t, cue}  a line: speaker id, face, text (string or function of the view), stage cue
//   {c: [...]}      a choice: each {t, fx, go, when}
//                   fx: effects as strings, run by the StoryStateManager, e.g.
//                       'var_bond_kael+15'  'var_eco_balance-15'  'flag_kept_royal_egg=true'
//                       'item+egg'  'item-egg'  'var_identity_revelation_stage=3'
//   {go}            jump to another scene         {do}  an action: fight:<id>, travel:<map>,
//                   save, goal:<id>, join:<who>, actend
//   {when}          on any step: skip it unless when(view) is true
window.STORY = {
  names: {
    me: 'Cậu', nar: '', linh: 'Linh', kael: 'Kaelen', mira: 'Mira', vex: 'Vex',
    fox: 'Hồ Ly Âm Bản', crab: 'Cua Giáp Lò Rèn', scale: 'Cân Định Giá Linh Hồn', bug: 'Bọ Ký Sinh',
    moc: 'Mốc', whale: 'Kình Ngư Ngược Gió',
  },

  // ---- Bản đồ: mỗi thực thể là dữ liệu; index.html đọc và xử lý ----------------------------
  //   type: puddle | auto | npc | pickup | creature | boss | travel | shop | deck | optfight | decor
  //   once: cờ được bật khi cảnh tự kích hoạt chạy (không chạy lại)
  //   block(s): đúng thì người chơi không đi qua được x này
  maps: {
    phelieu: {
      name: 'Thung Lũng Phế Liệu · Tầng Ngoài', w: 2300, ground: 600,
      entities: [
        { x: 130, type: 'decor', id: 'cocoon' },
        { x: 190, type: 'pipe', id: 'amber' },
        { x: 400, type: 'puddle' },
        { x: 460, type: 'pipe', id: 'water' },
        { x: 700, type: 'auto', scene: 'fox_first', once: 'fox_seen' },
        { x: 760, type: 'creature', id: 'echofox', when: s => !s.flags.fox_fed && !s.flags.fox_caught },
        { x: 840, type: 'puzzle', id: 'song' },                                           // tuỳ chọn
        { x: 1000, type: 'pickup', id: 'egg', when: s => !s.flags.egg_taken },
        { x: 1080, type: 'pipe', id: 'egg' },
        { x: 1150, type: 'auto', scene: 'crab_pre', once: 'crab_seen' },
        { x: 1300, type: 'boss', id: 'crab', block: s => !s.flags.crab_done },
        { x: 1390, type: 'pipe', id: 'fire' },
        { x: 1470, type: 'decor', id: 'quiet' },
        { x: 1470, type: 'examine', scene: 'quiet_hill', label: 'Đứng nghe đồi sắt', when: s => !s.clues.includes('quiet_hill') },
        { x: 1530, type: 'pipe', id: 'quiet' },
        { x: 1640, type: 'examine', scene: 'bridge_look', label: 'Xem cây cầu sắt gãy', id: 'bridge', when: s => !s.flags.pz_bridge }, // tuỳ chọn
        { x: 1750, type: 'auto', scene: 'kael_mira', once: 'met_kael' },
        { x: 1850, type: 'decor', id: 'campfire' },
        { x: 2180, type: 'travel', to: 'chonoi', when: s => s.flags.met_kael },
      ],
    },
    chonoi: {
      name: 'Chợ Nổi Lưng Kình Ngư', w: 2400, ground: 610,
      entities: [
        { x: 230, type: 'auto', scene: 'scale_pre', once: 'scale_seen' },
        { x: 330, type: 'decor', id: 'scale', block: s => !s.flags.flag_scale_exploded },
        { x: 285, type: 'pickup', id: 'mirror_scale', item: 'mirror', when: s => s.flags.flag_scale_exploded && !s.flags.mirror_scale_taken },
        { x: 560, type: 'puddle' },
        { x: 820, type: 'shop', id: 'bread' },
        { x: 960, type: 'puzzle', id: 'light', block: s => !s.flags.pz_light },             // bắt buộc: khoá Chợ Đen
        { x: 1100, type: 'npc', id: 'vex' },
        { x: 1420, type: 'optfight', id: 'bug', when: s => !s.flags.bugs_cleared },
        { x: 1700, type: 'deck' },
        { x: 1880, type: 'puddle' },
        { x: 2050, type: 'auto', scene: 'camp_pre', once: 'camp_seen', when: s => s.flags.flag_scale_exploded },
        { x: 2150, type: 'decor', id: 'campfire' },
        { x: 2250, type: 'npc', id: 'sleep', when: s => s.flags.flag_linh_heard_double_pulse },
      ],
    },
  },

  walk: {
    phelieu: [
      { x: 0, t: 'Thung Lũng Phế Liệu. Sắt gỉ chất thành đồi, hổ phách vương vãi như mật đông.' },
      { x: 260, t: 'Ngẩng lên không thấy trời. Chỉ thấy đất, ở rất xa, uốn cong lên rồi treo ngược trên đầu.' },
      { x: 560, t: 'Ở chính giữa, một mặt trời đang đập. Chậm, đều, như tim ai đó đang ngủ.' },
      { x: 1500, when: s => s.flags.crab_done, t: 'Phía trên vách đá có khói bếp. Và mùi nấm.' },
    ],
    chonoi: [
      { x: 0, t: 'Sàn gỗ dưới chân cậu thở. Cả khu chợ đang nằm trên lưng một con cá voi.' },
      { x: 650, t: 'Người ta mua bán bằng ánh sáng đựng trong đồng xu. Có những đồng xu thì thầm.' },
      { x: 1500, t: 'Gió ở đây ngược. Cá voi bơi ngược gió, nên chợ không bao giờ trôi mất.' },
    ],
  },

  // ---- Vũng nước lưu game (handover 3.1) --------------------------------------------------------
  // Chọn dòng đầu tiên có when() đúng. Hồi 3–4 chưa có trong lát này nhưng dữ liệu để sẵn.
  puddle: [
    { when: s => s.v.var_identity_revelation_stage >= 4, t: 'Nước trong vắt. Sau bao nhiêu vết xước, bao nhiêu lần suýt quên mất mình là ai... thật mừng vì người đứng ở đây vẫn là cậu.' },
    { when: s => s.v.var_identity_revelation_stage >= 3 && s.v.var_architect_corruption >= 70, t: 'Nước rất tĩnh. Cậu nhìn vào trong đó, và lần đầu tiên, cậu không chắc người đang mỉm cười dưới đáy nước là mình hay là ông ta.' },
    { when: s => s.v.var_identity_revelation_stage >= 3, t: 'Mặt nước rung rinh vì tiếng sấm. Dù bức tượng đá ngoài kia có mang khuôn mặt ai đi nữa... người đang cúi xuống nhìn vũng nước này vẫn chỉ là cậu thôi.' },
    // [CẦN KIỂM TRA] handover ghi "Bond >= 120" trong khi mỗi bond chạy 0–100: ở đây hiểu là tổng ba bond.
    { when: s => s.v.var_identity_revelation_stage >= 1 && s.bondSum >= 120 && s.party.length >= 3, t: 'Vũng nước hơi chật. Phải chen chúc lắm mới đủ chỗ cho bốn cái bóng cùng cúi xuống nhìn một lúc.' },
    { when: () => true, t: 'Chỉ là một vũng nước mưa nhỏ. Trông cậu hơi ướt và lem luốc, nhưng không sao cả.' },
  ],
  puddleSaved: '(Đã lưu.)',

  // ---- Vật phẩm: mô tả là hàm của trạng thái (phản hồi vi mô) ---------------------------------
  items: {
    deed: {
      name: 'Tờ Khế Ước Trắng',
      desc: s => s.flags.flag_linh_heard_double_pulse
        ? 'Một tờ giấy trắng tinh không có lấy một chữ. Mira bảo con dấu in chìm ở góc nói rằng cả cái Ngân Hàng đang mắc nợ cậu. Cậu vẫn dùng nó gói bánh.' // guessed: tiếp nối lời Mira ở Kịch bản 2
        : 'Một tờ giấy trắng tinh không có lấy một chữ. Ít nhất thì khi không có chữ nào, cậu có thể dùng nó để gói bánh mì nóng mà không sợ bẩn tay.', // handover
    },
    bread: {
      name: 'Mẩu Bánh Mì',
      desc: s => s.flags.fox_fed ? 'Nửa mẩu bánh mì. Nửa kia đang nằm trong bụng một con cáo bốn tai.' : 'Mẩu bánh mì. Hơi cứng. Bụng cậu đang kêu.', // guessed
      use: 'eat',
    },
    soup: {
      name: 'Bát Súp Nấm Của Kaelen',
      desc: s => s.flags.flag_kael_knows_onion
        ? 'Hành lá đã được ai đó kiên nhẫn ngồi nhặt sạch ra khỏi bát bằng một đôi bàn tay bọc gốm khổng lồ. Hơi mặn một chút, nhưng nuốt vào thấy ấm từ cổ họng xuống tận mũi giày.' // handover
        : 'Bát súp nấm phát quang, vành hơi mẻ. Còn nổi mấy cọng hành lá: Kaelen chưa biết cậu không ăn hành. Chưa biết thôi.', // guessed: trước khi Kaelen biết
      use: 'heal', heal: 'Hồi đầy máu trong màn né.', // handover: hồi 80 HP; thang máu màn né nhỏ hơn nên là hồi đầy
    },
    memoria: {
      name: 'Đồng Xu Ký Ức Lẻ',
      desc: () => 'Đồng xu lành lạnh. Nếu áp lên tai, cậu sẽ nghe thấy tiếng một đứa trẻ đang cười khúc khích vì trốn tìm thắng bố mình. Ai đó đã phải túng quẫn lắm mới đem bán buổi chiều hôm ấy đi.', // handover
      use: 'cleanse',
      cleanse: 'Đồng xu vỡ tan thành một làn gió ấm bay ngược về phía khu dân cư. Cậu chẳng thu được đồng Lumen nào cả, ví tiền vẫn mỏng dính... nhưng bước chân cậu bỗng nhẹ tênh.', // handover
    },
    egg: {
      name: 'Trứng Hồ Ly Hoàng Gia',
      desc: s => s.flags.flag_kept_royal_egg ? 'Quấn trong khăn quàng của cậu, Linh giữ hộ. Tiếng chuông bên trong mỗi ngày một rõ.' : 'Vỏ còn ấm. Áp tai vào thấy tiếng chuông ngân khe khẽ, như có ai đang tập hát.', // guessed
    },
    core: { name: 'Lõi Lửa', desc: () => 'Cục than hồng to bằng nắm tay, vẫn còn ấm. Ở chợ người ta trả 200 Lumen cho thứ này.' }, // guessed
    fragment: { // handover: Mảnh Phản Chiếu (int_clue_fragments_found 0–12); nguồn trong Hồi 1 là các câu đố [guessed]
      name: 'Mảnh Phản Chiếu',
      desc: s => `${s.v.int_clue_fragments_found} mảnh kính nhỏ, sắc cạnh. Soi vào mỗi mảnh thấy một khuôn mặt hơi khác: mảnh nào cũng giống cậu, mà không mảnh nào hoàn toàn là cậu.`, // guessed
    },
    shard: {
      name: 'Mảnh Sắt Hình Móc',
      desc: () => 'Mảnh sắt gỉ gỡ ra từ khớp càng con cua. Một đầu cong như cái móc, đầu kia khắc ba vạch thẳng, đều nhau, như ai đó đánh dấu cho khỏi lẫn.', // guessed
    },
    mirror: {
      name: 'Tấm Gương Nhỏ',
      desc: () => 'Gương phẳng, vừa lòng bàn tay. Soi vào thấy Lõi Nhịp Tim đang đập.', // guessed
    },
    foxbag: { name: 'Túi Vải', desc: () => 'Một túi vải đang run. Thỉnh thoảng nó nhại lại tiếng tim cậu.' }, // guessed
  },

  // ---- Cảnh -----------------------------------------------------------------------------------
  scenes: {
    // ---- Câu đố tìm manh mối: bối cảnh và phần thưởng ----
    song_pre: [
      { w: 'nar', when: s => !s.flags.song_seen, t: '(Một cánh cửa đá liền vào vách sắt, không bản lề, không tay nắm. Mặt cửa khắc năm ký tự, và một dòng chữ chạy vòng theo mép cửa:)' },
      { w: 'nar', when: s => !s.flags.song_seen, t: '"Bắt đầu nơi hổ phách vỡ, xuống chỗ nước nằm, ghé nơi sắt im tiếng, dừng ở chỗ lửa thở."' },
      { w: 'nar', when: s => !s.flags.song_seen, t: '(Chạm vào ký tự nào, ký tự ấy ngân một nốt. Quanh cửa không có ống sắt nào. Chúng ở đâu đó trong thung lũng.)' },
      { do: 'clue:door_verse' }, { do: 'flag:song_seen' },
      { do: 'puzzle:song' },
    ],
    song_done: [
      { w: 'nar', t: '(Bốn nốt ngân nối thành một câu hát. Cánh cửa đá trượt sang một bên. Trên mặt đá bên trong, những chữ cổ sáng lên rồi tắt:)' },
      { w: 'nar', t: '"Mừng cậu về nhà."' }, // handover Hồi 2: cửa khoá 300 năm tự mở và hiện dòng này; gieo trước ở Hồi 1
      { w: 'nar', t: '(Trong hốc đá trống trơn, chỉ có một mảnh kính nhỏ, và một vết lõm vừa khít bàn tay cậu.)' }, // guessed
    ],
    quiet_hill: [
      { w: 'nar', t: '(Một đồi sắt vụn cao ngang vai. Gió lùa qua, mà không có tiếng kêu nào. Như sắt ở đây đã quên cách kêu.)' }, // guessed
      { w: 'linh', f: 'think', when: s => s.party.includes('linh'), t: 'Lạ thật. Sắt mà im thế này, tôi chưa nghe bao giờ.' },
      { do: 'clue:quiet_hill' },
    ],
    bridge_look: [
      { w: 'nar', when: s => !s.clues.includes('bridge_pin'), t: '(Một cây cầu sắt gãy ngang khe vực. Bên kia mép có ánh gì lấp lánh.)' },
      { w: 'nar', when: s => !s.clues.includes('bridge_pin'), t: '(Ở chân cầu bên này có một lỗ chốt trống. Chốt phải là một thanh sắt hình móc. Quanh lỗ khắc ba vạch thẳng, như để đánh dấu đúng cái chốt.)' },
      { do: 'clue:bridge_pin' },
      { w: 'nar', t: '(Cậu thử dùng gì?)' },
      { c: [
        { t: '[Lắp mảnh sắt hình móc vào lỗ chốt]', when: s => s.has.shard, fx: [], go: 'bridge_shard' },
        { t: '[Nhét Tờ Khế Ước Trắng vào lỗ chốt]', when: s => s.has.deed, fx: [], go: 'bridge_no_deed' },
        { t: '[Chèn mẩu bánh mì vào]', when: s => s.has.bread, fx: [], go: 'bridge_no_bread' },
        { t: '[Đặt quả trứng vào]', when: s => s.has.egg, fx: [], go: 'bridge_no_egg' },
        { t: '[Dùng Lõi Lửa làm chốt]', when: s => s.has.core, fx: [], go: 'bridge_no_core' },
        { t: '[Thôi]', fx: [], go: 'bridge_leave' },
      ] },
    ],
    bridge_no_deed: [{ w: 'nar', t: '(Một tờ giấy không chống được cả cây cầu. Dù trông nó có vẻ muốn thử.)' }],
    bridge_no_bread: [{ w: 'nar', t: '(Bánh mì không phải chốt sắt. Bụng cậu đồng ý, cây cầu thì không.)' }],
    bridge_no_egg: [{ w: 'nar', t: '(Quả trứng ngân lên một tiếng nghe rất giống "đừng". Cậu cất nó lại.)' }],
    bridge_no_core: [{ w: 'nar', t: '(Lõi Lửa nóng quá, cầm sát lỗ chốt đã thấy rát tay. Nó không phải cái chốt. Nhưng có khi lại dùng được vào việc khác.)' }],
    bridge_leave: [{ w: 'nar', t: '(Cậu đứng nhìn cây cầu thêm một lúc.)' }],
    bridge_shard: [
      { w: 'nar', t: '(Mảnh sắt trượt vào lỗ chốt. Ba vạch trên mảnh sắt khớp đúng ba vạch quanh lỗ. Nhưng chốt còn lỏng: phải nung cho chảy mép thì mới bám.)' },
      { c: [
        { t: '[Gọi con cua lò rèn]', when: s => s.flags.crab_spared, fx: [], go: 'bridge_crab' },
        { t: '[Đốt Lõi Lửa để nung chốt]', when: s => s.has.core, fx: ['item-core'], go: 'bridge_core' },
        { t: '[Chưa có gì đủ nóng. Để sau.]', fx: [], go: 'bridge_cold' },
      ] },
    ],
    bridge_crab: [
      { w: 'nar', t: '(Con cua lò rèn lạch bạch từ tổ ra, ngồi xuống cạnh chân cầu, mở toang cửa lò trên mai. Mép chốt đỏ lên, chảy ra, rồi bám chặt.)' }, // handover: cua cộng sinh "nung hộ quặng miễn phí"
      { w: 'nar', t: '(Xong việc, nó khép lò lại và lạch bạch về tổ. Không ai bảo nó làm thế.)' },
      { do: 'unitem:shard' }, { do: 'solve:bridge' }, { go: 'bridge_done' },
    ],
    bridge_core: [
      { w: 'nar', t: '(Cậu áp Lõi Lửa vào chân cầu. Than hồng sáng rực một lần cuối, mép chốt chảy ra rồi bám chặt. Lõi Lửa nguội thành một cục đá xám. Vex sẽ không trả đồng nào cho nó nữa.)' },
      { do: 'unitem:shard' }, { do: 'solve:bridge' }, { go: 'bridge_done' },
    ],
    bridge_cold: [
      { w: 'nar', t: s => s.flags.crab_killed ? '(Cần một cái lò. Cái lò gần nhất... đã tắt.)' : '(Cần một cái lò thật nóng. Cậu nhìn quanh thung lũng.)' },
    ],
    bridge_done: [
      { w: 'nar', t: '(Cây cầu đỡ được cậu. Bên kia mép vực, giữa đám sắt vụn, là một mảnh kính nhỏ.)' },
    ],
    light_pre: [
      { w: 'nar', when: s => !s.flags.light_seen, t: '(Cổng Chợ Đen là một cánh cửa gỗ đen, không có ổ khoá nào cho chìa. Chỉ có một bàn đá với những tấm gương nhỏ xoay được, và một khe hứng ánh sáng Lõi Nhịp Tim.)' },
      { w: 'mira', f: 'think', when: s => !s.flags.light_seen, t: 'Khoá gương của Thương Đoàn. Dẫn ánh sáng vào đúng hai lỗ khoá là cửa mở.' }, // handover: Mira dùng Lumen kích hoạt bẫy quang học
      { w: 'mira', f: 'think', when: s => !s.flags.light_seen, t: 'Nhưng bàn này thiếu hai tấm gương. Có kẻ đã gỡ đi để khỏi ai vào. Thương Đoàn hay giấu gương dự phòng ở chỗ ai cũng soi mà chẳng ai nhìn.' }, // guessed
      { w: 'mira', f: 'neutral', when: s => !s.flags.light_seen, t: 'À, và nhớ: ánh sáng phải qua lăng kính rồi mới chia đôi được. Hai lỗ khoá, hai đường sáng.' }, // guessed
      { do: 'clue:lock_mirrors' }, { do: 'clue:mira_riddle' }, { do: 'clue:mira_prism' }, { do: 'flag:light_seen' },
      { do: 'puzzle:light' },
    ],
    light_done: [
      { w: 'nar', t: '(Hai tia sáng chạm hai lỗ khoá cùng một lúc. Cánh cửa gỗ đen thở ra một hơi dài, rồi mở.)' },
      { w: 'mira', f: 'neutral', t: 'Nhanh hơn tôi tưởng. ...Kẹt ở khe cửa có mảnh kính này, chắc của cậu.' }, // guessed
    ],
    wake: [
      { w: 'nar', t: '(Một tiếng nứt khô khốc. Lớp hổ phách quanh người cậu vỡ ra như vỏ trứng.)' },
      { w: 'nar', t: '(Bầu trời không ở trên đầu. Bầu trời ở khắp nơi: những lục địa mọc ngược, những khu rừng phát quang treo lơ lửng, và ở chính giữa là một mặt trời đang đập như tim.)' },
      { w: 'nar', t: '(Trong túi áo chỉ có một tờ giấy trắng, và một mẩu bánh mì. Không tên. Không chữ. Không nhớ gì.)' },
      { do: 'item:deed' }, { do: 'item:bread' }, { do: 'goal:valley' },
    ],

    // Hồ Ly Âm Bản (handover 3.3, CRE_ECHOFOX)
    fox_first: [
      { w: 'nar', t: '(Một con hồ ly nhỏ có bốn cái tai. Bộ lông đổi màu theo từng tiếng sắt va nhau. Nó nhìn chằm chằm mẩu bánh mì trong tay cậu.)' },
      { w: 'nar', t: '(Bụng cậu cũng đang kêu.)' },
      { do: 'save' },
      { c: [
        { t: '[Bẻ đôi mẩu bánh, chìa phần to hơn] Ăn đi, đừng sợ, tôi không làm đau cậu đâu.', fx: ['var_eco_balance+eco_feed', 'flag_fox_fed=true', 'flag_fox_recorded_voice=true'], go: 'fox_fed' },
        { t: '[Cất bánh vào túi] Xin lỗi. Tôi cũng đói.', fx: [], go: 'fox_keep' },
        { t: '[Vồ lấy nó] Ở chợ, người ta trả 150 Lumen một con.', fx: ['var_eco_balance-eco_kill', 'var_architect_corruption+corrupt_kill', 'flag_fox_caught=true', 'item+foxbag'], go: 'fox_caught' },
      ] },
    ],
    fox_fed: [
      { w: 'nar', t: '(Con cáo nhỏ ăn xong, nghiêng đầu nhại lại đúng tiếng bụng cậu đang kêu:)' }, // handover
      { w: 'fox', f: 'happy', t: '"Ọc... ọc..."' }, // handover
      { w: 'nar', t: '(rồi dụi đầu vào giày cậu.)' }, // handover
      { w: 'nar', t: '(Từ giờ, nó lẽo đẽo theo sau. Thỉnh thoảng cái đuôi chuông gió của nó lặp lại một câu rất khẽ, nghe như giọng cậu.)' }, // guessed: gieo hạt cho Hồi 4
    ],
    fox_keep: [
      { w: 'nar', t: '(Con cáo nhìn theo mẩu bánh một lúc lâu, rồi lủi vào đống sắt. Bụng cậu vẫn kêu. Mẩu bánh không ngon như cậu tưởng.)' }, // guessed
    ],
    fox_caught: [
      { w: 'nar', t: '(Nó không cắn. Nó chỉ run, và nhại lại tiếng tim cậu đang đập: nhanh, rất nhanh.)' }, // guessed
      { w: 'nar', t: '(Cậu bỏ nó vào túi vải. Túi nặng thêm. Lát nữa ví cũng thế.)' },
    ],

    // Cua Giáp Lò Rèn (handover Hồi 1, CRE_RUSTCRAB)
    crab_pre: [
      { w: 'nar', t: '(Một con cua to như túp lều, trên mai là cái lò đỏ rực. Nó đang nổi điên, cào tung cả đồi sắt. Một mảnh sắt gỉ cắm sâu vào khớp càng.)' },
      { w: 'nar', t: '(Dưới càng nó là một cô gái đeo ống nghe đồng, ôm chặt một con cáo nhỏ.)' },
      { w: 'linh', f: 'afraid', t: 'Ê! Cậu kia! Đừng đứng nhìn! Nó không ác đâu, nó đau đấy! Có mảnh sắt kẹt trong khớp càng!' }, // guessed
      { w: 'linh', f: 'afraid', t: 'Tôi nghe được nhịp của nó. Nó sắp phun gì thì tôi hét lên cho cậu né!' }, // guessed: Linh là thợ máy thính âm
      { do: 'fight:crab' },
    ],
    crab_spared: [
      { w: 'nar', t: '(Mảnh sắt rời ra với một tiếng "cạch". Con cua đứng yên rất lâu.)' },
      { w: 'nar', when: s => s.flags.crab_warmed, t: '(Con cua khổng lồ khẽ khép bớt cửa lò trên mai lại một nửa để lửa không làm bỏng mặt cậu.)' }, // handover
      { w: 'nar', when: s => s.flags.crab_warmed, t: '(Trên lớp mai đá xù xì của nó vẫn còn vết khắc nguệch ngoạc từ rất lâu: "Đừng chạm vào, coi chừng phỏng tay nhé.")' }, // handover
      { w: 'nar', when: s => s.flags.crab_warmed, t: '(Nét chữ ấy... nhìn quen quen.)' }, // guessed: chưa lộ thân phận ở Hồi 1
      { w: 'nar', when: s => !s.flags.crab_warmed, t: '(Rồi nó lùi về đống sắt, nằm xuống, cửa lò trên mai vẫn mở toang. Nó không còn giận. Nó chỉ chưa tin ai.)' }, // guessed
      { w: 'nar', t: '(Cậu giữ lại mảnh sắt gỉ. Một đầu cong như cái móc, đầu kia khắc ba vạch.)' },
      { do: 'item:shard' }, { do: 'clue:shard_marks' },
      { go: 'linh_bandage' },
    ],
    crab_killed: [
      { w: 'nar', t: '(Con cua sụp xuống. Ngọn lửa trên mai tắt dần, để lại một cục than hồng to bằng nắm tay: Lõi Lửa.)' },
      { w: 'nar', t: '(Trên lớp mai còn một vết khắc nguệch ngoạc: "Đừng chạm vào, coi chừng phỏng tay nhé." Giờ thì chẳng còn gì để phỏng tay nữa.)' }, // guessed variant of the handover carving
      { w: 'linh', f: 'sad', t: '...Nó chỉ đau thôi mà.' }, // guessed
      { w: 'nar', t: '(Cậu rút mảnh sắt gỉ ra khỏi khớp càng. Một đầu cong như cái móc, đầu kia khắc ba vạch.)' },
      { do: 'item:shard' }, { do: 'clue:shard_marks' },
      { go: 'linh_bandage' },
    ],
    linh_bandage: [
      { w: 'linh', f: 'neutral', cue: 'Linh rút cuộn băng, kéo tay cậu lại', t: 'Đứng im nào! Khám nhịp tim với dán băng cá nhân một lần tính 5 Lumen nhé. Tôi ghi vào cuốn sổ bìa xanh này rồi đấy, cấm có bùng!' }, // handover
      { do: 'debt' }, { do: 'join:linh' },
      { w: 'linh', f: 'neutral', t: 'Tôi là Linh. Con này là Mốc. Còn cậu tên gì?' }, // guessed
      { c: [
        { t: '[Mở miệng, nhưng không nhớ ra gì cả]', fx: [], go: 'linh_name' },
        { t: '[Chìa tờ giấy trắng trong túi ra]', fx: ['var_bond_linh+5'], go: 'linh_name' },
      ] },
    ],
    linh_name: [
      { w: 'linh', f: 'think', t: '...Không tên, không chữ, không xu dính túi. Thôi được, tạm gọi là Kẻ Trắng Tay.' }, // guessed
      { w: 'linh', f: 'happy', t: 'Đi với tôi. Trên vách đá kia có người đang nấu súp, mũi tôi thính lắm.' }, // guessed
      { do: 'goal:cliff' },
    ],

    // Kaelen và Mira bên vách đá (handover Hồi 1)
    kael_mira: [
      { w: 'nar', t: '(Bên rìa vách đá, một người khổng lồ khoác giáp gốm chằng chịt vết nứt hàn vàng đang khuấy một nồi súp. Cạnh đó, một cô gái áo dài cổ cao đang gẩy chiếc bàn tính pha lê.)' },
      { w: 'kael', f: 'neutral', cue: 'Kaelen múc súp vào một chiếc bát mẻ vành, đẩy sang cho cậu', t: 'Cầm lấy cái bát mẻ này đi. Tại tôi lỡ tay cắt dư một củ nấm phát quang nên mới thừa ra phần thứ tư thôi, không phải nấu riêng cho cậu đâu.' }, // handover
      { w: 'mira', f: 'think', cue: 'Mira nhìn tờ giấy trắng trong túi áo cậu', t: 'Trên người không có nổi một xu, lại còn mất trí nhớ. Theo sổ cái của tôi thì hiện tại cậu đáng giá đúng... 0 Lumen tròn trĩnh. Đừng có chết sớm đấy, lỗ vốn tôi.' }, // handover
      { do: 'save' },
      { c: [
        { t: '[Nhìn mấy cọng hành nổi trong bát] ...Tôi không ăn được hành.', fx: ['var_bond_kael+10', 'flag_kael_knows_onion=true'], go: 'kael_onion' },
        { t: '[Ăn hết bát súp, không nói gì]', fx: ['var_bond_kael+5'], go: 'kael_eat' },
        { t: '[Quay sang Mira] 0 Lumen là rẻ hay là đắt?', fx: ['var_bond_mira+10'], go: 'mira_zero' },
      ] },
    ],
    kael_onion: [
      { w: 'kael', f: 'think', t: '...Ừ. Đưa đây.' }, // guessed
      { w: 'nar', t: '(Kaelen ngồi nhặt từng cọng hành ra khỏi bát bằng đôi bàn tay bọc gốm to gấp ba bàn tay cậu. Lâu lắm. Không ai giục.)' }, // guessed: nguồn gốc của "vớt hết hành ra như mọi khi" ở Hồi 3
      { go: 'kael_after' },
    ],
    kael_eat: [
      { w: 'kael', f: 'neutral', t: 'Ăn nhanh thế. Đói lâu rồi hả.' }, // guessed
      { go: 'kael_after' },
    ],
    mira_zero: [
      { w: 'mira', f: 'happy', t: 'Là chưa định giá được. Loại hàng đó tôi ghét nhất. Và cũng thích nhất.' }, // guessed
      { go: 'kael_after' },
    ],
    kael_after: [
      { do: 'item:soup' }, { do: 'join:kael' }, { do: 'join:mira' },
      { w: 'kael', f: 'neutral', t: 'Sáng mai có chuyến tàu lưng cá ghé vách đá. Lên Chợ Nổi mà kiếm việc. Bát kia cứ giữ lấy.' }, // guessed
      { do: 'goal:ship' },
    ],

    // Chợ Nổi: Cân Định Giá Linh Hồn (handover Hồi 1, biến cố cuối hồi)
    scale_pre: [
      { w: 'nar', t: '(Cổng Chợ Nổi. Một chiếc cân bằng đồng và pha lê, cao hơn cả Kaelen. Ai qua cổng cũng phải đặt tay lên.)' },
      { w: 'nar', t: '(Linh đặt tay: kim cân rung rồi dừng ở một con số nhỏ. Kaelen: con số lớn hơn. Mira: chiếc cân kêu lên một tiếng như cười.)' },
      { w: 'nar', t: '(Đến lượt cậu.)' },
      { do: 'fight:scale' },
    ],
    scale_after: [
      { w: 'nar', t: '(Trên mặt kính vỡ còn một dòng chữ cổ ngữ đang sáng:)' },
      { w: 'nar', t: 'OVERFLOW: ORIGIN_ENTITY' }, // handover
      { w: 'linh', f: 'afraid', t: 'Mảnh sắt sượt qua vai cậu mà... không chảy giọt máu nào. Chỉ có mấy hạt bụi sáng bay lên.' }, // guessed, theo lời Linh ở Kịch bản 2
      { w: 'mira', f: 'think', t: 'Một chiếc cân của Thương Đoàn vừa nổ tung vì cậu. Tôi bắt đầu thấy khoản đầu tư này thú vị rồi đấy.' }, // guessed
      { w: 'kael', f: 'neutral', t: 'Đêm nay đốt lửa ở mũi tàu. Có chuyện gì thì nói sau khi ăn.' }, // guessed
      { do: 'goal:camp' },
    ],

    // Chợ Đen: Kịch bản 1 (handover DLG_BAZAAR_EGG_DILEMMA, giữ nguyên văn)
    vex: [
      { w: 'vex', f: 'think', when: s => s.has.foxbag, t: 'Túi vải kia đang run. Hồ Ly Âm Bản sống, phải không? 150 Lumen. Tôi không hỏi gì thêm.' }, // guessed
      { do: 'sellfox', when: s => s.has.foxbag },
      { w: 'vex', f: 'think', when: s => s.has.core, t: 'Lõi Lửa còn ấm. 200 Lumen. Lò nào thế? ...Thôi, đừng kể.' }, // guessed
      { do: 'sellcore', when: s => s.has.core },
      { go: 'vex_egg', when: s => s.has.egg && !s.flags.egg_resolved },
      { w: 'vex', f: 'neutral', when: s => !(s.has.egg && !s.flags.egg_resolved), t: 'Không có gì để bán thì đứng xa sạp tôi ra một chút. Ánh sáng các vị che mất khách.' }, // guessed
    ],
    vex_egg: [
      { do: 'flag:egg_resolved' },
      { w: 'vex', f: 'think', cue: 'Đưa chiếc kính lúp pha lê soi sát quả trứng đang phát ra tiếng chuông ngân khe khẽ', t: 'Vỏ còn ấm. Tiếng chuông trong ruột trứng rất trong. Giao nó cho tôi, các vị cầm ngay 3.000 Lumen—hoặc 2 Đồng Xu Ký Ức nguyên niêm phong. Đủ để mua lại bất kỳ thứ gì các vị từng đánh mất.' },
      { w: 'linh', f: 'afraid', cue: 'Bàn tay dính dầu máy của Linh bỗng nắm chặt lấy tay áo cậu; cô ấy không nhìn quả trứng mà nhìn chằm chằm vào hai đồng xu trên bàn', t: 'Này... cậu nhìn kìa. Hai đồng xu đó... số hiệu seri trên mép xu đúng là lô hàng ở khu phố cũ của tôi rồi. Chỉ cần hai đồng đó thôi là tối nay tôi với cậu lấy lại được chiếc hộp nhạc của mẹ tôi rồi...' },
      { w: 'kael', f: 'neutral', cue: 'Không trách mắng Linh, chỉ lặng lẽ nhìn chú cáo Mốc đang rụt cổ trốn sau gáy cô', t: 'Linh này. Con cáo nhỏ trên vai cậu đang run đấy. Cậu thử đưa ống nghe vào quả trứng xem nó đang nói gì đi.' },
      { w: 'linh', f: 'sad', cue: 'Bàn tay Linh từ từ buông vạt áo cậu ra, cô cúi gằm mặt nhìn mũi giày rách của mình, giọng nhỏ như tiếng muỗi', t: 'Tôi không cần đeo ống nghe cũng biết mà Kael... Tôi chỉ là... tôi sợ ngày mai người khác mua mất hộp nhạc đó thôi. Nếu quên mất giọng bà ấy, tôi sợ một ngày nào đó tôi cũng quên luôn cách hát...' },
      { do: 'save' },
      { c: [
        { t: '[Bọc quả trứng vào chiếc khăn quàng của cậu rồi đưa cho Linh giữ] Cầm lấy cho nó ấm. Hộp nhạc của mẹ cậu, tôi với cậu tự cày cuốc thêm vài chuyến hàng nữa rồi chuộc về.',
          fx: ['var_bond_kael+15', 'var_bond_linh+10', 'var_eco_balance+10', 'flag_kept_royal_egg=true'], go: 'vex_keep' },
        { t: '[Đặt quả trứng lên bàn của Vex] Đưa 2 đồng xu đó cho cô ấy đi.',
          fx: ['item-egg', 'var_memoria_coins+2', 'var_bond_linh+5', 'var_bond_kael-25', 'var_eco_balance-15', 'var_architect_corruption+15', 'flag_sold_royal_egg=true'], go: 'vex_sell' },
        { t: '[Huých nhẹ vai Mira] Mira, cậu có cách nào vừa giữ được trứng vừa lấy được tiền đặt cọc không?', when: s => s.party.includes('mira'),
          fx: ['var_lumen_gold+1200', 'var_bond_linh+15', 'var_bond_kael+10', 'var_bond_mira+15', 'flag_kept_royal_egg=true'], go: 'vex_mira' },
      ] },
    ],
    vex_keep: [
      { w: 'linh', f: 'sad', cue: 'Linh ôm chặt quả trứng, sụt sịt', t: '...Đồ ngốc. Giao trứng cho một đứa đang túng tiền như tôi mà cậu không sợ tôi đem trốn mất à? Đi thôi, ở đây thêm một phút nữa là tôi khóc thật đấy, mất mặt lắm.' },
    ],
    vex_sell: [
      { w: 'kael', f: 'neutral', cue: 'Kaelen quay lưng đi, không nói thêm gì', t: '...Linh cầm được xu rồi thì chúng ta về trại thôi. Tối nay trời có vẻ trở lạnh đấy.' },
    ],
    vex_mira: [
      { w: 'mira', f: 'happy', cue: 'Mira búng một đồng xu lên bàn', t: 'Bán đứt con gà đẻ trứng vàng là nghiệp dư rồi Vex ạ. Chúng tôi giữ quả trứng, nhưng bán độc quyền bản thu âm tiếng ngân đầu tiên khi nó nở cho sạp của anh với giá 1.200 Lumen tiền mặt. Ký nhanh đi, tôi còn phải dẫn Linh đi đặt cọc giữ chỗ chiếc hộp nhạc trước giờ đóng cửa.' },
    ],

    // Sạp bánh: giá theo sinh thái (Event Bus)
    bread_shop: [
      { w: 'nar', t: s => `(Sạp bánh. Hôm nay một mẩu bánh mì giá ${s.breadPrice} Lumen.${s.flags.bugs_cleared ? ' Chủ sạp bảo từ lúc cá voi hết ngứa, thuế chợ cũng hạ.' : ''})` },
      { c: [
        { t: s => `[Mua một mẩu] ${s.breadPrice} Lumen`, when: s => s.v.var_lumen_gold >= s.breadPrice, fx: ['buy:bread'], go: 'bread_bought' },
        { t: '[Thôi]', fx: [], go: 'bread_no' },
      ] },
    ],
    bread_bought: [{ w: 'nar', t: '(Bánh còn ấm. Cậu gói nó vào tờ giấy trắng.)' }],
    bread_no: [{ w: 'nar', t: '(Cậu đi tiếp. Bụng vẫn kêu khe khẽ.)' }],

    // Bọ Ký Sinh trên lưng Kình Ngư (tuỳ chọn; handover CRE_LEVIATHAN)
    bug_pre: [
      { w: 'nar', t: '(Mấy con bọ to bằng nắm tay bám chặt vào lớp da xanh thẫm giữa hai tấm ván. Chỗ đó, da cá voi đỏ ửng lên.)' },
      { w: 'linh', f: 'think', t: 'Bọ Ký Sinh. Chúng phun dịch chua khi bị động vào. Né cho khéo rồi gỡ từng con một.' }, // guessed
      { do: 'fight:bug' },
    ],
    bug_after: [
      { w: 'nar', t: '(Con cuối cùng rời ra. Dưới chân cậu, cả sàn gỗ khẽ rung lên một hồi dài, như một tiếng thở phào.)' },
      { w: 'mira', f: 'happy', t: 'Cá voi hết ngứa thì chợ bớt chòng chành, thuế chợ hạ. Cậu vừa làm giảm giá cả khu chợ đấy, biết không?' }, // guessed: handover "giảm 20% thuế"
    ],

    deck: [
      { w: 'nar', t: s => s.flags.bugs_cleared
        ? '(Con cá voi già 500 tuổi khẽ nghiêng mình một góc cực nhỏ để che gió lùa cho đống lửa trại của nhóm bạn không bị tắt.)' // handover
        : '(Dưới bàn tay cậu, sàn gỗ ấm và đang thở. Rất chậm. Con cá voi bơi ngược gió, và có chỗ nào đó trên lưng nó đang ngứa.)' }, // guessed
    ],

    // Lửa trại cuối Hồi 1: Kịch bản 2 (handover DLG_CAMP_HEARTBEAT_MYSTERY, giữ nguyên văn)
    camp_pre: [
      { w: 'mira', f: 'think', cue: 'Cầm tờ Khế Ước Trắng của cậu, cẩn thận phủi mấy vụn bánh mì nướng còn dính trên mặt giấy', t: 'Tôi thực sự bái phục cậu đấy. Tờ giấy được dệt từ tơ Nhện Khúc Xạ cổ đại có một không hai trong lịch sử Ngân Hàng... mà cậu lấy dùng để gói bánh mì kẹp thịt xiên lúc chiều.' },
      { w: 'kael', f: 'neutral', cue: 'Múc súp ra một chiếc bát gốm hơi mẻ ở vành, đẩy sang phía bên trái cho cậu', t: 'Giấy nào gói được đồ ăn cho khỏi nguội thì đều là giấy tốt cả. Cầm lấy bát súp đi cậu. Tôi lỡ tay thái dư một củ nấm nên mới chia ra bốn bát đấy, đừng có nghĩ nhiều.' },
      { w: 'nar', when: s => s.flags.flag_kael_knows_onion, t: '(Trong bát không có cọng hành nào.)' }, // guessed: phản hồi vi mô
      { w: 'linh', f: 'neutral', cue: 'Rút cuốn sổ bìa xanh nhỏ xíu và chiếc ống nghe đồng ra, ngồi phịch xuống cạnh cậu', t: 'Khoan ăn đã! Lúc chiều chiếc cân ở cổng chợ nổ tung, mảnh sắt sượt qua vai cậu mà tôi chẳng thấy giọt máu nào, chỉ thấy mấy hạt bụi sáng bay lên. Ngồi im tôi khám nhịp tim cho—tính 5 Lumen thôi, tôi ghi vào sổ xanh nhé!' },
      { do: 'save' },
      { c: [
        { t: '[Ngồi thẳng lưng] Cứ tự nhiên. Nhớ khám kỹ vào cho đáng 5 Lumen của tôi đấy.', fx: ['var_bond_linh+10', 'var_identity_revelation_stage+1', 'flag_linh_heard_double_pulse=true', 'debt'], go: 'camp_listen' },
        { t: '[Cầm bát súp che trước ngực] Khám bệnh mà thu tiền bạn bè là không tốt đâu nhé. Tôi ăn súp của Kaelen đây.', fx: ['var_bond_kael+10', 'var_bond_linh+5', 'flag_linh_heard_double_pulse=true'], go: 'camp_tease' },
      ] },
    ],
    camp_listen: [
      { w: 'linh', f: 'awe', cue: 'Linh khựng lại, ống nghe vẫn áp vào ngực cậu', t: '...Ơ kìa. Sao trong ngực cậu lại đông vui thế? Có tới hai nhịp đập đang đuổi bắt nhau này... Một nhịp rất ấm, còn nhịp kia... nghe giống hệt tiếng gió thổi qua Lõi Nhịp Tim mỗi buổi sáng.' },
      { go: 'camp_close' },
    ],
    camp_tease: [
      { w: 'linh', f: 'awe', cue: 'Linh lén áp ống nghe vào', t: 'Bắt được rồi nhé—ủa? Khoan đã... Kael ơi, Mira ơi, sao trong người cậu ấy lại có tiếng chuông ngân thứ hai thế này? Nghe êm tai cực kỳ, giống hệt bài hát ru của mấy con Kình Ngư ấy...' },
      { go: 'camp_close' },
    ],
    camp_close: [
      { do: 'stage1' }, // handover: Kịch bản 2 nâng var_identity_revelation_stage ở nhánh nghe; nhánh trêu vẫn nghe thấy, nên ít nhất là 1 [CẦN KIỂM TRA]
      { w: 'mira', f: 'happy', cue: 'Mira trả lại tờ Khế Ước cho cậu', t: 'Hai nhịp tim thì càng khó chết chứ sao, đỡ làm tôi mất trắng khoản đầu tư. Cất tờ giấy gói bánh của cậu kỹ vào nhé—con dấu in chìm ở góc giấy nói rằng không phải cậu nợ Ngân Hàng đâu, mà là cả cái Ngân Hàng này đang mắc nợ cậu đấy.' },
      { w: 'nar', t: '(Đêm đó, Lõi Nhịp Tim đập. Và lần đầu tiên cậu nhận ra: ngực mình đập cùng nhịp với nó.)' }, // guessed
      { do: 'goal:sleep' },
    ],
    sleep: [
      { w: 'nar', t: '(Ngủ bên lửa trại? Hồi 1 sẽ khép lại ở đây.)' },
      { c: [
        { t: '[Nằm xuống]', fx: [], go: 'act_end' },
        { t: '[Chưa, đi dạo thêm một chút]', fx: [], go: 'sleep_no' },
      ] },
    ],
    sleep_no: [{ w: 'nar', t: '(Lửa vẫn cháy. Không ai giục.)' }],
    act_end: [{ do: 'actend' }],
  },

  // ---- Màn đấu né đòn -------------------------------------------------------------------------
  fights: {
    crab: {
      title: 'Cua Giáp Lò Rèn',
      intro: 'Con cua gầm lên. Lò trên mai phun lửa.',
      // Linh nghe trước đợt đòn (bạn đồng hành báo trước)
      warn: { sparks: 'Linh: "Nó sắp rũ lửa trên mai xuống! Né mấy đốm sáng!"', slag: 'Linh: "Xỉ sắt! Nó sẽ lăn ngang! Nhảy qua khe hở!"', pillars: 'Linh: "Lò nóng quá rồi! Chỗ nào đỏ lên là chỗ đó phụt lửa!"' },
      quiet: s => s.rage > 70 ? 'Con cua thở phì phò. Càng nó vẫn cào xuống đất.' : s.rage > 35 ? 'Con cua khựng lại, nhìn cậu. Lửa trên mai hạ xuống một chút.' : 'Con cua đứng im. Nó giơ cái càng bị kẹt ra, như đang chờ.',
      actions: [
        { id: 'whisper', label: 'Nói khẽ', hint: 'Làm dịu cơn giận' },
        { id: 'warm', label: 'Ngồi sưởi cạnh nó', hint: 'Dịu chậm, nhưng nó sẽ nhớ' },
        { id: 'pull', label: 'Gỡ mảnh sắt', hint: 'Chỉ được khi nó đã dịu' },
        { id: 'strike', label: 'Đánh', hint: 'Nhanh hơn. Có giá.' },
        { id: 'soup', label: 'Ăn súp', hint: 'Hồi đầy máu', needs: 'soup' },
      ],
      lines: {
        whisper: 'Cậu nói rất khẽ, không biết mình đang nói gì. Con cua nghiêng đầu nghe.',
        warm: 'Cậu ngồi xuống cạnh cái lò, chìa tay ra sưởi. Hơi nóng rát mặt. Con cua nhìn cậu, rất lâu.',
        warm2: 'Cậu vẫn ngồi đó. Con cua khép bớt cửa lò trên mai lại một nửa.',
        pullNo: 'Cậu chạm vào mảnh sắt. Nó giật càng lại, gầm lên. Còn đau quá, còn giận quá.',
        strike: 'Cậu đánh vào khớp càng. Con cua rú lên. Lửa trên mai bùng cao hơn.',
        soup: 'Cậu húp vội bát súp. Ấm từ cổ họng xuống tận mũi giày.',
        resonance: 'Hai nhịp tim trong ngực cậu đập cùng một lúc. Hành động này mạnh gấp đôi.',
        wait: 'Cậu chần chừ. Khoảng lặng trôi qua.',
        down: 'Cậu gục xuống. Linh hét gì đó. Cậu chống tay đứng dậy.',
      },
    },
    scale: {
      title: 'Cân Định Giá Linh Hồn',
      intro: 'Kim cân quay tít. Mặt kính nứt toác. Nó sắp nổ!',
      warn: { burst: 'Kaelen: "Nằm xuống! Mảnh kính bay tứ phía!"' },
      end: 'Tiếng nổ tắt. Kaelen hạ chiếc khiên gốm xuống.',
      down: 'Một mảnh kính sượt qua vai cậu. Kaelen kéo cậu ra sau khiên.',
    },
    bug: {
      title: 'Bọ Ký Sinh',
      intro: 'Mấy con bọ dựng lưng, phun dịch chua.',
      warn: { spit: 'Linh: "Chúng phun theo hướng cậu đứng! Đi vòng, đừng đứng yên!"' },
      quiet: () => 'Mấy con bọ phun mệt, đang hít hơi.',
      actions: [
        { id: 'pick', label: 'Gỡ một con', hint: 'Gỡ con gần nhất ra khỏi da cá voi' },
        { id: 'soup', label: 'Ăn súp', hint: 'Hồi đầy máu', needs: 'soup' },
      ],
      lines: {
        pick: 'Cậu luồn tay gỡ một con. Da cá voi bên dưới đỏ ửng, nhưng dịu dần.',
        soup: 'Cậu húp vội bát súp.',
        wait: 'Cậu chần chừ. Khoảng lặng trôi qua.',
        down: 'Dịch chua bắn trúng mắt. Linh lau cho cậu. Thử lại nào.',
      },
    },
  },

  // ---- Câu đố tìm manh mối (dữ liệu; engine ở index.html) -----------------------------------
  // Luật: màn câu đố không chứa sẵn đáp án. Manh mối nằm ngoài thế giới (soi đồ, gõ ống, nghe người
  // nói) và được ghi vào Sổ manh mối (phím J). Sai không bị khoá; đi tìm thêm rồi quay lại.
  // Thưởng mỗi câu: +1 Mảnh Phản Chiếu. Rương người thợ cũ và Cân Thử để lượt sau.
  glyphs: ['Lá', 'Sóng', 'Móc', 'Mắt', 'Chạc'],
  pipes: { // năm ống sắt rải khắp Thung Lũng; mỗi ống khắc một ký tự, ngân một nốt
    amber: { glyph: 0, place: 'kén hổ phách vỡ' },
    water: { glyph: 1, place: 'vũng nước mưa' },
    quiet: { glyph: 2, place: 'đồi sắt im tiếng' },
    fire: { glyph: 3, place: 'lò của con cua' },
    egg: { glyph: 4, place: 'chỗ quả trứng nằm' },
  },
  pipeLine: (place, g) => `(Một ống sắt dựng đứng cạnh ${place}. Cậu gõ thử: nó ngân một nốt, ngân rất lâu. Trên thân ống khắc một ký tự hình ${g}.)`,
  puzzles: {
    song: {
      label: 'Xem cánh cửa đá', title: 'Cửa Đá Hát',
      help: 'Mũi tên: chọn ký tự · E: gõ · X: xoá nốt cuối · J: Sổ manh mối · Q: thôi',
      verse: 'Bắt đầu nơi hổ phách vỡ, xuống chỗ nước nằm, ghé nơi sắt im tiếng, dừng ở chỗ lửa thở.', // guessed
      doorOrder: [3, 0, 4, 1, 2], // năm ký tự trên mặt cửa, xếp lộn để không lộ thứ tự
      answer: [0, 1, 2, 3],       // Lá (kén) → Sóng (vũng nước) → Móc (đồi im) → Mắt (lò cua); Chạc (trứng) là ống mồi
      wrong: 'Cửa ngân một tiếng trầm, như thở dài. Các ký tự tắt hết.',
      nudge: 'Linh: "Câu khắc trên cửa nói đi theo đường nào ấy nhỉ? Mở sổ ra xem đi."', // guessed
      foxHum: 'Con hồ ly bốn tai ngồi trước cửa, ngân hai nốt: nốt đầu và nốt cuối của một bài hát nó từng nghe ở đây.', // guessed
    },
    light: {
      label: 'Ổ khoá tia sáng ở cổng Chợ Đen', title: 'Khoá Gương Chợ Đen',
      help: 'Mũi tên: chọn ô · E: đặt / xoay gương · X: nhấc gương khỏi hốc · H: nhờ Mira (Lumen) · J: Sổ · Q: thôi',
      // S nguồn sáng · m gương có sẵn (xoay được) · o hốc trống (đặt gương tìm được) · P lăng kính · # vách · A, B ổ khoá
      // Đã kiểm bằng bộ giải: đặt đúng 2 gương vào 2 trong 4 hốc → đúng 1 lời giải.
      rows: ['S.m.#..', '.......', 'o.P.m.o', '......#', '..o.o.A', 'B......'],
      needMirrors: 2,
      missing: n => `Trên bàn đá còn hốc gương trống, mà trong túi cậu mới có ${n} tấm gương.`,
      hint: c => `Mira gẩy bàn tính: "Chỗ sáng kia sai rồi. ${c} Lumen, tôi ghi sổ."`,
      poor: 'Mira: "Hết tiền thì thôi, lần này tôi chỉ không lấy tiền. Chỉ lần này thôi đấy."',
    },
  },
  clues: { // Sổ manh mối: mỗi manh mối một mục
    door_verse: { group: 'Cửa Đá Hát', title: 'Câu khắc trên cửa đá', text: '"Bắt đầu nơi hổ phách vỡ, xuống chỗ nước nằm, ghé nơi sắt im tiếng, dừng ở chỗ lửa thở."' },
    pipe_amber: { group: 'Cửa Đá Hát', title: 'Ống sắt cạnh kén hổ phách vỡ', glyph: 0 },
    pipe_water: { group: 'Cửa Đá Hát', title: 'Ống sắt cạnh vũng nước mưa', glyph: 1 },
    pipe_quiet: { group: 'Cửa Đá Hát', title: 'Ống sắt cạnh đồi sắt im tiếng', glyph: 2 },
    pipe_fire: { group: 'Cửa Đá Hát', title: 'Ống sắt cạnh lò của con cua', glyph: 3 },
    pipe_egg: { group: 'Cửa Đá Hát', title: 'Ống sắt cạnh chỗ quả trứng nằm', glyph: 4 },
    quiet_hill: { group: 'Cửa Đá Hát', title: 'Đồi sắt im tiếng', text: 'Gió lùa qua đồi sắt sau lò con cua mà không có tiếng kêu nào.' },
    fox_hum: { group: 'Cửa Đá Hát', title: 'Hồ ly ngân hai nốt', text: 'Nốt đầu là nốt của ký tự Lá, nốt cuối là nốt của ký tự Mắt.' },
    bridge_pin: { group: 'Cây cầu gãy', title: 'Lỗ chốt ở chân cầu', text: 'Chốt phải là một thanh sắt hình móc. Quanh lỗ khắc ba vạch thẳng.' },
    shard_marks: { group: 'Cây cầu gãy', title: 'Mảnh sắt gỡ từ càng cua', text: 'Một đầu cong như cái móc, đầu kia khắc ba vạch thẳng.' },
    lock_mirrors: { group: 'Khoá Chợ Đen', title: 'Bàn gương thiếu gương', text: 'Ổ khoá có hốc gương trống. Thiếu hai tấm gương.' },
    mira_riddle: { group: 'Khoá Chợ Đen', title: 'Mira nói về gương dự phòng', text: '"Thương Đoàn hay giấu gương dự phòng ở chỗ ai cũng soi mà chẳng ai nhìn."' },
    mira_prism: { group: 'Khoá Chợ Đen', title: 'Mira nói về lăng kính', text: '"Ánh sáng phải qua lăng kính rồi mới chia đôi được. Hai lỗ khoá, hai đường sáng."' },
    scale_glass: { group: 'Khoá Chợ Đen', title: 'Mặt kính cân vỡ', text: 'Một tấm kính của Cân Định Giá còn nguyên, phẳng, soi được: một tấm gương.' },
    puddle_mirror: { group: 'Khoá Chợ Đen', title: 'Dưới đáy vũng nước', text: 'Dưới đáy vũng nước ở Chợ Nổi có một tấm gương ai đó giấu. Chỗ ai cũng soi, mà chẳng ai nhìn.' },
  },
  clueToast: t => `Ghi vào sổ: ${t}`,
  puddleMirror: ['Lần này cậu không nhìn mặt mình. Cậu nhìn xuống đáy.', 'Dưới lớp nước nông có một tấm gương nhỏ, ai đó giấu ở đây. Chỗ ai cũng soi, mà chẳng ai nhìn.'], // guessed

  goals: {
    valley: 'Tìm đường ra khỏi thung lũng', cliff: 'Lên vách đá, chỗ có khói bếp', ship: 'Lên lưng Kình Ngư ở cuối thung lũng',
    camp: 'Tìm chỗ đốt lửa ở mũi tàu', sleep: 'Ngủ bên lửa trại',
  },

  pickups: {
    mirror_scale: ['Giữa đống kính vỡ của chiếc cân có một tấm còn nguyên, phẳng như mặt nước. Cậu nhặt lên.', 'Soi vào thấy Lõi Nhịp Tim. Và một nửa mặt cậu.'], // guessed
    egg: ['Một quả trứng to bằng nắm tay, nằm lọt giữa hai thanh sắt. Vỏ còn ấm. Bên trong có tiếng chuông ngân khe khẽ.', 'Quanh đó không có tổ, chỉ có một vệt kéo lê và dấu chân cua. Cậu bọc nó vào vạt áo.'], // guessed: handover không nói trứng ở đâu ra
  },

  hints: {
    puddle: 'Cúi nhìn vũng nước', puzzleDone: 'Đã xong', travel: 'Lên lưng Kình Ngư', shop: 'Sạp bánh', vex: 'Sạp của Vex',
    bug: 'Gỡ Bọ Ký Sinh', deck: 'Áp tay lên sàn gỗ', sleep: 'Ngủ bên lửa trại', egg: 'Nhặt quả trứng ấm', mirror_scale: 'Nhặt tấm kính còn nguyên', pipe: 'Gõ ống sắt',
  },

  // ---- Màn kết Hồi 1: thế giới ghi lại những gì về cậu (không có con số) -----------------
  actEnd: {
    title: 'Hết Hồi 1 · Kẻ Trắng Tay',
    lines: [
      s => `Sổ xanh của Linh: nợ ${s.v.var_linh_tab_debt} Lumen. Chưa trả.`,
      s => s.flags.fox_fed ? 'Ở Thung Lũng Phế Liệu, một con cáo bốn tai vẫn còn nhớ tiếng bụng cậu.' : s.flags.fox_caught ? 'Ở Chợ Đen, có một túi vải từng run.' : 'Ở Thung Lũng Phế Liệu, một con cáo bốn tai vẫn đói.',
      s => s.flags.crab_spared ? (s.flags.crab_warmed ? 'Một con cua già khép lò lại một nửa mỗi khi có ai ngồi cạnh.' : 'Một con cua già nằm nghỉ, càng không còn mảnh sắt.') : 'Ở Thung Lũng Phế Liệu, một cái lò đã tắt.',
      s => s.flags.flag_kept_royal_egg ? 'Trong khăn quàng của cậu, một quả trứng đang tập hát.' : s.flags.flag_sold_royal_egg ? 'Trong túi Linh có hai đồng xu. Kaelen chưa nói lại câu nào với cậu.' : null,
      s => s.flags.flag_kael_knows_onion ? 'Kaelen đã biết cậu không ăn hành.' : null,
      s => s.v.int_clue_fragments_found > 0 ? `Trong túi cậu có ${s.v.int_clue_fragments_found} Mảnh Phản Chiếu. Chưa mảnh nào khớp hẳn với mặt cậu.` : null,
      s => `Mira định giá cậu: 0 Lumen.`,
      s => s.v.var_identity_revelation_stage >= 1 ? 'Trong ngực cậu có hai nhịp tim.' : null,
    ],
    next: 'Hồi 2 · Dấu Chân Kẻ Sáng Thế — chưa có trong bản này.',
  },

  ui: {
    title: 'TRONG', sub: 'Kẻ đang được cậu điều khiển thực sự là ai?',
    start: 'Enter: bắt đầu', cont: 'C: chơi tiếp chỗ đã lưu',
    controls: ['A/D hoặc mũi tên: đi · E: tương tác', 'Space: lời tiếp theo · phím số: chọn', 'I: túi đồ · J: sổ manh mối · L: nhật ký · P: tạm dừng · M: tắt tiếng', 'Trong màn né: mũi tên để né · Shift: đi chậm'],
    lumen: 'Lumen', memoria: 'Xu Ký Ức', goal: 'Việc đang làm', debt: n => `Sổ xanh của Linh: nợ ${n} Lumen`,
    paused: 'Tạm dừng', speed: 'Tốc độ chữ', speedHint: 'Mũi tên trái, phải: đổi tốc độ chữ', resume: 'P: chơi tiếp',
    log: 'Nhật ký lời thoại', logHint: 'L: đóng · Mũi tên lên, xuống: cuộn',
    journal: 'Sổ manh mối', journalHint: 'J: đóng · Mũi tên lên, xuống: cuộn', journalEmpty: '(Chưa ghi gì. Soi đồ vật, gõ thử, hỏi người khác.)',
    inv: 'Túi đồ', invHint: 'Mũi tên: chọn · E: dùng · I: đóng', invEmpty: '(Trống.)', cleanse: 'E: Bóp vỡ / Thanh Tẩy', eat: 'E: Ăn',
    advance: 'Space', choose: 'Phím số, hoặc mũi tên rồi Enter',
    hp: 'Máu', resonance: 'Cộng hưởng', rage: 'Giận', hpBoss: 'Máu', left: n => `Còn ${n} con`, survive: n => `Chịu thêm ${n} giây`,
    quietTitle: 'Khoảng lặng', quietHint: 'Phím số để chọn', again: 'Enter: chơi lại từ đầu',
  },
};
