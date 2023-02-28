# Maple

Welcome on the `maple` folder of the `indigo` project. In this folder, you can find the MAPLE package that can be used for both ODEs/DAEs systems analysis and manipulation. It can also be used to generate efficient MATLAB and C++ code for the integrator available in this repository.

## Dependencies

The `Indigo` Maple package depends on the `LEM` (Large Expressions Management) and `LULEM` (LU decomposition with Large Expressions Management) packages.
These packages contain functions to solve linear systems of equations avoiding expression swell. The module uses a full pivoting LU decomposition and fraction-free preserving Gaussian elimination to solve the system of equations.

## Installation

Firstly, install the dependencies. The `LEM` package is freely available at this [link](https://github.com/StoccoDavide/LEM/), while the `LULEM` package is freely available at this other [link](https://github.com/StoccoDavide/LULEM/). For installation of both dependency packages, refer to the instructions present on the repositories homepage.

To install the `Indigo` package you must have first installed Maple. Then navigate to the toolbox folder of Maple installation, which should be:
- OSX: `/Library/Frameworks/Maple.framework/Versions/Current/toolbox`;
- Windows: `C:/Programs/Maple/toolbox/`;
- Linux: `???` (if you managed to install Linux probably you know better than me where is the right folder 🫡).
If the `toolbox` folder does not exist, create it.

Make a folder named `Indigo` and inside this folder create another one named `lib`. Copy the latest [released](https://github.com/StoccoDavide/indigo/releases) MLA (Maple Library Archive) file `Indigo.mla` in the `lib` that you have just created.

Then test the library in a Maple worksheet or document by typing:
```
> with(Indigo);
```
Alternatively, you can use the `test.mw` file provided in the repository. If the package is loaded without errors, it is done!

## Package description

If you want a full description of the `Indigo` package type:
```
> Describe(Indigo);
```
This command will generate a brief description of the module and all the procedures and other objects present in the `LEM.mpl` file, which will be (very) similar to the following code.
```
🚧 Under construction...
```

## Worked example

In case you have no time to read the description and realize how it should or should not work, here is a simple worked example.
```
🚧 Under construction...
```
