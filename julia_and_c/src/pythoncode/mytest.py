# ctypes_test.py
# https://realpython.com/python-bindings-overview/
import ctypes
import pathlib
from pathlib import Path

if __name__ == "__main__":
    # Load the shared library into ctypes
    p = Path("/usr/lib/libgarlandtest.so")
    libname =p.absolute() 
    c_lib = ctypes.CDLL(libname)

    x = ctypes.c_float(5)
    y = ctypes.c_float(10.1)

    c_lib.add2.restype = ctypes.c_float
    answer = c_lib.add2(x, y)

    print(f"the answer is {answer}")
