include("myfunctions.jl")

using MatrixMarket
using GLM
using SparseArrays
using DataFrames
using DelimitedFiles

# Arguments
infile = ARGS[1]
outfile1 = ARGS[2]
outfile2 = ARGS[3]
outfile3 = ARGS[4]
outfile4 = ARGS[5]
outfile5 = ARGS[6]
outfile6 = ARGS[7]
outfile7 = ARGS[8]
is_sparse = ARGS[10]

# Load
data_sparse = MatrixMarket.mmread(infile)
data_sparse = convert(SparseMatrixCSC{Int}, data_sparse)

# Adjcent Matrix
n = size(data_sparse, 2)
adj = trues(n, n)
for i in 1:n
	adj[i, i] = false
end

# GLM
coefs = []
thresholds = []

for i in 1:n
    println("$i / $n")
	# Data Formatting
    X_sp = data_sparse[:, vec(adj[i, :])]
    y = Array(data_sparse[:, i])
	df = DataFrame()
	for i in 1:n-1
	    df[!, Symbol("X$i")] = X_sp[:, i]
	end
	df.Y = y
    # GLM
	formula_str = "Y ~ " * join([Symbol("X$i") for i in 1:n-1], " + ")
	formula = eval(Meta.parse("@formula(" * formula_str * ")"))
    model = fit(GeneralizedLinearModel, formula, df, Binomial(), LogitLink(), verbose=true)
    # Push
    push!(coefs, coef(model)[2:end])
    push!(thresholds, coef(model)[1])
end

# ネットワーク行列の作成
raw_net = zeros(n, n)

for i in 1:n
    raw_net[i, vec(adj[i, :])] = coefs[i]
end

net = (raw_net + raw_net') / 2

# {0,1} => {-1,1}
uniqval = sort(unique(data_sparse))
res = MyFunctionsModule.LinTransform(net, thresholds, from=(0,1), to=(uniqval[1], uniqval[2]))
h = vec(res["thresholds"])
J = res["graph"]

# Allstates (0,1)
Allstates = MyFunctionsModule.generate_combinations([0, 1], size(data_sparse)[2])

# Frequency
Freq = []
for x in 1:size(Allstates, 1)
    count = 0
    for row in 1:size(data_sparse, 1)
        if all(Allstates[x, :] .== data_sparse[row, :])
            count += 1
        end
    end
    push!(Freq, count)
end

# Empirical Probability
P_emp = Freq ./ sum(Freq)

# Allstates (0,1)
Allstates = map(x -> (x .+ 1) .÷ 2, Allstates)

# Hamiltonian
E = [MyFunctionsModule.H(J, s, h) for s in eachrow(Allstates)]

# Estimated Probability
P_est = exp.(-E) ./ sum(exp.(-E))

# Save to files
writedlm(outfile1, Allstates)
writedlm(outfile2, Freq)
writedlm(outfile3, P_emp)
writedlm(outfile4, h)
writedlm(outfile5, J)
writedlm(outfile6, E)
writedlm(outfile7, P_est)
