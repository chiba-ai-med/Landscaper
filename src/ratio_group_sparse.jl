using MatrixMarket
using SparseArrays
using DataFrames
using DelimitedFiles

# Arguments
infile1  = ARGS[1]
infile2  = ARGS[2]
outfile   = ARGS[3]
groupfile = ARGS[4] 
# infile1 = "output_sparse/Allstates.tsv"
# infile2 = "output_sparse/BIN_DATA"
# groupfile = "output_sparse/group.tsv"

# 任意の空白区切りを「タブ連結」に統一（R側の正規化と同等）
normalize_state(s::String) = join(split(strip(s)), '\t')

# Load
Allstates_raw = readlines(infile1)
Allstates     = map(normalize_state, Allstates_raw)   # 例: "-1\t-1\t1"
X = mmread(infile2)                                   # Sparse CSC, N×M
group = strip.(vec(readdlm(groupfile, String)))       # 1列のラベル

# Size / sanity
N, M = size(X)
length(group) == N || error("group の行数($(length(group)))が BIN_DATA($(N)) と一致しない")

# 行は Allstates の順を厳守
state_index = Dict{String,Int}(s => i for (i, s) in enumerate(Allstates))

# 生成: 各行の {-1,1} をタブ連結の文字列へ（例: "-1\t-1\t1"）
state_labels = Vector{String}(undef, N)
for i in 1:N
    if i % 10_000_000 == 0
        println("Building state label $i / $N")
    end
    row_vals = fill("-1", M)
    nzj = findnz(X[i, :])[1]  # 非ゼロ列のインデックス
    @inbounds for j in nzj
        row_vals[j] = "1"
    end
    state_labels[i] = join(row_vals, '\t')
end

# グループ集合（ソート後に全ゼロ列は落とす）
groups_sorted = sort(unique(group))
group_index_all = Dict{String,Int}(g => i for (i, g) in enumerate(groups_sorted))

# 集計 (state × group_all)
state_freq = zeros(Int, length(state_index), length(group_index_all))
for i in 1:N
    if i % 10_000_000 == 0
        println("Counting row $i / $N")
    end
    s = state_labels[i]
    g = group[i]
    haskey(state_index, s) || continue  # Allstatesに無い状態は無視（R同等）
    state_freq[state_index[s], group_index_all[g]] += 1
end

# 列和=0 のグループを除外（R出力に合わせる）
colsum = [sum(@view state_freq[:, j]) for j in 1:size(state_freq, 2)]
nonzero_cols = findall(>(0), colsum)
isempty(nonzero_cols) && error("全グループで列和=0。Allstates と BIN_DATA の整合を確認してください。")
group_names_final = groups_sorted[nonzero_cols]

# 出力（R準拠）
# 先頭行：グループ名のみ（スペース区切り）
# 各行： state(タブを含む文字列) + スペース + 各グループ頻度（スペース区切り）
open(outfile, "w") do io
    write(io, join(group_names_final, " ") * "\n")
    for s in Allstates
        rowidx = state_index[s]
        counts = (string(state_freq[rowidx, group_index_all[g]]) for g in group_names_final)
        write(io, s * " " * join(collect(counts), " ") * "\n")
    end
end