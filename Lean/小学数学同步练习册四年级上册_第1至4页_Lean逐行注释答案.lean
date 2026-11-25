-- 《小学数学同步练习册四年级上册答案》原书第1至4页的Lean形式化试作。
-- 对应答案PDF物理第8至11页；只导入标准库，使用Lean4.36.0-rc1检查。
-- 每个非空代码行都有中文注释；题意由人工转为模型，Lean检查写出的形式命题。
-- 本批数量用自然数表示，实际除法均整除、实际减法均非负，相关适用性另有证明。
-- 应用题既有完整脱式算法，也有从直接数量关系推出结论的模型证明。
-- 条件选择题的中文相关性是人工判断，编号筛选不代表机器理解了中文题意。
import Std -- 导入Lean自带标准库，不需要Mathlib。

namespace Workbook.Page01 -- 物理第八页、原书第一页的全部证明放在此命名空间。

-- 本页所有数量都用自然数表示，钱的单位是元，路程是千米，时间是小时。
-- 乘法保持每份数乘份数：单价乘销量、每小时路程乘小时数。
-- 自然数减法在结果小于零时截断为零，因此本页另证每个实际减法均非负。
-- 自然数除法是整数除法，本页只用于下方已证明整除的四个算式，不据此推广到任意除法。

theorem page_subtractions_are_nonnegative : -- 核验本页实际出现的减法都不会发生自然数截断。
    (30 : Nat) ≤ 50 ∧ -- 围棋单价减去假设单价，差价是非负数。
    (120 : Nat) ≤ 300 ∧ -- 高速动车速度减去普通列车速度，速度差是非负数。
    (120 : Nat) * 5 ≤ 300 * 5 ∧ -- 高速动车路程减去普通列车路程，路程差是非负数。
    (210 : Nat) / 3 ≤ 2480 / 8 ∧ -- 第一条计算题先除后减，三百一十不少于七十。
    (2100 : Nat) / 3 ≤ 750 * 2 := by -- 第三条计算题中，一千五百不少于七百。
  decide -- 由内核核验上述五项具体大小关系。

theorem page_divisions_are_exact : -- 核验本页四次除法都没有余数。
    (2480 : Nat) % 8 = 0 ∧ -- 两千四百八十能被八整除。
    (210 : Nat) % 3 = 0 ∧ -- 二百一十能被三整除。
    (2100 : Nat) % 3 = 0 ∧ -- 二千一百能被三整除。
    ((80 : Nat) * 5) % 20 = 0 := by -- 先算八十乘五，所得四百能被二十整除。
  decide -- 由内核核验四个余数都是零。

theorem sales_by_separate_revenues : -- 第一题方法一，分别求两种棋的总价再相加。
    (30 : Nat) * 45 + 50 * 30 = 2850 := by -- 单价乘销量得到各类销售额，目标单位是元。
  calc -- 按原题的运算顺序写出完整脱式。
    (30 : Nat) * 45 + 50 * 30 = 1350 + 1500 := by decide -- 象棋收入一千三百五十元，围棋收入一千五百元。
    _ = 2850 := by decide -- 两项收入相加，答销售总额为二千八百五十元。

theorem sales_by_assuming_price_thirty : -- 第一题方法二，假设每副都按三十元卖，再补围棋差价。
    (30 : Nat) * (45 + 30) + (50 - 30) * 30 = 2850 := by -- 先按七十五副计价，再为三十副围棋各补二十元。
  calc -- 保持每副价格乘副数的顺序，逐行计算。
    (30 : Nat) * (45 + 30) + (50 - 30) * 30 = 30 * 75 + 20 * 30 := by decide -- 总副数是七十五，每副围棋应补二十元。
    _ = 2250 + 600 := by decide -- 假设收入二千二百五十元，补价六百元。
    _ = 2850 := by decide -- 答销售总额为二千八百五十元。

theorem sales_methods_agree : -- 第一题的两种综合算式确实给出相同总额。
    (30 : Nat) * 45 + 50 * 30 = 30 * (45 + 30) + (50 - 30) * 30 := by -- 比较分别求和与先假设后补差两种方法。
  calc -- 通过已经证明的共同结果连接两种方法。
    (30 : Nat) * 45 + 50 * 30 = 2850 := sales_by_separate_revenues -- 使用方法一的完整脱式结论。
    _ = 30 * (45 + 30) + (50 - 30) * 30 := sales_by_assuming_price_thirty.symm -- 反向使用方法二的完整脱式结论。

theorem sales_total_from_quantities -- 将第一题的已知值与直接数量关系显式建模，而不把答案当作假设。
    (chessUnit chessCount goUnit goCount chessRevenue goRevenue total : Nat) -- 分别表示两类单价、销量、分类收入以及销售总额。
    (hChessUnit : chessUnit = 30) -- 原题已知象棋每副三十元。
    (hChessCount : chessCount = 45) -- 原题已知卖出象棋四十五副。
    (hGoUnit : goUnit = 50) -- 原题已知围棋每副五十元。
    (hGoCount : goCount = 30) -- 原题已知卖出围棋三十副。
    (hChessRevenue : chessRevenue = chessUnit * chessCount) -- 象棋收入直接等于每副价格乘卖出的副数。
    (hGoRevenue : goRevenue = goUnit * goCount) -- 围棋收入直接等于每副价格乘卖出的副数。
    (hTotal : total = chessRevenue + goRevenue) : -- 销售总额直接等于两种棋收入的和。
    total = 2850 := by -- 从题目条件推出总额，而非预先假定总额。
  calc -- 先代入数量关系，再代入原题的具体已知值。
    total = chessRevenue + goRevenue := hTotal -- 按总额与分类收入的直接关系展开。
    _ = chessUnit * chessCount + goUnit * goCount := by rw [hChessRevenue, hGoRevenue] -- 将分类收入分别替换为单价乘销量。
    _ = 30 * 45 + 50 * 30 := by rw [hChessUnit, hChessCount, hGoUnit, hGoCount] -- 只使用题目给出的四项已知值。
    _ = 2850 := sales_by_separate_revenues -- 使用已证明的脱式计算，答销售总额为二千八百五十元。

theorem travel_by_separate_distances : -- 第二题方法一，分别求两车五小时的路程再相减。
    (300 : Nat) * 5 - 120 * 5 = 900 := by -- 每小时路程乘相同小时数，再比较高速与普通列车。
  calc -- 先分别计算乘法，再进行减法。
    (300 : Nat) * 5 - 120 * 5 = 1500 - 600 := by decide -- 高速动车走一千五百千米，普通列车走六百千米。
    _ = 900 := by decide -- 答高速动车多行驶九百千米。

theorem travel_by_speed_difference : -- 第二题方法二，速度差乘两车共同的行驶时间。
    ((300 : Nat) - 120) * 5 = 900 := by -- 每小时多行的路程乘五小时，得到路程差。
  calc -- 先算括号内的速度差，再算乘法。
    ((300 : Nat) - 120) * 5 = 180 * 5 := by decide -- 每小时高速动车多行一百八十千米。
    _ = 900 := by decide -- 答高速动车五小时多行驶九百千米。

theorem travel_methods_agree : -- 第二题的分别求路程法与速度差法确实等价。
    (300 : Nat) * 5 - 120 * 5 = (300 - 120) * 5 := by -- 两边均表示同走五小时后高速动车多行的路程。
  calc -- 通过已经核验的共同路程差连接两种算式。
    (300 : Nat) * 5 - 120 * 5 = 900 := travel_by_separate_distances -- 使用分别求路程再相减的方法。
    _ = (300 - 120) * 5 := travel_by_speed_difference.symm -- 反向使用速度差乘时间的方法。

theorem travel_gap_from_quantities -- 将第二题的速度、共同时间、路程及所问差值显式建模。
    (ordinarySpeed fastSpeed hours ordinaryDistance fastDistance gap : Nat) -- 依次表示普通速度、高速速度、小时数、两车路程及路程差。
    (hOrdinarySpeed : ordinarySpeed = 120) -- 原题已知普通列车每小时行一百二十千米。
    (hFastSpeed : fastSpeed = 300) -- 原题已知高速动车每小时行三百千米。
    (hHours : hours = 5) -- 原题已知两车都行驶五小时。
    (hOrdinaryDistance : ordinaryDistance = ordinarySpeed * hours) -- 普通列车路程等于每小时路程乘小时数。
    (hFastDistance : fastDistance = fastSpeed * hours) -- 高速动车路程等于每小时路程乘小时数。
    (hGap : gap = fastDistance - ordinaryDistance) : -- 所问数量是高速动车路程减去普通列车路程。
    gap = 900 := by -- 根据速度、时间和路程关系求差，不假定差值答案。
  calc -- 按题意依次替换直接数量关系和已知值。
    gap = fastDistance - ordinaryDistance := hGap -- 将所问路程差展开为两车路程之差。
    _ = fastSpeed * hours - ordinarySpeed * hours := by rw [hFastDistance, hOrdinaryDistance] -- 两段路程都保持每小时路程乘小时数。
    _ = 300 * 5 - 120 * 5 := by rw [hFastSpeed, hOrdinarySpeed, hHours] -- 代入三百、一百二十和共同时间五小时。
    _ = 900 := travel_by_separate_distances -- 使用闭式脱式结论，答高速动车多行驶九百千米。

