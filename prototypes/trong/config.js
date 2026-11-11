// PROTOTYPE - NOT FOR PRODUCTION
// Question: Người chơi có chọn tha con cua đang nổi điên dù đánh nó nhanh hơn và được 200 Lumen không?
// Date: 2026-11-12
// Every tuning value lives here, each with value, min, max and step. The game reads them live
// through tune.<name> (index.html). Story values marked "handover" come from
// HANDOVER_STORY_V2.md, Bước 4 and the YAML scripts; change them there and here together.
window.CONFIG = {
  seed: 1,
  volume: { value: 0.5, min: 0, max: 1, step: 0.05 },

  // ---- Màn né đòn (the hook) ----
  soul_speed: { value: 230, min: 120, max: 400, step: 10 },        // px/giây
  soul_slow: { value: 0.45, min: 0.2, max: 1, step: 0.05 },        // Shift: nhân tốc độ
  soul_hp: { value: 20, min: 6, max: 60, step: 1 },                // máu của mình trong màn né
  soul_hit_r: { value: 5, min: 2, max: 10, step: 0.5 },            // px: bán kính trúng đòn
  invuln_time: { value: 0.9, min: 0.2, max: 2, step: 0.05 },       // giây: bất tử sau khi trúng
  graze_r: { value: 22, min: 10, max: 40, step: 1 },               // px: sượt qua trong tầm này thì cộng hưởng
  graze_gain: { value: 6, min: 1, max: 20, step: 1 },              // cộng hưởng mỗi viên sượt
  resonance_max: { value: 100, min: 40, max: 200, step: 10 },
  arena_w: { value: 460, min: 240, max: 700, step: 10 },           // px
  arena_h: { value: 210, min: 140, max: 300, step: 10 },           // px
  arena_w_party: { value: 60, min: 0, max: 200, step: 10 },        // px: khung rộng thêm khi có bạn đồng hành
  wave_time: { value: 7, min: 3, max: 14, step: 0.5 },             // giây: một đợt đòn
  quiet_time: { value: 9, min: 3, max: 20, step: 0.5 },            // giây: khoảng lặng để chọn (hết giờ thì chọn Chờ)
  boss_quiet_time: { value: 4, min: 2, max: 12, step: 0.5 },       // giây: khoảng lặng của trận boss (hết giờ thì giữ ý định cũ)

  // ---- Cua Giáp Lò Rèn (boss) ----
  crab_hp: { value: 60, min: 20, max: 200, step: 5 },              // máu, nếu chọn đánh
  crab_hit: { value: 3, min: 1, max: 10, step: 1 },                // máu mất mỗi đòn trúng
  crab_spark_speed: { value: 150, min: 60, max: 300, step: 10 },   // px/giây
  crab_slag_speed: { value: 170, min: 60, max: 300, step: 10 },    // xỉ lăn, px/giây
  crab_pillar_warn: { value: 0.9, min: 0.3, max: 2, step: 0.05 },  // giây: báo trước cột lửa
  act_strike: { value: 30, min: 5, max: 60, step: 1 },             // Đánh: máu cua mất (2 đòn: đánh phải nhanh hơn mọi đường tha)
  resonance_mult: { value: 2, min: 1, max: 4, step: 0.25 },        // cộng hưởng đầy: hành động nhân chừng này

  // ---- Trận boss (BOSS_DESIGN.md): báo trước → đánh → sơ hở ----
  boss_warn: { value: 0.8, min: 0.6, max: 2, step: 0.05 },         // giây báo trước mỗi đòn (luật: ≥ 0,6)
  boss_attack_time: { value: 4.2, min: 2, max: 8, step: 0.1 },     // giây một đòn
  boss_open_time: { value: 1.4, min: 0.6, max: 3, step: 0.1 },     // giây sơ hở sau đòn
  boss_open_tin: { value: 2.4, min: 1, max: 5, step: 0.1 },        // sơ hở dài hơn ở pha Tin
  counter_r: { value: 22, min: 10, max: 50, step: 1 },             // px: đứng trong vòng này và bấm E là phản đòn
  boss_ring_lead: { value: 1, min: 0, max: 2, step: 0.1 },         // giây: vòng sáng hiện mờ trước sơ hở để kịp chạy tới
  quiet_every: { value: 2, min: 1, max: 4, step: 1 },              // khoảng lặng sau mỗi chừng ấy đòn (đòn đầu luôn có)
  trust_need: { value: 3, min: 1, max: 6, step: 1 },               // tin cần để sang pha Tin: Nói khẽ +1, Ngồi sưởi +2
  listen_r: { value: 70, min: 30, max: 140, step: 5 },             // px: đứng gần khớp càng trong tầm này thì Linh nghe được
  listen_time: { value: 1.5, min: 0.5, max: 4, step: 0.1 },        // giây đứng gần (cộng dồn) để nghe ra
  glint_time: { value: 1.2, min: 0.4, max: 3, step: 0.1 },         // giây: ánh kim loé ở khớp càng lúc lò bừng
  glint_r: { value: 18, min: 8, max: 40, step: 1 },                // px: chạm ánh kim trong tầm này là Soi thấy
  glint_hint_mult: { value: 2, min: 1, max: 4, step: 0.25 },       // Linh đã nhắc: ánh kim hiện lâu gấp chừng này
  assist_bullet: { value: 0.7, min: 0.3, max: 1, step: 0.05 },     // Né chậm (menu tạm dừng): đạn chậm và thưa còn chừng này
  assist_open: { value: 1.3, min: 1, max: 2, step: 0.05 },         // Né chậm: sơ hở dài gấp chừng này
  speed_tin: { value: 0.5, min: 0.2, max: 1, step: 0.05 },         // pha Tin: đạn chậm lại
  speed_cung: { value: 1.4, min: 1, max: 2.5, step: 0.05 },        // pha Cùng đường: đạn nhanh và dày lên
  bullet_cap: { value: 120, min: 40, max: 300, step: 10 },         // tối đa đạn một lúc (luật dễ đọc)
  hit_flash: { value: 0.6, min: 0, max: 2, step: 0.1 },            // giây: viên vừa trúng mình nhấp nháy lại
  crab_rain_rate: { value: 5, min: 1, max: 15, step: 0.5 },        // tia lửa mỗi giây
  crab_fan_rate: { value: 7, min: 1, max: 20, step: 0.5 },         // pha Đau: lửa phụt thành quạt từ khớp càng
  crab_fan_speed: { value: 140, min: 60, max: 300, step: 10 },
  crab_fan_gap: { value: 26, min: 10, max: 60, step: 1 },          // độ: khe an toàn hướng về vết thương
  crab_breath_rate: { value: 2.2, min: 0.5, max: 8, step: 0.1 },   // pha Tin: lửa thở chậm

  // ---- Cân Định Giá nổ (sống sót) ----
  scale_time: { value: 8, min: 3, max: 20, step: 0.5 },            // giây
  scale_shard_rate: { value: 9, min: 2, max: 25, step: 0.5 },      // mảnh mỗi giây
  scale_shard_speed: { value: 210, min: 80, max: 400, step: 10 },

  // ---- Bọ Ký Sinh (tuỳ chọn) ----
  bug_count: { value: 3, min: 1, max: 6, step: 1 },
  bug_spit_rate: { value: 2.2, min: 0.5, max: 8, step: 0.1 },      // ngụm mỗi giây mỗi con
  bug_spit_speed: { value: 140, min: 60, max: 300, step: 10 },
  bug_tax_cut: { value: 0.2, min: 0, max: 0.5, step: 0.05 },       // handover: giảm 20% thuế khi gỡ hết

  // ---- Câu đố ----
  pz_fragment: { value: 1, min: 0, max: 3, step: 1 },              // Mảnh Phản Chiếu mỗi câu đố
  light_hint_cost: { value: 20, min: 0, max: 100, step: 5 },       // Lumen cho một gợi ý của Mira

  // ---- Biến cốt truyện khởi tạo (handover, Bước 4) ----
  start_lumen: { value: 250, min: 0, max: 2000, step: 10 },
  start_bond: { value: 30, min: 0, max: 100, step: 5 },
  start_eco: { value: 60, min: 0, max: 100, step: 5 },

  // ---- Tác động lựa chọn (handover: Bước 4 và YAML) ----
  eco_feed: { value: 5, min: 0, max: 20, step: 1 },                // cho sinh vật ăn / thuần hoá
  eco_kill: { value: 8, min: 0, max: 20, step: 1 },                // giết sinh vật lấy nguyên liệu
  corrupt_kill: { value: 10, min: 0, max: 30, step: 1 },           // giết sinh vật hiền lành
  corrupt_cleanse: { value: 10, min: 0, max: 30, step: 1 },        // Thanh Tẩy một đồng Memoria
  linh_fee: { value: 5, min: 1, max: 20, step: 1 },                // nợ khám bệnh của Linh
  fox_bounty: { value: 150, min: 0, max: 500, step: 10 },          // săn Hồ Ly Âm Bản
  crab_core_value: { value: 200, min: 0, max: 500, step: 10 },     // Lõi Lửa khi đánh cua

  // ---- Chợ: giá bánh mì theo sinh thái (Event Bus) ----
  bread_base: { value: 12, min: 1, max: 50, step: 1 },             // Lumen
  bread_eco_swing: { value: 0.5, min: 0, max: 1, step: 0.05 },     // sinh thái 0 → giá x(1+swing); 100 → x(1-swing)
  market_tax: { value: 0.25, min: 0, max: 0.6, step: 0.05 },       // thuế chợ

  // ---- Đi lại ----
  walk_speed: { value: 240, min: 120, max: 420, step: 10 },        // px/giây
  reach: { value: 80, min: 40, max: 160, step: 5 },                // px
  travel_time: { value: 2.6, min: 1, max: 6, step: 0.1 },          // giây: chuyến tàu lưng cá
  line_time: { value: 5, min: 2, max: 10, step: 0.5 },             // giây: dòng chữ khi đi
  text_speed: { value: 42, min: 12, max: 120, step: 2 },           // chữ/giây
  heartbeat_bpm: { value: 54, min: 30, max: 100, step: 1 },        // nhịp Lõi Nhịp Tim
  sprite_scale: { value: 2, min: 1, max: 4, step: 1 },             // điểm ảnh Aseprite → màn hình (640×360 ×2)
};
