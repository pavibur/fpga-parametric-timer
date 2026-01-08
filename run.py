from vunit import VUnit

vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()

lib = vu.add_library("design_lib")
lib.add_source_files("./design/*.vhd")

tb_lib = vu.add_library("tb_lib")
tb_lib.add_source_files("./testbench/*.vhd")

vu.main()
