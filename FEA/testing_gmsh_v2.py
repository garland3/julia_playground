# %%
import os
import pygmsh
import gmsh
# %%
# mesh_size = 0.4
w = 1
h = 1
length = 5
mesh_relative_size = 0.1 # 1e-2
gmsh.initialize()
gmsh.model.add("t1")

# geom = pygmsh.occ.Geometry()
# model3D = geom.__enter__()
# box0 =  model3D.add_box([0.0, 0, 0], [1, 1, 1])
# # %%
# # %%
# model3D.add_physical(box0, "box0")


# MAKE 4 points
p1 = gmsh.model.geo.addPoint(0, 0, 0, mesh_relative_size)
p2 = gmsh.model.geo.addPoint(w, 0, 0, mesh_relative_size)
p3 = gmsh.model.geo.addPoint(w, h, 0, mesh_relative_size)
p4 = gmsh.model.geo.addPoint(0, h, 0, mesh_relative_size)

# MAKE 4 lines
line1 = gmsh.model.geo.addLine(p1, p2, -1)
line2 = gmsh.model.geo.addLine(p2, p3, -1)
line3 = gmsh.model.geo.addLine(p3, p4, -1)
line4 = gmsh.model.geo.addLine(p4, p1, -1)

# MAKE a LOOP from the lines
loop1 = gmsh.model.geo.addCurveLoop([line1, line2,line3,line4], -1)
# MAKE a PLANE from the loop
surf1 = gmsh.model.geo.addPlaneSurface([loop1])
print(f"surf1 is {surf1}")
gmsh.model.addPhysicalGroup(2, [surf1], name = "surf1")


# gmsh.model.geo.

# The 2 means it is of dim 2,
# points = 0
# lines = 1
# surf = 2
ov2 = gmsh.model.geo.extrude([(2,surf1)], 0, 0, length)
gmsh.model.geo.synchronize()

print(f"return from extrude is {ov2}")
for item in ov2:
    print(f"Extrude return item {item}")
    dim, tag = item
    if dim == 2:
        bb =gmsh.model.getBoundingBox(dim,tag)
        print(f"\tbounding box is {bb}")
        z_point1 = bb[2]
        z_point2 = bb[5]
        if z_point1 == z_point2:
            print("found far surf")
            gmsh.model.addPhysicalGroup(2, [tag], name = "surf2")
    if dim ==3:
        print(f"Found volume tag {tag}")
        volume_tag = tag
        gmsh.model.addPhysicalGroup(3, [volume_tag], name = "vol1")


    # gmsh.model.getParent

gmsh.model.geo.synchronize()
gmsh.option.setNumber("Mesh.SaveAll", 1)

# model3D.synchronize()
# gmsh.model.geo.mesh()
# gmsh.model.mesh.set
gmsh.model.mesh.generate(3)



# %%
# geom.generate_mesh(dim=3)

name = "mesh3D_v2.msh"
os.unlink(name)
gmsh.write(name)
# %%
gmsh.write("mesh3D_v2.vtk")

# %%
gmsh.finalize()

# %%
