using Distributions
using Random
using CSV
using DataFrames
using Plots


# dataset = CSV.read("data.csv", DataFrame)
# data = Matrix(dataset)'
# display(data)

data = [ 
    0.33 0.00 0.50 0.25 1.00; 
    0.33 0.00 0.50 0.00 0.00
]


function show_partition_matrix(partition_matrix)
    for (i,y) in enumerate(eachrow(partition_matrix))
        println(y, " Ω", i)
    end
    print(join([join((" x", i)) for i in 1:length(eachcol(partition_matrix))]), "\n")
end

# Iₖ(column::Array) = if 1 in column return true else false end

function fuzzy_c_means(data, number_of_clusters, m)

    U = zeros(Float64, number_of_clusters, size(data,2))
    show_partition_matrix(U)
    U = init_partition_matrix(U)
    show_partition_matrix(U)
    V = cluster_centers(U, data, m)
    distances = euclidian_distances(V, data)
    display(distances)
    Iₖ = NaN64

    
end


function init_partition_matrix(partition_table)
    height = length(partition_table[:, 1])
    len = length(partition_table[1, :])

    for col in 1:len
        for row in 1:rand(1:height)
            partition_table[rand(1:height), col] += 1
        end
    end

    for row in 1:height
        if sum(partition_table[row, :]) == 0
            partition_table[row, rand(1:height)] += 1
        end
    end

    for i in 1:len
        col_sum = sum(partition_table[:, i])
        partition_table[:, i] = partition_table[:, i] ./ col_sum
    end

    return partition_table
end

function init_random_partition_matrix(partition_matrix)
    for (k, member) in enumerate(eachcol(partition_matrix))
        resources = 1
        for i in 1:length(member)-1
            value = rand(Uniform(0, resources))
            resources -= value
            partition_matrix[i, k] = value
        end
        partition_matrix[end, k] = resources
    end

    return partition_matrix
end

function cluster_centers(partition_table, data)  #  prototype
    size_of_data = size(data)
    v = zeros(size(partition_table, 1), size_of_data[1])   

    for partition_table_row in 1:size(partition_table, 1)
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
    return rotr90(v)
end


function cluster_centers(partition_table, data, m)  #  prototype
    size_of_data = size(data)
    v = zeros(size(partition_table, 1), size_of_data[1])   

    for partition_table_row in 1:size(partition_table, 1)
        for data_row in 1:size_of_data[1]
            summed_nominator = 0
            summed_denominator = 0
            for entry_number in 1:size_of_data[2]
                fuzzied_pt = (partition_table[partition_table_row, entry_number]^m)
                summed_denominator += fuzzied_pt
                summed_nominator += data[data_row, entry_number]*fuzzied_pt
            end
            v[partition_table_row, data_row] = summed_nominator/summed_denominator
        end     
    end
    display(v) 
    return rotr90(v)
end


function frobenius_norm(m1::Matrix{Int64}, m2::Matrix{Int64})
    summed_first = 0
    summed_second = 0
    for i in 1:size(m1,2)
        for j in 1:size(m2,1)
            summed_first += m1[j,i]^2
            summed_second += m2[j,i]^2
        end
    end
    return sqrt(summed_first) - sqrt(summed_second)
end

function euclidian_distances(v1::Matrix{Float64}, v2::Matrix{Float64})
    v1 = [v1[i, :] for i in 1:size(v1,1)]
    v2 = [v2[i, :] for i in 1:size(v2,1)]
    s = size(v1,1)
    d = zeros((length(v1[1]),length(v2[2])))
    
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

function update_partition_table(partition_table, distances)
    partition_table = zeros(Int, size(partition_table,1), size(partition_table,2))
    for i in 1:size(partition_table, 2) 
        for k in 1:size(partition_table, 1)

        
            data = distances[:, i]
            # println(data, "\t", distances[k, i])
            # println(minimum(data), "\t==\t", data, "\t= ", minimum(data) == (distances[k, i]))
            if minimum(data) == distances[k, i]
                partition_table[k, i] = 1
                break
            end
        end
    end
    display(partition_table)
    return partition_table
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


scatter(data[1, :], data[2, :], legend=false)
fuzzy_c_means(data, 4, 2)