theorem calculation_three_one : -- 第三题第一条，先算两次除法，再算减法。
    (2480 : Nat) / 8 - 210 / 3 = 240 := by -- 本页已经核验这两次除法整除且减法非负。
  calc -- 保留原题的除法优先次序。
    (2480 : Nat) / 8 - 210 / 3 = 310 - 70 := by decide -- 两个商分别是三百一十和七十。
    _ = 240 := by decide -- 相减得到二百四十。

theorem calculation_three_two : -- 第三题第二条，先算两次乘法，再算加法。
    (61 : Nat) * 52 + 36 * 125 = 7672 := by -- 验证六十一乘五十二加三十六乘一百二十五。
  calc -- 逐行展示两个乘积及其和。
    (61 : Nat) * 52 + 36 * 125 = 3172 + 4500 := by decide -- 两个乘积分别是三千一百七十二和四千五百。
    _ = 7672 := by decide -- 相加得到七千六百七十二。

theorem calculation_three_three : -- 第三题第三条，先算乘法和除法，再算减法。
    (750 : Nat) * 2 - 2100 / 3 = 800 := by -- 本页已经核验除法整除且一千五百减七百非负。
  calc -- 先分别求积与商，再相减。
    (750 : Nat) * 2 - 2100 / 3 = 1500 - 700 := by decide -- 七百五十乘二是一千五百，二千一百除三是七百。
    _ = 800 := by decide -- 相减得到八百。

theorem calculation_three_four : -- 第三题第四条，先按从左到右的次序算乘除，最后算加法。
    (120 : Nat) + 80 * 5 / 20 = 140 := by -- 乘法和除法同级，原式先算八十乘五，再除二十。
  calc -- 展示乘、除、加三个依次执行的步骤。
    (120 : Nat) + 80 * 5 / 20 = 120 + 400 / 20 := by decide -- 先算八十乘五得到四百。
    _ = 120 + 20 := by decide -- 四百除以二十得到二十，且这次除法整除。
    _ = 140 := by decide -- 最后相加得到一百四十。

end Workbook.Page01 -- 本页全部题目及其数量关系证明结束。

namespace Workbook.Page02 -- 本命名空间对应练习册原书第２页，即源文件物理第９页。

theorem continuation_from_previous_page : (240 : Nat) + 15 * 365 - 200 = 5515 := by -- 核验从上一页续来的混合运算。
  calc -- 严格按照先乘法、后加减的顺序逐步计算。
    (240 : Nat) + 15 * 365 - 200 = 240 + 5475 - 200 := by decide -- 先计算十五乘三百六十五。
    _ = 5715 - 200 := by decide -- 再把二百四十与乘积相加。
    _ = 5515 := by decide -- 最后减去二百，得到五千五百一十五。

theorem q4_1_correct : (488 : Nat) - 120 / 4 * 9 = 218 := by -- 第４题第一式应先按从左到右计算除法、乘法。
  calc -- 用正确的运算顺序改正原来的解答。
    (488 : Nat) - 120 / 4 * 9 = 488 - 30 * 9 := by decide -- 一百二十除以四得到三十。
    _ = 488 - 270 := by decide -- 三十乘九得到二百七十。
    _ = 218 := by decide -- 四百八十八减二百七十得到二百一十八。

theorem q4_1_misordered_trace : ((488 : Nat) - 120) / 4 * 9 = 828 := by -- 此定理只核验错误添括号后的数值，不认可这种改写。
  calc -- 原错解把减法提前，实际算的是另一个式子。
    ((488 : Nat) - 120) / 4 * 9 = 368 / 4 * 9 := by decide -- 提前相减得到三百六十八。
    _ = 92 * 9 := by decide -- 这个错误式子的商确为九十二。
    _ = 828 := by decide -- 因而错误式子得到八百二十八。

theorem q4_1_reject_828 : (488 : Nat) - 120 / 4 * 9 ≠ 828 := by -- 明确证明原题的正确值与错答八百二十八不同。
  decide -- 通过自然数的可判定计算检查不等式。

theorem q4_2_division : (480 : Nat) / 4 = 120 := by -- 第４题第二式的商是一百二十，而不是十二。
  decide -- 标准库核验这个整除结果。

theorem q4_2_reject_12 : (480 : Nat) / 4 ≠ 12 := by -- 明确定位原错解漏掉一个零的错误。
  decide -- 证明四百八十除以四不等于十二。

theorem q4_2_correct : (480 : Nat) / 4 + 70 * 9 = 750 := by -- 第４题第二式应得到七百五十。
  calc -- 先算除法与乘法，再把结果相加。
    (480 : Nat) / 4 + 70 * 9 = 120 + 630 := by decide -- 两项分别是一百二十和六百三十。
    _ = 750 := by decide -- 两项相加得到七百五十。

theorem q4_2_erroneous_sum : (12 : Nat) + 630 = 642 := by -- 六百四十二只是把错误的商十二代入后得到的和。
  decide -- 这一步加法本身成立，但不能作为原式的答案。

theorem q4_2_reject_642 : (480 : Nat) / 4 + 70 * 9 ≠ 642 := by -- 证明原题正确结果与错答六百四十二不同。
  decide -- 核验两个自然数结果确实不相等。

theorem q5_1 : (750 : Nat) - 30 * 20 + 80 = 230 := by -- 第５题第一小题按先乘后加减进行脱式计算。
  calc -- 每个等号对应原题的一步脱式。
    (750 : Nat) - 30 * 20 + 80 = 750 - 600 + 80 := by decide -- 先计算三十乘二十。
    _ = 150 + 80 := by decide -- 七百五十减六百得到一百五十。
    _ = 230 := by decide -- 再加八十得到二百三十。

theorem q5_2_factor_method : (35 : Nat) * 68 + 35 * 32 = 3500 := by -- 第５题第二小题的第一种方法是提取共同因数。
  calc -- 保留原页展示的乘法分配律简算过程。
    (35 : Nat) * 68 + 35 * 32 = 35 * (68 + 32) := (Nat.mul_add 35 68 32).symm -- 反向使用乘法分配律提取三十五。
    _ = 35 * 100 := by decide -- 括号里的六十八与三十二相加为一百。
    _ = 3500 := by decide -- 三十五乘一百得到三千五百。

theorem q5_2_separate_products_method : (35 : Nat) * 68 + 35 * 32 = 3500 := by -- 第二种方法分别求两个乘积再相加。
  calc -- 不提取公因数，直接保留两项计算过程。
    (35 : Nat) * 68 + 35 * 32 = 2380 + 1120 := by decide -- 同一步算出两个乘积，分别为二千三百八十和一千一百二十。
    _ = 3500 := by decide -- 两个乘积相加得到三千五百。

theorem q5_3 : (180 : Nat) / 9 - 120 / 6 = 0 := by -- 第５题第三小题先分别做两个除法。
  calc -- 两个商相同，所以相减为零。
    (180 : Nat) / 9 - 120 / 6 = 20 - 20 := by decide -- 两个整除的商都是二十。
    _ = 0 := by decide -- 二十减二十为零。

theorem q6_1_quotient : (612 : Nat) / 36 = 17 := by -- 第６题第一问，总张数除以每副大七巧板用纸量。
  calc -- 单位依次是张除以每副的张数，结果为副数。
    (612 : Nat) / 36 = 17 := by decide -- 六百一十二张恰好可以做十七副。

theorem q6_1_remainder : (612 : Nat) % 36 = 0 := by -- 证明这里没有余纸，避免把自然数除法的截断误认为精确相除。
  decide -- 六百一十二除以三十六的余数为零。

theorem q6_1_multiplication_check : (36 : Nat) * 17 = 612 := by -- 用每副张数乘副数检查答案。
  decide -- 三十六张乘十七副恰好用完六百一十二张。

theorem q6_1_quantity_model -- 以下把自然语言的数量关系人工建模成自然数等式。
    (totalSheets sheetsPerLarge largeSets : Nat) -- 三个变量分别表示总张数、每副大七巧板张数和所做副数。
    (h_total : totalSheets = 612) -- 已知共有六百一十二张卡纸。
    (h_per_large : sheetsPerLarge = 36) -- 已知每副大七巧板需要三十六张。
    (h_all_used : sheetsPerLarge * largeSets = totalSheets) : -- 数量关系是每副用纸量乘副数等于全部用纸量，并未预设答案。
    largeSets = 17 ∧ totalSheets / sheetsPerLarge = 17 ∧ totalSheets % sheetsPerLarge = 0 := by -- 从已知量和用纸关系推出副数、商以及零余数。
  have h_product : 36 * largeSets = 612 := by -- 先把具体已知值代入乘法关系。
    simpa [h_total, h_per_large] using h_all_used -- 只替换题目给出的张数，不加入副数结论。
  have h_sets : largeSets = 17 := by omega -- 由三十六乘副数等于六百一十二唯一推出十七副。
  refine ⟨h_sets, ?_, ?_⟩ -- 分别提交副数结论、除法结论与余数结论。
  · simp [h_total, h_per_large] -- 代入已知值并核验精确商为十七。
  · simp [h_total, h_per_large] -- 代入已知值并核验余数为零。

