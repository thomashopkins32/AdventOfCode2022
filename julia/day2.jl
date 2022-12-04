using DelimitedFiles

strat_map1 = Dict("A X" => 1 + 3,
                 "A Y" => 2 + 6,
                 "A Z" => 3 + 0,
                 "B X" => 1 + 0,
                 "B Y" => 2 + 3,
                 "B Z" => 3 + 6,
                 "C X" => 1 + 6,
                 "C Y" => 2 + 0,
                 "C Z" => 3 + 3)

strat_map2 = Dict("A X" => 3 + 0,
                  "A Y" => 1 + 3,
                  "A Z" => 2 + 6,
                  "B X" => 1 + 0,
                  "B Y" => 2 + 3,
                  "B Z" => 3 + 6,
                  "C X" => 2 + 0,
                  "C Y" => 3 + 3,
                  "C Z" => 1 + 6)

function solution(strat_map)
    rounds = strip.(readlines("../files/input2.txt"), ['\n'])
    total_score = 0
    for r in rounds
        total_score += strat_map[r]
    end
    return total_score
end
