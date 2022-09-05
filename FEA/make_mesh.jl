### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 94e8e986-2b2f-11ed-219e-a124aed9d763
# import gmsh
import Gmsh: gmsh
# import Pkg; Pkg.add("gmsh")

# ╔═╡ 5ebaade9-e3b1-44f3-a17e-369833313100
begin
	w = 1
	h = 1
	length = 5
	mesh_relative_size = 0.1 # 1e-2
end

# ╔═╡ 4a7a9347-1026-403f-891d-517b0210549a
gmsh.initialize()

# ╔═╡ 5b09eab2-685e-4934-ac71-4edd2f230a8c
gmsh.model.add("t1")


# ╔═╡ 9768883a-ddfe-4df4-988e-9ac7adee04df
md"""
MAKE 4 points

"""

# ╔═╡ 04240b0a-4411-4101-b562-61fbbb1ab95a
begin
	p1 = gmsh.model.geo.addPoint(0, 0, 0, mesh_relative_size)
	p2 = gmsh.model.geo.addPoint(w, 0, 0, mesh_relative_size)
	p3 = gmsh.model.geo.addPoint(w, h, 0, mesh_relative_size)
	p4 = gmsh.model.geo.addPoint(0, h, 0, mesh_relative_size)
end

# ╔═╡ 183cca3c-e643-4a81-9f78-25c337601c4f
md"""
MAKE 4 lines

"""

# ╔═╡ 8dd4f1d7-7161-48fc-859e-824766237326
begin
	line1 = gmsh.model.geo.addLine(p1, p2, -1)
	line2 = gmsh.model.geo.addLine(p2, p3, -1)
	line3 = gmsh.model.geo.addLine(p3, p4, -1)
	line4 = gmsh.model.geo.addLine(p4, p1, -1)
end

# ╔═╡ a7235b45-22f1-4ddb-8312-3d76170b8da2
begin
	# MAKE a LOOP from the lines
	loop1 = gmsh.model.geo.addCurveLoop([line1, line2,line3,line4], -1)
	# MAKE a PLANE from the loop
	surf1 = gmsh.model.geo.addPlaneSurface([loop1])
end

# ╔═╡ 19a82a18-46f6-46b6-a265-1629f5163d43
tag = gmsh.model.addPhysicalGroup(2, [surf1])


# ╔═╡ ea8d2863-279b-4295-8213-adc5f123637d
gmsh.model.setPhysicalName(2, tag, "surf1")

# ╔═╡ 56ead786-a3cd-44e9-8e73-d43ddeec7919
begin
	extrude_items = gmsh.model.geo.extrude([(2,surf1)], 0, 0, length)
	gmsh.model.geo.synchronize()
end

# ╔═╡ b52ac9ab-3122-4131-b8c8-34bd381ed69b
extrude_items

# ╔═╡ 4dcb6868-d4fa-47e5-bee3-c3646ec991d5
for item in extrude_items
	println(item)
	 dim, tag = item
	if dim ==2
		bb =gmsh.model.getBoundingBox(dim,tag)
        println("\tbounding box is $bb")
		 z_point1 = bb[3]
        z_point2 = bb[6]
        if z_point1 == z_point2
 			println("found far surf")
            grouptag = gmsh.model.addPhysicalGroup(2, [tag])
			gmsh.model.setPhysicalName(2, grouptag, "surf2")
			
		end
	elseif dim ==3
		println("Found volume tag $tag")
        volume_tag = tag
		grouptag = gmsh.model.addPhysicalGroup(3, [tag])
		gmsh.model.setPhysicalName(3, grouptag, "vol1")

	end
end

# ╔═╡ 50e66b87-9630-43d3-920d-76ebaf2e2157
begin
	gmsh.model.geo.synchronize()
	gmsh.option.setNumber("Mesh.SaveAll", 1)
end

# ╔═╡ 9f9650ea-2fa8-4ee5-8332-6d2ffed2ca3b
gmsh.model.mesh.generate(3)

# ╔═╡ c3c61e5d-c8a2-4a06-96a5-e4d61c643e9d
begin
	
	name = "mesh3D_v2.msh"
	# os.unlink(name)
	gmsh.write(name)
	# %%
	gmsh.write("mesh3D_v2.vtk")
	
	# %%
	gmsh.finalize()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Gmsh = "705231aa-382f-11e9-3f0c-b7cb4346fdeb"

