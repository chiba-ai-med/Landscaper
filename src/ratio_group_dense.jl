using DelimitedFiles

# Arguments
infile1  = ARGS[1]
infile2  = ARGS[2]
outfile   = ARGS[3]
groupfile = ARGS[4] 
# infile1 = "output_seurat_beta0/Allstates.tsv"
# infile2 = "output_seurat_beta0/BIN_DATA.tsv"
# groupfile = "output_seurat_beta0/group.tsv"

# 文字列正規化：任意の空白区切りを「タブ連結」に統一（Rの gsub/strsplit 相当）
normalize_state(s::String) = join(split(strip(s)), '\t')

# Load & normalize
Allstates_raw = readlines(infile1)
BIN_raw       = readlines(infile2)

Allstates = map(normalize_state, Allstates_raw)   # 例: "-1\t-1\t1"
state_labels = map(normalize_state, BIN_raw)      # 例: "-1\t-1\t1"

group = strip.(vec(readdlm(groupfile, String)))   # 1列のラベル, 例: "A","B",...

# Sanity
N = length(state_labels)
if length(group) != N
    error("group の行数($(length(group)))が BIN_DATA($(N)) と一致しない")
end

# インデックス
state_index = Dict{String,Int}(s => i for (i, s) in enumerate(Allstates))
groups_sorted = sort(unique(group))
group_index  = Dict{String,Int}(g => i for (i, g) in enumerate(groups_sorted))

# 集計 (state × group)
state_freq = zeros(Int, length(state_index), length(group_index))
for i in 1:N
    s = state_labels[i]
    g = group[i]
    haskey(state_index, s) || continue  # Allstates に無い状態は無視（R同等）
    state_freq[state_index[s], group_index[g]] += 1
end

# 列和=0 のグループを落とす（R出力に合わせる）
nonzero_cols = [j for j in 1:length(groups_sorted) if sum(@view state_freq[:, j]) > 0]
group_names_final = groups_sorted[nonzero_cols]
if isempty(group_names_final)
    error("全グループで列和=0。Allstates と BIN_DATA の整合が取れていない可能性が高い")
end

# 出力
# 先頭行：グループ名のみ（スペース区切り）
# 各行： state(タブを含む文字列) + スペース + 各グループ頻度（スペース区切り）
open(outfile, "w") do io
    write(io, join(group_names_final, " ") * "\n")
    for s in Allstates  # 行順は Allstates の順
        rowidx = state_index[s]
        counts = (string(state_freq[rowidx, group_index[g]]) for g in group_names_final)
        write(io, s * " " * join(collect(counts), " ") * "\n")
    end
end