theorem q6_1_capacity_bound (largeSets : Nat) (h_available : 36 * largeSets ≤ 612) : largeSets ≤ 17 := by -- 即使只要求用纸不超过库存，所做副数也不可能超过十七。
  omega -- 用每副三十六张与总量上界证明十七副是最大可制作数量。

theorem q6_1_maximum_feasible : (36 : Nat) * 17 ≤ 612 ∧ ∀ n : Nat, 36 * n ≤ 612 → n ≤ 17 := by -- 同时证明十七副可制作，以及任何可制作数量都不超过十七副。
  constructor -- 分别证明可行性和最大性两个命题。
  · decide -- 十七副恰好用六百一十二张，因此不超过库存。
  · intro n h_available -- 任取一个用纸量不超过库存的制作副数。
    exact q6_1_capacity_bound n h_available -- 引用已证的容量上界，得到该副数不超过十七。

theorem q6_2_direct_method : (36 : Nat) * 9 + 24 * 6 = 468 := by -- 第６题第二问，先分别算大、小七巧板的用纸量。
  calc -- 按每副张数乘副数求出两类卡纸数量。
    (36 : Nat) * 9 + 24 * 6 = 324 + 144 := by decide -- 九副大的用三百二十四张，六副小的用一百四十四张。
    _ = 468 := by decide -- 合计需要四百六十八张。

theorem q6_2_all_large_method : (36 : Nat) * (9 + 6) - (36 - 24) * 6 = 468 := by -- 第二种方法先假设十五副全是大的，再减去多算的纸。
  calc -- 六副小的每副少用十二张，所以总共应减七十二张。
    (36 : Nat) * (9 + 6) - (36 - 24) * 6 = 36 * 15 - 12 * 6 := by decide -- 先求总副数与每副用纸差。
    _ = 540 - 72 := by decide -- 全按大的需要五百四十张，多算七十二张。
    _ = 468 := by decide -- 减去多算的张数，仍得四百六十八张。

theorem q6_2_methods_agree : (36 : Nat) * 9 + 24 * 6 = 36 * (9 + 6) - (36 - 24) * 6 := by -- 核验原页两种方法在本题数据下相等。
  calc -- 两边分别由已经证明的脱式结果连接。
    (36 : Nat) * 9 + 24 * 6 = 468 := q6_2_direct_method -- 第一法求得四百六十八张。
    _ = 36 * (9 + 6) - (36 - 24) * 6 := q6_2_all_large_method.symm -- 第二法也求得同一张数。

theorem q6_2_quantity_model -- 此模型使用题目给出的四个数量以及总用纸关系。
    (sheetsPerLarge sheetsPerSmall largeSets smallSets totalSheets : Nat) -- 变量依次表示大、小每副张数，大、小副数，以及总张数。
    (h_per_large : sheetsPerLarge = 36) -- 大七巧板每副需要三十六张。
    (h_per_small : sheetsPerSmall = 24) -- 小七巧板每副需要二十四张。
    (h_large_sets : largeSets = 9) -- 本问制作九副大的。
    (h_small_sets : smallSets = 6) -- 本问制作六副小的。
    (h_total_relation : totalSheets = sheetsPerLarge * largeSets + sheetsPerSmall * smallSets) : -- 总张数等于两类用纸量之和，未假设具体答案。
    totalSheets = 468 := by -- 从给定数量与总量关系推出四百六十八张。
  calc -- 先用数量关系，再代入已知值，最后引用直接计算。
    totalSheets = sheetsPerLarge * largeSets + sheetsPerSmall * smallSets := h_total_relation -- 把所求总张数展开为两项用纸量。
    _ = 36 * 9 + 24 * 6 := by rw [h_per_large, h_per_small, h_large_sets, h_small_sets] -- 代入四项已知值。
    _ = 468 := q6_2_direct_method -- 由已验证的运算得到答案。

def NeedPriceCondition (n : Nat) : Prop := n = 4 ∨ n = 5 ∨ n = 6 -- 第７题第一问的选项需要性由人工读题建模，并非形式系统自行理解了中文。

instance needPriceConditionDecidable (n : Nat) : Decidable (NeedPriceCondition n) := by -- 给人工定义的条件提供可判定性，以便筛选选项。
  unfold NeedPriceCondition -- 展开为选项编号等于四、五或六的命题。
  infer_instance -- 自然数相等和有限析取都有标准可判定实例。

def priceQuestionOptions : List Nat := [1, 2, 3, 4, 5, 6] -- 原题列出的六个候选条件按编号组成列表。

theorem q7_1_modelled_selection : priceQuestionOptions.filter (fun n => decide (NeedPriceCondition n)) = [4, 5, 6] := by -- 只证明按人工谓词筛选六个编号的结果是四、五、六。
  decide -- 对有限列表逐个计算该谓词，得到原页所勾的三个编号。

theorem q7_2_unit_price_method : (680 : Nat) - 1050 / 3 = 330 := by -- 第７题第二问，先求每套桌椅价格再求单价差。
  calc -- 帐篷单价减去桌椅的单价，就是多用的钱数。
    (680 : Nat) - 1050 / 3 = 680 - 350 := by decide -- 一千零五十元平均分给三套，每套三百五十元。
    _ = 330 := by decide -- 六百八十减三百五十为三百三十元。

theorem q7_2_three_items_method : ((680 : Nat) * 3 - 1050) / 3 = 330 := by -- 第二种方法先比较三顶帐篷与三套桌椅的总价。
  calc -- 总差价再除以三，得到一件对一套的单价差。
    ((680 : Nat) * 3 - 1050) / 3 = (2040 - 1050) / 3 := by decide -- 三顶帐篷共二千零四十元。
    _ = 990 / 3 := by decide -- 与三套桌椅总价相差九百九十元。
    _ = 330 := by decide -- 每组差价为三百三十元。

theorem q7_2_methods_agree : (680 : Nat) - 1050 / 3 = (680 * 3 - 1050) / 3 := by -- 核验比较单价与先比较三件总价两种方法在本题中一致。
  calc -- 两种方法都连接到同一个差价结果。
    (680 : Nat) - 1050 / 3 = 330 := q7_2_unit_price_method -- 第一法的结果是三百三十元。
    _ = (680 * 3 - 1050) / 3 := q7_2_three_items_method.symm -- 第二法的结果也是三百三十元。

theorem q7_2_quantity_model -- 人工建模只假设已知价格、套数与直接数量关系。
    (tentPrice furniturePrice furnitureCount furnitureTotal extraCost : Nat) -- 变量依次表示帐篷单价、桌椅单价、桌椅套数、桌椅总价与所求差价。
    (h_tent_price : tentPrice = 680) -- 原题给出每顶帐篷六百八十元。
    (h_furniture_count : furnitureCount = 3) -- 原题给出买了三套折叠桌椅。
    (h_furniture_total : furnitureTotal = 1050) -- 原题给出三套桌椅共一千零五十元。
    (h_total_relation : furniturePrice * furnitureCount = furnitureTotal) -- 单价乘套数等于桌椅总价，没有把三百五十元作为已知。
    (h_difference_relation : extraCost = tentPrice - furniturePrice) : -- 所求差价等于帐篷单价减桌椅单价，没有把三百三十元作为已知。
    furniturePrice = 350 ∧ extraCost = 330 ∧ furniturePrice ≤ tentPrice := by -- 同时推出桌椅单价、差价以及减法不会被截断的大小关系。
  have h_product : furniturePrice * 3 = 1050 := by -- 先将套数和总价代入单价关系。
    simpa [h_furniture_count, h_furniture_total] using h_total_relation -- 已知条件给出三倍桌椅单价等于一千零五十。
  have h_price : furniturePrice = 350 := by omega -- 根据乘法关系推出每套桌椅三百五十元。
  have h_extra : extraCost = 330 := by -- 把已经推出的单价代入差价关系。
    calc -- 此处只使用题意数量关系和已知值，不预设答案。
      extraCost = tentPrice - furniturePrice := h_difference_relation -- 首先展开差价的定义关系。
      _ = 680 - 350 := by rw [h_tent_price, h_price] -- 代入帐篷已知单价和桌椅已证单价。
      _ = 330 := by decide -- 计算得到多用三百三十元。
  have h_nonnegative : furniturePrice ≤ tentPrice := by -- 另外检查帐篷确实不比桌椅便宜。
    rw [h_price, h_tent_price] -- 将大小关系化为三百五十不超过六百八十。
    decide -- 数值比较证明这里的自然数减法是普通非负差。
  exact ⟨h_price, h_extra, h_nonnegative⟩ -- 汇总三个由条件推出的结论。

theorem all_displayed_divisors_positive : (0 : Nat) < 4 ∧ 0 < 9 ∧ 0 < 6 ∧ 0 < 36 ∧ 0 < 3 := by -- 本页所有除数都为正数，不涉及除以零。
  decide -- 逐项检查出现过的五个除数。

