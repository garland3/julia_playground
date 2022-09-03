# Poisson's equation actually. 
# https://gridap.github.io/Tutorials/stable/pages/t001_poisson/
using Gridap
using GridapGmsh
model = GmshDiscreteModel("mesh3D_v2.msh")
writevtk(model,"model")
order = 1
reffe = ReferenceFE(lagrangian,Float64,order)
V0 = TestFESpace(model,reffe,dirichlet_tags=["surf1","surf2"])
g(x) = 2.0
Ug = TrialFESpace(V0,g)
degree = 2
Ω = Triangulation(model)
dΩ = Measure(Ω,degree)

# f(x) = 1.0
# h(x) = 3.0
a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ
b(v) = 0 # ∫( v*f )*dΩ + ∫( v*h )*dΓ
op = AffineFEOperator(a,b,Ug,V0)

println("Everything run before solve")
ls = LUSolver()
solver = LinearFESolver(ls)
uh = solve(solver,op)
println("Solve finished. Writing results")
writevtk(Ω,"my_results1",cellfields=["uh"=>uh])

# U = TrialFESpace(V,[0,1])
# Ω = Triangulation(model)
# dΩ = Measure(Ω,2*order)
# a(u,v) = ∫( ∇(v)⋅∇(u) )dΩ
# l(v) = 0
# op = AffineFEOperator(a,l,U,V)