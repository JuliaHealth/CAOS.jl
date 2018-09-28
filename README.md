# CAOS

#### Characteristic Attribute Organization System (CAOS) implementation in Julia.


| MacOS / Linux | Windows | Test Coverage | Documentation |
| --- | ---- | ------ | ------ |
|[![Travis](https://img.shields.io/travis/bcbi/CAOS.jl/master.svg?style=flat-square)](https://travis-ci.org/bcbi/CAOS.jl)| [![AppVeyor](https://img.shields.io/appveyor/ci/fernandogelin/CAOS-jl/master.svg?style=flat-square)](https://ci.appveyor.com/project/fernandogelin/caos-jl) | [![Codecov](https://img.shields.io/codecov/c/github/bcbi/CAOS.jl.svg?style=flat-square)](https://codecov.io/gh/bcbi/CAOS.jl/branch/master) | [![Docs](https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square)](https://bcbi.github.io/caos.jl/stable) [![Docs](https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square)](https://bcbi.github.io/caos.jl/latest) |

## Installation

In addition to the required Julia packages, it is required that you have [BLAST][blast-url] 2.7.1+ installed and accessible in your PATH (eg. you should be able to execute `$ blastn -h` from the command line).

[blast-url]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download

The package must be downloaded from GitHub

* Git: `git clone https://github.com/bcbi/CAOS.jl`

## Project Status

The package is tested against the current Julia `0.7` and Julia `1.0` release on OS X, Linux, and Windows.

## Contributing and Questions

Contributions are very welcome, as are feature requests and suggestions. Please open an
[issue][issues-url] if you encounter any problems or would just like to ask a question.

[issues-url]: https://github.com/bcbi/CAOS/issues