theorem all_correct_divisions_exact : (120 : Nat) % 4 = 0 ∧ 480 % 4 = 0 ∧ 180 % 9 = 0 ∧ 120 % 6 = 0 ∧ 612 % 36 = 0 ∧ 1050 % 3 = 0 ∧ (680 * 3 - 1050) % 3 = 0 := by -- 本页正确解法中所有除法均整除，故自然数除法没有丢失小数部分。
  decide -- 以零余数逐项核验整除性。

theorem all_subtractions_nonnegative : (200 : Nat) ≤ 240 + 15 * 365 ∧ 120 / 4 * 9 ≤ 488 ∧ 120 ≤ 488 ∧ 30 * 20 ≤ 750 ∧ 120 / 6 ≤ 180 / 9 ∧ 24 ≤ 36 ∧ (36 - 24) * 6 ≤ 36 * (9 + 6) ∧ 1050 / 3 ≤ 680 ∧ 1050 ≤ 680 * 3 := by -- 本页全部主式减法的被减数不小于减数，避免自然数截断掩盖负数问题。
  decide -- 逐项核验所有原式以及两种方法中的非负差。

end Workbook.Page02 -- 结束原书第２页的全部形式化验证。

namespace Workbook.Page03 -- 本命名空间对应练习册物理第十页、原书第三页。

