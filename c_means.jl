using Plots
using Random
using Distributions


# data = [randn((1,6)); randn((1,6))]
data =  [2.5 3 3 3.5 5.5 6 6 6.5; 3.5 3 4 3.5 5.5 6 5 5.5]
println(data)

function cluster_centers(partition_table, data)  #  prototype
    s = size(partition_table)
    number_of_rows = s[1]
    entries = s[2]
    V_row = []
    v = []    

    for row_number in 1:number_of_rows
    
        summed_nominator = 0
        summed_denominator = 0
        for entry_number in 1:entries
            summed_denominator += partition_table[row_number, entry_number]
            summed_nominator += data[row_number, entry_number]*partition_table[row_number, entry_number]
        end
        append!(V_row, [summed_nominator/summed_denominator])
    
        append!(v, [V_row])
    end
    println(v)
end

# prototype(patition_table) = v(partition_table)

function sum_square_error()

end

function lagrange_multipliers()

end

function c_means(data, number_of_clusters)
    Uₕ = zeros(Int, number_of_clusters, size(data,2))
    show_partition_matrix(Uₕ)
    Uₕ = init_random(Uₕ)
    show_partition_matrix(Uₕ)
    Vₕ = cluster_centers(Uₕ, data)


end

function euclidian_distances(v1::Vector, v2::Vector)
    if size(v1) == size(v2)
        s = size(v1,1)
        d = zeros((length(v1[1]), s))
        
        for j in 1:length(v2[1])
            for k in 1:length(v1[1])
                summed = 0
                for i in 1:s
                    # println(v1[1], " ", v1[2], " ", v2[1], " ", v2[2])
                    summed += (v1[i][k] - v2[i][j])^2
                end
                d[k, j] = summed
            end
        end
        # println(length(v1[1]))
        return d
    end
end

function update_partition_table(n, data, prototypes)
    partition_table = zeros(Int, n, size(data,2))
    for k in 1:size(partition_table, 1)
        for i in 1:size(partition_table, 2)
            partition_table[i, j] = 1
        end
    end
end

function criterion_function(partition_table)

end

function init_random(partition_table)
    height = length(eachrow(partition_table))
    for (i, _) in enumerate(eachcol(partition_table))
        partition_table[rand(1:height), i] = 1
    end

    for (i, row) in enumerate(eachrow(partition_table))
        if sum(row) == 0
            rand_col = rand(1:size(partition_table, 2))
            partition_table[:, rand_col] .= 0
            partition_table[i, rand_col] = 1
        end
        i = 1
    end
    return partition_table
end

function show_partition_matrix(partition_matrix)
    for (i,y) in enumerate(eachrow(partition_matrix))
        println(y, " Ω", i)
    end
    print(join([join((" x", i)) for i in 1:length(eachcol(partition_matrix))]), "\n")
end

c_means(data, 2)
# scatter(data[1,:], data[2,:])

function euclidian_distances_test()
    v1 = [[2.5,3,3,3.5,5.5,6,6,6.5],[3.5,3,4,3.5,5.5,6,5,5.5]]
    v2 = [[4.25,4.75],[4.25, 4.75]]
    result = euclidian_distances(v1, v2)
    display(result)

end
# euclidian_distances_test()
