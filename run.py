from vunit import VUnit
import random

vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()

lib = vu.add_library("design_lib")
lib.add_source_files("./design/timer.vhd")

tb_lib = vu.add_library("tb_lib")
tb_lib.add_source_files("./testbench/tb_timer.vhd")

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


# Generate random configs
random.seed(42) 
for i in range(10):
    tb_clk_freq = random.randint(5, 50)   
    tb_delay_ms = random.randint(100, 3000) 
    
    tb.add_config(
        name=f"rand_{i}_f{tb_clk_freq}Hz_d{tb_delay_ms}ms",
        generics={
            "tb_clk_freq_g": tb_clk_freq,
            "tb_delay_g": tb_delay_ms
        }
    )

vu.main()
