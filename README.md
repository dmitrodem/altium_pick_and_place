# Tool for generating pick and place files from Altium project variants
## Preface
Altium Designer is a quite powerful tool for developing PCBs, but it has numerous bugs which are not fixed and even not planned to. One of the most frustrating things about it is "project variants". Variants itself are a good idea (you can mark components as "do not populate", change their nominals without actually editing your schematic or pcb). But it is somewhat buggy: for my projects it sometimes "forgets" about variants when generating pick-and-place file or even mixes up components ids.
## Usage
First of all define your own variant of pcb and edit it as you like. Then export pick-and-place file in ``.csv`` format **with no variant**, for example, as ``myproject.csv``.

The utility ``pnptool.py`` takes one required parameter -- project file (.PcbPrj). If run as
```sh
pnptool.py --project myproject.PcbPrj
```
it shows list of available variants
```sh
Available variations:
1: alt01
2: alt02
Select desired variation index via command line (--variant N)
```

Select the one you want and also specify previously generated ``.csv`` file and path to the result:
```sh
pnptool.py --project myproject.PcbPrj --variant 1 --pnp myproject.csv --output myproject_alt01.txt
```
This will generate correct pick-and-place file myproject_alt01.txt for variant alt01

## Limitations
Currently only "Do not fill part" and "Change Comment field" type variations are supported (i.e. no "Alternative part change")
