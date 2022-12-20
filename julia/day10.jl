using DelimitedFiles

function solution1()
    instructions = readdlm("../files/input10.txt", ' ')
    cycle_hist = [1]
    register = 1
    for i = 1:size(instructions, 1)
        instr = instructions[i, 1]
        if instr == "noop"
            append!(cycle_hist, register)
        elseif instr == "addx"
            amount = instructions[i, 2]
            append!(cycle_hist, register)
            append!(cycle_hist, register)
            register += amount
        end
    end
    return sum([c * cycle_hist[c + 1] for c = 20:40:220])
end

function draw!(display, cycle, register)
    offset = cycle % 40
    if register - 1 <= offset <= register + 1
        display[cycle + 1] = '#'
    end
end

function solution2()
    instructions = readdlm("../files/input10.txt", ' ')
    display = collect("." ^ (40 * 6))
    cycle_idx = 0
    register = 1
    for i = 1:size(instructions, 1)
        instr = instructions[i, 1]
        if instr == "noop"
            draw!(display, cycle_idx, register)
            cycle_idx += 1 
        elseif instr == "addx"
            draw!(display, cycle_idx, register)
            cycle_idx += 1 
            draw!(display, cycle_idx, register)
            cycle_idx += 1 
            amount = instructions[i, 2]
            register += amount
        end
    end
    for i = 1:40:40 * 6
        println(join(display[i:i + 39]))
    end
end
