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
      name: 'Thung Lũng Phế Liệu · Tầng Ngoài', w: 2900, ground: 600,
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
        // Rương người thợ cũ: câu đố dùng đủ Bốn cách hỏi (Nghe · Định giá · Vọng lại · Soi)
        { x: 2000, type: 'inspect', id: 'forge' },
        { x: 2090, type: 'inspect', id: 'belt' },
        { x: 2170, type: 'inspect', id: 'pool_dark' },
        { x: 2280, type: 'inspect', id: 'pile_rust' },
        { x: 2380, type: 'inspect', id: 'pile_gear' },
        { x: 2480, type: 'inspect', id: 'pile_copper' },
        { x: 2580, type: 'inspect', id: 'pile_beam' },
        { x: 2780, type: 'travel', to: 'chonoi', when: s => s.flags.met_kael },
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
      { x: 1960, t: 'Một xưởng rèn bỏ hoang. Ai đó đã rời đi rất vội.' },
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
      { do: 'clue:need_heat' },
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
    chest_done: [
      { w: 'nar', t: '(Mọi mảnh ghép khớp lại. Cậu bới đống ống đồng. Dưới cùng là một hộp thiếc móp méo, khoá đã gỉ đứt từ lâu.)' },
      { w: 'nar', t: '(Trong hộp có ít Lumen cũ, một chiếc búa nhỏ bọc vải, và một mảnh kính sắc cạnh. Soi vào, cậu thấy mặt mình, nhưng già hơn một chút.)' }, // guessed
      { w: 'linh', f: 'awe', when: s => s.party.includes('linh'), t: 'Ba trăm năm mà vẫn còn. Ông ấy chắc mong ai đó tìm thấy lắm.' }, // guessed
      { w: 'mira', f: 'think', when: s => s.party.includes('mira'), t: 'Lumen đời cũ, vẫn tiêu được. Còn cái mảnh kính kia... tôi không định giá được. Lạ thật.' }, // guessed
      { do: 'gain:40' },
    ],
    ask_leave: [],
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
      { do: 'clue:crab_rage' },
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
      { w: 'nar', t: '(Cậu đặt tay lên mặt kính. Kim cân quay tít, không dừng. Mặt kính nứt toác.)' }, // handover: chạm vào thì cân nổ tung
      { w: 'kael', f: 'neutral', t: 'Nằm xuống!' }, // guessed
      { w: 'nar', t: '(Chiếc cân nổ tung. Kaelen giơ khiên gốm che cả nhóm. Mảnh kính rơi lách tách như mưa.)' }, // guessed
      { do: 'flag:flag_scale_exploded' }, { do: 'clue:scale_overflow' },
      { go: 'scale_after' },
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
      { w: 'linh', f: 'think', t: 'Bọ Ký Sinh. Chúng phun dịch chua khi bị động vào. Né cho khéo, lúc chúng hít hơi thì đứng vào vòng sáng mà gỡ.' }, // guessed
      { do: 'fight:bug' },
    ],
    bug_after: [
      { w: 'nar', t: '(Con cuối cùng rời ra. Dưới chân cậu, cả sàn gỗ khẽ rung lên một hồi dài, như một tiếng thở phào.)' },
      { w: 'linh', f: 'happy', when: s => s.flags.bug_queen_first, t: 'Gỡ đúng con đầu đàn là cả đàn đi. Như bắt mạch ấy: tìm chỗ đập lệch.' }, // guessed
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
    door_verse: { case: 'song', title: 'Câu khắc trên cửa đá', text: '"Bắt đầu nơi hổ phách vỡ, xuống chỗ nước nằm, ghé nơi sắt im tiếng, dừng ở chỗ lửa thở."' },
    pipe_amber: { case: 'song', title: 'Ống sắt cạnh kén hổ phách vỡ', glyph: 0 },
    pipe_water: { case: 'song', title: 'Ống sắt cạnh vũng nước mưa', glyph: 1 },
    pipe_quiet: { case: 'song', title: 'Ống sắt cạnh đồi sắt im tiếng', glyph: 2 },
    pipe_fire: { case: 'song', title: 'Ống sắt cạnh lò của con cua', glyph: 3 },
    pipe_egg: { case: 'song', title: 'Ống sắt cạnh chỗ quả trứng nằm', glyph: 4 },
    quiet_hill: { case: 'song', title: 'Đồi sắt im tiếng', text: 'Gió lùa qua đồi sắt sau lò con cua mà không có tiếng kêu nào.' },
    fox_hum: { case: 'song', title: 'Hồ ly ngân hai nốt', text: 'Nốt đầu là nốt của ký tự Lá, nốt cuối là nốt của ký tự Mắt.' },
    bridge_pin: { case: 'bridge', title: 'Lỗ chốt ở chân cầu', text: 'Chốt phải là một thanh sắt hình móc. Quanh lỗ khắc ba vạch thẳng.' },
    shard_marks: { case: 'bridge', title: 'Mảnh sắt gỡ từ càng cua', text: 'Một đầu cong như cái móc, đầu kia khắc ba vạch thẳng.' },
    lock_mirrors: { case: 'light', title: 'Bàn gương thiếu gương', text: 'Ổ khoá có hốc gương trống. Thiếu hai tấm gương.' },
    mira_riddle: { case: 'light', title: 'Mira nói về gương dự phòng', text: '"Thương Đoàn hay giấu gương dự phòng ở chỗ ai cũng soi mà chẳng ai nhìn."' },
    mira_prism: { case: 'light', title: 'Mira nói về lăng kính', text: '"Ánh sáng phải qua lăng kính rồi mới chia đôi được. Hai lỗ khoá, hai đường sáng."' },
    scale_glass: { case: 'light', title: 'Mặt kính cân vỡ', text: 'Một tấm kính của Cân Định Giá còn nguyên, phẳng, soi được: một tấm gương.' },
    crab_pain: { case: 'crab', title: 'Linh nghe con cua', text: 'Khớp càng trái có tiếng rít, như sắt cứa vào thịt.' },
    crab_shard: { case: 'crab', title: 'Soi khớp càng', text: 'Một mảnh sắt gỉ cắm sâu ở khớp càng trái.' },
    scale_overflow: { case: 'scale', title: 'Chữ trên mặt kính cân', text: 'OVERFLOW: ORIGIN_ENTITY. Dòng chữ cổ hiện lên khi chiếc cân nổ vì cậu.' }, // handover
    bug_queen: { case: 'bug', title: 'Con bọ đầu đàn', text: 'Một con đập chậm, nặng, lệch nhịp; cả đàn đập theo nó. Gỡ nó là cả đàn bỏ đi.' }, // guessed
    crab_memory: { case: 'crab', title: 'Hồ ly vọng lại', text: 'Một giọng rất xưa: "Đừng chạm vào, coi chừng phỏng tay nhé." Con cua nhận ra giọng ấy.' },
    need_heat: { case: 'bridge', title: 'Chốt còn lỏng', text: 'Mảnh sắt vừa khớp lỗ chốt nhưng còn lỏng. Phải nung cho chảy mép.' },
    // Rương người thợ cũ: mỗi manh mối có thể cho từ khoá (keys) để điền Bàn Ghép
    forge_order: { case: 'chest', title: 'Tấm biển trên cột lò', text: '"Mọi thợ rời xưởng trước giờ khoá cổng."', keys: ['k_gate'] },
    forge_listen: { case: 'chest', title: 'Linh nghe cái lò', text: 'Lò tắt vội. Than ở dưới còn nguyên hình cục, chưa kịp cháy hết.' },
    forge_appraise: { case: 'chest', title: 'Mira định giá cái lò', text: 'Lò của Thương Đoàn. Đóng cửa ít nhất ba trăm năm.', keys: ['k_guild', 'k_300'] },
    forge_echo: { case: 'chest', title: 'Hồ ly vọng lại ở lò', text: 'Một giọng khàn: "…để dưới ống đồng… nhanh lên, trước khi cổng khoá…" Rồi tiếng thiếc va vào sắt.' },
    belt_look: { case: 'chest', title: 'Đai dụng cụ bỏ quên', text: 'Đồ nghề còn cài nguyên trên đai. Không ai bỏ đồ nghề tốt thế này, trừ khi phải chạy.', keys: ['k_belt', 'k_forgot'] },
    belt_appraise: { case: 'chest', title: 'Mira định giá cái đai', text: 'Đai thợ rèn Thương Đoàn, kiểu khoá ba trăm năm trước. Không phải đồ thợ Chợ Nổi.', keys: ['k_guild', 'k_300', 'k_market'] },
    pool_look: { case: 'chest', title: 'Soi vũng nước đen', text: 'Mặt nước cho thấy một buổi chiều khác: một người ôm hộp thiếc đi về phía có ánh đồng lấp lánh, rồi khuỵu xuống đào.', keys: ['k_tin'] },
    rust_listen: { case: 'chest', title: 'Linh nghe đống tôn gỉ', text: 'Đặc. Toàn tôn đè lên tôn.' },
    gear_listen: { case: 'chest', title: 'Linh nghe đống bánh răng', text: 'Rỗng ở dưới, nhưng có tiếng chạy lạo xạo, như chuột.', keys: ['k_rat'] },
    gear_appraise: { case: 'chest', title: 'Mira định giá đống bánh răng', text: 'Bánh răng máy kéo, mới chừng mười năm. Không phải đồ cổ.', keys: ['k_10'] },
    copper_listen: { case: 'chest', title: 'Linh nghe đống ống đồng', text: 'Rỗng, và có gì đó bằng thiếc nằm dưới, gõ vào kêu boong boong.' },
    beam_listen: { case: 'chest', title: 'Linh nghe đống dầm gãy', text: 'Đặc, nứt dọc. Sắp sập.' },
    crab_rage: { case: 'chest', title: 'Con cua nổi điên', text: 'Con cua lò rèn nổi điên vì mảnh sắt kẹt ở khớp càng.', keys: ['k_crab'] },
    puddle_mirror: { case: 'light', title: 'Dưới đáy vũng nước', text: 'Dưới đáy vũng nước ở Chợ Nổi có một tấm gương ai đó giấu. Chỗ ai cũng soi, mà chẳng ai nhìn.' },
  },
  clueToast: t => `Ghi vào sổ: ${t}`,

  // ---- Sổ 2.0: mỗi hồ sơ có câu hỏi mở; câu hỏi được trả lời khi có ít nhất một manh mối của nó ----
  cases: {
    song: { title: 'Cửa Đá Hát', region: 'Thung Lũng: cạnh kén, vũng nước, lò cua, đồi sắt', questions: [
      { q: 'Cửa muốn nghe gì?', clues: ['door_verse'] },
      { q: 'Nơi hổ phách vỡ khắc ký tự gì?', clues: ['pipe_amber'] },
      { q: 'Chỗ nước nằm khắc ký tự gì?', clues: ['pipe_water'] },
      { q: 'Đâu là nơi sắt im tiếng?', clues: ['quiet_hill'] },
      { q: 'Nơi sắt im tiếng khắc ký tự gì?', clues: ['pipe_quiet'] },
      { q: 'Chỗ lửa thở khắc ký tự gì?', clues: ['pipe_fire'] },
    ] },
    bridge: { title: 'Cây cầu gãy', region: 'Thung Lũng: khe vực sau lò cua', questions: [
      { q: 'Chân cầu thiếu gì?', clues: ['bridge_pin'] },
      { q: 'Lấy cái chốt ở đâu?', clues: ['shard_marks'] },
      { q: 'Lấy gì nung chốt?', clues: ['need_heat'] },
    ] },
    crab: { title: 'Con cua lò rèn', region: 'Trong trận: đứng sát khớp càng trái trong lúc né', questions: [
      { q: 'Nó đau ở đâu?', clues: ['crab_pain'] },
      { q: 'Cái gì làm nó đau?', clues: ['crab_shard'] },
      { q: 'Nó có nhớ ai không?', clues: ['crab_memory'] },
    ] },
    chest: { title: 'Rương người thợ cũ', region: 'Thung Lũng: xưởng rèn bỏ hoang sau vách đá', board: 'chest', questions: [
      { q: 'Ai làm ở xưởng này?', clues: ['forge_appraise', 'belt_appraise'] },
      { q: 'Vật gì bị giấu?', clues: ['pool_look'] },
      { q: 'Giấu dưới đống nào?', clues: ['copper_listen', 'forge_echo'] },
      { q: 'Khi nào, vì sao vội?', clues: ['forge_order', 'belt_look'] },
    ] },
    scale: { title: 'Cân Định Giá Linh Hồn', region: 'Cổng Chợ Nổi: dòng chữ trên mặt kính khi cân nổ', questions: [
      { q: 'Chiếc cân nói gì về cậu?', clues: ['scale_overflow'] },
    ] },
    bug: { title: 'Bọ Ký Sinh', region: 'Lưng Kình Ngư: nghe từng con trong lúc né', questions: [
      { q: 'Con nào là đầu đàn?', clues: ['bug_queen'] },
    ] },
    light: { title: 'Khoá Gương Chợ Đen', region: 'Chợ Nổi: cổng, vũng nước, lời Mira', questions: [
      { q: 'Bàn gương thiếu gì?', clues: ['lock_mirrors'] },
      { q: 'Tấm gương thứ nhất ở đâu?', clues: ['scale_glass'] },
      { q: 'Tấm gương thứ hai ở đâu?', clues: ['puddle_mirror', 'mira_riddle'] },
      { q: 'Tia sáng phải đi thế nào?', clues: ['mira_prism'] },
    ] },
  },

  // ---- Bốn cách hỏi thế giới: cùng một vật, hỏi khác thì ra sự thật khác ----
  asks: {
    listen: { name: 'Nghe', who: 'linh', label: 'Nhờ Linh áp ống nghe', need: s => s.party.includes('linh'), none: 'Đặc. Chỉ là sắt thôi, không có gì đáng nghe.' },
    appraise: { name: 'Định giá', who: 'mira', label: 'Nhờ Mira định giá', need: s => s.party.includes('mira'), none: 'Không đáng một đồng. Đừng tốn thời gian của tôi.' },
    echo: { name: 'Vọng lại', who: 'nar', label: 'Để hồ ly vọng lại', need: s => s.flags.fox_fed && !s.foxShy, none: '(Con hồ ly nghiêng đầu nghe, rồi im. Ở đây chưa từng có tiếng gì đáng nhớ.)' },
    look: { name: 'Soi', who: 'nar', label: 'Soi thật kỹ', need: () => true, none: '(Cậu nhìn thật kỹ. Nó vẫn chỉ là chính nó.)' },
  },
  // Vật soi được: look = lần đầu nhìn (cho manh mối lookClue); asks = câu trả lời riêng theo từng cách hỏi
  inspect: {
    forge: { name: 'Lò rèn nguội', board: 'chest', lookClue: 'forge_order',
      look: '(Một lò rèn bỏ hoang, than nguội từ lâu. Trên cột lò còn một tấm biển đồng mờ chữ: "Mọi thợ rời xưởng trước giờ khoá cổng.")',
      asks: {
        listen: { t: 'Lò này tắt vội. Than ở dưới còn nguyên hình cục, chưa kịp cháy hết.', clue: 'forge_listen' },
        appraise: { t: 'Lò của Thương Đoàn, nhìn cái khoá cửa lò là biết. Đóng cửa ít nhất ba trăm năm rồi.', clue: 'forge_appraise' },
        echo: { t: '(Cái đuôi chuông gió của con hồ ly rung lên, phát lại một giọng khàn, rất xa: "…để dưới ống đồng… nhanh lên, trước khi cổng khoá…" Rồi một tiếng thiếc va vào sắt.)', clue: 'forge_echo' },
      } },
    belt: { name: 'Đai dụng cụ', lookClue: 'belt_look',
      look: '(Một chiếc đai da treo trên móc, đồ nghề còn cài nguyên: búa nhỏ, dùi, kìm. Ai lại bỏ quên đồ nghề còn tốt thế này?)',
      asks: {
        appraise: { t: 'Đai thợ rèn Thương Đoàn, có dấu xưởng. Kiểu khoá đai này thôi làm từ ba trăm năm trước. Không phải đồ thợ Chợ Nổi đâu.', clue: 'belt_appraise' },
        listen: { t: 'Trong túi đai có tiếng lạch cạch. ...À, chỉ là đinh.' },
      } },
    pool_dark: { name: 'Vũng nước đen', look: '(Một vũng nước đen, phẳng lì, nằm dưới mái xưởng. Không gợn.)',
      asks: {
        look: { t: '(Cậu cúi xuống soi. Mặt nước không phản chiếu cậu. Nó phản chiếu một buổi chiều khác: một người ôm hộp thiếc, vội vã đi về phía có ánh đồng lấp lánh, rồi khuỵu xuống đào.)', clue: 'pool_look' },
        listen: { t: 'Nước đọng. Không có gì ở dưới, nông lắm.' },
      } },
    pile_rust: { name: 'Đống tôn gỉ đỏ', key: 'k_prust', look: '(Một đống tôn gỉ đỏ quạch, cao ngang ngực.)',
      asks: { listen: { t: 'Đặc. Toàn tôn đè lên tôn.', clue: 'rust_listen' }, appraise: { t: 'Tôn vụn. Bán cân cũng không ai mua.' } } },
    pile_gear: { name: 'Đống bánh răng', key: 'k_pgear', look: '(Một đống bánh răng to nhỏ, có cái còn bóng dầu.)',
      asks: { listen: { t: 'Rỗng ở dưới! ...Ơ, có tiếng chạy lạo xạo. Chuột thì phải.', clue: 'gear_listen' }, appraise: { t: 'Bánh răng máy kéo. Mới lắm, chừng mười năm. Không phải đồ cổ.', clue: 'gear_appraise' } } },
    pile_copper: { name: 'Đống ống đồng', key: 'k_pcopper', look: '(Một đống ống đồng xếp chéo nhau, ánh đồng lấp lánh dưới Lõi Nhịp Tim.)',
      asks: { listen: { t: 'Rỗng. Và có gì đó bằng thiếc nằm dưới, gõ vào kêu boong boong.', clue: 'copper_listen' }, appraise: { t: 'Ống đồng không gỉ. Ai chôn đồ dưới này thì biết lựa chỗ.' } } },
    pile_beam: { name: 'Đống dầm gãy', key: 'k_pbeam', look: '(Mấy cây dầm sắt gãy chồng lên nhau.)',
      asks: { listen: { t: 'Đặc, nứt dọc. Sắp sập đấy, đừng đứng gần.', clue: 'beam_listen' } } },
  },

  // ---- Từ khoá cho Bàn Ghép: kind quyết định ô nào nhận được ----
  keywords: {
    k_guild: { t: 'Thương Đoàn', kind: 'ai' }, k_market: { t: 'Chợ Nổi', kind: 'ai' },
    k_tin: { t: 'hộp thiếc', kind: 'vat' }, k_belt: { t: 'đai dụng cụ', kind: 'vat' }, k_rat: { t: 'ổ chuột', kind: 'vat' },
    k_prust: { t: 'đống tôn gỉ', kind: 'noi' }, k_pgear: { t: 'đống bánh răng', kind: 'noi' }, k_pcopper: { t: 'đống ống đồng', kind: 'noi' }, k_pbeam: { t: 'đống dầm gãy', kind: 'noi' },
    k_300: { t: 'ba trăm năm', kind: 'khi' }, k_10: { t: 'mười năm', kind: 'khi' },
    k_gate: { t: 'cổng sắp khoá', kind: 'viec' }, k_forgot: { t: 'bỏ quên cả đai dụng cụ', kind: 'viec' }, k_crab: { t: 'con cua nổi điên', kind: 'viec' },
  },
  kinds: { ai: 'Ai', vat: 'Vật', noi: 'Nơi', khi: 'Khi nào', viec: 'Chuyện gì' },

  // ---- Bàn Ghép: câu chuyện bị khuyết. Xác nhận theo từng nhóm 3 ô; sai 3 lần thì bạn đồng hành gợi cách hỏi ----
  boards: {
    chest: {
      title: 'Ghép lại chuyện: Rương người thợ cũ',
      lines: [
        ['Người thợ của ', { k: 'ai', a: 'k_guild' }, ' giấu ', { k: 'vat', a: 'k_tin' }, ' dưới ', { k: 'noi', a: 'k_pcopper' }, '.'],
        ['Ông giấu nó ', { k: 'khi', a: 'k_300' }, ' trước, khi ', { k: 'viec', a: 'k_gate' }, ', vội đến mức ', { k: 'viec', a: 'k_forgot' }, '.'],
      ],
      hints: { // bậc 1: chỉ cách hỏi hoặc chỗ chưa hỏi, không bao giờ nói đáp án
        k_guild: 'Mira: "Đồ của ai thì đưa tôi định giá. Cái lò, cái đai, cái gì cũng được."',
        k_tin: 'Linh: "Cậu đã soi vũng nước đen dưới mái xưởng chưa? Nước ở đây nhớ dai lắm."',
        k_pcopper: 'Linh: "Để tôi nghe từng đống. Chỗ rỗng chưa chắc là chỗ đúng đâu."',
        k_300: 'Mira: "Bao lâu rồi thì cứ hỏi tôi. Nhìn kiểu khoá là tôi đoán được tuổi."',
        k_gate: 'Linh: "Tấm biển đồng trên cột lò ghi gì ấy nhỉ?"',
        k_forgot: 'Linh: "Ai lại bỏ đồ nghề còn tốt thế? Nhìn lại cái đai xem."',
      },
      wrong: 'Chưa khớp. Câu này vẫn có chỗ sai.',
      right: 'Câu này khớp.',
      sell: (c, w) => `Mira gẩy bàn tính: "Ô này là ${w}. ${c} Lumen, tôi ghi sổ."`,
      poor: 'Mira: "Hết tiền thì tự nghĩ. Tôi không làm từ thiện. ...Lần này."',
    },
  },
  puddleMirror: ['Lần này cậu không nhìn mặt mình. Cậu nhìn xuống đáy.', 'Dưới lớp nước nông có một tấm gương nhỏ, ai đó giấu ở đây. Chỗ ai cũng soi, mà chẳng ai nhìn.'], // guessed

  // ---- Trận boss (BOSS_DESIGN.md): đánh boss là hiểu một sinh vật ----------------------------
  // Nhịp mỗi đòn: báo trước → đánh → sơ hở. Trong sơ hở, chạm vòng sáng để phản đòn theo "ý định"
  // đã chọn ở khoảng lặng. Khoảng lặng dùng Bốn cách hỏi lên chính boss; câu trả lời mở pha và động từ.
  // Pha: gian (đầu trận) → dau (khi hỏi ra chỗ đau) → tin (đủ phản đòn tử tế) ; Đánh thì sang cung (Cùng đường).
  bosses: {
    crab: { // Đấu trường top-down (BOSS_DESIGN mục 7): né chiêu trên mặt đất; boss mệt thì E chữa lành, F đánh
      title: 'Cua Giáp Lò Rèn', mode: 'arena',
      hp: 'crab_hp',       // tên thông số máu trong config.js (chỉ dùng khi chọn Đánh)
      intro: 'Con cua gầm lên. Lò trên mai phun lửa.',
      // vị trí tính từ chân con cua, nhân với crab_scale
      wound: [-108, 18],   // chỗ đứng ngay dưới khớp càng trái: nghe, soi, chữa lành ở đây
      shard: [-90, -65],   // mảnh sắt trên khớp càng (chỗ ánh kim loé)
      body: [0, -12, 80, 30], // thân để va chạm: tâm x, y và bán trục ngang, dọc
      phases: { // combo: số chiêu trước khi nó mệt
        gian: { name: 'Giận', attacks: ['slam', 'rain', 'slag'], combo: 2 },
        dau: { name: 'Đau', attacks: ['fan', 'rain'], combo: 2 },
        tin: { name: 'Tin', attacks: ['breath'], combo: 1 },
        cung: { name: 'Cùng đường', attacks: ['slam', 'slag', 'rain', 'fan'], combo: 2 },
      },
      warn: { // Linh nghe trước từng chiêu (kẹt dưới càng nhưng vẫn nghe được)
        slam: 'Linh: "Nó vung càng! Tránh khỏi phía trước mặt nó!"', rain: 'Linh: "Nó sắp rũ lửa trên mai xuống! Chỗ nào đỏ là chỗ đó rơi!"',
        slag: 'Linh: "Xỉ sắt lăn ngang! Tìm làn không đỏ!"', fan: 'Linh: "Lửa phụt ra từ khớp càng! Lại sát chỗ đau mới tránh được!"',
        breath: 'Linh: "Nó... đang thở chậm lại."',
      }, // guessed
      // Hỏi bằng hành động trong lúc né: near = đứng gần khớp càng đủ lâu; glint = đứng gần khớp càng lúc lò bừng
      // (ánh kim loé); hurt = hồ ly tự lên tiếng khi cậu trúng đòn lần đầu hoặc khi sang pha Đau.
      asks: {
        listen: { how: 'near', need: () => true, t: 'Khớp càng trái! Có tiếng rít, như sắt cứa vào thịt. Nó đau chỗ đó!', who: 'linh', clue: 'crab_pain', phase: 'dau' }, // guessed
        look: { how: 'glint', need: () => true, t: '(Cậu nhìn xuyên qua làn lửa. Ở khớp càng trái có gì đó lấp lánh: một mảnh sắt gỉ, cắm sâu.)', who: 'nar', clue: 'crab_shard' }, // guessed
        echo: { how: 'hurt', need: s => s.flags.fox_fed && !s.foxShy, t: '(Cái đuôi chuông gió của hồ ly phát lại một giọng rất xưa, rất dịu: "Đừng chạm vào, coi chừng phỏng tay nhé." Con cua khựng lại, như nhận ra.)', who: 'nar', clue: 'crab_memory' }, // handover: dòng khắc trên mai cua
      },
      lines: {
        tired: 'Con cua thở dốc. Lò trên mai tối đi một nhịp.', // guessed
        tiredTin: 'Con cua đứng im, giơ cái càng bị kẹt ra. Nó đang chờ.',
        recover: 'Nó lấy lại hơi.', // guessed
        healNoKnow: 'Cậu chạm vào nó, nhưng không biết nó đau ở đâu. Nó gạt cậu ra.', // guessed
        healGian: 'Nó không nghe thấy gì. Nó đau quá.',
        healDau: 'Cậu đặt tay lên khớp càng, nói khẽ. Con cua nghiêng đầu nghe.', // guessed
        healDauWarm: 'Cậu ngồi sát cái lò, chìa tay ra sưởi, khẽ nhắc lại giọng nói xưa. Con cua nhìn cậu rất lâu, rồi khép bớt cửa lò lại.',
        healTinNoLook: 'Nó giơ càng ra chờ, nhưng cậu không biết phải gỡ cái gì. Nhìn kỹ khớp càng đã.', // guessed
        healCung: 'Nó không còn nghe thấy gì nữa. Chỉ còn lửa.', // guessed: đường đánh không quay lại được
        strikeAsk: 'Đánh thì không quay lại được nữa. Bấm F lần nữa nếu cậu chắc.', // guessed
        strike: 'Cậu đánh vào khớp càng. Con cua rú lên. Lửa trên mai bùng cao, dữ hơn, tuyệt vọng hơn.',
        toDau: 'Giờ cậu biết nó đau ở đâu. Lửa của nó bắt đầu toả ra từ chính chỗ đó.',
        toTin: 'Con cua thôi gầm. Lửa trên mai hạ xuống, chỉ còn thở.',
        resonance: 'Hai nhịp tim trong ngực cậu đập cùng một lúc.',
        perfect: 'Né sát!',
        down: [ // gục: Linh băng bó và ghi nợ vào sổ xanh (handover: câu đùa 5 Lumen); n = số Lumen
          n => `Cậu gục xuống. Linh lôi cậu ra sau tảng sắt, quấn băng quanh tay cậu, rồi rút cuốn sổ xanh ra. "Băng gạc: ${n} Lumen. Ghi nợ."`,
          n => `Lại gục. Linh băng tiếp, không nói gì, chỉ ghi thêm ${n} Lumen vào sổ xanh.`,
          n => `Linh thở dài, ghi thêm ${n} Lumen. "Cậu mà gục nữa là tôi phá sản trước cậu đấy."`,
        ], // guessed: lời thoại khi gục
        listenHint: 'Linh: "Cậu nghe không? Có tiếng rít, ở khớp càng bên trái... Lại sát đó, tôi nghe rõ hơn."', // guessed
        glintFirst: '(Lò bừng lên. Ở khớp càng trái có gì đó loé sáng.)', // guessed
        tinHint: 'Linh: "Nó đang chờ cậu. Lúc lò bừng lên, đứng sát khớp càng trái mà nhìn. Có gì lấp lánh ở đó!"', // guessed
        tiredHint: 'Linh: "Nó mệt rồi! Lại khớp càng mà chữa (E), hoặc..." Linh không nói hết câu.', // guessed
        shield: 'Kaelen giơ khiên gốm đỡ trọn chiêu ấy.',
      },
      keys: { heal: 'E: Chữa lành', strike: 'F: Đánh', tiredNow: 'Nó đang mệt: ra đòn đi' },
    },
    bug: { // Bọ Ký Sinh (BOSS_DESIGN 4.2): Nghe ra con đầu đàn; gỡ nó trước thì cả đàn bỏ đi
      title: 'Bọ Ký Sinh', mode: 'bugs',
      intro: 'Mấy con bọ dựng lưng, phun dịch chua.',
      clue: 'bug_queen',
      phases: { gian: { name: 'Bám chặt', attacks: ['spit'] } },
      warn: { spit: 'Linh: "Chúng phun theo hướng cậu đứng! Đi vòng, đừng đứng yên!"' },
      lines: {
        listenHint: 'Linh: "Khoan. Mấy con này không đập cùng một nhịp. Đứng sát từng con, tôi nghe thử."', // guessed
        listenNormal: 'Linh: "Con này đập đều, nhanh. Bọ thường."', // guessed
        listenQueen: 'Linh: "Con này... đập chậm, nặng, lệch nhịp. Cả đàn đang đập theo nó. Con đầu đàn đấy!"', // guessed
        resonanceHear: 'Hai nhịp tim trong ngực cậu đập cùng một lúc. Linh nghe được cả đàn.', // guessed
        tagQueen: 'Đầu đàn', tagNormal: 'Bọ thường', tagUnknown: 'Gỡ',
        pickNormal: 'Cậu luồn tay gỡ một con. Da cá voi bên dưới đỡ đỏ. Mấy con còn lại phun dồn hơn.', // guessed
        pickQueen: 'Cậu gỡ con đầu đàn. Mấy con còn lại co chân, rời khỏi da cá voi, bò đi mất.', // guessed
        soupLabel: 'Ăn súp', soupHint: 'Hồi đầy máu', skipLabel: 'Thôi, né tiếp', soup: 'Cậu húp vội bát súp.',
        down: [
          n => `Dịch chua bắn trúng mắt. Linh lau cho cậu, rồi ghi ${n} Lumen vào sổ xanh. "Nước rửa mắt."`, // guessed
          n => `Lại trúng. Linh lau tiếp, ghi thêm ${n} Lumen.`, // guessed
        ],
        shield: 'Kaelen giơ khiên gốm đỡ trọn ngụm ấy.', missed: 'Sơ hở trôi qua.', intent: () => '',
      },
    },
  },

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
    journal: 'Sổ manh mối', journalHint: 'J: đóng · Mũi tên lên, xuống: chọn hồ sơ', solvedMark: 'đã giải', stillAt: r => `Còn manh mối ở: ${r}`, keysTitle: 'Từ khoá đã có', other: 'Ghi chú khác', askTitle: n => `${n}: hỏi thế nào?`, askBoard: '[Ghép lại chuyện]', askLeave: '[Thôi]', journalEmpty: '(Chưa ghi gì. Soi đồ vật, gõ thử, hỏi người khác.)',
    inv: 'Túi đồ', invHint: 'Mũi tên: chọn · E: dùng · I: đóng', invEmpty: '(Trống.)', cleanse: 'E: Bóp vỡ / Thanh Tẩy', eat: 'E: Ăn',
    advance: 'Space', choose: 'Phím số, hoặc mũi tên rồi Enter',
    hp: 'Máu', resonance: 'Cộng hưởng', phase: 'Pha', ask: l => `Hỏi: ${l}`, plan: l => `Định: ${l}`, planNow: 'đang định', known: 'Đã hiểu', rage: 'Giận', hpBoss: 'Máu', left: n => `Còn ${n} con`, survive: n => `Chịu thêm ${n} giây`,
    arenaKeys: 'WASD: đi · Space: lướt né · E: chữa lành · F: đánh (khi nó mệt)',
    quietTitle: 'Khoảng lặng', quietPick: 'Chọn ý định cho lần sơ hở tới', counterKey: 'E', slow: 'Né chậm', slowHint: 'N: bật, tắt né chậm (đạn chậm hơn, sơ hở dài hơn)', on: 'bật', off: 'tắt', quietHint: 'Phím số để chọn', again: 'Enter: chơi lại từ đầu',
  },
};
