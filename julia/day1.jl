
function solution1()
    file_as_string = read("../files/input1.txt", String)
    each_elf = split(file_as_string, "\n\n"; keepempty=false)
    each_elf_and_item = split.(each_elf, "\n"; keepempty=false)
    total_cals = sum.(map(x -> parse.(Int, x), each_elf_and_item))
    return max(total_cals...)
end


function solution2()
    file_as_string = read("../files/input1.txt", String)
    each_elf = split(file_as_string, "\n\n"; keepempty=false)
    each_elf_and_item = split.(each_elf, "\n"; keepempty=false)
    total_cals = sum.(map(x -> parse.(Int, x), each_elf_and_item))
    sorted_cals = sort(total_cals; rev=true)
    return sum(sorted_cals[1:3])
end

println("Solution 1: $(solution1())")
println("Solution 2: $(solution2())")


