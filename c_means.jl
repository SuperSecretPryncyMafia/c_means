using Plots
using Random
using Distributions


# data = [randn((1,6)); randn((1,6))]
data =  [2.5 3 3 3.5 5.5 6 6 6.5; 3.5 3 4 3.5 5.5 6 5 5.5]
println(data)

function cluster_centers(partition_table, data)  #  prototype
    
    size_of_data = size(data)
    v = zeros(size_of_data[1], size_of_data[1])   

    for partition_table_row in 1:size_of_data[1]
        for data_row in 1:size_of_data[1]
            summed_nominator = 0
            summed_denominator = 0
            for entry_number in 1:size_of_data[2]
                summed_denominator += partition_table[partition_table_row, entry_number]
                summed_nominator += data[data_row, entry_number]*partition_table[partition_table_row, entry_number]
            end
            v[partition_table_row, data_row] = summed_nominator/summed_denominator
        end     
    end
    display(v) 
    return reverse(rotr90(v))
end

# prototype(patition_table) = v(partition_table)

function sum_square_error()

end

function lagrange_multipliers()

end

function c_means(data, number_of_clusters)
    J = [Inf]
    ϵ = 5
    Uₕ = zeros(Int, number_of_clusters, size(data,2))
    show_partition_matrix(Uₕ)
    Uₕ = init_random(Uₕ)
    show_partition_matrix(Uₕ)
    Vₕ = cluster_centers(Uₕ, data)
    d = euclidian_distances(data, Vₕ)
    println(d)
    append!(J, [criterion_function(Uₕ, d)])
    println(J)
    while minimum(J) > ϵ
        Uₕ = zeros(Int, number_of_clusters, size(data,2))
        show_partition_matrix(Uₕ)
        Uₕ = init_random(Uₕ)
        show_partition_matrix(Uₕ)
        Vₕ = cluster_centers(Uₕ, data)
        d = euclidian_distances(data, Vₕ)
        println(d)
        append!(J, [criterion_function(Uₕ, d)])
        println(J)
    end
    println(Uₕ, "\n", Vₕ, "\n", d)
end

function euclidian_distances(v1::Matrix{Float64}, v2::Matrix{Float64})
    v1 = [v1[i, :] for i in 1:size(v1,1)]
    v2 = [v2[i, :] for i in 1:size(v2,1)]
    s = size(v1,1)
    d = zeros((length(v1[1]),s,))
    
    for j in 1:length(v2[2])
        for k in 1:length(v1[1])
            summed = 0
            for i in 1:s
                # println(v1[1], " ", v1[2], " ", v2[1], " ", v2[2])
                summed += (v1[i][k] - v2[i][j])^2
            end
            d[ k, j] = summed
        end
    end
    # println(length(v1[1]))
    display(d)
    return d'

end

function euclidian_distances(v1::Vector, v2)
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
    display(d)
    return d'
end

function update_partition_table(partition_table, distances)
    partition_table = zeros(Int, n, size(data,2))
    for k in 1:size(partition_table, 1)
        for i in 1:size(partition_table, 2)
            partition_table[i, j] = 1
        end
    end
end

function criterion_function(partition_table, distances)
    J = 0
    for column in 1:size(partition_table,2)
        for row in 1:size(partition_table,1)
            J += partition_table[row, column]*distances[row, column]
        end
    end
    return J
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

#c_means(data,2)
# scatter(data[1,:], data[2,:])

function euclidian_distances_test()
    v1 = [2.5 3 3 3.5 5.5 6 6 6.5;3.5 3 4 3.5 5.5 6 5 5.5]
    v2 = [4.25 4.75;4.25 4.75]
    result = euclidian_distances(v1, v2)

    display(result)

end

function test_cluster_centers()
    v1 = [2.5 3 3 3.5 5.5 6 6 6.5;3.5 3 4 3.5 5.5 6 5 5.5]
    pt = [0 0 0 0 1 1 1 1 ;1 1 1 1 0 0 0 0]
    result = cluster_centers(pt, v1)
    display(result)
end

function test_criterion_function()
    J = [Inf]
    data = [2.5 3 3 3.5 5.5 6 6 6.5;3.5 3 4 3.5 5.5 6 5 5.5]
    Uₕ = [1 1 0 0 1 0 1 0; 0 0 1 1 0 1 0 1]
    show_partition_matrix(Uₕ)
    # Uₕ = init_random(Uₕ)
    # show_partition_matrix(Uₕ)
    Vₕ = cluster_centers(Uₕ, data)
    display(Vₕ)
    d = euclidian_distances(data, Vₕ)
    display(d)
    append!(J, [criterion_function(Uₕ, d)])
    println(J)
end


euclidian_distances_test()
test_cluster_centers()
test_criterion_function()