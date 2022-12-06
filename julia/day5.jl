function read_board(lines)
    offsets = Dict(2 + i * 4 => i + 1  for i = 0:8)
    stacks = [[] for i = 1:9]
    for l in lines
        for i = 2:4:2 + 4 * 8
            if i > length(l)
                break
            end
            if isletter(l[i])
                pushfirst!(stacks[offsets[i]], l[i])
            end
        end
    end
    return stacks
end

function solution1()
    lines = strip.(readlines("../files/input5.txt"))
    stacks = read_board(lines[1:9])
    directions = split.(lines[11:end], ' ')
    for d in directions
        amount = parse(Int, d[2])
        from = parse(Int, d[4])
        to = parse(Int, d[6])
        stack_size = length(stacks[from])
        for _ = 1:amount 
            to_place = pop!(stacks[from])
            append!(stacks[to], to_place)
        end
    end
    soln = join([pop!(s) for s in stacks], "")
    return soln
end
    
function solution2()
    lines = strip.(readlines("../files/input5.txt"))
    stacks = read_board(lines[1:9])
    directions = split.(lines[11:end], ' ')
    for d in directions
        amount = parse(Int, d[2])
        from = parse(Int, d[4])
        to = parse(Int, d[6])
        stack_size = length(stacks[from])
        to_place = []
        for _ = 1:amount 
            c = pop!(stacks[from])
            pushfirst!(to_place, c)
        end
        append!(stacks[to], to_place)
    end
    soln = join([pop!(s) for s in stacks], "")
    return soln
end
