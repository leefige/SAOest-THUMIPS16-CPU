# SAOest的THCO MIPS CPU

写完软工的SAOest又要开始造CPU啦！

## 注意事项

若综合时，在synthesize的warning中发现如clka, clkb, dina等信号never used时，在左边Design栏中找到```c_GraphicMem```，单击，在下边的菜单里双击```Regenerate Core```，重新生成后再运行即可。

## 目标

1. 基本功能
    - 25+5条指令（详见doc/我们要做的指令集.xlsx）
2. 拓展功能
    - 外设：VGA, PS2
    - Delay slot
    - Forward, Hazard Detection完善冲突处理
    - 其他可能的拓展

## 地址映射

|地址空间|分配|大小/Word|映射器件|
|---|---|---|---|
|0x0000 - 0x3FFF|监控程序|16k|SRAM 2 (Inst Mem)|
|0x4000 - 0x7FFF|用户程序|16k|SRAM 2 (Inst Mem)|
|0x8000 - 0xBEFF|监控程序数据段|15k|SRAM 1 (Data Mem)|
|0xBF00|COM数据位|1|COM|
|0xBF01|COM状态位|1|COM|
|0xBF02|PS2数据位|1|PS2|
|0xBF03|PS2状态位|1|PS2|
|0xBF04 - 0xBF0F|保留|12|-|
|0xBF10 - 0xBFFF|系统堆栈|240|SRAM 1 (Data Mem)|
|0xC000 - 0xED3F|用户程序数据段|11584|SRAM 1 (Data Mem)|
|0xED40 - 0xFFFF|显存|4800|Dual RAM (Graphic Mem)|

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
│   ├── Keyboard.vhd
│   ├── Memory.vhd
│   └── VGA_640480.vhd
└── THINPAD_top.vhd

3 directories, 26 files
```

**[注]** 片内DualRAM在```ipcore_dir/```目录下。

***

Powered by SAOest, 2017.
