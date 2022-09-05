# %%

import pygmsh
import gmsh
# %%
mesh_size = 0.1
geom = pygmsh.occ.Geometry()
model3D = geom.__enter__()
box0 =  model3D.add_box([0.0, 0, 0], [1, 1, 1])
# %%
model3D.synchronize()
# %%
model3D.add_physical(box0, "box0")
# %%
geom.generate_mesh(dim=3)
gmsh.write("mesh3D.msh")
# %%
gmsh.write("mesh3D.vtk")

# %%
