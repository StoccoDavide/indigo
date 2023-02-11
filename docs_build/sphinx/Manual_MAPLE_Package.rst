MAPLE Package
=============

The ``ìndigo`` toolbox comes with a MAPLE package that can be used to generate
code for the numerical integration of ODEs/DAEs in the MATLAB environment.
The aim of this package is to provide a simple and easy-to-use interface to
symbolically manipulate ODEs/DAEs model equations (*e.g.* smart differentiation,
Jacobian computation, automated DAEs index reduction, etc.) and to generate code
for the numerical integration of these equations in MATLAB in a semi-automated
way.

Installation
------------

The package is composed of a set of scripts that can be loaded in the MAPLE
environment. The package must be compiled and copied in the MAPLE system
installation folder. Once the package is installed, it can be included in the
MAPLE environment by typing the following command:

.. code-block:: none

  with(indigo);

The package can be also loaded from the ``mpl`` file by typing the following
command:

.. code-block:: none

  read("{path}/indigo.mpl");

where ``{path}`` is the relative or absolute path where the ``indigo.mpl`` file is
located.