-- 全页用自然数记录数量：价格单位为元，药材产量单位为千克，购买数量单位为套或枚。
-- 自然数本身非负；涉及减法时另核对被减数不少于减数，涉及除法时核对除数正且整除。
-- 所有乘法按每份数量在前、份数或倍数在后的顺序书写；每个等号都是内核检查的证明步骤。

 theorem q1_first_division_is_exact : (0 : Nat) < 16 ∧ 288 % 16 = 0 := by -- 第一小题的除数十六非零，而且二百八十八能被十六整除。
  decide -- 标准库的判定证明逐项验证这两个具体自然数命题。

 theorem q1_first_method_parentheses : (25 : Nat) * (44 + 288 / 16) = 1550 := by -- 第一题第一式，方法一：先算括号内的除法，再加法，最后乘法。
  calc -- 以下每一行只进行题目要求的一步脱式计算。
    (25 : Nat) * (44 + 288 / 16) = 25 * (44 + 18) := by rfl -- 二百八十八除以十六等于十八。
    _ = 25 * 62 := by rfl -- 括号内四十四加十八等于六十二。
    _ = 1550 := by rfl -- 二十五乘六十二等于一千五百五十。

 theorem q1_first_method_distributive : (25 : Nat) * (44 + 288 / 16) = 1550 := by -- 第一题第一式，方法二：使用乘法分配律。
  calc -- 从原式开始，保留展开后每一行完整的计算过程。
    (25 : Nat) * (44 + 288 / 16) = 25 * 44 + 25 * (288 / 16) := by rw [Nat.mul_add] -- 乘法分配律把二十五分别乘括号中的两个加数。
    _ = 1100 + 25 * 18 := by rfl -- 二十五乘四十四等于一千一百，同时计算括号内的除法。
    _ = 1100 + 450 := by rfl -- 二十五乘十八等于四百五十。
    _ = 1550 := by rfl -- 两个积相加得到一千五百五十。

 theorem q1_second_divisions_are_exact : (0 : Nat) < 90 ∧ (15 * 30) % 90 = 0 ∧ 0 < 15 * 30 / 90 ∧ 270 % (15 * 30 / 90) = 0 := by -- 第二式中两次除法的除数均正，且都能整除。
  decide -- 验证四百五十除以九十得五，二百七十也能被五整除。

 theorem q1_second_method : (270 : Nat) / (15 * 30 / 90) = 54 := by -- 第一题第二式：先算括号，括号内同级乘除从左向右。
  calc -- 完整展示括号内先乘后除，再计算括号外的除法。
    (270 : Nat) / (15 * 30 / 90) = 270 / (450 / 90) := by rfl -- 十五乘三十等于四百五十。
    _ = 270 / 5 := by rfl -- 四百五十除以九十等于五。
    _ = 54 := by rfl -- 二百七十除以五等于五十四。

 theorem q1_third_subtraction_and_division_are_valid : (352 : Nat) ≤ 357 ∧ 0 < 357 - 352 ∧ (43 + 32) % (357 - 352) = 0 := by -- 第三式的减法不出现负数，所得除数为正，且被除数能整除。
  decide -- 核对三百五十七不少于三百五十二，差为五，七十五能被五整除。

 theorem q1_third_method : ((43 : Nat) + 32) / (357 - 352) = 15 := by -- 第一题第三式：分别算两组小括号，再相除。
  calc -- 以下是原页第三条算式的完整脱式计算。
    ((43 : Nat) + 32) / (357 - 352) = 75 / 5 := by rfl -- 分子四十三加三十二为七十五，分母三百五十七减三百五十二为五。
    _ = 15 := by rfl -- 七十五除以五等于十五。

 theorem q2_method_separate_totals : (280 : Nat) * 4 + 95 * 5 = 1595 := by -- 第二题方法一：模型每套二百八十元乘四套，徽章每枚九十五元乘五枚。
  calc -- 两类商品先分别求总价，再相加。
    (280 : Nat) * 4 + 95 * 5 = 1120 + 475 := by rfl -- 四套模型共一千一百二十元，五枚徽章共四百七十五元。
    _ = 1595 := by rfl -- 总共花费一千五百九十五元。

 theorem q2_method_group_pairs : ((280 : Nat) + 95) * 4 + 95 = 1595 := by -- 第二题方法二：四套模型分别搭配一枚徽章，另有一枚徽章。
  calc -- 每组价格乘四组，再加剩余一枚徽章的价格。
    ((280 : Nat) + 95) * 4 + 95 = 375 * 4 + 95 := by rfl -- 每组一套模型与一枚徽章共三百七十五元。
    _ = 1500 + 95 := by rfl -- 四组共一千五百元。
    _ = 1595 := by rfl -- 再加一枚徽章九十五元，共一千五百九十五元。

 theorem q2_model_total -- 第二题数量模型：结论从单价、数量和总价关系推出，不把答案当作假设。
    (modelPrice modelCount badgePrice badgeCount total : Nat) -- 五个变量依次表示模型单价、模型套数、徽章单价、徽章枚数和总价。
    (h_modelPrice : modelPrice = 280) -- 已知每套模型二百八十元。
    (h_modelCount : modelCount = 4) -- 已知买了四套模型。
    (h_badgePrice : badgePrice = 95) -- 已知每枚徽章九十五元。
    (h_badgeCount : badgeCount = 5) -- 已知买了五枚徽章。
    (h_total : total = modelPrice * modelCount + badgePrice * badgeCount) : -- 直接数量关系是两类单价分别乘数量，再相加。
    total = 1595 := by -- 所求结论是总共花费一千五百九十五元。
  calc -- 先使用数量关系，再代入已知数据，最后使用已证明的脱式计算。
    total = modelPrice * modelCount + badgePrice * badgeCount := h_total -- 总价由两个商品总价组成。
    _ = 280 * 4 + 95 * 5 := by rw [h_modelPrice, h_modelCount, h_badgePrice, h_badgeCount] -- 把题目给出的四个数分别代入。
    _ = 1595 := q2_method_separate_totals -- 由方法一的完整计算得到总价。

 theorem q2_model_grouping -- 第二题分组模型：证明第二种算法也确实来自同一购买条件。
    (modelPrice modelCount badgePrice badgeCount total : Nat) -- 仍使用价格、数量和总价这五个实际数量变量。
    (h_modelPrice : modelPrice = 280) -- 模型单价是二百八十元。
    (h_modelCount : modelCount = 4) -- 模型数量是四套。
    (h_badgePrice : badgePrice = 95) -- 徽章单价是九十五元。
    (h_badgeCount : badgeCount = 5) -- 徽章数量是五枚。
    (h_total : total = modelPrice * modelCount + badgePrice * badgeCount) : -- 只假设原始总价关系。
    total = (modelPrice + badgePrice) * modelCount + badgePrice ∧ total = 1595 := by -- 同时证明四组加一枚的表示与最终总价。
  have h_grouped : total = (modelPrice + badgePrice) * modelCount + badgePrice := by -- 先核对按四组搭配没有漏算或多算徽章。
    calc -- 从原始总价式转换成分组式。
      total = modelPrice * modelCount + badgePrice * badgeCount := h_total -- 使用原始购买总价关系。
      _ = (280 + 95) * 4 + 95 := by rw [h_modelPrice, h_modelCount, h_badgePrice, h_badgeCount] -- 代入后由自然数计算核对四组加一枚与原式相同。
      _ = (modelPrice + badgePrice) * modelCount + badgePrice := by rw [h_modelPrice, h_modelCount, h_badgePrice] -- 把分组式恢复成实际数量变量。
  constructor -- 分别证明分组等式与数值结论。
  · exact h_grouped -- 第一部分就是刚证明的分组关系。
  · calc -- 第二部分使用分组算法给出总价。
      total = (modelPrice + badgePrice) * modelCount + badgePrice := h_grouped -- 将总价写成四组加剩余一枚。
      _ = (280 + 95) * 4 + 95 := by rw [h_modelPrice, h_modelCount, h_badgePrice] -- 代入每组价格、组数和剩余徽章单价。
      _ = 1595 := q2_method_group_pairs -- 由方法二的脱式计算得到一千五百九十五元。

 theorem q3_method_sum_first : ((16 : Nat) + 33) * 2 + 2 = 100 := by -- 第三题方法一：篮球和足球价格之和的两倍，再多二元。
  calc -- 先求价格和，再乘二，最后加二。
    ((16 : Nat) + 33) * 2 + 2 = 49 * 2 + 2 := by rfl -- 篮球十六元与足球三十三元的价格和为四十九元。
    _ = 98 + 2 := by rfl -- 四十九元的两倍是九十八元。
    _ = 100 := by rfl -- 再加二元，羽毛球拍每副一百元。

 theorem q3_method_distribute : (16 : Nat) * 2 + 33 * 2 + 2 = 100 := by -- 第三题方法二：将两种球的价格分别加倍，再加二元。
  calc -- 两个价格分别乘倍数，然后求和补差。
    (16 : Nat) * 2 + 33 * 2 + 2 = 32 + 66 + 2 := by rfl -- 十六的两倍是三十二，三十三的两倍是六十六。
    _ = 98 + 2 := by rfl -- 两个加倍后的价格之和是九十八元。
    _ = 100 := by rfl -- 多二元后，羽毛球拍每副一百元。

 theorem q3_distributive_connection : ((16 : Nat) + 33) * 2 + 2 = 16 * 2 + 33 * 2 + 2 := by -- 连接两种解法，说明分别加倍来自乘法分配律。
  rw [Nat.add_mul] -- 和乘二等于各加数分别乘二后相加。

 theorem q3_model_price -- 第三题数量模型：用球的单价、倍数与增加的钱数推出球拍单价。
    (basketballPrice footballPrice multiplier extra racketPrice : Nat) -- 五个变量分别表示篮球价、足球价、倍数、增加额和每副球拍价。
    (h_basketball : basketballPrice = 16) -- 已知篮球每个十六元。
    (h_football : footballPrice = 33) -- 已知足球每个三十三元。
    (h_multiplier : multiplier = 2) -- 已知球拍价格是两种球价格之和的两倍再多二元。
    (h_extra : extra = 2) -- 其中多出的金额是二元。
    (h_price : racketPrice = (basketballPrice + footballPrice) * multiplier + extra) : -- 直接数量关系先将两种球价格相加，再乘倍数，再加增加额。
    racketPrice = 100 := by -- 所求结论是羽毛球拍每副一百元。
  calc -- 从题意关系逐项代入实际数据。
    racketPrice = (basketballPrice + footballPrice) * multiplier + extra := h_price -- 使用球拍价格与两种球价格的直接关系。
    _ = (16 + 33) * 2 + 2 := by rw [h_basketball, h_football, h_multiplier, h_extra] -- 代入两个单价、倍数和增加的钱数。
    _ = 100 := q3_method_sum_first -- 使用已经验证的先求和方法。

 theorem q4_first_subtraction_is_nonnegative : (100 : Nat) ≤ (500 + 350) * 2 ∧ 100 ≤ 500 * 2 + 350 * 2 := by -- 第四题两种算法中的减一百都不会触发自然数截断。
  decide -- 两个被减数实际同为一千七百，均不少于一百。

 theorem q4_first_method_successive : ((500 : Nat) + 350) * 2 - 100 = 1600 := by -- 第四题第一问方法一：先求黄芪产量，再求当归产量。
  calc -- 依次计算黄芪、黄芪的两倍以及少收的一百千克。
    ((500 : Nat) + 350) * 2 - 100 = 850 * 2 - 100 := by rfl -- 黄芪比五百千克板蓝根多三百五十千克，为八百五十千克。
    _ = 1700 - 100 := by rfl -- 黄芪产量的两倍是一千七百千克。
    _ = 1600 := by rfl -- 当归比这个两倍少一百千克，收获一千六百千克。

 theorem q4_first_method_distribute : (500 : Nat) * 2 + 350 * 2 - 100 = 1600 := by -- 第四题第一问方法二：将板蓝根产量与黄芪增加量分别加倍。
  calc -- 分别计算两份五百千克与两份三百五十千克，再扣除一百千克。
    (500 : Nat) * 2 + 350 * 2 - 100 = 1000 + 700 - 100 := by rfl -- 两个五百是一千，两个三百五十是七百。
    _ = 1700 - 100 := by rfl -- 两项合计一千七百千克。
    _ = 1600 := by rfl -- 减去一百千克得到当归收获量一千六百千克。

 theorem q4_first_distributive_connection : ((500 : Nat) + 350) * 2 - 100 = 500 * 2 + 350 * 2 - 100 := by -- 证明第一问的分开补差方法与原综合式一致。
  rw [Nat.add_mul] -- 用乘法分配律展开和乘二，减一百的位置保持不变。

 theorem q4_second_divisions_are_exact : (0 : Nat) < 800 ∧ 1600 % 800 = 0 ∧ (1600 * 3) % 800 = 0 := by -- 第四题第二问除数八百为正，两种算法需要的除法都整除。
  decide -- 核对一千六百与四千八百均为八百的整数倍。

 theorem q4_second_method_lingzhi_first : (1600 : Nat) * 3 / 800 = 6 := by -- 第四题第二问方法一：先求灵芝收获量，再与金银花比较。
  calc -- 每份一千六百千克乘三份，再除以金银花的八百千克。
    (1600 : Nat) * 3 / 800 = 4800 / 800 := by rfl -- 灵芝收获量是当归的三倍，为四千八百千克。
    _ = 6 := by rfl -- 四千八百除以八百得六，所以灵芝是金银花的六倍。

 theorem q4_second_method_ratio_first : ((1600 : Nat) / 800) * 3 = 6 := by -- 第四题第二问方法二：先比较当归与金银花，再取三倍。
  calc -- 一千六百能被八百整除，因此先求两者的整数倍数是适用的。
    ((1600 : Nat) / 800) * 3 = 2 * 3 := by rfl -- 当归收获量是金银花的两倍。
    _ = 6 := by rfl -- 灵芝是当归的三倍，也就是金银花的六倍。

 theorem q4_second_methods_agree : (1600 : Nat) * 3 / 800 = (1600 / 800) * 3 := by -- 核对本题中先乘再除与先除再乘得到相同倍数。
  calc -- 这里只对本题可整除的具体数据证明，不泛化为任意自然数除法规则。
    (1600 : Nat) * 3 / 800 = 6 := q4_second_method_lingzhi_first -- 第一种算法已经证明结果为六。
    _ = (1600 / 800) * 3 := q4_second_method_ratio_first.symm -- 第二种算法也等于六，反向连接即可。

 theorem q4_yield_model -- 第四题联动模型：仅从原题的已知产量和相邻数量关系推出两个答案及适用条件。
    (banlangen huangqi danggui jinyinhua lingzhi : Nat) -- 五个变量依次表示板蓝根、黄芪、当归、金银花和灵芝的千克数。
    (huangqiExtra dangguiMultiple dangguiLess lingzhiMultiple : Nat) -- 四个变量依次表示黄芪增加量、当归倍数、当归减少量和灵芝倍数。
    (h_banlangen : banlangen = 500) -- 已知板蓝根收获五百千克。
    (h_huangqiExtra : huangqiExtra = 350) -- 已知黄芪比板蓝根多三百五十千克。
    (h_dangguiMultiple : dangguiMultiple = 2) -- 已知比较当归时，先取黄芪产量的两倍。
    (h_dangguiLess : dangguiLess = 100) -- 已知当归比黄芪产量的两倍少一百千克。
    (h_jinyinhua : jinyinhua = 800) -- 已知金银花收获八百千克。
    (h_lingzhiMultiple : lingzhiMultiple = 3) -- 已知灵芝收获量是当归的三倍。
    (h_huangqi : huangqi = banlangen + huangqiExtra) -- 直接关系一是黄芪等于板蓝根加增加量。
    (h_danggui : danggui = huangqi * dangguiMultiple - dangguiLess) -- 直接关系二是当归等于黄芪乘倍数后减去减少量。
    (h_lingzhi : lingzhi = danggui * lingzhiMultiple) : -- 直接关系三是灵芝等于当归乘灵芝倍数，没有假设任何所求答案。
    dangguiLess ≤ huangqi * dangguiMultiple ∧ 0 < jinyinhua ∧ danggui = 1600 ∧ lingzhi = 4800 ∧ lingzhi % jinyinhua = 0 ∧ lingzhi / jinyinhua = 6 ∧ lingzhi = jinyinhua * 6 := by -- 结论同时给出减法非负、除数为正、当归产量、灵芝产量、整除和六倍关系。
  have h_huangqi_value : huangqi = 850 := by -- 先由板蓝根产量与增加量推出黄芪的实际产量。
    calc -- 这个中间量只由已知条件得出。
      huangqi = banlangen + huangqiExtra := h_huangqi -- 使用黄芪比板蓝根多收的关系。
      _ = 500 + 350 := by rw [h_banlangen, h_huangqiExtra] -- 代入板蓝根五百千克和增加的三百五十千克。
      _ = 850 := by rfl -- 黄芪实际收获八百五十千克。
  have h_danggui_value : danggui = 1600 := by -- 继续用黄芪产量推出第一问的当归产量。
    calc -- 仍然从直接数量关系出发，不使用答案假设。
      danggui = huangqi * dangguiMultiple - dangguiLess := h_danggui -- 使用当归比黄芪两倍少一百千克的关系。
      _ = (500 + 350) * 2 - 100 := by rw [h_huangqi_value, h_dangguiMultiple, h_dangguiLess] -- 代入已推出的黄芪产量和题给倍数、减少量。
      _ = 1600 := q4_first_method_successive -- 用第一问方法一得到当归收获一千六百千克。
  have h_lingzhi_value : lingzhi = 4800 := by -- 再从当归产量推出灵芝收获量。
    calc -- 每份为当归产量，灵芝共有这样的三份。
      lingzhi = danggui * lingzhiMultiple := h_lingzhi -- 使用灵芝是当归三倍的直接关系。
      _ = 1600 * 3 := by rw [h_danggui_value, h_lingzhiMultiple] -- 代入已求当归产量与题给三倍。
      _ = 4800 := by rfl -- 灵芝收获四千八百千克。
  have h_subtraction_safe : dangguiLess ≤ huangqi * dangguiMultiple := by -- 证明本模型使用自然数减法不会因负数而截断。
    rw [h_dangguiLess, h_huangqi_value, h_dangguiMultiple] -- 将安全条件化成一百不大于八百五十乘二。
    decide -- 一百确实不大于一千七百。
  have h_divisor_positive : 0 < jinyinhua := by -- 证明比较倍数时的除数不是零。
    rw [h_jinyinhua] -- 金银花产量是八百千克。
    decide -- 八百为正。
  have h_division_exact : lingzhi % jinyinhua = 0 := by -- 证明灵芝产量能被金银花产量整除，所以商确为倍数。
    rw [h_lingzhi_value, h_jinyinhua] -- 代入后，内核直接算出四千八百除以八百的余数为零。
  have h_ratio : lingzhi / jinyinhua = 6 := by -- 得到第二问所求的倍数。
    calc -- 使用由模型推出的灵芝产量和题给金银花产量。
      lingzhi / jinyinhua = (1600 * 3) / 800 := by rw [h_lingzhi_value, h_jinyinhua] -- 灵芝为四千八百千克，金银花为八百千克。
      _ = 6 := q4_second_method_lingzhi_first -- 用第二问方法一的完整计算得到六倍。
  have h_multiple : lingzhi = jinyinhua * 6 := by -- 再给出不用除法取整也能直接表达的六倍关系。
    calc -- 通过乘法等式确保六倍是精确关系。
      lingzhi = 4800 := h_lingzhi_value -- 灵芝收获四千八百千克。
      _ = 800 * 6 := by rfl -- 四千八百恰好等于每份八百乘六份。
      _ = jinyinhua * 6 := by rw [h_jinyinhua] -- 每份八百千克正是金银花的产量。
  exact ⟨h_subtraction_safe, h_divisor_positive, h_danggui_value, h_lingzhi_value, h_division_exact, h_ratio, h_multiple⟩ -- 汇总适用条件及两问结论：当归一千六百千克，灵芝是金银花的六倍。

