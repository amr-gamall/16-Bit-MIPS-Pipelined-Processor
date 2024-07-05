# 32-Bit-MIPS-Multicycle-Processor 
- An implementation to *h&h* 32 bit MIPS multicycle processor
- Quick notes
    - $A$, $B$ and $Data$ registers could be removed, it's just for the sake of illustrating that the time period is scaled down, that's, $T_P$ is dropping down due to the segmentation the logic.
- Usage
    - Simulation : write the hex file of your program to the data/instruction memory and run the testbench file using `python maketest.py testbench` you can replace testbench with your own simulation file.

    - Synthesis : You're on your own :'(, look up your FPGA tool and synthesize it using it. I don't think anyone would plan and route my shitty design, I don't even think anyone would star it or even look it up.