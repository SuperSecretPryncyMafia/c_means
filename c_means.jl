using Plots
using Random
using Distributions


data = [randn((1,6)); randn((1,6))]
data = [
    2.5 3.0 3.0 3.5 5.5 6.0 6.0 6.5;
    3.5 3.0 4.0 3.5 5.5 6.0 5.0 5.5
]
println(data)

function cluster_centers(partition_table, data)  #  prototype
    V = [[],[]]
    for (i, row) in enumerate(eachrow(partition_table))
        for index in 1:size(data, 1)
            gen = [data[index,j] for j in 1:length(row) if row[j] == 1]
            append!(V[i], mean(gen))
        end

    end
    
    display(V)
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
    d = zeros(size(v1))
    for i in 1:size(v1,1)
        for j in 1:size(v1,2)
            d[i, j] = sqrt((v1[1][j] - v2[1][i]^2 + (v1[2][j] - v2[2][i])^2))
        end
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