end Workbook.Page03 -- 原书第三页的全部计算方法和应用题数量模型到此结束。

namespace Workbook.Page04 -- 本文件对应练习册物理第十一页、原书第四页。

def q1FirstWorkflow (outside factor upper lower : Nat) : Nat := -- 第一道算式的工作流程，四个输入都是自然数。
  let difference := upper - lower -- 先算小括号里的减法。
  let product := factor * difference -- 再算中括号里的乘法。
  outside + product -- 最后把中括号内的积加到括号外的数上。

theorem q1FirstWorkflow_matches (outside factor upper lower : Nat) : -- 说明分步工作流程与原综合算式完全一致。
    q1FirstWorkflow outside factor upper lower = outside + (factor * (upper - lower)) := by -- 综合式明确规定先减、再乘、最后加。
  rfl -- 展开两个中间量后，两边就是同一个表达式。

theorem q1First_calc : (261 + (170 * (810 - 795)) : Nat) = 2811 := by -- 第一题第一小题，最终结果是二千八百一十一。
  calc -- 依照括号规定的运算顺序逐行脱式。
    (261 + (170 * (810 - 795)) : Nat) = 261 + (170 * 15) := by decide -- 先算小括号，八百一十减七百九十五得十五。
    _ = 261 + 2550 := by decide -- 再算中括号，一百七十乘十五得二千五百五十。
    _ = 2811 := by decide -- 最后计算加法。

theorem q1FirstWorkflow_answer : q1FirstWorkflow 261 170 810 795 = 2811 := by -- 分步执行也得到第一小题的同一答案。
  exact q1First_calc -- 工作流程的定义展开后，直接复用已经逐步证明的综合式。

def q1SecondWorkflow (dividend left right factor : Nat) : Nat := -- 第二道算式把括号内的和与积依次作为中间量。
  let sum := left + right -- 先算小括号内的加法。
  let divisor := sum * factor -- 再算中括号内的乘法，得到整个除数。
  dividend / divisor -- 最后以括号外的数除以整个中括号。

theorem q1SecondWorkflow_matches (dividend left right factor : Nat) : -- 形式化核验第二小题的运算次序。
    q1SecondWorkflow dividend left right factor = dividend / ((left + right) * factor) := by -- 中括号内整个乘积共同作除数。
  rfl -- 逐一定义展开中间量即可。

theorem q1Second_calc : (600 / ((15 + 25) * 5) : Nat) = 3 := by -- 第一题第二小题，商是三。
  calc -- 先加、再乘、最后除。
    (600 / ((15 + 25) * 5) : Nat) = 600 / (40 * 5) := by decide -- 先求十五与二十五的和四十。
    _ = 600 / 200 := by decide -- 再求四十乘五，整个除数是二百。
    _ = 3 := by decide -- 六百除以二百等于三。

theorem q1SecondWorkflow_answer : q1SecondWorkflow 600 15 25 5 = 3 := by -- 分步流程得到同一个商。
  exact q1Second_calc -- 复用已核验的逐行计算。

def q1ThirdWorkflow (outside upper lower divisor : Nat) : Nat := -- 第三道算式依次求差、求商、求积。
  let difference := upper - lower -- 先算小括号中的差。
  let quotient := difference / divisor -- 再把差除以七十一这类括号内的除数。
  outside * quotient -- 最后用括号外的数乘所得的商。

theorem q1ThirdWorkflow_matches (outside upper lower divisor : Nat) : -- 形式化核验第三小题的流程和综合式一致。
    q1ThirdWorkflow outside upper lower divisor = outside * ((upper - lower) / divisor) := by -- 商整体作括号外乘法的一个因数。
  rfl -- 中间量展开后两边相同。

theorem q1Third_calc : (18 * ((358 - 216) / 71) : Nat) = 36 := by -- 第一题第三小题，结果是三十六。
  calc -- 括号内先减后除，最后乘十八。
    (18 * ((358 - 216) / 71) : Nat) = 18 * (142 / 71) := by decide -- 三百五十八减二百一十六得一百四十二。
    _ = 18 * 2 := by decide -- 一百四十二除以七十一得二。
    _ = 36 := by decide -- 十八乘二得三十六。

theorem q1ThirdWorkflow_answer : q1ThirdWorkflow 18 358 216 71 = 36 := by -- 中间量工作流程得到同样的结果。
  exact q1Third_calc -- 应用综合式的已证答案。

theorem q1_natural_number_conditions : -- 检查自然数减法不截断、每个除数非零且实际整除。
    795 ≤ (810 : Nat) ∧ 216 ≤ (358 : Nat) ∧ -- 两个减法中的被减数均不小于减数。
    ((15 + 25) * 5 : Nat) ≠ 0 ∧ (600 % ((15 + 25) * 5) : Nat) = 0 ∧ -- 第二小题用非零除数，余数为零。
    (71 : Nat) ≠ 0 ∧ ((358 - 216) % 71 : Nat) = 0 := by -- 第三小题也没有零作除数或向下取整的问题。
  decide -- 对这些具体不等式与余数等式作精确核验。

def q2FirstWorkflow (minuend addendA addendB divisor multiplier : Nat) : Nat := -- 第二题左表的四道算式依次合并为一个工作流程。
  let first := addendA + addendB -- 对应表中第一步，先求十八与二十四的和。
  let second := first / divisor -- 对应第二步，把所得的和除以六。
  let third := second * multiplier -- 对应第三步，把所得的商乘十五。
  minuend - third -- 对应第四步，用二百减去所得的积。

theorem q2FirstWorkflow_matches (minuend addendA addendB divisor multiplier : Nat) : -- 核验逐层代入而不是改变原有顺序。
    q2FirstWorkflow minuend addendA addendB divisor multiplier = -- 左边保留四步工作流程。
      minuend - (addendA + addendB) / divisor * multiplier := by -- 右边用小括号保证第一步加法优先。
  rfl -- 各中间结果依次代入后就是此综合式。

