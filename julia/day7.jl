mutable struct Directory 
    name::String
    subdirs::Vector{Directory}
    parent::Union{Nothing, Directory}
    total_size::Int
end

function solution1()
    lines = strip.(readlines("../files/input7.txt"))
    root = Directory("/", [], nothing, 0)
    curr_dir = root
    for (i, l) in enumerate(lines[2:end])
        if '$' == l[1]
            full_cmd = split(l, ' ')
            cmd = full_cmd[2]
            if cmd == "ls"
                continue # skip to next line
            end
            if cmd == "cd"
                arg = full_cmd[3]
                if arg == ".."
                    curr_dir.parent.total_size += curr_dir.total_size
                    curr_dir = curr_dir.parent
                else
                    for d in curr_dir.subdirs
                        if d.name == arg
                            curr_dir = d
                            break
                        end
                    end
                end
            end
        elseif "dir" == l[1:3]
            out_line = split(l, ' ')
            name = out_line[2]
            push!(curr_dir.subdirs, Directory(name, [], curr_dir, 0))
        else
            out_line = split(l, ' ')
            size = parse(Int, out_line[1])
            curr_dir.total_size += size
        end
    end

    # fix for the end
    curr_dir.parent.total_size += curr_dir.total_size


    all_under = []
    queue = [root]
    while length(queue) != 0
        curr = pop!(queue)
        append!(queue, curr.subdirs)
        println("$(curr.name) : $(curr.total_size)")
        if curr.total_size <= 100_000
            push!(all_under, curr.total_size)
        end
    end
    return sum(all_under)
end



    
    
    