[compat]
Gmsh = "~0.2.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "72d64cecc76bc5841e61b1d7c17c3742d21bf1e4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FLTK_jll]]
deps = ["Artifacts", "Fontconfig_jll", "FreeType2_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "Xorg_libXft_jll", "Xorg_libXinerama_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "72a4842f93e734f378cf381dae2ca4542f019d23"
uuid = "4fce6fc7-ba6a-5f4c-898f-77e99806d6f8"
version = "1.3.8+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.GLU_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg"]
git-tree-sha1 = "65af046f4221e27fb79b28b6ca89dd1d12bc5ec7"
uuid = "bd17208b-e95e-5925-bf81-e2f59b3e5c61"
version = "9.0.1+0"

[[deps.GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"
version = "6.2.1+2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Gmsh]]
deps = ["Reexport", "gmsh_jll"]
git-tree-sha1 = "16a612f79cf8025dd117c094ca8a2f769714705c"
uuid = "705231aa-382f-11e9-3f0c-b7cb4346fdeb"
version = "0.2.0"

[[deps.HDF5_jll]]
deps = ["Artifacts", "JLLWrappers", "LibCURL_jll", "Libdl", "OpenSSL_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "c003b31e2e818bc512b0ff99d7dce03b0c1359f5"
uuid = "0234f1f7-429e-5d53-9886-15a909be8d59"
version = "1.12.2+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ad927676766e6529a2d5152f12040620447c0c9b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "14.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearElasticity_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "71e8ee0f9fe0e86a8f8c7f28361e5118eab2f93f"
uuid = "18c40d15-f7cd-5a6d-bc92-87468d86c5db"
version = "5.0.0+0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.METIS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "1d31872bb9c5e7ec1f618e8c4a56c8b0d9bddc7e"
uuid = "d00139f3-1899-568f-a2f0-47f597d42d70"
version = "5.1.1+0"

[[deps.MMG_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "LinearElasticity_jll", "Pkg", "SCOTCH_jll"]
git-tree-sha1 = "70a59df96945782bb0d43b56d0fbfdf1ce2e4729"
uuid = "86086c02-e288-5929-a127-40944b0018b7"
version = "5.6.0+0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OCCT_jll]]
deps = ["Artifacts", "FreeType2_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "Xorg_libXft_jll", "Xorg_libXinerama_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "acc8099ae8ed10226dc8424fb256ec9fe367a1f0"
uuid = "baad4e97-8daa-5946-aac2-2edac59d34e1"
version = "7.6.2+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SCOTCH_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7110b749766853054ce8a2afaa73325d72d32129"
uuid = "a8d0f55d-b80e-548d-aff6-1a04c175f0f9"
version = "6.1.3+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXft_jll]]
deps = ["Fontconfig_jll", "Libdl", "Pkg", "Xorg_libXrender_jll"]
git-tree-sha1 = "754b542cdc1057e0a2f1888ec5414ee17a4ca2a1"
uuid = "2c808117-e144-5220-80d1-69d4eaa9352c"
version = "2.3.3+1"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.gmsh_jll]]
deps = ["Artifacts", "Cairo_jll", "CompilerSupportLibraries_jll", "FLTK_jll", "FreeType2_jll", "GLU_jll", "GMP_jll", "HDF5_jll", "JLLWrappers", "JpegTurbo_jll", "LLVMOpenMP_jll", "Libdl", "Libglvnd_jll", "METIS_jll", "MMG_jll", "OCCT_jll", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "Xorg_libXft_jll", "Xorg_libXinerama_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "9774ebf68348b3b56c74a78b829051310163fd76"
uuid = "630162c2-fc9b-58b3-9910-8442a8a132e6"
version = "4.10.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═94e8e986-2b2f-11ed-219e-a124aed9d763
# ╠═5ebaade9-e3b1-44f3-a17e-369833313100
# ╠═4a7a9347-1026-403f-891d-517b0210549a
# ╠═5b09eab2-685e-4934-ac71-4edd2f230a8c
# ╟─9768883a-ddfe-4df4-988e-9ac7adee04df
# ╠═04240b0a-4411-4101-b562-61fbbb1ab95a
# ╟─183cca3c-e643-4a81-9f78-25c337601c4f
# ╠═8dd4f1d7-7161-48fc-859e-824766237326
# ╠═a7235b45-22f1-4ddb-8312-3d76170b8da2
# ╠═19a82a18-46f6-46b6-a265-1629f5163d43
# ╠═ea8d2863-279b-4295-8213-adc5f123637d
# ╠═56ead786-a3cd-44e9-8e73-d43ddeec7919
# ╠═b52ac9ab-3122-4131-b8c8-34bd381ed69b
# ╠═4dcb6868-d4fa-47e5-bee3-c3646ec991d5
# ╠═50e66b87-9630-43d3-920d-76ebaf2e2157
# ╠═9f9650ea-2fa8-4ee5-8332-6d2ffed2ca3b
# ╠═c3c61e5d-c8a2-4a06-96a5-e4d61c643e9d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
