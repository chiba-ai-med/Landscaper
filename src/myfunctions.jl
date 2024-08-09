module MyFunctionsModule

using LinearAlgebra  # 行列操作のためのモジュール

export H, generate_combinations, LinTransform

# IsingSampler:::H
function H(J::Matrix{Float64}, s::SubArray{Int64}, h::Vector{T}) where T
    res = 0.0
    N = size(J, 1)

    for i in 1:N
        res -= h[i] * s[i]
        for j in i:N
            if j != i
                res -= J[i, j] * s[i] * s[j]
            end
        end
    end

    return res
end

# 全組み合わせを生成する関数
function generate_combinations(vals, len)
    combinations = Array{Int, 2}(undef, 2^len, len)
    i = 1
    for comb in Iterators.product(ntuple(_ -> vals, len)...)
        combinations[i, :] = collect(comb)
        i += 1
    end
    return combinations
end

function LinTransform(graph::AbstractMatrix, thresholds::AbstractVector; from::Tuple{Int,Int} = (0, 1), to::Tuple{Int,Int} = (-1, 1), a::Union{Nothing, Float64} = nothing, b::Union{Nothing, Float64} = nothing)

    # 引数のチェック
    @assert !isempty(graph) && !isempty(thresholds)

    # aとbのデフォルト値設定
    if isnothing(a) && isnothing(b)
        a = (to[1] - to[2]) / (from[1] - from[2])
        b = to[1] - a * from[1]
    end

    # 対角成分を0に設定
    for i in 1:size(graph, 1)
        graph[i, i] = 0
    end

    # 新しい graph と thresholds を計算
    new_graph = graph / (a^2)
    new_thresholds = thresholds / a - (b * sum(graph, dims=2))[:, 1] / (a^2)

    return Dict(
        "graph" => new_graph,
        "thresholds" => new_thresholds
    )

end

end