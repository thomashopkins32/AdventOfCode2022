
function solution(marker)
    buffer = read("../files/input6.txt", String)
    current_chars = []
    for (i, c) in enumerate(buffer)
        if length(current_chars) < marker
            append!(current_chars, c)
        else
            popfirst!(current_chars)
            append!(current_chars, c)
            if length(Set(current_chars)) == marker
                return i
            end
        end
    end
    return -1
end