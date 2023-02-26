#!/bin/bash
yasm -gdwarf2 -f elf64 paorth.asm && ld.lld paorth.o --entry=paorth
