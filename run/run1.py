#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr 30 16:04:51 2022

@author: sidra
"""
import os


runcommand = 'nohup Rscript fullfastadownload.R &'
os.system(runcommand)


runcommand = 'nohup python3 modify_fasta.py &'
os.system(runcommand)
