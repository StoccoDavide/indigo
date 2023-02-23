# Maple

Welcome in the `maple` folder of the `indigo` project. In this folder, you can find the MAPLE package that can be used for both ODEs/DAEs systems analysis and manipulation. It can also be used to generate efficient MATLAB and C++ code for the integrator available in this repository.

## Dependencies

The MAPLE package depends on the `LULEM` (LU Decomposition with Large Expression Management) package. This package contains functions to solve systems of linear equations with large symbolic expressions. The module uses a pivoting LU decomposition to solve the system of equations.

The `LULEM` package is freely available at this [link](https://github.com/StoccoDavide/LULEM/). For the installation, refer to the instruction present in the repository homepage.

## Installation

To install the package you must have first installed Maple. Then copy the released MLA (Maple Library Archive) file `indigo.mla` in the toolbox folder of Maple installation, which should be:

- OSX: `/Library/Frameworks/Maple.framework/Versions/20XX/toolbox` (susbitutite the `20XX` version with the one you have installed);
- Windows: `C:/Programs/Maple/toolbox/`;
- Linux: `???` (if you managed to install Linux probably you know better than me where is the right folder 🫡).

If the toolbox folder does not exist, create it.

Then load the library in a Maple worksheet or document by typing:
```
> with(indigo);
```
If the package is loaded without errors, it is done!

## Usage

🚧 Under construction...
