function decide_order(left, right)
    idx = 1
    right_order = false
    while true
        # end of the line for both at the same time
        if idx > length(left) && idx > length(right)
            return false, true
        end
        # left side ends first
        if idx > length(left) && idx <= length(right)
            return true, true
        end
        # right side ends first
        if idx <= length(left) && idx > length(right)
            return true, false
        end
        # compare two integer values
        if typeof(left[idx]) == Int && typeof(right[idx]) == Int
            if left[idx] < right[idx]
                return true, true
            elseif right[idx] < left[idx]
                return true, false
            end
        # one value is an integer
        elseif typeof(left[idx]) == Int
            exit, right_order = decide_order([left[idx]], right[idx])
            if exit
                return true, right_order
            end
        elseif typeof(right[idx]) == Int
            exit, right_order = decide_order(left[idx], [right[idx]])
            if exit
                return true, right_order
            end
        else
            # both values are lists (recursion)
            exit, right_order = decide_order(left[idx], right[idx])
            if exit
                return true, right_order
            end
        end
        idx += 1
    end
    return true, true
end


function solution1()
    groups = split.(read("../files/input13.txt", String), "\n\n")
    pairs_str = split.(groups, "\n"; keepempty=false)
    pairs = [eval.(Meta.parse.(n)) for n in pairs_str]

    sum_right_order = 0
    for (p, (left, right)) in enumerate(pairs)
        _, right_order = decide_order(left, right)
        if right_order
            sum_right_order += p
        end
    end

    return sum_right_order
end
    
function solution2()
    all = split.(read("../files/input13.txt", String), "\n"; keepempty=false)
    packets = [eval.(Meta.parse.(n)) for n in all]
    push!(packets, [[2]])
    push!(packets, [[6]])

    sort!(packets; lt= (x, y) -> decide_order(x, y)[2])

    divider2 = findall(x -> x == [[2]], packets)[1]
    divider6 = findall(x -> x == [[6]], packets)[1]

    return divider2 * divider6
end
    
