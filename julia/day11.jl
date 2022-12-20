mutable struct Monkey
    items::Vector{Int}
    operation::Function
    test_func::Function
    div::Int
    true_friend::Int
    false_friend::Int
end

isintstring(str) = all(isdigit(c) for c in str)

function read_monkeys()
    monkey_descriptions = split(read("../files/input11.txt", String), "\n\n")
    monkeys = []
    for md in monkey_descriptions
        steps = split(md, "\n")
        starting_items = parse.(Int, split(split(steps[2], ": ")[2], ", "))
        operation_text = split(steps[3], " = ")[2]
        test_num = parse(Int, split(steps[4], " ")[end])
        if '*' in operation_text
            vars = split(operation_text, " * ")
            # only rhs can be a number
            if isintstring(vars[2])
                rhs = parse(Int, vars[2])
                operation = x -> x * rhs
            else
                operation = x -> x * x
            end
        else
            vars = split(operation_text, " + ")
            # only rhs can be a number
            if isintstring(vars[2])
                rhs = parse(Int, vars[2])
                operation = x -> x + rhs
            else
                operation = x -> x + x
            end
        end
        div = test_num
        test_func = x -> x % test_num == 0
        true_friend = parse(Int, split(steps[5], " ")[end])
        false_friend = parse(Int, split(steps[6], " ")[end])
        push!(monkeys, Monkey(starting_items, operation, test_func, div,
                              true_friend, false_friend))
    end
    return monkeys
end
    
function solution1()
    monkeys = read_monkeys()
    num_inspected = [0 for i = 1:length(monkeys)]
    for r = 1:20
        for (j, m) in enumerate(monkeys)
            num_inspected[j] += length(m.items)
            for i = 1:length(m.items)
                item_worry_level = popfirst!(m.items)
                worry_level = div(m.operation(item_worry_level), 3)
                if m.test_func(worry_level)
                    push!(monkeys[m.true_friend + 1].items, worry_level)
                else
                    push!(monkeys[m.false_friend + 1].items, worry_level)
                end
            end
        end
    end
    sorted_nums = sort(num_inspected, rev=true)
    return sorted_nums[1] * sorted_nums[2]
end

function solution2()
    monkeys = read_monkeys()
    lcm_divisors = lcm([m.div for m in monkeys]...)
    num_inspected = [0 for i = 1:length(monkeys)]
    for r = 1:10000
        for (j, m) in enumerate(monkeys)
            num_inspected[j] += length(m.items)
            for i = 1:length(m.items)
                item_worry_level = popfirst!(m.items)
                worry_level = m.operation(item_worry_level) % lcm_divisors
                if m.test_func(worry_level)
                    push!(monkeys[m.true_friend + 1].items, worry_level)
                else
                    push!(monkeys[m.false_friend + 1].items, worry_level)
                end
            end
        end
    end
    sorted_nums = sort(num_inspected, rev=true)
    return sorted_nums[1] * sorted_nums[2]
end
