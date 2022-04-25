using Plots
cₜ = 5
cₛ = 0:0.1:1
# r = (cₛ/cₜ)^2
r = (cₛ./cₜ).^2
plot(cₛ,r)