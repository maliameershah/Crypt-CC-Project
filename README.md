Crypt++ Lexical Analyzer
Overview

This project is a lexical analyzer (scanner) for a custom Mini C++-like language, implemented in Flex.
The scanner tokenizes source code, identifies keywords, identifiers, numbers, operators, and punctuations, and also handles errors.

The language is a reversed/symbolic variant of C++, with unique keywords, operators, and identifier rules.

Features

Custom Keywords: fi, rof, elihw, esle, nruter, hctiws, tsnoc, tuoc, nic, tni, taolf, rahc, gnirts, loob, doiv

Custom Operators: - (addition), + (subtraction), * (division), / (multiplication), (, ) swapped

Identifiers: Must start with pre and end with lisation or itrate

Numbers: Must start with 00

String & Char Literals, Comments, Punctuations supported

Error Handling: Invalid tokens reported in the format

File Structure
.
├── documentation.pdf         # Flex scanner source file
├── video.mp4                 # Flex scanner source file
├── scanner.l                 # Flex scanner source file
├── test.ali                  # Sample test program (30+ lines)
├── tokens.txt                # Sample output of scanner
├── errors.log                # Sample error log (if any)
└── README.md                 # This file

Installation & Requirements

VMware or any Linux environment

Ubuntu / Debian recommended

Flex and GCC installed

sudo apt update
sudo apt install flex gcc build-essential -y

Usage

Compile the scanner:

flex scanner.l
gcc lex.yy.c -lfl -o scanner


Run the scanner on a source file:

./scanner test.cpp > tokens.txt


Language Rules Summary
Category	Syntax Example
Keywords	fi, rof, esle, etc.
Data Types	tni, taolf, rahc, gnirts, loob, doiv
Operators	-, +, *, /, (, )
Identifiers	preCounterlisation, preIndexitrate
Numbers	0010, 0020, 0000
Strings/Chars	"Hello", 'A'
Comments	// single-line, /* multi-line */
Demo

The project includes a 30+ line test program test.cpp to demonstrate:

Tokenization of all keywords, identifiers, numbers, operators, and punctuations

Error handling for invalid identifiers or symbols

Author

Muhammad Ali Ameer Shah – Student, Compiler Construction Phase 1

All work is original and created using a custom language design.