theorem q2First_calc : (200 - (18 + 24) / 6 * 15 : Nat) = 95 := by -- 第二题左表应合并成这个综合算式。
  calc -- 每一步都保持最后的减法仍在整个乘积之外。
    (200 - (18 + 24) / 6 * 15 : Nat) = 200 - 42 / 6 * 15 := by decide -- 第一步先计算十八加二十四。
    _ = 200 - 7 * 15 := by decide -- 第二步把四十二除以六。
    _ = 200 - 105 := by decide -- 第三步把七乘十五。
    _ = 95 := by decide -- 第四步用二百减去一百零五。

theorem q2FirstWorkflow_answer : q2FirstWorkflow 200 18 24 6 15 = 95 := by -- 表中四步执行完毕所得结果为九十五。
  exact q2First_calc -- 由定义直接连接工作流程与综合式的答案。

def q2SecondWorkflow (minuend innerMinuend dividend divisor multiplier : Nat) : Nat := -- 第二题右表先除、再减、再乘、最后减。
  let first := dividend / divisor -- 第一步计算一百二十除以五。
  let second := innerMinuend - first -- 第二步用三十五减去所得的商。
  let third := second * multiplier -- 第三步把差乘八。
  minuend - third -- 第四步用一百五十减去这个积。

theorem q2SecondWorkflow_matches (minuend innerMinuend dividend divisor multiplier : Nat) : -- 说明右表逐步代入后的括号位置。
    q2SecondWorkflow minuend innerMinuend dividend divisor multiplier = -- 左边是原表的工作流程。
      minuend - (innerMinuend - dividend / divisor) * multiplier := by -- 减法所得的整个差先括起再乘。
  rfl -- 展开四个中间量，直接得到右边的综合式。

theorem q2Second_calc : (150 - (35 - 120 / 5) * 8 : Nat) = 62 := by -- 第二题右表的综合算式及答案。
  calc -- 小括号内先算除法，再算减法。
    (150 - (35 - 120 / 5) * 8 : Nat) = 150 - (35 - 24) * 8 := by decide -- 一百二十除以五得二十四。
    _ = 150 - 11 * 8 := by decide -- 三十五减二十四得十一。
    _ = 150 - 88 := by decide -- 十一乘八得八十八。
    _ = 62 := by decide -- 一百五十减八十八得六十二。

theorem q2SecondWorkflow_answer : q2SecondWorkflow 150 35 120 5 8 = 62 := by -- 右表工作流程与综合算式得到同一答案。
  exact q2Second_calc -- 直接使用逐步计算的已证结果。

theorem q2_natural_number_conditions : -- 排除本题自然数运算中的截断与不整除情况。
    (6 : Nat) ≠ 0 ∧ (5 : Nat) ≠ 0 ∧ ((18 + 24) % 6 : Nat) = 0 ∧ -- 左表的除法整除，而且两个表的除数都非零。
    (120 % 5 : Nat) = 0 ∧ 24 ≤ (35 : Nat) ∧ -- 右表的除法整除，括号内的差非负。
    105 ≤ (200 : Nat) ∧ 88 ≤ (150 : Nat) := by -- 两表最后相减也都得到非负数。
  decide -- 由内核核验所有具体数值条件。

def q3Workflow (boys girls combined : Nat) : Nat := -- 第三题以男生数、女生数和两组总人数为输入。
  let modelGroup := boys + girls -- 航模组人数等于十二名男生加六名女生。
  let artGroup := modelGroup * 2 -- 美术组人数是每份航模组人数乘二份。
  combined / artGroup -- 合唱组和体操组的合计人数除以美术组人数，得到倍数。

theorem q3Workflow_matches (boys girls combined : Nat) : -- 说明题意的中间数量与综合算式一致。
    q3Workflow boys girls combined = combined / ((boys + girls) * 2) := by -- 两个组只使用合计人数，不假设各有一半。
  rfl -- 先代入美术组，再代入航模组的人数定义。

theorem q3_method1 : (108 / ((12 + 6) * 2) : Nat) = 3 := by -- 方法一先求美术组人数，再求倍数。
  calc -- 每个除数都是相应组的实际人数。
    (108 / ((12 + 6) * 2) : Nat) = 108 / (18 * 2) := by decide -- 航模组共有十八人。
    _ = 108 / 36 := by decide -- 美术组人数为十八人乘二份，得三十六人。
    _ = 3 := by decide -- 两组合计一百零八人，是美术组的三倍。

theorem q3_method2 : (108 / (12 + 6) / 2 : Nat) = 3 := by -- 方法二先比较航模组，再把两份航模组换成一份美术组。
  calc -- 连除只是换算份数，未把合唱、体操两组设为人数相等。
    (108 / (12 + 6) / 2 : Nat) = 108 / 18 / 2 := by decide -- 航模组共有十八人。
    _ = 6 / 2 := by decide -- 两组合计人数相当于六份航模组人数。
    _ = 3 := by decide -- 每两份航模组人数是一份美术组人数，所以共有三份。

theorem q3_methods_agree : -- 把两种算法与同一题意工作流程联系起来。
    q3Workflow 12 6 108 = 108 / (12 + 6) / 2 := by -- 左边先求美术组，右边分两次换算份数。
  calc -- 两种具体方法都严格计算为三。
    q3Workflow 12 6 108 = 3 := q3_method1 -- 先求美术组的办法已经证明。
    _ = 108 / (12 + 6) / 2 := q3_method2.symm -- 再把第二种办法的等式反向连接。

theorem q3_model (boys girls modelGroup artGroup choirGroup gymGroup multiple : Nat) -- 所有变量均表示自然数人数或倍数。
    (hBoys : boys = 12) (hGirls : girls = 6) -- 题目给出航模组男生十二人、女生六人。
    (hModel : modelGroup = boys + girls) -- 航模组人数由男女生人数相加得到。
    (hArt : artGroup = modelGroup * 2) -- 美术组人数为每份航模组人数乘二份。
    (hCombined : choirGroup + gymGroup = 108) -- 只给出合唱组与体操组总人数，绝不假设两组各自相等。
    (hMultiple : multiple = (choirGroup + gymGroup) / artGroup) : -- 待求倍数按合计人数除以美术组人数定义，并未预设答案。
    modelGroup = 18 ∧ artGroup = 36 ∧ multiple = 3 ∧ -- 结论给出两个中间人数与最后的倍数。
      choirGroup + gymGroup = artGroup * 3 := by -- 同时证明合计人数恰好是三份美术组人数，避免只依赖整除后的商。
  have hModelValue : modelGroup = 18 := by omega -- 从男女人数和相加关系推出航模组十八人。
  have hArtValue : artGroup = 36 := by omega -- 从航模组十八人及两倍关系推出美术组三十六人。
  have hMultipleValue : multiple = 3 := by -- 根据实际人数关系求待求倍数。
    calc -- 模型中的量先替换成由条件推出的已知值。
      multiple = (choirGroup + gymGroup) / artGroup := hMultiple -- 从待求量的题意定义开始。
      _ = 108 / 36 := by rw [hCombined, hArtValue] -- 仅使用两组合计一百零八人与美术组三十六人。
      _ = 3 := by decide -- 一百零八除以三十六得三。
  have hExactRatio : choirGroup + gymGroup = artGroup * 3 := by omega -- 重新验证人数恰为三倍而没有余数。
  exact ⟨hModelValue, hArtValue, hMultipleValue, hExactRatio⟩ -- 因而所问两组总人数是美术组的三倍。

theorem q3_natural_number_conditions : -- 核验两个方法中的除法都可以按自然数精确执行。
    ((12 + 6) * 2 : Nat) ≠ 0 ∧ (12 + 6 : Nat) ≠ 0 ∧ -- 美术组人数与航模组人数均非零。
    (108 % ((12 + 6) * 2) : Nat) = 0 ∧ -- 第一种方法恰好整除。
    (108 % (12 + 6) : Nat) = 0 ∧ ((108 / (12 + 6)) % 2 : Nat) = 0 := by -- 第二种方法的两步也分别整除。
  decide -- 用余数为零明确排除向下取整造成的假倍数。

def q4Workflow (headphones : Nat) : Nat := -- 第四题以蓝牙耳机单价为输入，价格单位均为元。
  let watch := headphones * 2 + 80 -- 智能手表是耳机价格的两倍再多八十元。
  let priceDifference := watch - headphones -- 原题说的是手表与耳机的差价，先从手表价格减耳机价格。
  priceDifference * 3 - 50 -- 平板电脑比每份差价乘三份的结果少五十元。

theorem q4Workflow_matches (headphones : Nat) : -- 展开价格关系以核验综合算式。
    q4Workflow headphones = ((headphones * 2 + 80) - headphones) * 3 - 50 := by -- 乘三所用的量是差价，绝非两种商品总价。
  rfl -- 将手表价格和差价两个中间量依次代入。

theorem q4_price_difference (headphones : Nat) : -- 方法二先将差价化简成耳机价格加八十元。
    (headphones * 2 + 80) - headphones = headphones + 80 := by -- 两份耳机价格减一份，还剩一份，再保留增加的八十元。
  omega -- 对任意自然数耳机价格证明此线性数量关系。

