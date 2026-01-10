from vunit import VUnit

vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()

lib = vu.add_library("design_lib")
lib.add_source_files("./design/*.vhd")

tb_lib = vu.add_library("tb_lib")
tb_lib.add_source_files("./testbench/*.vhd")

tb = tb_lib.test_bench("tb_timer")

tb.add_config(
    name="f10Hz_d1s",
    generics={
        "tb_clk_freq_g": 10,
        "tb_delay_g": 1000
    },
)

tb.add_config(
    name="f10Hz_d2s",
    generics={
        "tb_clk_freq_g": 10,
        "tb_delay_g": 2000
    },
)

tb.add_config(
    name="f20Hz_d500ms",
    generics={
        "tb_clk_freq_g": 20,
        "tb_delay_g": 1000
    },
)

tb.add_config(
    name="f35Hz_d2600ms",
    generics={
        "tb_clk_freq_g": 35,
        "tb_delay_g": 2600
    },
)

vu.main()
