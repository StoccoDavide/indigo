% +--------------------------------------------------------------------------+
% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |
% | Current version authors:                                                 |
% |   Davide Stocco and Enrico Bertolazzi.                                   |
% +--------------------------------------------------------------------------+

% Matlab generated code for implicit system: DoublePendulum
% This file has been automatically generated by Indigo.
% DISCLAIMER: If you need to edit it, do it wisely!

classdef DoublePendulum < Indigo.DAE.Implicit
  %
  % No class description provided.
  %
  properties (SetAccess = protected, Hidden = true)
    % User data
    m_m__1 = 1.0;
    m_m__2 = 2.0;
    m_g = 9.81;
    m_ell__1 = 1.0;
    m_ell__2 = 1.5;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = DoublePendulum( varargin )
      % Class constructor.

      % Superclass constructor
      num_eqns = 10;
      num_veil = 13;
      num_invs = 6;
      this = this@Indigo.DAE.Implicit('DoublePendulum', num_eqns, num_veil, num_invs);

      % User data
      if (nargin == 0)
        % Keep default values
      elseif (nargin == 1 && isstruct(varargin{1}))
        this.m_m__1 = varargin{1}.m__1;
        this.m_m__2 = varargin{1}.m__2;
        this.m_g = varargin{1}.g;
        this.m_ell__1 = varargin{1}.ell__1;
        this.m_ell__2 = varargin{1}.ell__2;
      elseif (nargin == 5)
        this.m_m__1 = varargin{1};
        this.m_m__2 = varargin{2};
        this.m_g = varargin{3};
        this.m_ell__1 = varargin{4};
        this.m_ell__2 = varargin{5};
      else
        error('wrong number of input arguments.');
      end
    end % DoublePendulum
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_F = F( this, in_1, in_2, in_3, ~ )
      % Evaluate the function F.

      % Extract properties
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;

      % Extract inputs
      x__1 = in_1(1);
      y__1 = in_1(2);
      x__2 = in_1(3);
      y__2 = in_1(4);
      u__1 = in_1(5);
      v__1 = in_1(6);
      u__2 = in_1(7);
      v__2 = in_1(8);
      lambda__1 = in_1(9);
      lambda__2 = in_1(10);
      x__1_dot = in_2(1);
      y__1_dot = in_2(2);
      x__2_dot = in_2(3);
      y__2_dot = in_2(4);
      u__1_dot = in_2(5);
      v__1_dot = in_2(6);
      u__2_dot = in_2(7);
      v__2_dot = in_2(8);
      lambda__1_dot = in_2(9);
      lambda__2_dot = in_2(10);
      V_y58KN_1 = in_3(1);
      V_y58KN_2 = in_3(2);

      % Evaluate function
      out_1 = -u__1 + x__1_dot;
      out_2 = -v__1 + y__1_dot;
      out_3 = -u__2 + x__2_dot;
      out_4 = -v__2 + y__2_dot;
      t2 = x__1 * lambda__1;
      out_5 = m__1 * u__1_dot + 2 * t2;
      out_6 = m__1 * v__1_dot + V_y58KN_1;
      t6 = x__2 * lambda__2;
      out_7 = m__2 * u__2_dot + 2 * t6;
      out_8 = m__2 * v__2_dot + V_y58KN_2;
      t9 = 0.1e1 / m__1;
      t23 = x__1 ^ 2;
      t24 = y__1 ^ 2;
      out_9 = 8 * x__1_dot * t9 * t2 + 2 * y__1_dot * t9 * (2 * y__1 * lambda__1 + V_y58KN_1) - 4 * u__1 * u__1_dot - 4 * v__1 * v__1_dot + 4 * t9 * lambda__1_dot * (t23 + t24);
      t29 = 0.1e1 / m__2;
      t43 = x__2 ^ 2;
      t44 = y__2 ^ 2;
      out_10 = 8 * x__2_dot * t29 * t6 + 2 * y__2_dot * t29 * (2 * y__2 * lambda__2 + V_y58KN_2) - 4 * u__2 * u__2_dot - 4 * v__2 * v__2_dot + 4 * t29 * lambda__2_dot * (t43 + t44);

      % Store outputs
      out_F = zeros(10, 1);
      out_F(1) = out_1;
      out_F(2) = out_2;
      out_F(3) = out_3;
      out_F(4) = out_4;
      out_F(5) = out_5;
      out_F(6) = out_6;
      out_F(7) = out_7;
      out_F(8) = out_8;
      out_F(9) = out_9;
      out_F(10) = out_10;
    end % F
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x = JF_x( this, in_1, in_2, ~, ~ )
      % Evaluate the Jacobian of F with respect to x.

      % Extract properties
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;

      % Extract inputs
      x__1 = in_1(1);
      y__1 = in_1(2);
      x__2 = in_1(3);
      y__2 = in_1(4);
      lambda__1 = in_1(9);
      lambda__2 = in_1(10);
      x__1_dot = in_2(1);
      y__1_dot = in_2(2);
      x__2_dot = in_2(3);
      y__2_dot = in_2(4);
      u__1_dot = in_2(5);
      v__1_dot = in_2(6);
      u__2_dot = in_2(7);
      v__2_dot = in_2(8);
      lambda__1_dot = in_2(9);
      lambda__2_dot = in_2(10);

      % Evaluate function
      out_5_1 = 2 * lambda__1;
      t1 = 0.1e1 / m__1;
      t2 = t1 * lambda__1;
      out_9_1 = 8 * t1 * lambda__1_dot * x__1 + 8 * x__1_dot * t2;
      out_9_2 = 8 * t1 * lambda__1_dot * y__1 + 4 * y__1_dot * t2;
      out_7_3 = 2 * lambda__2;
      t12 = 0.1e1 / m__2;
      t13 = t12 * lambda__2;
      out_10_3 = 8 * t12 * lambda__2_dot * x__2 + 8 * x__2_dot * t13;
      out_10_4 = 8 * t12 * lambda__2_dot * y__2 + 4 * y__2_dot * t13;
      out_1_5 = -1;
      out_9_5 = -4 * u__1_dot;
      out_2_6 = -1;
      out_9_6 = -4 * v__1_dot;
      out_3_7 = -1;
      out_10_7 = -4 * u__2_dot;
      out_4_8 = -1;
      out_10_8 = -4 * v__2_dot;
      out_5_9 = 2 * x__1;
      out_9_9 = 8 * x__1_dot * t1 * x__1 + 4 * y__1_dot * t1 * y__1;
      out_7_10 = 2 * x__2;
      out_10_10 = 8 * x__2_dot * t12 * x__2 + 4 * y__2_dot * t12 * y__2;

      % Store outputs
      out_JF_x = zeros(10, 10);
      out_JF_x(5, 1) = out_5_1;
      out_JF_x(9, 1) = out_9_1;
      out_JF_x(9, 2) = out_9_2;
      out_JF_x(7, 3) = out_7_3;
      out_JF_x(10, 3) = out_10_3;
      out_JF_x(10, 4) = out_10_4;
      out_JF_x(1, 5) = out_1_5;
      out_JF_x(9, 5) = out_9_5;
      out_JF_x(2, 6) = out_2_6;
      out_JF_x(9, 6) = out_9_6;
      out_JF_x(3, 7) = out_3_7;
      out_JF_x(10, 7) = out_10_7;
      out_JF_x(4, 8) = out_4_8;
      out_JF_x(10, 8) = out_10_8;
      out_JF_x(5, 9) = out_5_9;
      out_JF_x(9, 9) = out_9_9;
      out_JF_x(7, 10) = out_7_10;
      out_JF_x(10, 10) = out_10_10;
    end % JF_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x_dot = JF_x_dot( this, in_1, ~, in_3, ~ )
      % Evaluate the Jacobian of F with respect to x_dot.

      % Extract properties
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;

      % Extract inputs
      x__1 = in_1(1);
      y__1 = in_1(2);
      x__2 = in_1(3);
      y__2 = in_1(4);
      u__1 = in_1(5);
      v__1 = in_1(6);
      u__2 = in_1(7);
      v__2 = in_1(8);
      lambda__1 = in_1(9);
      lambda__2 = in_1(10);
      V_y58KN_1 = in_3(1);
      V_y58KN_2 = in_3(2);

      % Evaluate function
      out_1_1 = 1;
      t2 = 0.1e1 / m__1;
      out_9_1 = 8 * t2 * lambda__1 * x__1;
      out_2_2 = 1;
      out_9_2 = 2 * t2 * (2 * y__1 * lambda__1 + V_y58KN_1);
      out_3_3 = 1;
      t9 = 0.1e1 / m__2;
      out_10_3 = 8 * t9 * lambda__2 * x__2;
      out_4_4 = 1;
      out_10_4 = 2 * t9 * (2 * y__2 * lambda__2 + V_y58KN_2);
      out_5_5 = m__1;
      out_9_5 = -4 * u__1;
      out_6_6 = m__1;
      out_9_6 = -4 * v__1;
      out_7_7 = m__2;
      out_10_7 = -4 * u__2;
      out_8_8 = m__2;
      out_10_8 = -4 * v__2;
      t19 = x__1 ^ 2;
      t20 = y__1 ^ 2;
      out_9_9 = 4 * t2 * (t19 + t20);
      t23 = x__2 ^ 2;
      t24 = y__2 ^ 2;
      out_10_10 = 4 * t9 * (t23 + t24);

      % Store outputs
      out_JF_x_dot = zeros(10, 10);
      out_JF_x_dot(1, 1) = out_1_1;
      out_JF_x_dot(9, 1) = out_9_1;
      out_JF_x_dot(2, 2) = out_2_2;
      out_JF_x_dot(9, 2) = out_9_2;
      out_JF_x_dot(3, 3) = out_3_3;
      out_JF_x_dot(10, 3) = out_10_3;
      out_JF_x_dot(4, 4) = out_4_4;
      out_JF_x_dot(10, 4) = out_10_4;
      out_JF_x_dot(5, 5) = out_5_5;
      out_JF_x_dot(9, 5) = out_9_5;
      out_JF_x_dot(6, 6) = out_6_6;
      out_JF_x_dot(9, 6) = out_9_6;
      out_JF_x_dot(7, 7) = out_7_7;
      out_JF_x_dot(10, 7) = out_10_7;
      out_JF_x_dot(8, 8) = out_8_8;
      out_JF_x_dot(10, 8) = out_10_8;
      out_JF_x_dot(9, 9) = out_9_9;
      out_JF_x_dot(10, 10) = out_10_10;
    end % JF_x_dot
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_v = JF_v( ~, ~, ~, ~, ~ )
      % Evaluate the Jacobian of F with respect to v.

      % Extract properties
      % No properties

      % Extract inputs

      % Evaluate function
      % No body

      % Store outputs
      out_JF_v = zeros(10, 13);
    end % JF_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_v = v( this, in_1, ~ )
      % Evaluate the the veils v.

      % Extract properties
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      g = this.m_g;
      ell__1 = this.m_ell__1;
      ell__2 = this.m_ell__2;

      % Extract inputs
      x__1 = in_1(1);
      y__1 = in_1(2);
      x__2 = in_1(3);
      y__2 = in_1(4);
      u__1 = in_1(5);
      v__1 = in_1(6);
      u__2 = in_1(7);
      v__2 = in_1(8);
      lambda__1 = in_1(9);
      lambda__2 = in_1(10);

      % Evaluate function
      t3 = 2 * y__1 * lambda__1;
      V_y58KN_1 = g * m__1 + t3;
      t6 = 2 * y__2 * lambda__2;
      V_y58KN_2 = g * m__2 + t6;
      t7 = ell__1 ^ 2;
      t8 = x__1 ^ 2;
      t9 = y__1 ^ 2;
      V_y58KN_3 = t7 - t8 - t9;
      t10 = ell__2 ^ 2;
      t11 = x__2 ^ 2;
      t12 = y__2 ^ 2;
      V_y58KN_4 = t10 - t11 - t12;
      V_y58KN_5 = u__1 * x__1 + v__1 * y__1;
      V_y58KN_6 = u__2 * x__2 + v__2 * y__2;
      t20 = u__1 ^ 2;
      t21 = v__1 ^ 2;
      t25 = 0.1e1 / m__1;
      V_y58KN_7 = t25 * (-y__1 * V_y58KN_1 - 2 * lambda__1 * t8 + (t20 + t21) * m__1);
      t29 = u__2 ^ 2;
      t30 = v__2 ^ 2;
      t34 = 0.1e1 / m__2;
      V_y58KN_8 = t34 * (-y__2 * V_y58KN_2 - 2 * lambda__2 * t11 + (t29 + t30) * m__2);
      V_y58KN_9 = t25 * (t3 + V_y58KN_1);
      V_y58KN_10 = t25 * (t8 + t9);
      V_y58KN_11 = t34 * lambda__2 * x__2;
      V_y58KN_12 = t34 * (t6 + V_y58KN_2);
      V_y58KN_13 = t34 * (t11 + t12);

      % Store outputs
      out_v = zeros(13, 1);
      out_v(1) = V_y58KN_1;
      out_v(2) = V_y58KN_2;
      out_v(3) = V_y58KN_3;
      out_v(4) = V_y58KN_4;
      out_v(5) = V_y58KN_5;
      out_v(6) = V_y58KN_6;
      out_v(7) = V_y58KN_7;
      out_v(8) = V_y58KN_8;
      out_v(9) = V_y58KN_9;
      out_v(10) = V_y58KN_10;
      out_v(11) = V_y58KN_11;
      out_v(12) = V_y58KN_12;
      out_v(13) = V_y58KN_13;
    end % v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jv_x = Jv_x( this, in_1, in_2, ~ )
      % Evaluate the Jacobian of v with respect to x.

      % Extract properties
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;

      % Extract inputs
      x__1 = in_1(1);
      y__1 = in_1(2);
      x__2 = in_1(3);
      y__2 = in_1(4);
      u__1 = in_1(5);
      v__1 = in_1(6);
      u__2 = in_1(7);
      v__2 = in_1(8);
      lambda__1 = in_1(9);
      lambda__2 = in_1(10);
      V_y58KN_1 = in_2(1);
      V_y58KN_2 = in_2(2);

      % Evaluate function
      D_V_y58KN_1_1 = 0;
      D_V_y58KN_2_1 = 0;
      D_V_y58KN_3_1 = -2 * x__1;
      D_V_y58KN_4_1 = 0;
      D_V_y58KN_5_1 = u__1;
      D_V_y58KN_6_1 = 0;
      t3 = 0.1e1 / m__1;
      D_V_y58KN_7_1 = -4 * t3 * lambda__1 * x__1;
      D_V_y58KN_8_1 = 0;
      D_V_y58KN_9_1 = 0;
      D_V_y58KN_10_1 = 2 * x__1 * t3;
      D_V_y58KN_11_1 = 0;
      D_V_y58KN_12_1 = 0;
      D_V_y58KN_13_1 = 0;
      D_V_y58KN_1_2 = 2 * lambda__1;
      D_V_y58KN_2_2 = 0;
      t7 = 2 * y__1;
      D_V_y58KN_3_2 = -t7;
      D_V_y58KN_4_2 = 0;
      D_V_y58KN_5_2 = v__1;
      D_V_y58KN_6_2 = 0;
      D_V_y58KN_7_2 = t3 * (-y__1 * D_V_y58KN_1_2 - V_y58KN_1);
      D_V_y58KN_8_2 = 0;
      D_V_y58KN_9_2 = 2 * t3 * D_V_y58KN_1_2;
      D_V_y58KN_10_2 = 2 * y__1 * t3;
      D_V_y58KN_11_2 = 0;
      D_V_y58KN_12_2 = 0;
      D_V_y58KN_13_2 = 0;
      D_V_y58KN_1_3 = 0;
      D_V_y58KN_2_3 = 0;
      D_V_y58KN_3_3 = 0;
      D_V_y58KN_4_3 = -2 * x__2;
      D_V_y58KN_5_3 = 0;
      D_V_y58KN_6_3 = u__2;
      D_V_y58KN_7_3 = 0;
      t14 = 0.1e1 / m__2;
      D_V_y58KN_8_3 = -4 * t14 * lambda__2 * x__2;
      D_V_y58KN_9_3 = 0;
      D_V_y58KN_10_3 = 0;
      D_V_y58KN_11_3 = t14 * lambda__2;
      D_V_y58KN_12_3 = 0;
      t17 = x__2 * t14;
      D_V_y58KN_13_3 = 2 * t17;
      D_V_y58KN_1_4 = 0;
      D_V_y58KN_2_4 = 2 * lambda__2;
      D_V_y58KN_3_4 = 0;
      t18 = 2 * y__2;
      D_V_y58KN_4_4 = -t18;
      D_V_y58KN_5_4 = 0;
      D_V_y58KN_6_4 = v__2;
      D_V_y58KN_7_4 = 0;
      D_V_y58KN_8_4 = t14 * (-y__2 * D_V_y58KN_2_4 - V_y58KN_2);
      D_V_y58KN_9_4 = 0;
      D_V_y58KN_10_4 = 0;
      D_V_y58KN_11_4 = 0;
      D_V_y58KN_12_4 = 2 * t14 * D_V_y58KN_2_4;
      D_V_y58KN_13_4 = 2 * y__2 * t14;
      D_V_y58KN_1_5 = 0;
      D_V_y58KN_2_5 = 0;
      D_V_y58KN_3_5 = 0;
      D_V_y58KN_4_5 = 0;
      D_V_y58KN_5_5 = x__1;
      D_V_y58KN_6_5 = 0;
      D_V_y58KN_7_5 = 2 * u__1;
      D_V_y58KN_8_5 = 0;
      D_V_y58KN_9_5 = 0;
      D_V_y58KN_10_5 = 0;
      D_V_y58KN_11_5 = 0;
      D_V_y58KN_12_5 = 0;
      D_V_y58KN_13_5 = 0;
      D_V_y58KN_1_6 = 0;
      D_V_y58KN_2_6 = 0;
      D_V_y58KN_3_6 = 0;
      D_V_y58KN_4_6 = 0;
      D_V_y58KN_5_6 = y__1;
      D_V_y58KN_6_6 = 0;
      D_V_y58KN_7_6 = 2 * v__1;
      D_V_y58KN_8_6 = 0;
      D_V_y58KN_9_6 = 0;
      D_V_y58KN_10_6 = 0;
      D_V_y58KN_11_6 = 0;
      D_V_y58KN_12_6 = 0;
      D_V_y58KN_13_6 = 0;
      D_V_y58KN_1_7 = 0;
      D_V_y58KN_2_7 = 0;
      D_V_y58KN_3_7 = 0;
      D_V_y58KN_4_7 = 0;
      D_V_y58KN_5_7 = 0;
      D_V_y58KN_6_7 = x__2;
      D_V_y58KN_7_7 = 0;
      D_V_y58KN_8_7 = 2 * u__2;
      D_V_y58KN_9_7 = 0;
      D_V_y58KN_10_7 = 0;
      D_V_y58KN_11_7 = 0;
      D_V_y58KN_12_7 = 0;
      D_V_y58KN_13_7 = 0;
      D_V_y58KN_1_8 = 0;
      D_V_y58KN_2_8 = 0;
      D_V_y58KN_3_8 = 0;
      D_V_y58KN_4_8 = 0;
      D_V_y58KN_5_8 = 0;
      D_V_y58KN_6_8 = y__2;
      D_V_y58KN_7_8 = 0;
      D_V_y58KN_8_8 = 2 * v__2;
      D_V_y58KN_9_8 = 0;
      D_V_y58KN_10_8 = 0;
      D_V_y58KN_11_8 = 0;
      D_V_y58KN_12_8 = 0;
      D_V_y58KN_13_8 = 0;
      D_V_y58KN_1_9 = t7;
      D_V_y58KN_2_9 = 0;
      D_V_y58KN_3_9 = 0;
      D_V_y58KN_4_9 = 0;
      D_V_y58KN_5_9 = 0;
      D_V_y58KN_6_9 = 0;
      t23 = x__1 ^ 2;
      D_V_y58KN_7_9 = t3 * (-y__1 * D_V_y58KN_1_9 - 2 * t23);
      D_V_y58KN_8_9 = 0;
      D_V_y58KN_9_9 = 2 * t3 * D_V_y58KN_1_9;
      D_V_y58KN_10_9 = 0;
      D_V_y58KN_11_9 = 0;
      D_V_y58KN_12_9 = 0;
      D_V_y58KN_13_9 = 0;
      D_V_y58KN_1_10 = 0;
      D_V_y58KN_2_10 = t18;
      D_V_y58KN_3_10 = 0;
      D_V_y58KN_4_10 = 0;
      D_V_y58KN_5_10 = 0;
      D_V_y58KN_6_10 = 0;
      D_V_y58KN_7_10 = 0;
      t28 = x__2 ^ 2;
      D_V_y58KN_8_10 = t14 * (-y__2 * D_V_y58KN_2_10 - 2 * t28);
      D_V_y58KN_9_10 = 0;
      D_V_y58KN_10_10 = 0;
      D_V_y58KN_11_10 = t17;
      D_V_y58KN_12_10 = 2 * t14 * D_V_y58KN_2_10;
      D_V_y58KN_13_10 = 0;

      % Store outputs
      out_Jv_x = zeros(13, 10);
      out_Jv_x(1, 1) = D_V_y58KN_1_1;
      out_Jv_x(2, 1) = D_V_y58KN_2_1;
      out_Jv_x(3, 1) = D_V_y58KN_3_1;
      out_Jv_x(4, 1) = D_V_y58KN_4_1;
      out_Jv_x(5, 1) = D_V_y58KN_5_1;
      out_Jv_x(6, 1) = D_V_y58KN_6_1;
      out_Jv_x(7, 1) = D_V_y58KN_7_1;
      out_Jv_x(8, 1) = D_V_y58KN_8_1;
      out_Jv_x(9, 1) = D_V_y58KN_9_1;
      out_Jv_x(10, 1) = D_V_y58KN_10_1;
      out_Jv_x(11, 1) = D_V_y58KN_11_1;
      out_Jv_x(12, 1) = D_V_y58KN_12_1;
      out_Jv_x(13, 1) = D_V_y58KN_13_1;
      out_Jv_x(1, 2) = D_V_y58KN_1_2;
      out_Jv_x(2, 2) = D_V_y58KN_2_2;
      out_Jv_x(3, 2) = D_V_y58KN_3_2;
      out_Jv_x(4, 2) = D_V_y58KN_4_2;
      out_Jv_x(5, 2) = D_V_y58KN_5_2;
      out_Jv_x(6, 2) = D_V_y58KN_6_2;
      out_Jv_x(7, 2) = D_V_y58KN_7_2;
      out_Jv_x(8, 2) = D_V_y58KN_8_2;
      out_Jv_x(9, 2) = D_V_y58KN_9_2;
      out_Jv_x(10, 2) = D_V_y58KN_10_2;
      out_Jv_x(11, 2) = D_V_y58KN_11_2;
      out_Jv_x(12, 2) = D_V_y58KN_12_2;
      out_Jv_x(13, 2) = D_V_y58KN_13_2;
      out_Jv_x(1, 3) = D_V_y58KN_1_3;
      out_Jv_x(2, 3) = D_V_y58KN_2_3;
      out_Jv_x(3, 3) = D_V_y58KN_3_3;
      out_Jv_x(4, 3) = D_V_y58KN_4_3;
      out_Jv_x(5, 3) = D_V_y58KN_5_3;
      out_Jv_x(6, 3) = D_V_y58KN_6_3;
      out_Jv_x(7, 3) = D_V_y58KN_7_3;
      out_Jv_x(8, 3) = D_V_y58KN_8_3;
      out_Jv_x(9, 3) = D_V_y58KN_9_3;
      out_Jv_x(10, 3) = D_V_y58KN_10_3;
      out_Jv_x(11, 3) = D_V_y58KN_11_3;
      out_Jv_x(12, 3) = D_V_y58KN_12_3;
      out_Jv_x(13, 3) = D_V_y58KN_13_3;
      out_Jv_x(1, 4) = D_V_y58KN_1_4;
      out_Jv_x(2, 4) = D_V_y58KN_2_4;
      out_Jv_x(3, 4) = D_V_y58KN_3_4;
      out_Jv_x(4, 4) = D_V_y58KN_4_4;
      out_Jv_x(5, 4) = D_V_y58KN_5_4;
      out_Jv_x(6, 4) = D_V_y58KN_6_4;
      out_Jv_x(7, 4) = D_V_y58KN_7_4;
      out_Jv_x(8, 4) = D_V_y58KN_8_4;
      out_Jv_x(9, 4) = D_V_y58KN_9_4;
      out_Jv_x(10, 4) = D_V_y58KN_10_4;
      out_Jv_x(11, 4) = D_V_y58KN_11_4;
      out_Jv_x(12, 4) = D_V_y58KN_12_4;
      out_Jv_x(13, 4) = D_V_y58KN_13_4;
      out_Jv_x(1, 5) = D_V_y58KN_1_5;
      out_Jv_x(2, 5) = D_V_y58KN_2_5;
      out_Jv_x(3, 5) = D_V_y58KN_3_5;
      out_Jv_x(4, 5) = D_V_y58KN_4_5;
      out_Jv_x(5, 5) = D_V_y58KN_5_5;
      out_Jv_x(6, 5) = D_V_y58KN_6_5;
      out_Jv_x(7, 5) = D_V_y58KN_7_5;
      out_Jv_x(8, 5) = D_V_y58KN_8_5;
      out_Jv_x(9, 5) = D_V_y58KN_9_5;
      out_Jv_x(10, 5) = D_V_y58KN_10_5;
      out_Jv_x(11, 5) = D_V_y58KN_11_5;
      out_Jv_x(12, 5) = D_V_y58KN_12_5;
      out_Jv_x(13, 5) = D_V_y58KN_13_5;
      out_Jv_x(1, 6) = D_V_y58KN_1_6;
      out_Jv_x(2, 6) = D_V_y58KN_2_6;
      out_Jv_x(3, 6) = D_V_y58KN_3_6;
      out_Jv_x(4, 6) = D_V_y58KN_4_6;
      out_Jv_x(5, 6) = D_V_y58KN_5_6;
      out_Jv_x(6, 6) = D_V_y58KN_6_6;
      out_Jv_x(7, 6) = D_V_y58KN_7_6;
      out_Jv_x(8, 6) = D_V_y58KN_8_6;
      out_Jv_x(9, 6) = D_V_y58KN_9_6;
      out_Jv_x(10, 6) = D_V_y58KN_10_6;
      out_Jv_x(11, 6) = D_V_y58KN_11_6;
      out_Jv_x(12, 6) = D_V_y58KN_12_6;
      out_Jv_x(13, 6) = D_V_y58KN_13_6;
      out_Jv_x(1, 7) = D_V_y58KN_1_7;
      out_Jv_x(2, 7) = D_V_y58KN_2_7;
      out_Jv_x(3, 7) = D_V_y58KN_3_7;
      out_Jv_x(4, 7) = D_V_y58KN_4_7;
      out_Jv_x(5, 7) = D_V_y58KN_5_7;
      out_Jv_x(6, 7) = D_V_y58KN_6_7;
      out_Jv_x(7, 7) = D_V_y58KN_7_7;
      out_Jv_x(8, 7) = D_V_y58KN_8_7;
      out_Jv_x(9, 7) = D_V_y58KN_9_7;
      out_Jv_x(10, 7) = D_V_y58KN_10_7;
      out_Jv_x(11, 7) = D_V_y58KN_11_7;
      out_Jv_x(12, 7) = D_V_y58KN_12_7;
      out_Jv_x(13, 7) = D_V_y58KN_13_7;
      out_Jv_x(1, 8) = D_V_y58KN_1_8;
      out_Jv_x(2, 8) = D_V_y58KN_2_8;
      out_Jv_x(3, 8) = D_V_y58KN_3_8;
      out_Jv_x(4, 8) = D_V_y58KN_4_8;
      out_Jv_x(5, 8) = D_V_y58KN_5_8;
      out_Jv_x(6, 8) = D_V_y58KN_6_8;
      out_Jv_x(7, 8) = D_V_y58KN_7_8;
      out_Jv_x(8, 8) = D_V_y58KN_8_8;
      out_Jv_x(9, 8) = D_V_y58KN_9_8;
      out_Jv_x(10, 8) = D_V_y58KN_10_8;
      out_Jv_x(11, 8) = D_V_y58KN_11_8;
      out_Jv_x(12, 8) = D_V_y58KN_12_8;
      out_Jv_x(13, 8) = D_V_y58KN_13_8;
      out_Jv_x(1, 9) = D_V_y58KN_1_9;
      out_Jv_x(2, 9) = D_V_y58KN_2_9;
      out_Jv_x(3, 9) = D_V_y58KN_3_9;
      out_Jv_x(4, 9) = D_V_y58KN_4_9;
      out_Jv_x(5, 9) = D_V_y58KN_5_9;
      out_Jv_x(6, 9) = D_V_y58KN_6_9;
      out_Jv_x(7, 9) = D_V_y58KN_7_9;
      out_Jv_x(8, 9) = D_V_y58KN_8_9;
      out_Jv_x(9, 9) = D_V_y58KN_9_9;
      out_Jv_x(10, 9) = D_V_y58KN_10_9;
      out_Jv_x(11, 9) = D_V_y58KN_11_9;
      out_Jv_x(12, 9) = D_V_y58KN_12_9;
      out_Jv_x(13, 9) = D_V_y58KN_13_9;
      out_Jv_x(1, 10) = D_V_y58KN_1_10;
      out_Jv_x(2, 10) = D_V_y58KN_2_10;
      out_Jv_x(3, 10) = D_V_y58KN_3_10;
      out_Jv_x(4, 10) = D_V_y58KN_4_10;
      out_Jv_x(5, 10) = D_V_y58KN_5_10;
      out_Jv_x(6, 10) = D_V_y58KN_6_10;
      out_Jv_x(7, 10) = D_V_y58KN_7_10;
      out_Jv_x(8, 10) = D_V_y58KN_8_10;
      out_Jv_x(9, 10) = D_V_y58KN_9_10;
      out_Jv_x(10, 10) = D_V_y58KN_10_10;
      out_Jv_x(11, 10) = D_V_y58KN_11_10;
      out_Jv_x(12, 10) = D_V_y58KN_12_10;
      out_Jv_x(13, 10) = D_V_y58KN_13_10;
    end % Jv_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_h = h( ~, ~, in_2, ~ )
      % Calculate the residual of the invariants h.

      % Extract properties
      % No properties

      % Extract inputs
      V_y58KN_3 = in_2(3);
      V_y58KN_4 = in_2(4);
      V_y58KN_5 = in_2(5);
      V_y58KN_6 = in_2(6);
      V_y58KN_7 = in_2(7);
      V_y58KN_8 = in_2(8);

      % Evaluate function
      out_1 = V_y58KN_3;
      out_2 = V_y58KN_4;
      out_3 = 2 * V_y58KN_5;
      out_4 = 2 * V_y58KN_6;
      out_5 = -2 * V_y58KN_7;
      out_6 = -2 * V_y58KN_8;

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
    function out_Jh_x = Jh_x( ~, ~, ~, ~ )
      % Calculate the Jacobian of h with respect to x.

      % Extract properties
      % No properties

      % Extract inputs

      % Evaluate function
      % No body

      % Store outputs
      out_Jh_x = zeros(6, 10);
    end % Jh_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_v = Jh_v( ~, ~, ~, ~ )
      % Calculate the Jacobian of h with respect to v.

      % Extract properties
      % No properties

      % Extract inputs

      % Evaluate function
      out_1_3 = 1;
      out_2_4 = 1;
      out_3_5 = 2;
      out_4_6 = 2;
      out_5_7 = -2;
      out_6_8 = -2;

      % Store outputs
      out_Jh_v = zeros(6, 13);
      out_Jh_v(1, 3) = out_1_3;
      out_Jh_v(2, 4) = out_2_4;
      out_Jh_v(3, 5) = out_3_5;
      out_Jh_v(4, 6) = out_4_6;
      out_Jh_v(5, 7) = out_5_7;
      out_Jh_v(6, 8) = out_6_8;
    end % Jh_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = in_domain( ~, ~, ~ )
      out = true;
    end % in_domain
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end % DoublePendulum

% That's All Folks!
