
# https://gridap.github.io/Tutorials/stable/pages/t003_elasticity/
using Gridap
using GridapGmsh
model = GmshDiscreteModel("mesh3D_v2.msh")


order = 1

reffe = ReferenceFE(lagrangian,VectorValue{3,Float64},order)
V0 = TestFESpace(model,reffe;
  conformity=:H1,
  dirichlet_tags=["surf1","surf2"],
  dirichlet_masks=[(true,false,false), (true,true,true)])
# for i in 1:10
    g1(x) = VectorValue(0.05,0.0,0.0)
    g2(x) = VectorValue(0.0,0.0,0.0)

    U = TrialFESpace(V0,[g1,g2])


    const E = 70.0e9
    const ν = 0.33
    const λ = (E*ν)/((1+ν)*(1-2*ν))
    const μ = E/(2*(1+ν))
    σ(ε) = λ*tr(ε)*one(ε) + 2*μ*ε


    degree = 2*order
    Ω = Triangulation(model)
    dΩ = Measure(Ω,degree)

    a(u,v) = ∫( ε(v) ⊙ (σ∘ε(u)) )*dΩ
    l(v) = 0

    op = AffineFEOperator(a,l,U,V0)
    uh = solve(op)

    writevtk(Ω,"results",cellfields=["uh"=>uh,"epsi"=>ε(uh),"sigma"=>σ∘ε(uh)])
# end
# writevtk(model,"model")
# order = 1
# reffe = ReferenceFE(lagrangian,Float64,order)
# V0 = TestFESpace(model,reffe,dirichlet_tags=["surf1","surf2"])
# g(x) = 2.0
# Ug = TrialFESpace(V0,g)
# degree = 2
# Ω = Triangulation(model)
# dΩ = Measure(Ω,degree)

# # f(x) = 1.0
# # h(x) = 3.0
# a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ
# b(v) = 0 # ∫( v*f )*dΩ + ∫( v*h )*dΓ
# op = AffineFEOperator(a,b,Ug,V0)

# println("Everything run before solve")
# ls = LUSolver()
# solver = LinearFESolver(ls)
# uh = solve(solver,op)
# println("Solve finished. Writing results")
# writevtk(Ω,"my_results1",cellfields=["uh"=>uh])

# U = TrialFESpace(V,[0,1])
# Ω = Triangulation(model)
# dΩ = Measure(Ω,2*order)
# a(u,v) = ∫( ∇(v)⋅∇(u) )dΩ
# l(v) = 0
# op = AffineFEOperator(a,l,U,V)