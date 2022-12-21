using DelimitedFiles
using DataStructures

alphabet = "SabcdefghijklmnopqrstuvwxyzE"
positions = Dict(a => i for (i, a) in enumerate(alphabet))

function alphabet_distance(c1, c2) 
    return positions[c2] - positions[c1]
end

function get_neighbors(idx, grid)
    neighbors = []
    i, j = idx[1], idx[2]
    max_i, max_j = size(grid)
    if i - 1 > 0 && alphabet_distance(grid[idx], grid[i - 1, j]) <= 1
        push!(neighbors, CartesianIndex(i - 1, j))
    end
    if j - 1 > 0 && alphabet_distance(grid[idx], grid[i, j - 1]) <= 1
        push!(neighbors, CartesianIndex(i, j - 1))
    end
    if i < max_i && alphabet_distance(grid[idx], grid[i + 1, j]) <= 1
        push!(neighbors, CartesianIndex(i + 1, j))
    end
    if j < max_j && alphabet_distance(grid[idx], grid[i, j + 1]) <= 1
        push!(neighbors, CartesianIndex(i, j + 1))
    end
    return neighbors
end

function solution1()
    grid::Matrix{Char} = permutedims(hcat(collect.(readlines("../files/input12.txt"))...))
    start = findall(x -> x == 'S', grid)[1]
    pq = PriorityQueue{CartesianIndex, Int}()
    distances = Dict()
    previous = Dict()

    for v in CartesianIndices(grid)
        distances[v] = typemax(Int64)
        previous[v] = nothing
    end
    distances[start] = 0
    enqueue!(pq, start, distances[start])
    done = false
    while length(pq) > 0
        u = dequeue!(pq)
        for v in get_neighbors(u, grid)
            alt = distances[u] + 1
            if alt < distances[v]
                distances[v] = alt
                previous[v] = u
                enqueue!(pq, v, distances[v])
            end
            if grid[v] == 'E'
                done = true
                break
            end
        end
        if done
            break
        end
    end

    # traceback along previous
    steps = 1
    curr = findall(x -> x == 'E', grid)[1]
    while previous[curr] != start
        curr = previous[curr]
        steps += 1
    end

    return steps
end

function solution2()
    grid::Matrix{Char} = permutedims(hcat(collect.(readlines("../files/input12.txt"))...))
    start = findall(x -> x == 'a', grid)
    pq = PriorityQueue{CartesianIndex, Int}()
    distances = Dict()
    previous = Dict()

    for v in CartesianIndices(grid)
        distances[v] = typemax(Int64)
        previous[v] = nothing
    end
    for v in start
        distances[v] = 0
        enqueue!(pq, v, distances[v])
    end
    done = false
    while length(pq) > 0
        u = dequeue!(pq)
        for v in get_neighbors(u, grid)
            alt = distances[u] + 1
            if alt < distances[v]
                distances[v] = alt
                previous[v] = u
                enqueue!(pq, v, distances[v])
            end
            if grid[v] == 'E'
                done = true
                break
            end
        end
        if done
            break
        end
    end

    # traceback along previous
    steps = 1
    curr = findall(x -> x == 'E', grid)[1]
    while !(previous[curr] in start)
        curr = previous[curr]
        steps += 1
    end

    return steps
end
