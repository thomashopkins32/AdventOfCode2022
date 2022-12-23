using Combinatorics
using DataStructures

mutable struct Valve
    name::String
    flow_rate::Int
    connections::Vector{String}
end

function remove!(a, item)
    deleteat!(a, findall(x->x==item, a))
end

function parse_valves()
    lines = readlines("../files/input16.txt")
    valves = Dict{String, Valve}()
    for l in lines
        flow_rate = parse(Int, match(r"\d+", l).match)
        valve_matches = collect(eachmatch(r"[A-Z][A-Z]", l))
        valve_id = valve_matches[1].match
        connections = [String(valve_matches[i].match) for i = 2:length(valve_matches)]
        valves[valve_id] = Valve(valve_id, flow_rate, connections)
    end
    return valves
end

function simulate(valves, current_valve, time_left, open_valves, dp)
    if time_left == 0
        return 0
    end
    key = (current_valve, time_left, open_valves)
    if key in keys(dp)
        return dp[key]
    end
    maximum_payoff = 0
    decisions = copy(valves[current_valve].connections)
    push!(decisions, current_valve)
    for n in decisions
        local payoff = 0
        if n != current_valve || valves[n].flow_rate == 0 # continue to next valve
            payoff = simulate(valves, n, time_left - 1, open_valves, dp)
        elseif !(n in open_valves) # open current valve
            local open = copy(open_valves)
            push!(open, n)
            payoff = time_left * valves[n].flow_rate + simulate(valves, n,
                                                                time_left - 1, open, dp)
        end
        maximum_payoff = max(maximum_payoff, payoff)
    end
    dp[key] = maximum_payoff
    return maximum_payoff
end

function solution1()
    valves = parse_valves()
    dp = Dict()
    return simulate(valves, "AA", 29, Set(), dp)
end

function compute_distances(valves::Dict{String, Valve})
    #= Get distances between all nonzero flow valves =#
    dist = Dict{Tuple{String, String}, Int}((k1, k2) => 10_000_000 for (k1, _) in valves, (k2, _) in valves)
    for (k, v) in valves
        for c in v.connections
            dist[(k, c)] = 1
        end
        dist[(k, k)] = 0
    end
    for (k, v) in valves
        for (k2, v2) in valves
            for (k3, v3) in valves
                if dist[(k2, k3)] > dist[(k2, k)] + dist[(k, k3)]
                    dist[(k2, k3)] = dist[(k2, k)] + dist[(k, k3)]
                end
                if dist[(k3, k2)] > dist[(k, k2)] + dist[(k3, k)]
                    dist[(k3, k2)] = dist[(k, k2)] + dist[(k3, k)]
                end
            end
        end
    end
    return dist
end

function Combinatorics.partitions(dict::Dict{String, Valve}, n::Int)
    return Combinatorics.partitions(collect(dict), n)
end

function path_pressure_release(time_left::Int, nonzero_valves::Dict{String, Valve},
        valves::Dict{String, Valve}, distances::Dict{Tuple{String, String}, Int})
    start = "AA"
    # queue holding the node order and state information
    # this is (Current Node, Time Left, Open Valves, Pressure Released)
    q = Vector{Tuple{String, Int, Set{String}, Int}}()
    push!(q, (start, time_left, Set{String}(), 0))
    max_pressure_release = 0
    while !isempty(q)
        curr = pop!(q) # extract current node
        # no time left, or all nodes visited, compute max path so far
        if curr[2] <= 0 || length(setdiff(keys(nonzero_valves), curr[3])) == 0
            max_pressure_release = max(max_pressure_release, curr[4])
            continue
        end
        for (k, v) in nonzero_valves # all nonzero valves are connected in this graph
            # no reason to stay in the same place or re-visit already opened
            if k == curr || k in curr[3]
                continue
            end
            # otherwise compute payoff of traveling here and add it to the queue
            # (time left - distance traveled - 1) * flow_rate
            #  -1 is time it takes to open the valve
            t = curr[2] - distances[curr[1], k] - 1
            # only add if there is enough time left (need 0 here to do comparison above)
            if t > 0
                payoff = t * v.flow_rate
                push!(q, (k, t, union(curr[3], [k]), curr[4] + payoff))
            else
                push!(q, (k, 0, union(curr[3], [k]), curr[4]))
            end
        end
    end
    return max_pressure_release
end

function solution2()
    valves = parse_valves()
    # compute distances between all pairs of valves
    valves_dist = compute_distances(valves)
    # we only care about moving between nonzero flow rate valves
    nonzero_flows = filter(x -> x[2].flow_rate != 0, valves)
    # partition nonzero valves so no sharing
    max_release = 0
    for (my_valves, el_valves) in Combinatorics.partitions(nonzero_flows, 2)
        # run DFS on each separately
        # we want to maximize the pressure output
        my_release = path_pressure_release(26, Dict(my_valves), valves, valves_dist)
        el_release = path_pressure_release(26, Dict(el_valves), valves, valves_dist)
        total_release = my_release + el_release
        max_release = max(max_release, total_release)
    end
    return max_release
end
