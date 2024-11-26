# Lin-Hunter

Lin-Hunter is a tool designed to enhance the testing efficiency of FPGA logic synthesis tools. It employs equivalent mutations to diversify HDL test cases and utilizes the Linear Upper Confidence Bound (LinUCB) algorithm to optimize the testing process. 

## Overview

Field-Programmable Gate Arrays (FPGAs) logic synthesis is essential in Electronic Design Automation (EDA), translating RTL designs to gate-level netlists. Ensuring the accuracy and reliability of FPGA logic synthesis tools is crucial, as any bugs in these tools may result in unexpected behaviors of RTL designs, potentially leading to severe safety issues.

LegoHDL is a prominent method for testing FPGA logic synthesis tools, leveraging syntax trees to guide the generation of Cyber-Physical Systems (CPS) models and converting them into Hardware Description Language (HDL) test cases. However, the CPS model's reliance on randomly generated strategies can lead to a lack of diversity in the generated HDL test cases, preventing thorough testing of FPGA logic synthesis tools.

## Solution: Lin-Hunter

To address these challenges and thoroughly test logic synthesis tools, we propose Lin-Hunter. Lin-Hunter comprises three main components:

1. **EMI Mutation Strategy Component**: Designs equivalent mutation rules to generate function-equivalent HDL test cases.
2. **Mutation Optimization Component**: Employs the Linear Upper Confidence Bound (LinUCB) to guide the EMI mutation component in identifying optimal mutation strategies.
3. **Equivalence Checking Component**: Detects compiler bugs in FPGA logic synthesis tools by analyzing the outputs of the generated HDL test cases.

## Key Features

- **Equivalent Mutations**: Diversifies HDL test cases to ensure thorough testing.
- **Optimization with LinUCB**: Enhances the efficiency of identifying optimal mutation strategies.
- **Bug Detection**: Analyzes outputs to detect and report compiler bugs in FPGA logic synthesis tools.

## Experimental Results

Experimental results have demonstrated the bug-trigger efficiency of Lin-Hunter. Over a three-month period, Lin-Hunter detected 12 bugs, all of which were confirmed by official developers.

## Installation

To install Lin-Hunter, follow these steps:

```bash
git clone https://github.com/your-repo/lin-hunter.git
cd lin-hunter
# Add further installation instructions here
# Lin-Hunter
