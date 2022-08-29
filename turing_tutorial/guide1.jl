# follwing the guide here. 
# https://turing.ml/v0.21/docs/using-turing/guide

# Import packages.
# using Turing
# using StatsPlots

# # Define a simple Normal model with unknown mean and variance.
# @model function gdemo(x, y)
#     s² ~ InverseGamma(2, 3)
#     m ~ Normal(0, sqrt(s²))
#     x ~ Normal(m, sqrt(s²))
#     y ~ Normal(m, sqrt(s²))
# end

# #  Run sampler, collect results.
# c1 = sample(gdemo(1.5, 2), SMC(), 1000)
# c2 = sample(gdemo(1.5, 2), PG(10), 1000)
# c3 = sample(gdemo(1.5, 2), HMC(0.1, 5), 1000)
# c4 = sample(gdemo(1.5, 2), Gibbs(PG(10, :m), HMC(0.1, 5, :s²)), 1000)
# c5 = sample(gdemo(1.5, 2), HMCDA(0.15, 0.65), 1000)
# c6 = sample(gdemo(1.5, 2), NUTS(0.65), 1000)

# # Summarise results
# describe(c3)

# # Plot results
# plot(c3)
# savefig("gdemo-plot2.png")

# Load Distributed to add processes and the @everywhere macro.
    using Distributed

    # Load Turing.
    using Turing
    
    # Add four processes to use for sampling.
    addprocs(4)
    
    # Initialize everything on all the processes.
    # Note: Make sure to do this after you've already loaded Turing,
    #       so each process does not have to precompile.
    #       Parallel sampling may fail silently if you do not do this.
    @everywhere using Turing
    
    # Define a model on all processes.
    @everywhere @model function gdemo(x)
        s² ~ InverseGamma(2, 3)
        m ~ Normal(0, sqrt(s²))
    
        for i in eachindex(x)
            x[i] ~ Normal(m, sqrt(s²))
        end
    end
    
    # Declare the model instance everywhere.
    @everywhere model = gdemo([1.5, 2.0])
    
    # Sample four chains using multiple processes, each with 1000 samples.
    sample(model, NUTS(), MCMCDistributed(), 1000, 4)
    