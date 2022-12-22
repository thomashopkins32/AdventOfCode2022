
function draw(board, filename)
    open(filename, "w") do file
        for l in eachrow(board)
            write(file, "$(join(l))\n")
        end
    end
end

function draw_line(board, start, finish)
    offset = 299
    sx, sy = start
    fx, fy = finish
    if sx == fx # draw vertical line down
        if sy <= fy
            while sy <= fy
                board[sy + 1, sx-offset] = '#'
                sy += 1
            end
        else
            while fy <= sy
                board[fy + 1, sx-offset] = '#'
                fy += 1
            end
        end
    end
    if sy == fy # draw horizontal line right
        if sx <= fx
            while sx <= fx
                board[sy + 1, sx-offset] = '#'
                sx += 1
            end
        else
            while fx <= sx
                board[sy + 1, fx-offset] = '#'
                fx += 1
            end
        end
    end
end

function create_board(; add_line=false)
    paths = split.(readlines("../files/input14.txt"), " -> ")
    paths = [split.(path, ",") for path in paths]
    paths = [[parse.(Int, p) for p in pts] for pts in paths]

    board::Matrix{Char} = ['.' for i = 1:200, j = 300:900]
    max_y = typemin(Int)
    for path in paths
        for i = 2:length(path)
            max_y = max(max_y, path[i-1][2] + 1, path[i][2] + 1)
            draw_line(board, path[i-1], path[i])
        end
    end
    board[1, 500 - 299] = '+'
    if add_line
        board[max_y + 2, :] .= '#'
    end
    return board
end

function solution1()
    board = create_board()
    offset = 299
    # simulate falling sand
    falls_off_board = false
    while !falls_off_board
        curr = [1, 500 - offset]
        while true
            if curr[1] + 1 > size(board, 1)
                falls_off_board = true
                break
            end
            if board[curr[1] + 1, curr[2]] == '.'
                curr[1] += 1
            elseif board[curr[1] + 1, curr[2] - 1] == '.'
                curr[1] += 1
                curr[2] -= 1
            elseif board[curr[1] + 1, curr[2] + 1] == '.'
                curr[1] += 1
                curr[2] += 1
            else
                board[curr[1], curr[2]] = 'O'
                break
            end
        end
    end
    draw(board, "out13-1.txt")
    return count(board .== 'O')
end


function solution2()
    board = create_board(; add_line=true)
    offset = 299
    # simulate falling sand
    plugs_source = false
    while !plugs_source
        curr = [1, 500 - offset]
        while true
            if board[curr[1] + 1, curr[2]] == '.'
                curr[1] += 1
            elseif board[curr[1] + 1, curr[2] - 1] == '.'
                curr[1] += 1
                curr[2] -= 1
            elseif board[curr[1] + 1, curr[2] + 1] == '.'
                curr[1] += 1
                curr[2] += 1
            else
                if curr[1] == 1 && curr[2] == 500 - offset
                    plugs_source = true
                end
                board[curr[1], curr[2]] = 'O'
                break
            end
        end
    end
    draw(board, "out13-2.txt")
    return count(board .== 'O')
end

