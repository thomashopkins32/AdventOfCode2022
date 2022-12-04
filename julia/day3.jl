
char_list = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
char_priority = Dict(char_list[i] => i for i = 1:length(char_list))

function solution1()
    rucksacks = strip.(readlines("../files/input3.txt"), '\n')
    total = 0
    for sack in rucksacks
        split_point = Int(length(sack) // 2)
        common_char = pop!(intersect(Set(SubString(sack, 1:split_point)),
                                     Set(SubString(sack, split_point + 1:length(sack)))))
        total += char_priority[common_char]
    end
    return total
end

function solution2()
    rucksacks = strip.(readlines("../files/input3.txt"), '\n')
    groups = [rucksacks[i:i+2] for i = 1:3:size(rucksacks, 1)]
    total = 0
    for g in groups
        common_char = pop!(intersect(Set(g[1]),
                                     Set(g[2]),
                                     Set(g[3])))
        total += char_priority[common_char]
    end
    return total
end
