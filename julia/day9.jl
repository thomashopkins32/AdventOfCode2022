using DelimitedFiles

function distance(head, tail)
    return sqrt((head[1] - tail[1])^2 + (head[2] - tail[2])^2)
end

function move(head, tail)
    # diagonal movement
    if head[1] > tail[1] && head[2] > tail[2]
        return [1, 1]
    elseif head[1] > tail[1] && head[2] < tail[2]
        return [1, -1]
    elseif head[1] < tail[1] && head[2] > tail[2]
        return [-1, 1]
    elseif head[1] < tail[1] && head[2] < tail[2]
        return [-1, -1]
    # normal movement
    elseif head[1] < tail[1] && head[2] == tail[2]
        return [-1, 0]
    elseif head[1] > tail[1] && head[2] == tail[2]
        return [1, 0]
    elseif head[1] == tail[1] && head[2] < tail[2]
        return [0, -1]
    elseif head[1] == tail[1] && head[2] > tail[2]
        return [0, 1]
    end
    return [0, 0]
end

function solution1()
    directions = readdlm("../files/input9.txt", ' ')
    head = [0, 0]
    tail = [0, 0]
    all_tail_positions = Set{Tuple{Int, Int}}()
    push!(all_tail_positions, (tail[1], tail[2]))
    for i = 1:size(directions, 1)
        d = directions[i, 1]
        amount = directions[i, 2]
        if d == "R"
            idx = 2
            movement = 1
        elseif d == "L"
            idx = 2
            movement = -1
        elseif d == "D"
            idx = 1
            movement = 1
        elseif d == "U"
            idx = 1
            movement = -1
        else
            println("Unknown direction")
        end
        for r = 1:amount
            head[idx] += movement
            dist = distance(head, tail)
            if dist > sqrt(2)
                tail .+= move(head, tail)
                push!(all_tail_positions, (tail[1], tail[2]))
            end
        end
    end
    return length(all_tail_positions)
end

function solution2()
    directions = readdlm("../files/input9.txt", ' ')
    knots = [[0, 0] for i = 1:10]
    all_tail_positions = Set{Tuple{Int, Int}}()
    push!(all_tail_positions, (knots[end][1], knots[end][2]))
    for i = 1:size(directions, 1)
        d = directions[i, 1]
        amount = directions[i, 2]
        if d == "R"
            idx = 2
            movement = 1
        elseif d == "L"
            idx = 2
            movement = -1
        elseif d == "D"
            idx = 1
            movement = 1
        elseif d == "U"
            idx = 1
            movement = -1
        else
            println("Unknown direction")
        end
        for r = 1:amount
            knots[1][idx] += movement
            for j = 2:length(knots)
                dist = distance(knots[j-1], knots[j])
                if dist > sqrt(2)
                    knots[j] .+= move(knots[j-1], knots[j])
                    if j == length(knots)
                        push!(all_tail_positions, (knots[j][1], knots[j][2]))
                    end
                end
            end
        end
    end
    return length(all_tail_positions)
end
