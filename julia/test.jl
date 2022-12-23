
function recursive_function(n)
    if n == 0
        return
    else
        local_var = n
        recursive_function(n-1)
        println("Local variable in call $n: $local_var")
    end
end

recursive_function(3)
