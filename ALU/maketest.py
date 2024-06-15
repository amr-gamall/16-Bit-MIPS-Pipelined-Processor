import subprocess
import sys


subprocess.run(['iverilog', f'{sys.argv[1]}.v', '-o', sys.argv[1]])
subprocess.run(f'./{sys.argv[1]}')
subprocess.run(['code', f'{sys.argv[1]}.vcd'])
subprocess.run(['rm', sys.argv[1]])