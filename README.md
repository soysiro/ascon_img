# ASCON Hardware

## Prerequisites

Before run, need to install iverilog and gtkwave for simulation, and python to generate testcase

In Ubuntu:

```bash
sudo apt install python3
sudo apt install iverilog gtkwave
```

In Arch

```bash
sudo pacman -S iverilog gtkwave python3
```

## Step to run

### Generate testcase

To generate testcase, change the value of variable below:

```python
# AEAD Data
associateddata = b"ASCON"
plaintext      = b"ascon-unicass"
ciphertext     = b"ascon-unicass"
```

Key, nonce will be get from random 

After generate testcase, run this 

```bash
python run.py
```

### Simulate design

Change dir to testbench
```bash
cd testbench
```

Compile design
```bash
iverilog -c program_files.txt -o encdec.out
```

Run design
```bash
vvp encdec.out
```

View signal wave by gtkwave

```bash
gtkwave test.vcd
```

