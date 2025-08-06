using DelimitedFiles

# Arguments
infile1  = ARGS[1]
infile2  = ARGS[2]
outfile   = ARGS[3]
groupfile = ARGS[4] 
# infile1 = "output_seurat_beta0/Allstates.tsv"
# infile2 = "output_seurat_beta0/BIN_DATA.tsv"
# groupfile = "group.txt"

# Load
Allstates = readlines(infile1)  # e.g., "1\t-1"
state_labels = [join(split(line, 't'), '\t') for line in readlines(infile2)]  # Convert to state labels
group = vec(readdlm(groupfile, String))  # Group Vector: N
groups = sort(unique(group))

# Size
N = length(state_labels)

# State Name → Row Index
state_index = Dict(s => i for (i, s) in enumerate(Allstates))
group_index = Dict(g => i for (i, g) in enumerate(groups))

# Step 1: Cross-tabulation (state × group) matrix construction
state_freq = zeros(Int, length(state_index), length(group_index))
for i in 1:N
    if i % 10000000 == 0
        println("Processing row $i of $(size(X, 1))")
    end
    s = state_labels[i]
    g = group[i]
    haskey(state_index, s) || continue
    haskey(group_index, g) || continue
    rowidx = state_index[s]
    colidx = group_index[g]
    state_freq[rowidx, colidx] += 1
end

# Step 2: Post-processing
state_names_sorted = sort(collect(keys(state_index)))  # "-1\t1" など
group_names_sorted = sort(collect(keys(group_index)))  # "A", "B", ...
num_states = length(state_names_sorted)
num_groups = length(group_names_sorted)

# Output Table
table = Matrix{String}(undef, num_states + 1, num_groups + 1)

# Header Row
table[1, 1] = "state"
for j in 1:num_groups
    table[1, j + 1] = group_names_sorted[j]
end

# Data Section
for i in 1:num_states
    s = state_names_sorted[i]
    table[i + 1, 1] = s
    rowidx = state_index[s]
    for j in 1:num_groups
        g = group_names_sorted[j]
        colidx = group_index[g]
        table[i + 1, j + 1] = string(state_freq[rowidx, colidx])
    end
end

# Save
writedlm(outfile, table, '\t')
