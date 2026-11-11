// PROTOTYPE - NOT FOR PRODUCTION
// Question: Người chơi có thấy xót khi bầu trời làng tí hon xám đi vì một câu tự trách của chính mình không?
// Date: 2026-11-10
// Every word the player reads. A scene is a list of steps:
//   {w, f, t}   a line: who speaks, their face, the text (a string, or a function of the state)
//   {c: [...]}  a choice: each {t, m, set, go}; m names a mood change, set remembers it, go jumps
//   {go}        jump to another scene        {do}  an action the game runs (travel, battle, ending)
//   {when}      on any step: skip it unless when(state) is true
window.STORY = {
  names: {
    me: 'Mình', mi: 'Mi', say: 'Bà Sậy', lau: 'Lau', giant: 'Người Mang',
    scorn: 'Lời Chê', weary: 'Cơn Mỏi', wither: 'Cơn Héo',
  },
  layers: { giua: 'Tầng Giữa · Hốc của mình', trong: 'Tầng Trong · Làng Li', ngoai: 'Tầng Ngoài · Bờ vai Người Mang' },
  moodNames: ['Tắt', 'Nặng', 'Đục', 'Lặng', 'Ấm', 'Trong'],

  // ---- Dòng chữ hiện khi đang đi: không chặn bước -----------------------------------------
  walk: {
    giua: [
      { x: 0, t: 'Lại một buổi dậy muộn. Hốc của mình xám như mọi hôm.' },
      { x: 330, t: 'Vách Hốc từng ấm. Mình không nhớ nó nguội từ bao giờ.' },
      { x: 700, t: 'Có ánh gì đó… lọt ra từ chính ngực mình. Vũng lặng phía trước đang soi nó.' },
      { x: 1500, when: s => !s.flags.wellFree, t: 'Cuối Hốc là sương đặc. Chân mình chưa chịu bước về phía ấy.' },
      { x: 1500, when: s => s.flags.wellFree && !s.flags.witherDown, t: 'Sương đã tan. Nơi vách nguội nhất, có thứ gì cao và khô đứng chắn.' },
      { x: 2350, when: s => s.flags.witherDown, t: 'Sau lưng Cơn Héo là một tấm Màng mỏng. Bên kia Màng, có gió.' },
    ],
    trong: [
      { x: 0, t: 'Khe hẹp mở ra. Dưới mình là cả một ngôi làng. Trên đầu họ là gương mặt mình.' },
      { x: 1300, when: s => !s.flags.scornDown, t: 'Ngoài bãi có thứ gì sắc cạnh đang lơ lửng. Nó nói bằng giọng mình.' },
      { x: 2050, t: 'Những mái nhà vỏ hạt thưa dần. Nhà nào còn đèn, nhà ấy còn người.' },
      { x: 2380, when: s => !s.flags.wellFree, t: 'Giếng sương ở cuối làng. Có thứ gì nặng trĩu đang ngồi lên miệng giếng.' },
    ],
    ngoai: [
      { x: 0, t: 'Khe hẹp. Rồi không còn vách nào nữa.' },
      { x: 320, t: 'Mình đang đứng trên một bờ vai. Bờ vai ấy dài hơn mọi con đường mình từng đi.' },
      { x: 760, t: 'Xa kia là một gương mặt, to bằng cả bầu trời làng Li. Mắt nhắm. Da xám màu vách Hốc.' },
      { x: 1250, t: 'Những đốm hổ phách trôi quanh nó, tắt dần từng đốm. Giống hệt lá rụng dưới làng.' },
      { x: 1560, when: s => s.flags.lau, t: 'Lau thì thầm trên vai mình: "Trời ơi… Trời của Trời cũng buồn."' },
    ],
  },

  // ---- Lời cư dân treo trên đầu, đổi theo nấc tâm trạng (1..5) -------------------------------
  ambient: {
    mi: ['Mầm ơi, ráng thêm hôm nữa…', 'Mầm ơi, ráng thêm hôm nữa…', 'Hôm nay có nắng mỏng.', 'Mầm nhú rồi, bà ơi!', 'Mầm cao hơn cháu rồi!'],
    say: ['Tôi ghi: nặng.', 'Tôi ghi: đục.', 'Tôi ghi: lặng.', 'Tôi ghi: ấm.', 'Tôi ghi: trong.'],
    lau: ['Mặt Trời buồn quá.', 'Mặt Trời buồn quá.', 'Trời đang nghĩ gì đó.', 'Trời vừa nhìn xuống!', 'Trời cười kìa!'],
  },

  // ---- Việc chăm mình ở tầng Giữa ----------------------------------------------------------
  care: {
    sleep: { name: 'Ổ rêu', verb: 'Ngủ', t: 'Mình nằm xuống ổ rêu và, lần này, không tự mắng vì đã nằm.', gain: 'Máu hồi đầy' },
    eat: { name: 'Bầu sương', verb: 'Ăn', t: 'Mình ăn chậm. Vị ngọt nhạt của sương đọng. Dưới làng chắc đất đang mềm ra.', gain: 'Thêm một Giọt Sương' },
    rest: { name: 'Phiến ấm', verb: 'Nghỉ', t: 'Mình ngồi lên phiến ấm, không làm gì cả. Hóa ra không làm gì cũng là một việc.', gain: 'Ấm lên nhiều hơn' },
    breathe: { name: 'Khe gió', verb: 'Thở', t: 'Hít vào. Giữ. Thở ra. Vách Hốc phập phồng theo, rất khẽ.', gain: 'Hơi hồi đầy' },
    used: 'Vừa làm rồi. Để lát nữa.',
    back: 'Dưới làng, đất mềm hẳn ra. Có ai đó đang hát.',
  },

  // ---- Đồ vật và ghi chép ---------------------------------------------------------------------
  objects: {
    shell: { name: 'Mảnh vỏ khắc chữ', verb: 'Đọc', t: ['Nét khắc của chính mình, từ mùa nào không rõ:', '"Mai sẽ dậy sớm. Mai sẽ ăn tử tế. Mai."'] },
    jar: { name: 'Hũ hạt lép', verb: 'Xem', t: ['Một hũ hạt giống lép. Nhãn viết bằng nét chữ nhỏ xíu:', '"Gieo khi Trời khá hơn." Nhãn đã ố.'] },
    bowl: { name: 'Bát hứng sương', verb: 'Nhặt', dew: true, t: ['Một cái bát con đặt dưới mái, hứng được đúng một giọt.', 'Ai đó đã để dành nó cho một hôm trời nặng. Mình xin một giọt.'] },
    book: { name: 'Sổ Trời', verb: 'Lật', t: ['Trang gần nhất: "Nặng. Nặng. Nặng. Lặng. Nặng."', 'Lật về trước rất xa: "Trong. Trong vắt. Trời cười, cả làng phơi chăn."', 'Thì ra mình từng như thế.'] },
    fleck: { name: 'Vảy sáng đã tắt', verb: 'Nhặt', t: ['Một đốm hổ phách rơi xuống bờ vai, đã nguội.', 'Cầm lên mới thấy bên trong nó có vân, như một mái nhà vỏ hạt.'] },
  },

  hints: {
    pool: 'Cúi nhìn vũng lặng', poolAgain: 'Vào trong', pillar: 'Leo cột sáng về Hốc', talk: 'Nói chuyện',
    membrane: 'Bước qua Màng', ear: 'Gọi vào vành tai', goal0: 'Đi về phía ánh sáng',
  },

  goals: {
    start: 'Đến vũng lặng ở giữa Hốc',
    village: 'Gặp bà Sậy, rồi ra bãi',
    scorn: 'Đối mặt Lời Chê ngoài bãi',
    well: 'Giải giếng sương cuối làng',
    up: 'Về Hốc, đi tới cuối Hốc',
    wither: 'Vượt Cơn Héo ở cuối Hốc',
    out: 'Bước qua Màng',
    giant: 'Đi tới gương mặt Người Mang',
  },

  scenes: {
    // ---- Tầng Giữa ---------------------------------------------------------------------------
    pool: [
      { w: 'me', f: 'think', t: 'Dưới mặt nước lặng, ngực mình hở một khe sáng.' },
      { w: 'me', f: 'awe', t: 'Trong khe có… mái nhà. Có khói bếp. Nhỏ hơn hạt bụi.' },
      { w: 'me', f: 'think', t: 'Chưa ai ở Hốc từng kể rằng có thể đi vào trong chính mình. Mình cúi xuống thêm một chút.' },
      { do: 'travel:trong' },
    ],

    // ---- Tầng Trong: lựa chọn đầu tiên ---------------------------------------------------------
    mi_first: [
      { w: 'mi', f: 'awe', t: 'Trời ơi! Trời rơi xuống một giọt kìa!' },
      { w: 'mi', f: 'happy', t: 'Cháu là Mi, cháu trông vườn mầm. Bà Sậy dặn hễ thấy Trời thì phải cúi đầu, mà cháu quên mất rồi.' },
      { w: 'mi', f: 'sad', t: 'Trời cho cháu hỏi… vì sao hôm nay trời nặng thế? Mầm của cháu ba hôm rồi không chịu mở mắt.' },
      { do: 'save' },
      { c: [
        { t: 'Tại ta. Ta vô dụng, đến dậy cho ra hồn cũng không xong.', m: 'harsh', set: ['c1', 'blame'], go: 'mi_blame' },
        { t: 'Ta mệt, Mi ạ. Mệt thì trời nặng. Ta đang học cách nghỉ.', m: 'kind', set: ['c1', 'kind'], go: 'mi_kind' },
        { t: 'Trời thì có lúc nặng lúc nhẹ. Đừng hỏi nhiều.', m: 'deflect', set: ['c1', 'deflect'], go: 'mi_deflect' },
      ] },
    ],
    mi_blame: [
      { w: 'mi', f: 'afraid', t: 'Trời… trời vừa tối đi. Lá rụng kìa!' },
      { w: 'mi', f: 'sad', t: 'Cháu xin lỗi. Cháu không cố ý làm Trời tự mắng mình. Mỗi lần Trời mắng mình, dưới này rụng một lớp lá.' },
      { w: 'me', f: 'think', t: 'Một câu của mình. Cả một hàng cây.' },
      { go: 'mi_after' },
    ],
    mi_kind: [
      { w: 'mi', f: 'happy', t: 'Ơ… trời vừa sáng lên! Trời thấy không, mầm nhú kìa!' },
      { w: 'mi', f: 'neutral', t: 'Bà Sậy bảo: Trời không cần vui, Trời chỉ cần đừng ghét mình. Giờ cháu mới hiểu.' },
      { w: 'me', f: 'think', t: 'Mình chỉ nói thật một câu. Dưới này người ta gọi thế là nắng.' },
      { go: 'mi_after' },
    ],
    mi_deflect: [
      { w: 'mi', f: 'sad', t: 'Dạ… Trời xám thêm một chút rồi.' },
      { w: 'mi', f: 'neutral', t: 'Cháu không hỏi nữa. Nhưng mầm thì vẫn hỏi đấy ạ, bằng cách không mọc.' },
      { w: 'me', f: 'think', t: 'Mình gạt đi một câu hỏi. Dưới này, người ta hứng lấy nó như hứng mưa.' },
      { go: 'mi_after' },
    ],
    mi_after: [
      { w: 'mi', f: 'neutral', t: 'Trời đi gặp bà Sậy đi. Bà giữ Sổ Trời, bà biết hết các mùa của Trời.' },
      { w: 'mi', f: 'happy', t: 'À! Hôm nào Trời ăn, đất dưới này mềm ra. Hôm nào Trời ngủ đủ, sương xuống đều. Trời cứ leo cột sáng kia là về lại Hốc của Trời.' },
      { do: 'goal:village' },
    ],
    mi_again: [
      { w: 'mi', f: 'neutral', t: s => s.level >= 4 ? 'Mầm của cháu mở mắt rồi! Trời đừng đi đâu vội nhé.' : s.level <= 2 ? 'Mầm vẫn ngủ. Cháu ngồi canh, lỡ đâu trời đổi.' : 'Cháu đang đếm lá. Hôm nay rụng ít hơn hôm qua.' },
    ],

    // ---- Bà Sậy và cuốn Sổ Trời --------------------------------------------------------------
    say_first: [
      { w: 'say', f: 'neutral', t: 'Vậy là Trời xuống thật. Tôi già rồi, không cúi nổi nữa, Trời bỏ quá cho.' },
      { w: 'say', f: 'neutral', t: 'Tôi giữ Sổ Trời. Ngày nào tôi cũng ghi: trời trong, trời đục, trời lặng. Dạo này toàn một chữ: nặng.' },
      { w: 'say', f: 'sad', t: 'Mùa tối trước, chúng tôi mất một phần ba làng. Không phải vì Trời ác. Chỉ vì Trời quên rằng mình có chúng tôi.' },
      { w: 'say', f: 'sad', when: s => s.flags.c1 === 'blame', t: 'Con bé Mi kể Trời tự gọi mình là vô dụng. Trời ạ, một thứ vô dụng thì không nuôi nổi bốn mươi nóc nhà.' },
      { w: 'say', f: 'happy', when: s => s.flags.c1 === 'kind', t: 'Con bé Mi kể Trời bảo đang học cách nghỉ. Câu ấy tôi sẽ chép vào Sổ, bằng mực tốt.' },
      { w: 'say', f: 'neutral', when: s => s.flags.c1 === 'deflect', t: 'Con bé Mi kể Trời bảo nó đừng hỏi. Trẻ con không hỏi thì ai hỏi hộ chúng tôi?' },
      { w: 'say', f: 'neutral', t: 'Ngoài bãi có một Lời Chê vừa rơi xuống. Chúng rơi mỗi khi Trời nặng lời với chính mình. Nó chặn đường ra ruộng. Trời định làm gì với nó?' },
      { do: 'save' },
      { c: [
        { t: 'Ta ra nhìn thẳng vào nó. Lời của ta thì ta nhận.', m: 'small', set: ['c2', 'own'], go: 'say_own' },
        { t: 'Nó nói đúng mà. Cứ để nó ở đó.', m: 'harsh', set: ['c2', 'agree'], go: 'say_agree' },
        { t: 'Chỉ cho ta cách đánh.', m: 'none', set: ['c2', 'fight'], go: 'say_teach' },
      ] },
    ],
    say_own: [
      { w: 'say', f: 'happy', t: 'Nhận, chứ không phải nuốt. Trời nói được câu ấy là nó đã nhỏ đi một nửa rồi.' },
      { go: 'say_teach' },
    ],
    say_agree: [
      { w: 'say', f: 'sad', t: 'Nó nói đúng một phần mười, rồi lấy phần ấy làm cớ mà chém cả mười. Trời nhìn lên mà xem, trời vừa sập thêm.' },
      { go: 'say_teach' },
    ],
    say_teach: [
      { w: 'say', f: 'neutral', t: 'Nghe này. Nó hay gom lời một nhịp rồi mới giáng. Thấy nó gom thì Trời hãy THỦ.' },
      { w: 'say', f: 'neutral', t: 'Còn muốn nó nhỏ lại thì GỌI TÊN nó ra. Thứ gì bị gọi đúng tên cũng bớt dữ.' },
      { w: 'say', f: 'happy', t: 'Cầm lấy giọt sương này. Uống khi đau. Và Trời ạ… thua cũng đừng mắng mình. Mắng là nó lại rơi thêm.' },
      { do: 'dew' },
      { do: 'goal:scorn' },
    ],
    say_again: [
      { w: 'say', f: 'neutral', t: s => s.flags.wellFree ? 'Giếng thở lại rồi. Tôi ghi vào Sổ: hôm nay Trời tự xuống múc nước cho làng.' : s.flags.scornDown ? 'Lời Chê tan rồi. Còn giếng sương cuối làng, Trời ạ. Không có sương, làng không chờ nổi.' : 'Thấy nó gom lời thì THỦ. Muốn nó nhỏ lại thì GỌI TÊN. Tôi ngồi đây ghi.' },
    ],

    // ---- Trận 1: Lời Chê ---------------------------------------------------------------------
    scorn_pre: [
      { w: 'scorn', f: 'neutral', t: 'Ngươi lại dậy muộn. Ngươi lúc nào cũng thế.' },
      { w: 'me', f: 'think', t: 'Giọng nó là giọng mình. Mình đã ném thứ này xuống đầu họ bao nhiêu lần rồi?' },
      { do: 'battle:scorn' },
    ],
    scorn_win: [
      { w: 'me', f: 'think', t: 'Lời Chê vỡ ra thành bụi, rồi bụi cũng lắng. Nó không chết. Nó chỉ thôi to.' },
      { w: 'lau', f: 'awe', t: 'Tôi thấy hết từ ngọn lau! Trời đánh nhau với lời của chính Trời.' },
      { w: 'lau', f: 'neutral', t: 'Tôi là Lau. Tôi leo cao nhất làng, vì tôi muốn nhìn gần mặt Trời. Gần rồi mới thấy: mặt Trời buồn.' },
      { w: 'lau', f: 'sad', t: 'Nên tôi có một câu, giữ mãi chưa hỏi được ai. Trời ơi… Trời có trời không?' },
      { w: 'me', f: 'awe', t: 'Mình chưa từng ngẩng lên mà hỏi thế. Hốc của mình cũng có vách. Vách ấy ấm hay nguội… là theo ai?' },
      { do: 'save' },
      { c: [
        { t: 'Ta không biết. Đi cùng ta, mình lên xem.', m: 'small', set: ['c3', 'together'], go: 'lau_join' },
        { t: 'Có thì cũng chẳng ngó ngàng gì tới ta đâu.', m: 'deflect', set: ['c3', 'alone'], go: 'lau_alone' },
        { t: 'Nếu có… chắc nó cũng đang nặng như ta.', m: 'small', set: ['c3', 'guess'], go: 'lau_guess' },
      ] },
    ],
    lau_alone: [
      { w: 'lau', f: 'sad', t: 'Trời vừa nói đúng câu mà cả làng tôi sợ nhất. Chúng tôi cũng từng nghĩ thế về Trời.' },
      { go: 'lau_join' },
    ],
    lau_guess: [
      { w: 'lau', f: 'awe', t: 'Vậy thì phải có ai lên hỏi nó, như cháu Mi hỏi Trời sáng nay.' },
      { go: 'lau_join' },
    ],
    lau_join: [
      { w: 'lau', f: 'happy', t: 'Tôi theo Trời. Tôi nhỏ, nhưng đèn tôi sáng, và chuông tôi biết dỗ.' },
      { do: 'join' },
      { w: 'lau', f: 'neutral', t: 'Nhưng khoan đã. Giếng sương cuối làng bị một Cơn Mỏi ngồi lên rồi. Không có sương, làng không chờ nổi Trời đi xa.' },
      { do: 'goal:well' },
    ],

    // ---- Trận 2: Cơn Mỏi ----------------------------------------------------------------------
    weary_pre: [
      { w: 'weary', f: 'neutral', t: 'Ngồi xuống đi… để mai… mai rồi tính…' },
      { w: 'lau', f: 'afraid', when: s => s.flags.lau, t: 'Đừng nghe nó, Trời ơi! Nó không đánh mạnh đâu. Nó chỉ nặng dần, nặng dần, cho tới khi mình thôi đứng dậy.' },
      { do: 'battle:weary' },
    ],
    weary_win: [
      { w: 'me', f: 'think', t: 'Cơn Mỏi trượt khỏi miệng giếng như một tấm chăn ướt. Giếng sương thở lại.' },
      { w: 'me', f: 'awe', t: 'Nước dâng, mát đến tận ngực mình. Ngực thật, ở trên kia.' },
      { w: 'lau', f: 'happy', t: 'Giờ thì đi được rồi. Lên Hốc đi Trời. Rồi lên nữa.' },
      { w: 'lau', f: 'neutral', t: 'Mà này. Trước khi đi xa, Trời ăn gì đi đã, ngủ một giấc đã. Dưới này cả làng nhìn thấy đấy.' },
      { do: 'dew' },
      { do: 'goal:up' },
    ],

    // ---- Trùm: Cơn Héo ------------------------------------------------------------------------
    fog: [
      { w: 'me', f: 'think', t: 'Sương ở cuối Hốc đặc như vách. Mình chưa từng nghĩ có gì ở phía sau nó.' },
    ],
    wither_pre: [
      { w: 'wither', f: 'neutral', t: 'Ra ngoài làm gì. Ngoài ấy không ai cần ngươi. Trong này cũng thế.' },
      { w: 'lau', f: 'afraid', when: s => s.flags.lau, t: 'Nó cao quá… Nhưng Trời ơi, nó mọc từ đúng chỗ Trời hay nằm nhất.' },
      { w: 'me', f: 'think', t: s => s.level >= 4 ? 'Hôm nay mình đã ăn, đã nghỉ. Nó trông gầy hơn mình tưởng.' : s.level <= 2 ? 'Mình đến đây với một bầu trời đang nặng. Nó trông cao gấp đôi.' : 'Mình hít một hơi. Nó cao, nhưng nó khô.' },
      { do: 'battle:wither' },
    ],
    wither_win: [
      { w: 'me', f: 'think', t: 'Cơn Héo đổ xuống không một tiếng động, như thứ đã rỗng từ lâu.' },
      { w: 'me', f: 'awe', t: 'Sau nó là Màng: tấm da mỏng nhất của Hốc. Có gió lùa qua một kẽ rách.' },
      { w: 'lau', f: 'awe', when: s => s.flags.lau, t: 'Bên kia là trời của Trời. Tôi run quá. Đi thôi.' },
      { do: 'goal:out' },
    ],

    // ---- Thua một trận: không tải lại -------------------------------------------------------------
    lost: [
      { w: 'me', f: 'sad', t: 'Mình gục xuống. Trên đầu làng Li, trời sập thêm một nấc.' },
      { w: 'me', f: 'think', t: 'Nó vẫn đứng đó. Mình có thể thử lại. Nhưng trước hết, có lẽ nên về Hốc, ăn một miếng, ngủ một giấc.' },
    ],

    // ---- Tầng Ngoài: Người Mang ---------------------------------------------------------------
    giant: [
      { w: 'me', f: 'think', t: 'Mình gọi. Tiếng mình bé như tiếng Mi gọi mình sáng nay.' },
      { w: 'me', f: 'speak', t: 'Này… vì sao hôm nay trời nặng thế?' },
      { w: 'giant', f: 'sad', when: s => s.flags.c1 === 'blame', t: '…Tại ta. Ta vô dụng. Đến ngồi thẳng lên ta cũng không xong.' },
      { w: 'me', f: 'awe', when: s => s.flags.c1 === 'blame', t: 'Đó là câu của mình. Nguyên từng chữ. Nghe từ ngoài vào mới biết nó nặng đến thế.' },
      { w: 'giant', f: 'sad', when: s => s.flags.c1 === 'kind', t: '…Ta mệt. Lâu lắm rồi không ai hỏi ta câu ấy. Kể cả ta.' },
      { w: 'me', f: 'awe', when: s => s.flags.c1 === 'kind', t: 'Giọng nó rung lên một chút, như vách Hốc những hôm còn ấm.' },
      { w: 'giant', f: 'sad', when: s => s.flags.c1 === 'deflect', t: '…Đừng hỏi. Hỏi cũng thế thôi.' },
      { w: 'me', f: 'awe', when: s => s.flags.c1 === 'deflect', t: 'Câu ấy mình đã nói với một đứa trẻ. Giờ mới biết đứng nghe nó thì lạnh thế nào.' },
      { w: 'giant', f: 'sad', t: 'Ta chỉ là một hạt bụi dưới trời của ta. Hạt bụi có héo, cũng đâu ai hay.' },
      { w: 'lau', f: 'happy', when: s => s.flags.lau, t: 'Có cả làng hay đấy! Và trong làng có tôi!' },
      { w: 'me', f: 'think', t: 'Nó không biết. Nó không biết trong nó có Hốc, trong Hốc có mình, trong mình có bốn mươi nóc nhà.' },
      { do: 'save' },
      { c: [
        { t: 'Kể cho nó nghe về làng Li. Rồi về nhà ăn một bữa tử tế, vì cả hai.', m: 'none', set: ['c4', 'tell'], go: 'end_trong' },
        { t: 'Bảo nó phải gắng lên: cả một thế giới đang trông vào nó.', m: 'none', set: ['c4', 'push'], go: 'end_ganh' },
        { t: 'Chào nó, rồi đi tiếp ra ngoài: xem trời của nó là ai.', m: 'none', set: ['c4', 'leave'], go: 'end_bui' },
      ] },
    ],
    end_trong: [{ do: 'ending:trong' }],
    end_ganh: [{ do: 'ending:ganh' }],
    end_bui: [{ do: 'ending:bui' }],
  },

  // ---- Bốn kết thúc ----------------------------------------------------------------------------
  endingOrder: ['trong', 'ganh', 'bui', 'tat'],
  endings: {
    trong: {
      name: 'Trời Trong',
      lines: [
        'Mình kể. Về Mi quên cúi đầu. Về bà Sậy và cuốn Sổ. Về Lau leo ngọn lau để nhìn gần một gương mặt buồn.',
        'Người Mang nghe rất lâu. Rồi nó làm một việc nhỏ: nó hít vào, thật sâu. Gió ấm chạy dọc vách Hốc.',
        'Mình về nhà, ăn một bữa tử tế. Dưới làng, bà Sậy chấm mực tốt, ghi một chữ đã lâu không ghi: Trong.',
        'Mình là hạt bụi của ai đó, và là bầu trời của ai đó. Chăm lấy mình, hóa ra là việc lớn nhất mình làm được cho cả hai.',
      ],
      low: 'Trời làng Li chưa sáng hẳn. Nhưng lần đầu tiên sau nhiều mùa, nó sáng dần.',
    },
    ganh: {
      name: 'Gánh Trời',
      lines: [
        'Mình bảo nó: cố lên, đừng yếu đuối, bao nhiêu người đang trông vào.',
        'Người Mang gồng thẳng dậy. Vách Hốc ấm lên thật: nóng, căng, như sắp nứt.',
        'Mình nhận ra giọng mình. Đó là giọng mình vẫn dùng để nói với chính mình mỗi sáng.',
        'Thế giới sáng lên được một mùa. Không ai nở mãi được vì sợ.',
      ],
    },
    bui: {
      name: 'Hạt Bụi Đi Mãi',
      lines: [
        'Mình chào Người Mang, rồi đi tiếp. Ngoài nó là một bờ vai khác. Ngoài nữa, một gương mặt khác, cũng nhắm mắt.',
        'Tầng nào cũng có một bầu trời đang nặng. Mình đi mãi để tìm tầng ngoài cùng, nơi có ai đó không buồn.',
        'Dưới làng Li, trời không tối, chỉ xa dần. Bà Sậy ghi: "Lặng."',
        'Trên vai mình, đèn của Lau vẫn sáng. "Trời ơi," nó hỏi khẽ, "bao giờ mình về?"',
      ],
    },
    tat: {
      name: 'Trời Tắt',
      lines: [
        'Trời làng Li tối hẳn.',
        'Không ai ác cả. Mình chỉ quên rằng có một ngôi làng đang sống nhờ cách mình đối xử với chính mình.',
        'Bà Sậy đặt bút. Trang cuối của Sổ Trời để trắng.',
      ],
    },
  },

  // ---- Chữ trong trận đánh ----------------------------------------------------------------------
  battle: {
    commands: ['Đánh', 'Kỹ năng', 'Vật phẩm', 'Thủ'],
    skills: { me: 'Gọi Tên', lau: 'Chuông Nhỏ' },
    item: 'Giọt Sương',
    noSp: 'Không đủ hơi.',
    noDew: 'Hết Giọt Sương.',
    guard: n => `${n} thủ thế, lấy lại hơi.`,
    attack: n => `${n} đánh.`,
    nameIt: e => `Mình gọi tên nó: "${e}". Nó nhỏ lại.`,
    bell: 'Lau rung Chuông Nhỏ. Cả hai dịu đi.',
    dew: n => `${n} uống một Giọt Sương.`,
    tired: n => `${n} đang mỏi: đòn này chỉ còn một nửa.`,
    win: 'Nó lắng xuống.',
    tally: (m, d) => `Ấm lên +${m} · Hơi hồi đầy${d ? ' · Giọt Sương +1' : ''}`,
    lose: 'Mình gục.',
    moves: {
      scorn_cut: 'Lời Chê cứa một nhát.',
      scorn_charge: 'Lời Chê đang GOM LỜI. Lượt tới: PHÁN XÉT. Hãy THỦ!',
      scorn_judge: 'PHÁN XÉT giáng xuống!',
      weary_press: 'Cơn Mỏi đè lên mình, rút mất hơi.',
      weary_sag: n => `Cơn Mỏi làm ${n} trĩu xuống.`,
      weary_yawn: 'Cơn Mỏi ngáp. Nó đầy lại một chút, và nặng thêm.',
      wither_root: 'Rễ Khô quật cả hai.',
      wither_leaf: 'Lá Rụng: ba nhát nhỏ.',
      wither_charge: 'Cơn Héo đang HÚT CẠN. Lượt tới: MÙA TÀN. Cả hai hãy THỦ!',
      wither_season: 'MÙA TÀN phủ xuống!',
      wither_whisper_blame: '"Ta vô dụng." Chính miệng ngươi nói. Ta chỉ nhắc lại.',
      wither_whisper_kind: '"Học cách nghỉ" ư? Nghỉ là lười. Ngươi biết thế mà.',
      wither_whisper_deflect: '"Đừng hỏi nhiều." Phải, đừng hỏi. Cứ nằm đó.',
    },
  },

  ui: {
    title: 'TRONG',
    sub: 'Mình là bầu trời của ai đó, và là hạt bụi của ai đó.',
    start: 'Enter: bắt đầu', cont: 'C: chơi tiếp chỗ đã lưu',
    paused: 'Tạm dừng', speed: 'Tốc độ chữ', speedHint: 'Mũi tên trái, phải: đổi tốc độ chữ',
    resume: 'P: chơi tiếp', log: 'Nhật ký lời thoại', logHint: 'L: đóng · Mũi tên lên, xuống: cuộn',
    mood: 'Tâm trạng', dew: 'Giọt Sương', goal: 'Việc đang làm',
    again: 'Enter: quay về lựa chọn đầu tiên', ending: 'Kết thúc', seen: (n, k) => `Bạn đã thấy ${n} trên ${k} kết thúc`,
    saved: 'Đã lưu', warn: 'Trời làng Li sắp tắt. Về Hốc mà chăm lấy mình.',
    advance: 'Space', choose: 'Phím số, hoặc mũi tên rồi Enter',
  },
};
