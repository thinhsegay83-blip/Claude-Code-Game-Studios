// PROTOTYPE - NOT FOR PRODUCTION
// Question: Người chơi có thấy xót khi bầu trời làng tí hon xám đi vì một câu tự trách của chính mình không?
// Date: 2026-11-10
// Every tuning value lives here, each with value, min, max and step. The game reads them live
// through tune.<name> (index.html); the tweak panel, an add-on, writes them back here.
window.CONFIG = {
  seed: 1, // every gameplay random call reads rng(), seeded from this (or ?seed= in the address)
  volume: { value: 0.5, min: 0, max: 1, step: 0.05 },

  // ---- Tâm trạng (the hook): 0..100 "ấm", shown as 5 nấc of 20; 0 = thế giới Trong chết ----
  mood_start: { value: 40, min: 20, max: 100, step: 5 },          // ấm lúc mở mắt (nấc 2: trời xám)
  mood_first_choice: { value: 45, min: 20, max: 100, step: 5 },   // ấm khi chơi lại từ lựa chọn đầu
  mood_kind: { value: 20, min: 5, max: 40, step: 1 },             // ấm thêm khi dịu với mình
  mood_harsh: { value: 20, min: 5, max: 40, step: 1 },            // ấm mất khi tự trách
  mood_deflect: { value: 8, min: 0, max: 30, step: 1 },           // ấm mất khi né câu hỏi
  mood_small: { value: 10, min: 0, max: 30, step: 1 },            // ấm thêm ở các lựa chọn nhỏ
  mood_drain: { value: 0.1, min: 0, max: 0.5, step: 0.01 },       // ấm mất mỗi giây đi lại (bỏ bê)
  mood_care: { value: 12, min: 2, max: 30, step: 1 },             // ấm thêm cho mỗi việc chăm mình
  mood_rest_bonus: { value: 6, min: 0, max: 20, step: 1 },        // ấm thêm riêng cho "nghỉ"
  mood_loss: { value: 20, min: 5, max: 40, step: 1 },             // ấm mất khi thua một trận
  mood_win: { value: 10, min: 0, max: 30, step: 1 },              // ấm thêm khi thắng một trận
  mood_whisper: { value: 8, min: 0, max: 25, step: 1 },           // ấm mất khi Cơn Héo thì thầm
  mood_show_rate: { value: 1.6, min: 0.3, max: 6, step: 0.1 },    // trời đổi màu nhanh cỡ nào (1/giây)

  // ---- Đi lại ----
  walk_speed: { value: 250, min: 120, max: 420, step: 10 },       // px/giây ở tầng Giữa và Trong
  walk_speed_out: { value: 170, min: 80, max: 320, step: 10 },    // px/giây ở tầng Ngoài (mình là hạt bụi)
  reach: { value: 80, min: 40, max: 160, step: 5 },               // px: tầm với tới một thứ để nhấn E
  travel_time: { value: 2.4, min: 1, max: 5, step: 0.1 },         // giây: đi xuyên một tầng
  line_time: { value: 5, min: 2, max: 10, step: 0.5 },            // giây: một dòng chữ khi đang đi
  care_time: { value: 2.6, min: 1, max: 6, step: 0.1 },           // giây: một việc chăm mình

  // ---- Chữ ----
  text_speed: { value: 42, min: 12, max: 120, step: 2 },          // chữ/giây trong lời thoại

  // ---- Trận đánh: hai người hùng ----
  hero_hp: { value: 60, min: 30, max: 120, step: 2 },             // máu của mình
  hero_sp: { value: 10, min: 4, max: 20, step: 1 },               // hơi của mình
  hero_atk: { value: 11, min: 4, max: 30, step: 1 },              // đòn Đánh của mình
  lau_hp: { value: 34, min: 16, max: 80, step: 2 },               // máu của Lau
  lau_sp: { value: 8, min: 3, max: 16, step: 1 },                 // hơi của Lau
  lau_atk: { value: 6, min: 2, max: 20, step: 1 },                // đòn Đánh của Lau
  skill_cost: { value: 3, min: 1, max: 6, step: 1 },              // hơi cho một Kỹ năng
  name_mult: { value: 1.9, min: 1.2, max: 3, step: 0.1 },         // Gọi Tên: nhân sát thương
  name_shrink: { value: 0.7, min: 0.4, max: 1, step: 0.05 },      // Gọi Tên: địch nhỏ lại, đòn nhân chừng này
  name_turns: { value: 2, min: 1, max: 4, step: 1 },              // Gọi Tên: địch nhỏ lại mấy lượt
  bell_heal: { value: 12, min: 4, max: 30, step: 1 },             // Chuông Nhỏ của Lau: hồi máu cả hai
  guard_mult: { value: 0.45, min: 0.2, max: 0.9, step: 0.05 },    // Thủ: đòn nhận nhân chừng này
  guard_sp: { value: 2, min: 0, max: 5, step: 1 },                // Thủ: hồi hơi
  dew_heal: { value: 22, min: 8, max: 50, step: 1 },              // Giọt Sương: hồi máu
  dew_start: { value: 1, min: 0, max: 3, step: 1 },               // Giọt Sương lúc đầu
  dew_max: { value: 3, min: 1, max: 6, step: 1 },                 // Giọt Sương mang được
  mood_power_base: { value: 0.7, min: 0.4, max: 1, step: 0.05 },  // sức đánh ở nấc 0, mỗi nấc thêm bên dưới
  mood_power_step: { value: 0.1, min: 0, max: 0.2, step: 0.01 },  // sức đánh thêm mỗi nấc tâm trạng
  dmg_spread: { value: 0.1, min: 0, max: 0.3, step: 0.01 },       // sát thương lệch ± chừng này
  lose_hp_frac: { value: 0.5, min: 0.2, max: 1, step: 0.05 },     // máu còn lại sau khi thua

  // ---- Lời Chê: gom lời một lượt rồi giáng đòn lớn ----
  scorn_hp: { value: 72, min: 30, max: 160, step: 2 },
  scorn_cut: { value: 10, min: 3, max: 25, step: 1 },             // đòn Cứa
  scorn_judge: { value: 34, min: 12, max: 60, step: 1 },          // đòn Phán Xét (báo trước)

  // ---- Cơn Mỏi: không đòn lớn, càng lâu càng nặng, rút hơi, tự hồi ----
  weary_hp: { value: 95, min: 40, max: 200, step: 5 },
  weary_press: { value: 9, min: 3, max: 25, step: 1 },            // đòn Đè
  weary_sag: { value: 8, min: 3, max: 25, step: 1 },              // đòn Trĩu (làm mỏi: đòn kế của người trúng giảm nửa)
  weary_grow: { value: 3, min: 0, max: 8, step: 1 },              // mỗi vòng, đòn nặng thêm
  weary_drain: { value: 2, min: 0, max: 5, step: 1 },             // Đè rút chừng này hơi
  weary_heal: { value: 10, min: 0, max: 30, step: 1 },            // Ngáp: tự hồi

  // ---- Cơn Héo (trùm): mạnh hơn khi tâm trạng thấp ----
  wither_hp: { value: 150, min: 60, max: 320, step: 5 },
  wither_root: { value: 10, min: 4, max: 25, step: 1 },           // Rễ Khô: trúng cả hai
  wither_leaf: { value: 5, min: 2, max: 15, step: 1 },            // Lá Rụng: ba nhát nhỏ
  wither_season: { value: 30, min: 12, max: 60, step: 1 },        // Mùa Tàn (báo trước): trúng cả hai
  wither_mood_scale: { value: 0.12, min: 0, max: 0.3, step: 0.01 }, // đòn nặng thêm mỗi nấc tâm trạng thiếu

  // ---- Nhịp trận ----
  act_time: { value: 0.75, min: 0.3, max: 2, step: 0.05 },        // giây: một hành động của mình
  enemy_time: { value: 1.25, min: 0.5, max: 3, step: 0.05 },      // giây: một hành động của địch
};
