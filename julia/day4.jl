using DelimitedFiles

function solution1()
    pairs = readdlm("../files/input4.txt", ',', String)
    overlaps = 0
    for i = 1:size(pairs, 1)
        p = pairs[i, :]
        f1, f2 = parse.(Int, split(p[1], '-'))
        s1, s2 = parse.(Int, split(p[2], '-'))
        if (f1 <= s1 && f2 >= s2) || (s1 <= f1 && s2 >= f2)
            overlaps += 1
        end
    end
    return overlaps
end


function solution2()
    pairs = readdlm("../files/input4.txt", ',', String)
    overlaps = 0
    for i = 1:size(pairs, 1)
        p = pairs[i, :]
        f1, f2 = parse.(Int, split(p[1], '-'))
        s1, s2 = parse.(Int, split(p[2], '-'))
        if (f1 <= s1 <= f2) ||
            (f1 <= s2 <= f2) ||
            (s1 <= f1 <= s2) ||
            (s1 <= f2 <= s2)
            overlaps += 1
        end
    end
    return overlaps
end
