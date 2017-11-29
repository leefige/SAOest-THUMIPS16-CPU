# SAOest的THCO MIPS CPU

写完软工的SAOest又要开始造CPU啦！

## 目标

1. 基本功能
    - 25+5条指令（详见doc/我们要做的指令集.xlsx）
2. 拓展功能
    - 外设：VGA, PS2
    - Delay slot
    - Forward, Hazard Detection完善冲突处理
    - 其他可能的拓展

## 目录树

```bash
.
├── common
│   ├── Digit7.vhd
│   ├── Mux2.vhd
│   ├── Mux3.vhd
│   ├── Mux4.vhd
│   └── Mux6.vhd
├── CPU
│   ├── ALU.vhd
│   ├── BranchController.vhd
│   ├── Controller.vhd
│   ├── CPU.vhd
│   ├── ExMemRegister.vhd
│   ├── Extender.vhd
│   ├── ForwardUnit.vhd
│   ├── HazardUnit.vhd
│   ├── IdExRegister.vhd
│   ├── IfIdRegister.vhd
│   ├── IOMapper.vhd
│   ├── MemWbRegister.vhd
│   ├── PCReg.vhd
│   ├── RegisterFile.vhd
│   ├── StallController.vhd
│   └── TSetter.vhd
├── IO
│   ├── IOBridge.vhd
│   └── Memory.vhd
└── THINPAD_top.vhd

3 directories, 24 files
```

***

Powered by SAOest, 2017.
