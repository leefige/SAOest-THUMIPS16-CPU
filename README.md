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

## VGA说明


VGA工作原理为不断读取内存的一段特定区域（上表中的显存），并将其中的RGB数据显示在对应像素上。

每个像素对应R G B各3位，共9位，即能表示2^9种颜色。

显存大小为4800个Word（16位），从0xED40 - 0xFFFF，每个地址对应的16位数据中，只有低9位有用，分配为R(8:6)，G(5:3)，B(2:0)。

VGA可显示区域大小为640\*480像素。

因为地址长度只有16位十分有限，因此使用相邻若干像素显示同一为数据的方法。具体做法为行、列坐标除以8取整（右移3位）结果相同的像素显示内容相同，即将640\*480的区域映射到80\*60的区域。

美观起见，显示区域*暂定*为60\*60的正方形（映射后），位于屏幕中央。

那么，VGA显示程序要做的，就是向这60\*60的区域内写入数据（SW指令）。根据地址映射，```(0, 0)```像素对应的内存地址就是```0xED40```，```(0, 1)```像素对应的内存地址就是```0xED41```，```(1, 0)```像素对应的内存地址就是```0xED7C```（```0xED40```+0x3C，即每行60列），以此类推。

当前定义下，事实可见最大显存地址为```0xFB4F```，而如果定义可见区域为4:3的80\*60区域，则最大显存地址为```0xFFFF```。

**[注意]** 暂时未定义通过LW读取显存内容的操作。如果LW的目标地址为显存地址，将读出全'1'的数据。

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

Edited by 李逸飞. Powered by SAOest, 2017.
