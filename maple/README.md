# Maple

Welcome to the `maple` folder of the `indigo` project. In this folder, you can find the Maple package that can be used for both ODEs/DAEs systems analysis, manipulation, and code generation of efficient Matlab and C++ code for the integrator available in this repository.

## Dependencies

The `Indigo` Maple package depends on the `LEM` (Large Expressions Management) and `LAST` (Linear Algebra Symbolic Toolbox) packages.
These packages contain functions to solve linear systems of equations avoiding expression swell. The module uses a full pivoting LU decomposition and fraction-free preserving Gaussian elimination to solve the system of equations.

## Installation

Firstly, install the dependencies. The `LEM` package is freely available at this [link](https://github.com/StoccoDavide/LEM/), while the `LAST` package is freely available at this other [link](https://github.com/StoccoDavide/LAST/). For installation of both dependency packages, refer to the instructions present on the repository homepages.

To install the `Indigo` module you must have first installed Maple. Then open the `PackAndGo.mw` file and use the `!!!` button to *execute the entire worksheet*.

Then test the module in a Maple worksheet or document by typing:

```
> Indigo:-Info(LEM); # For Maple versions up to 2020
> Indigo:-Info();    # For Maple versions starting from 2021
```

Alternatively, you can use one of the tests file provided in the `tests` folder. If the module is loaded without errors, it is done!

## Module description

If you want a full description of the `Indigo` package type:
```
> Describe(Indigo);
> Describe(IndigoCodeGen);
> Describe(IndigoUtils);
```
This command will generate a brief description of the module and all the procedures and other objects present in the `Indigo.mpl`, `IndigoCodeGen.mpl`, and `IndigoUtils.mpl` files.


## Usage

In case you have no time to read the description and realize how it should or should not work, refer to the files in the `tests` folder.

### 🚧 Attention! 🚧

Maple object-oriented programming features have slightly changed in 2021, which online documentation states:

> As of Maple 2021, if the method has a formal parameter named `_self`, references to its object's local or exported variables may be written without prefixing them. That is, `_self:-variable` may be written as just `variable`. Maple will add the `self:-` prefix internally when the method is simplified.

> As of Maple 2021, a message-passing form of method call can be used, which will automatically pass the object as an argument if the method has a formal parameter named `_self`.

> Another way to invoke a method, similar to that used in other object-oriented languages, was introduced in Maple 2021. In this form, the object name is qualified by the method name, `object_name:-method_name(argument)` just as it can be in the function mechanism described above. However, the *object can be omitted from the argument sequence*.

For further information please refer to this [link](https://fr.maplesoft.com/support/help/Maple/view.aspx?path=object/methods).

## Authors

### Current version authors:

- *Davide Stocco*,
  Department of Industrial Engineering,
  University of Trento \
  email: davide.stocco@unitn.it

- *Matteo Larcher*,
  Department of Industrial Engineering,
  University of Trento \
  email: matteo.larcher@unitn.it

- *Enrico Bertolazzi*,
  Department of Industrial Engineering,
  University of Trento \
  email: enrico.bertolazzi@unitn.it
