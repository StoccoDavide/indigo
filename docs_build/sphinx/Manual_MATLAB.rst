MATLAB Toolbox
==============

Thr ``indigo`` MATLAB toolbox collects multiple integrators for ordinary
differential and differential-algebraic equations (ODEs/DAEs). The toolbox
provides a unified interface for the integration of ODEs/DAEs, which allows to
switch between different integration methods without changing the code of the
system of ODEs/DAEs. The toolbox is written in MATLAB and it is compatible with
MATLAB R2017b and later.

Installation
------------

Download the latest toolbox release from the repository
`releases <https://github.com/StoccoDavide/indigo/releases>`__
section. Analogously the latest development version can be downloaded from the
GitHub `repository <https://github.com/StoccoDavide/indigo>`__. In both cases
the pakage is a compressed file in `.zip` format. Unzip the file and add the
folder to the MATLAB path. In case you want to install the MATLAB toolbox
system-wide, you can open the `indigo.mtlbx` file and follow the instructions.
If you are using MATLAB R2017b or later, you can install the toolbox directly
from the Add-On Explorer by clicking on the `Get Add-Ons` button in the Add-On
Explorer tab. Then search for `indigo` and install the toolbox.

Structure
---------

The toolbox is structured through the following classes and functions.

- **Base:** (Abstract) class container for the system of Ordinary Differential
  Equations (ODEs) or Differential Algebraic Equations (DAEs).
- **ODEsystem:** (Abstract) class container for a system of Ordinary Differential
  Equations (ODEs).
- **ODEsolver:** (Abstract) class container for solvers of the system of Ordinary
  Differential Equations (ODEs) or Differential Algebraic Equations (DAEs).
- **RKexplicit:** (Abstract) class implementing the function step for the explicit
  (and explicit-embedded) Runge-Kutta integration method.
- **RKimplicit:** (Abstract) class implementing the function step for the implicit
  (and implicit-embedded) Runge-Kutta integration method.
- **NewtonSolver:** function implementing a Newton solver with affine invariant
  step for the explicit and implicit Runge-Kutta solvers.
- **SavePNG:** function for saving the current figure as a PNG file.

  .. list-table:: Available explicit Runge-Kutta solvers
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

  .. list-table:: Available implicit Runge-Kutta solvers
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

  .. list-table:: Available embedded (explicit and implicit) Runge-Kutta solvers
    :width: 80%

    * - *Fehlberg12*
      - *Fehlberg45I*
      - *Fehlberg45II*
      - *Fehlberg78*
    * - *HeunEuler*
      - *Merson45*
      - *Zonnenveld45*

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
functions. Analogously, the examples provided in the ``Examples`` section can be
used as a starting point for the usage of the ``indigo`` toolbox.
