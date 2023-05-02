MATLAB Toolbox
==============

The ``indigo`` MATLAB toolbox collects multiple integrators for differential and
differential-algebraic equations (ODEs/DAEs). The toolbox provides an efficient
interface for the integration of dynamical systems, which allows to easily
switch between different integration methods without changing the code of the
system of ODEs/DAEs. The toolbox is structured through a set of classes and
functions which are described in the following sections.

Installation
------------

Before talking about the structure of the toolbox, let's see how to install it.
There are multiple ways to install the toolbox.

- The easiest way is to download the latest toolbox release from the repository
  `releases <https://github.com/StoccoDavide/indigo/releases>`__ section. In
  this case, the package is a compressed in a `.zip` file format. Unzip the file
  and add the folder to the MATLAB path using the `setup.m` file.
- Analogously the latest development version can be downloaded from the GitHub
  `repository <https://github.com/StoccoDavide/indigo>`__ and add the folder to
  the MATLAB path using the `setup.m` file. If you want to install the MATLAB
  toolbox system-wide, compile the MATLAB toolbox using the project file
  `Indigo.prj` in the `matlab` folder of the repository. The complied toolbox will
  be saved in the file `indigo.mtlbx`. Open the `indigo.mtlbx` file and follow the
  instructions.
- You can also install the toolbox directly from the Add-On Explorer by clicking
  on the `Get Add-Ons` button in the Add-On Explorer tab. Then search for
  `indigo` and install the toolbox.

Structure
---------

The toolbox is structured into three sections: the first section contains the
Runge-Kutta solvers, the second section contains the types of ODEs/DAEs systems
that can be integrated, and the third section contains the utilities functions
used by the solvers.

The Runge-Kutta are contained in the folder ``indigo/RungeKutta``,
and implements into the following classes:

- **ODEsolver:** (Abstract) class container for solvers of the system of Ordinary
  Differential Equations (ODEs) or Differential Algebraic Equations (DAEs).
- **RKexplicit:** (Abstract) class implementing the function step for the explicit
  (and explicit-embedded) Runge-Kutta integration method.
- **RKimplicit:** (Abstract) class implementing the function step for the implicit
  (and implicit-embedded) Runge-Kutta integration method.

The types of ODEs/DAEs systems, which are contained in the folder
``indigo/ODEsystem``, and are implements into the following classes:

- **Base:** (Abstract) class container for the system of Ordinary Differential
  Equations (ODEs) or Differential Algebraic Equations (DAEs).
- **ODEsystem:** (Abstract) class container for a system of Ordinary Differential
  Equations (ODEs).

The utilities functions, which are contained in the folder ``indigo/Utils``, and
are implements into the following functions:

- **NewtonSolver:** function implementing a Newton solver with affine invariant
  step for the explicit and implicit Runge-Kutta solvers.
- **SavePNG:** function for saving the current figure as a PNG file.

  .. list-table:: **Available explicit Runge-Kutta solvers**
    :width: 80%

    * - *ExplicitEuler*
      - *ExplicitMidpoint*
      - *Generic2*
      - *Generic3*
    * - *Heun2*
      - *Heun3*
      - *Ralston2*
      - *Ralston3*
    * - *Ralston4*
      - *RK3*
      - *RK4*
      - *RK38*
    * - *SSPRK3*
      - *Wray3*
      - *-*
      - *-*

  .. list-table:: **Available implicit Runge-Kutta solvers**
    :width: 80%

    * - *CrankNicolson*
      - *GaussLegendre2*
      - *GaussLegendre4*
      - *GaussLegendre6*
    * - *ImplicitEuler*
      - *ImplicitMidpoint*
      - *LobattoIIIA2*
      - *LobattoIIIA4*
    * - *LobattoIIIB2*
      - *LobattoIIIB4*
      - *LobattoIIIC2*
      - *LobattoIIIC4*
    * - *LobattoIIICS2*
      - *LobattoIIICS4*
      - *LobattoIIID2*
      - *LobattoIIID4*
    * - *RadauIA3*
      - *RadauIA5*
      - *RadauIIA3*
      - *RadauIIA5*
    * - *SunGeng5*
      - *-*
      - *-*
      - *-*

  .. list-table:: **Available embedded explicit Runge-Kutta solvers**
    :width: 80%

    * - BogackiShampine23
      - CashKarp45
      - DormandPrince45
      - Fehlberg12
    * - Fehlberg45I
      - Fehlberg45II
      - Fehlberg78
      - HeunEuler21
    * - Merson45
      - Verner65
      - Zonnenveld45
      - *-*

  .. list-table:: **Available embedded implicit Runge-Kutta solvers**
    :width: 80%

    * - GaussLegendre34
      - GaussLegendre56
      - LobattoIIIA12
      - LobattoIIIA34
    * - LobattoIIIB12
      - LobattoIIIB34
      - LobattoIIIC12
      - LobattoIIIC34

Usage
-----

To use the toolbox you just have to follow the following steps.

1. Create an instance of the class representing the system of ODEs/DAEs, which
   must be a subclass of the class ``ODEsystem``;
2. Create an instance of the class representing the solver, by simply
   instantiating one of the available solver classes listed in the tables
   above.
3. Associate the system of ODEs/DAEs to the solver instance by calling the
   method ``set_ode`` of the solver instance. Finally, call the method ``solve``
   of the solver instance can be called to solve the system of ODEs/DAEs. It
   will return the solution of the system of ODEs/DAEs as a matrix, where each
   column is the solution of the system at a different time instant.
4. (Optional) The method ``plot`` of the solver instance can be called to plot the
   solution of the system of ODEs/DAEs.
5. (Optional) The method ``animate`` of the solver instance can be called to
   animate the solution of the system of ODEs/DAEs.

For further details, please refer to the documentation of the classes and
functions. Analogously, the examples provided in the ``tests`` section can be
used as a starting point for the usage of the ``indigo`` toolbox.
