println("hi")

 r= ccall((:add2, "libgarlandtest"),Float32 , (Float32 ,Float32 ), 1.1,2.2)
 print("result is ",r)