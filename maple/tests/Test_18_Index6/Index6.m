% +--------------------------------------------------------------------------+
% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |
% | Current version authors:                                                 |
% |   Davide Stocco and Enrico Bertolazzi.                                   |
% +--------------------------------------------------------------------------+

% Matlab generated code for implicit system: Index6
% This file has been automatically generated by Indigo.
% DISCLAIMER: If you need to edit it, do it wisely!

classdef Index6 < Indigo.Systems.Implicit
  %
  % No class description provided.
  %
  properties (SetAccess = protected, Hidden = true)
    % User data
    % No Properties
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = Index6( varargin )
      % Class constructor.

      % Superclass constructor
      num_eqns = 6;
      num_veil = 0;
      num_invs = 6;
      this = this@Indigo.Systems.Implicit('Index6', num_eqns, num_veil, num_invs);
    end % Index6
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_F = F( this, in_1, in_2, in_3, t )
      % Evaluate the function F.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);
      x__1_dot = in_2(1);
      x__2_dot = in_2(2);
      x__3_dot = in_2(3);
      x__4_dot = in_2(4);
      x__5_dot = in_2(5);
      x__6_dot = in_2(6);

      % Evaluate function
      t1 = sin(t);
      out_1 = x__3_dot + x__2 - t1;
      out_2 = x__4_dot + x__3 - t1;
      out_3 = x__5_dot + x__4 - t1;
      out_4 = x__6_dot + x__5 - t1;
      out_5 = x__2_dot + x__1 - t1;
      t2 = cos(t);
      out_6 = -x__1_dot + 2 * t2;

      % Store outputs
      out_F = zeros(6, 1);
      out_F(1) = out_1;
      out_F(2) = out_2;
      out_F(3) = out_3;
      out_F(4) = out_4;
      out_F(5) = out_5;
      out_F(6) = out_6;
    end % F
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x = JF_x( this, in_1, in_2, in_3, t )
      % Evaluate the Jacobian of F with respect to x.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);
      x__1_dot = in_2(1);
      x__2_dot = in_2(2);
      x__3_dot = in_2(3);
      x__4_dot = in_2(4);
      x__5_dot = in_2(5);
      x__6_dot = in_2(6);

      % Evaluate function
      out_5_1 = 1;
      out_1_2 = 1;
      out_2_3 = 1;
      out_3_4 = 1;
      out_4_5 = 1;

      % Store outputs
      out_JF_x = zeros(6, 6);
      out_JF_x(5, 1) = out_5_1;
      out_JF_x(1, 2) = out_1_2;
      out_JF_x(2, 3) = out_2_3;
      out_JF_x(3, 4) = out_3_4;
      out_JF_x(4, 5) = out_4_5;
    end % JF_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x_dot = JF_x_dot( this, in_1, in_2, in_3, t )
      % Evaluate the Jacobian of F with respect to x_dot.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);
      x__1_dot = in_2(1);
      x__2_dot = in_2(2);
      x__3_dot = in_2(3);
      x__4_dot = in_2(4);
      x__5_dot = in_2(5);
      x__6_dot = in_2(6);

      % Evaluate function
      out_6_1 = -1;
      out_5_2 = 1;
      out_1_3 = 1;
      out_2_4 = 1;
      out_3_5 = 1;
      out_4_6 = 1;

      % Store outputs
      out_JF_x_dot = zeros(6, 6);
      out_JF_x_dot(6, 1) = out_6_1;
      out_JF_x_dot(5, 2) = out_5_2;
      out_JF_x_dot(1, 3) = out_1_3;
      out_JF_x_dot(2, 4) = out_2_4;
      out_JF_x_dot(3, 5) = out_3_5;
      out_JF_x_dot(4, 6) = out_4_6;
    end % JF_x_dot
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_v = JF_v( this, in_1, in_2, in_3, t )
      % Evaluate the Jacobian of F with respect to v.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);
      x__1_dot = in_2(1);
      x__2_dot = in_2(2);
      x__3_dot = in_2(3);
      x__4_dot = in_2(4);
      x__5_dot = in_2(5);
      x__6_dot = in_2(6);

      % Evaluate function
      % No body

      % Store outputs
      out_JF_v = zeros(6, 0);
    end % JF_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_v = v( this, in_1, t )
      % Evaluate the the veils v.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);

      % Evaluate function
      % No body

      % Store outputs
      out_v = zeros(0, 1);
    end % v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jv_x = Jv_x( this, in_1, in_2, t )
      % Evaluate the Jacobian of v with respect to x.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);

      % Evaluate function
      % No body

      % Store outputs
      out_Jv_x = zeros(0, 6);
    end % Jv_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_h = h( this, in_1, in_2, t )
      % Calculate the residual of the invariants h.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);

      % Evaluate function
      t1 = cos(t);
      out_1 = -x__6 + t1;
      t2 = sin(t);
      t3 = 2 * t2;
      out_2 = -x__5 + t3;
      out_3 = -x__4 + t2 - 2 * t1;
      out_4 = -x__3 - t2 - t1;
      out_5 = -x__2 + t1;
      out_6 = -x__1 + t3;

      % Store outputs
      out_h = zeros(6, 1);
      out_h(1) = out_1;
      out_h(2) = out_2;
      out_h(3) = out_3;
      out_h(4) = out_4;
      out_h(5) = out_5;
      out_h(6) = out_6;
    end % h
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_x = Jh_x( this, in_1, in_2, t )
      % Calculate the Jacobian of h with respect to x.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);

      % Evaluate function
      out_6_1 = -1;
      out_5_2 = -1;
      out_4_3 = -1;
      out_3_4 = -1;
      out_2_5 = -1;
      out_1_6 = -1;

      % Store outputs
      out_Jh_x = zeros(6, 6);
      out_Jh_x(6, 1) = out_6_1;
      out_Jh_x(5, 2) = out_5_2;
      out_Jh_x(4, 3) = out_4_3;
      out_Jh_x(3, 4) = out_3_4;
      out_Jh_x(2, 5) = out_2_5;
      out_Jh_x(1, 6) = out_1_6;
    end % Jh_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_v = Jh_v( this, in_1, in_2, t )
      % Calculate the Jacobian of h with respect to v.

      % Extract properties
      % No properties

      % Extract inputs
      x__1 = in_1(1);
      x__2 = in_1(2);
      x__3 = in_1(3);
      x__4 = in_1(4);
      x__5 = in_1(5);
      x__6 = in_1(6);

      % Evaluate function
      % No body

      % Store outputs
      out_Jh_v = zeros(6, 0);
    end % Jh_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end % Index6

% That's All Folks!