theorem q4_method2_matches (headphones : Nat) : -- 把差价化简后的算法与原题工作流程连通。
    q4Workflow headphones = (headphones + 80) * 3 - 50 := by -- 新综合式只省去已经抵消的一份耳机价格。
  rw [q4Workflow_matches, q4_price_difference] -- 用两个已证关系完成等价改写。

theorem q4_method1 : (((280 * 2 + 80) - 280) * 3 - 50 : Nat) = 1030 := by -- 方法一先求手表单价、差价，再求平板电脑价格。
  calc -- 所有减法都按原题的差价与少五十元的含义执行。
    (((280 * 2 + 80) - 280) * 3 - 50 : Nat) = ((560 + 80) - 280) * 3 - 50 := by decide -- 先求耳机价格的两倍五百六十元。
    _ = (640 - 280) * 3 - 50 := by decide -- 再加八十元得到手表价格六百四十元。
    _ = 360 * 3 - 50 := by decide -- 手表与耳机差价是三百六十元。
    _ = 1080 - 50 := by decide -- 每份差价三百六十元，三份是一千零八十元。
    _ = 1030 := by decide -- 再少五十元，平板电脑价格为一千零三十元。

theorem q4_method2 : ((280 + 80) * 3 - 50 : Nat) = 1030 := by -- 方法二直接求化简后的差价，再求平板电脑价格。
  calc -- 差价用一份耳机价格加八十元表示。
    ((280 + 80) * 3 - 50 : Nat) = 360 * 3 - 50 := by decide -- 二百八十加八十得三百六十元。
    _ = 1080 - 50 := by decide -- 三百六十元乘三份得一千零八十元。
    _ = 1030 := by decide -- 减去五十元得到一千零三十元。

theorem q4_model (headphones watch priceDifference tablet : Nat) -- 四个变量分别表示耳机、手表、差价、平板电脑价格。
    (hHeadphones : headphones = 280) -- 耳机单价二百八十元是题给已知值。
    (hWatch : watch = headphones * 2 + 80) -- 手表价格比耳机的两倍多八十元。
    (hDifference : priceDifference = watch - headphones) -- 差价由两种商品价格相减得到。
    (hTablet : tablet = priceDifference * 3 - 50) : -- 平板电脑价格由差价的三倍少五十元定义，未将所求答案放入条件。
    watch = 640 ∧ priceDifference = 360 ∧ tablet = 1030 := by -- 从直接题意关系推出中间价格及最终价格。
  have hWatchValue : watch = 640 := by omega -- 先用耳机已知价格求出手表价格。
  have hDifferenceValue : priceDifference = 360 := by omega -- 再按差价关系求出三百六十元。
  have hTabletValue : tablet = 1030 := by omega -- 最后用差价三倍少五十元推出平板电脑价格。
  exact ⟨hWatchValue, hDifferenceValue, hTabletValue⟩ -- 因此答句为平板电脑一千零三十元。

theorem q4_natural_number_conditions : -- 明确本题两个自然数减法都不会触发截断。
    280 ≤ (280 * 2 + 80 : Nat) ∧ 50 ≤ (((280 * 2 + 80) - 280) * 3 : Nat) := by -- 手表不低于耳机，差价的三倍也不少于五十元。
  decide -- 对实际数据核验非负条件。

def q5Workflow (van : Nat) : Nat := -- 第五题各运输量单位均为箱，以面包车每次运量为输入。
  let freight := van * 2 - 3 -- 货车运量比每份面包车运量乘二份少三箱。
  let combined := van + freight -- 先将面包车和货车的每次运量相加。
  combined * 5 - 25 -- 卡车比每份两车合计运量乘五份少二十五箱。

theorem q5Workflow_direct (van : Nat) : -- 保留题目原有中间数量，避免先移括号而忽略自然数减法的界限。
    q5Workflow van = (van + (van * 2 - 3)) * 5 - 25 := by -- 货车先减三箱，再与面包车运量相加。
  rfl -- 直接展开货车与两车合计运量的定义。

theorem q5Workflow_matches (van : Nat) (hEnough : 3 ≤ van * 2) : -- 货车运量非负时，可把三箱从两车合计中扣除。
    q5Workflow van = (van + van * 2 - 3) * 5 - 25 := by -- 此式是方法一采用的综合式。
  change (van + (van * 2 - 3)) * 5 - 25 = (van + van * 2 - 3) * 5 - 25 -- 展开中间量，并把局部定义完全代入。
  omega -- 利用非负条件证明括号移动后值不变。

theorem q5_method2_matches (van : Nat) (hEnough : 3 ≤ van * 2) : -- 方法二先按三份面包车运量算，再把短少部分扣除。
    q5Workflow van = van * 3 * 5 - 3 * 5 - 25 := by -- 每份合计少三箱，五份合计应扣除三箱乘五份。
  change (van + (van * 2 - 3)) * 5 - 25 = van * 3 * 5 - 3 * 5 - 25 -- 把货车与合计运量完整展开成显式自然数算式。
  omega -- 在货车运量非负条件下核验常数倍与自然数减法的等价变换。

theorem q5_method1 : ((15 + 15 * 2 - 3) * 5 - 25 : Nat) = 185 := by -- 方法一依次求货车、两车合计和卡车运量。
  calc -- 按题意先乘，再加减，最后求五倍少二十五箱。
    ((15 + 15 * 2 - 3) * 5 - 25 : Nat) = (15 + 30 - 3) * 5 - 25 := by decide -- 面包车十五箱，取两份是三十箱。
    _ = (45 - 3) * 5 - 25 := by decide -- 面包车与两份面包车运量先合为四十五箱。
    _ = 42 * 5 - 25 := by decide -- 扣除货车少运的三箱，两车合计四十二箱。
    _ = 210 - 25 := by decide -- 每份合计四十二箱，五份是二百一十箱。
    _ = 185 := by decide -- 再少二十五箱，卡车一次能运一百八十五箱。

theorem q5_method2 : (15 * 3 * 5 - 3 * 5 - 25 : Nat) = 185 := by -- 方法二用面包车运量作基准，先按三份放大再补差。
  calc -- 三箱的差额要随五倍一同放大。
    (15 * 3 * 5 - 3 * 5 - 25 : Nat) = 45 * 5 - 15 - 25 := by decide -- 每份十五箱乘三份得四十五箱，每份少三箱乘五份得十五箱。
    _ = 225 - 15 - 25 := by decide -- 四十五箱乘五份得二百二十五箱。
    _ = 210 - 25 := by decide -- 先减放大后的十五箱差额。
    _ = 185 := by decide -- 最后再减二十五箱，得到同样的一百八十五箱。

theorem q5Workflow_answer : q5Workflow 15 = 185 := by -- 将计算过程的最终值连接回题意中的工作流程。
  calc -- 先用经过非负检查的综合式，再用逐步计算的答案。
    q5Workflow 15 = (15 + 15 * 2 - 3) * 5 - 25 := q5Workflow_matches 15 (by decide) -- 三十不少于三，所以综合式可安全使用。
    _ = 185 := q5_method1 -- 引用方法一的完整脱式证明。

theorem q5_model (van freight combined lorry : Nat) -- 变量分别表示面包车、货车、两车合计与卡车每次运量。
    (hVan : van = 15) -- 面包车一次十五箱是题给已知值。
    (hFreight : freight = van * 2 - 3) -- 货车比面包车的两倍少三箱。
    (hCombined : combined = van + freight) -- 两车合计为面包车与货车运量之和。
    (hLorry : lorry = combined * 5 - 25) : -- 卡车比两车合计的五倍少二十五箱，条件未预设最终答案。
    freight = 27 ∧ combined = 42 ∧ lorry = 185 := by -- 从原题关系推出各中间运量和所求卡车运量。
  have hFreightValue : freight = 27 := by omega -- 十五箱的两倍少三箱，货车一次二十七箱。
  have hCombinedValue : combined = 42 := by omega -- 面包车与货车合计一次四十二箱。
  have hLorryValue : lorry = 185 := by omega -- 两车合计的五倍少二十五箱，推出卡车一次一百八十五箱。
  exact ⟨hFreightValue, hCombinedValue, hLorryValue⟩ -- 因此答句为卡车一次能运一百八十五箱。

theorem q5_natural_number_conditions : -- 检查每处减法都确有足够的被减数。
    3 ≤ (15 * 2 : Nat) ∧ 25 ≤ ((15 + (15 * 2 - 3)) * 5 : Nat) ∧ -- 货车减三箱、卡车减二十五箱均不为负。
    (3 * 5 : Nat) ≤ (15 * 3 * 5 : Nat) ∧ -- 方法二先扣放大后的差额也是合法的自然数减法。
    25 ≤ (15 * 3 * 5 - 3 * 5 : Nat) := by -- 方法二最后减二十五箱仍无截断。
  decide -- 所有安全条件均按题目实际数据精确成立。

end Workbook.Page04 -- 原书第四页全部计算、工作流程、题意模型及两种应用题算法证明完毕。
