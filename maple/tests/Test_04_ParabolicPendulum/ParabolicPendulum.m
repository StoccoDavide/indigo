% +--------------------------------------------------------------------------+
% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |
% | Current version authors:                                                 |
% |   Davide Stocco and Enrico Bertolazzi.                                   |
% +--------------------------------------------------------------------------+

% Matlab generated code for implicit system: ParabolicPendulum
% This file has been automatically generated by Indigo.
% DISCLAIMER: If you need to edit it, do it wisely!

classdef ParabolicPendulum < ImplicitSystem
  %
  % No class description provided.
  %
  properties (SetAccess = protected, Hidden = true)
    % User data
    m_g = 9.81;
    m_m = 1;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = ParabolicPendulum( varargin )
      % Constructor for 'ParabolicPendulum' class.

      % Superclass constructor
      num_equations  = 5;
      num_invariants = 3;
      this = this@ImplicitSystem('ParabolicPendulum', num_equations, num_invariants);
      % User data
      if (nargin == 0)
        % Keep default values
      elseif (nargin == 2)
        this.m_g = varargin{1};
        this.m_m = varargin{2};
      else
        error('wrong number of input arguments.');
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_F = F( this, in_1, in_2, t )
      % Calculate the residual of the implicit system F(x, x_dot).
      % Extract properties
      g = this.m_g;
      m = this.m_m;

      % Extract inputs
      x = in_1(1);
      y = in_1(2);
      u = in_1(3);
      v = in_1(4);
      lambda = in_1(5);
      x_dot = in_2(1);
      y_dot = in_2(2);
      u_dot = in_2(3);
      v_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate assignments
      % No assignments

      % Evaluate elements
      t1 = x ^ 2;
      t2 = t1 ^ 2;
      t8 = y ^ 2;
      t11 = y * t1;
      t20 = t1 * x;
      t21 = t20 * lambda;
      t24 = u ^ 2;
      t28 = x * lambda;
      t31 = x * t24;
      t34 = y * t28;
      t42 = 384 * t2 * x * lambda - 2 * g * x - 256 * t20 * t24 - 512 * y * t21 + 128 * t8 * t28 + 128 * y * t31 + 8 * u * v + 144 * t21 + 8 * t28 - 64 * t31 - 80 * t34;
      t44 = t2 * lambda;
      t46 = lambda * t11;
      t48 = t24 * t1;
      t50 = t1 * lambda;
      t52 = y * lambda;
      t59 = t1 * u;
      out_1 = lambda_dot * (64 * t2 * t1 + 64 * t8 * t1 - 128 * y * t2 + 4 * t1 - 40 * t11 + 36 * t2 + 4 * t8) + x_dot * t42 + y_dot * (-128 * t44 + 128 * t46 + 64 * t48 - 40 * t50 + 8 * t52 + 8 * t24 + g) + u_dot * (-128 * t2 * u + 128 * y * t59 + 16 * u * y + 8 * v * x - 64 * t59 - 4 * u) + (8 * x * u - 4 * v) * v_dot;
      out_2 = y_dot - v;
      out_3 = 8 * t21 - 8 * t34 - 8 * t31 + 2 * t28 + u_dot;
      out_4 = v_dot + 2 * t24 + g / 2 - 6 * t50 + 2 * t52 - 16 * t44 + 16 * t48 + 16 * t46;
      out_5 = x_dot - u;

      % Store outputs
      out_F = zeros(5,1);
      out_F(1) = out_1;
      out_F(2) = out_2;
      out_F(3) = out_3;
      out_F(4) = out_4;
      out_F(5) = out_5;
    end % F
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function [out, out_dot] = JF( this, x, x_dot, t )

      % Calulate Jacobians
      out     = this.JF_x(x, x_dot, t);
      out_dot = this.JF_x_dot(x, x_dot, t);
    end % JF
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x = JF_x( this, in_1, in_2, t )
      % Calculate the Jacobian of F with respect to x.

      % Extract properties
      g = this.m_g;
      m = this.m_m;

      % Extract inputs
      x = in_1(1);
      y = in_1(2);
      u = in_1(3);
      v = in_1(4);
      lambda = in_1(5);
      x_dot = in_2(1);
      y_dot = in_2(2);
      u_dot = in_2(3);
      v_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate assignments
      % None

      % Evaluate function
      t1 = x ^ 2;
      t2 = t1 ^ 2;
      t5 = t1 * x;
      t9 = y ^ 2;
      t12 = x * y;
      t15 = 384 * t2 * x - 512 * y * t5 + 128 * t9 * x - 80 * t12 + 144 * t5 + 8 * x;
      t19 = y * t1;
      t22 = u ^ 2;
      t25 = t1 * lambda;
      t31 = y * lambda;
      t35 = 8 * lambda;
      t38 = t5 * lambda;
      t40 = x * lambda;
      t41 = y * t40;
      t43 = x * t22;
      t46 = -512 * t38 + 256 * t41 + 128 * t43 - 80 * t40;
      t50 = x * u;
      t55 = -512 * t5 * u + 256 * y * t50 - 128 * t50 + 8 * v;
      out_1_1 = lambda_dot * t15 + x_dot * (-1536 * lambda * t19 + 1920 * t2 * lambda + 128 * t9 * lambda - 768 * t22 * t1 + 128 * y * t22 - 2 * g - 64 * t22 + 432 * t25 - 80 * t31 + t35) + y_dot * t46 + u_dot * t55 + 8 * u * v_dot;
      t59 = 128 * t2;
      t60 = 128 * t19;
      t63 = -t59 + t60 - 40 * t1 + 8 * y;
      t69 = t1 * u;
      t72 = 128 * t69 + 16 * u;
      out_1_2 = lambda_dot * t63 + x_dot * t46 + y_dot * (128 * t25 + t35) + u_dot * t72;
      out_1_3 = x_dot * t55 + y_dot * t72 + u_dot * (-t59 + t60 - 64 * t1 + 16 * y - 4) + 8 * x * v_dot;
      out_1_4 = 8 * u * x_dot + 8 * x * u_dot - 4 * v_dot;
      out_1_5 = x_dot * t15 + y_dot * t63;
      out_2_4 = -1;
      t92 = 2 * lambda;
      out_3_1 = 24 * t25 - 8 * t31 - 8 * t22 + t92;
      out_3_2 = -8 * t40;
      out_3_3 = -16 * t50;
      out_3_5 = 8 * t5 - 8 * t12 + 2 * x;
      out_4_1 = -64 * t38 + 32 * t41 + 32 * t43 - 12 * t40;
      out_4_2 = 16 * t25 + t92;
      out_4_3 = 32 * t69 + 4 * u;
      out_4_5 = -16 * t2 + 16 * t19 - 6 * t1 + 2 * y;
      out_5_3 = -1;

      % Store outputs
      out_JF_x = zeros(5,5);
      out_JF_x(1,1) = out_1_1;
      out_JF_x(1,2) = out_1_2;
      out_JF_x(1,3) = out_1_3;
      out_JF_x(1,4) = out_1_4;
      out_JF_x(1,5) = out_1_5;
      out_JF_x(2,4) = out_2_4;
      out_JF_x(3,1) = out_3_1;
      out_JF_x(3,2) = out_3_2;
      out_JF_x(3,3) = out_3_3;
      out_JF_x(3,5) = out_3_5;
      out_JF_x(4,1) = out_4_1;
      out_JF_x(4,2) = out_4_2;
      out_JF_x(4,3) = out_4_3;
      out_JF_x(4,5) = out_4_5;
      out_JF_x(5,3) = out_5_3;
    end % JF_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x_dot = JF_x_dot( this, in_1, in_2, t )
      % Calculate the Jacobian of F with respect to x_dot.

      % Extract properties
      g = this.m_g;
      m = this.m_m;

      % Extract inputs
      x = in_1(1);
      y = in_1(2);
      u = in_1(3);
      v = in_1(4);
      lambda = in_1(5);
      x_dot = in_2(1);
      y_dot = in_2(2);
      u_dot = in_2(3);
      v_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate assignments
      % None

      % Evaluate function
      t1 = x ^ 2;
      t2 = t1 ^ 2;
      t6 = t1 * x;
      t7 = t6 * lambda;
      t10 = u ^ 2;
      t14 = x * lambda;
      t15 = y ^ 2;
      t18 = x * t10;
      out_1_1 = 384 * t2 * x * lambda - 2 * g * x - 256 * t6 * t10 + 128 * t15 * t14 - 80 * y * t14 + 128 * y * t18 - 512 * y * t7 + 8 * u * v + 8 * t14 - 64 * t18 + 144 * t7;
      t31 = y * t1;
      out_1_2 = -40 * lambda * t1 - 128 * lambda * t2 + 128 * lambda * t31 + 8 * y * lambda + 64 * t10 * t1 + g + 8 * t10;
      t43 = t1 * u;
      out_1_3 = -128 * t2 * u + 128 * y * t43 + 16 * u * y + 8 * v * x - 64 * t43 - 4 * u;
      out_1_4 = 8 * x * u - 4 * v;
      out_1_5 = 64 * t15 * t1 + 64 * t2 * t1 - 128 * y * t2 + 4 * t1 + 4 * t15 + 36 * t2 - 40 * t31;
      out_2_2 = 1;
      out_3_3 = 1;
      out_4_4 = 1;
      out_5_1 = 1;

      % Store outputs
      out_JF_x_dot = zeros(5,5);
      out_JF_x_dot(1,1) = out_1_1;
      out_JF_x_dot(1,2) = out_1_2;
      out_JF_x_dot(1,3) = out_1_3;
      out_JF_x_dot(1,4) = out_1_4;
      out_JF_x_dot(1,5) = out_1_5;
      out_JF_x_dot(2,2) = out_2_2;
      out_JF_x_dot(3,3) = out_3_3;
      out_JF_x_dot(4,4) = out_4_4;
      out_JF_x_dot(5,1) = out_5_1;
    end % JF_x_dot
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_h = h( this, in_1, t )
      % Calculate the residual of the invariants h.
      % Extract properties
      g = this.m_g;
      m = this.m_m;

      % Extract inputs
      x = in_1(1);
      y = in_1(2);
      u = in_1(3);
      v = in_1(4);
      lambda = in_1(5);

      % Evaluate assignments
      % No assignments

      % Evaluate elements
      t1 = x ^ 2;
      t2 = t1 ^ 2;
      t3 = y * t1;
      t5 = y ^ 2;
      out_1 = -t2 + 2 * t3 - t1 - t5 + 1;
      t9 = x * u;
      out_2 = 4 * t1 * x * u - 2 * t1 * v - 4 * y * t9 + 2 * v * y + 2 * t9;
      t20 = lambda * t2;
      t23 = u ^ 2;
      t27 = lambda * t1;
      t30 = t1 * t23;
      t47 = v ^ 2;
      out_3 = 64 * t2 * t1 * lambda + 8 * u * v * x - t1 * g + g * y - 40 * lambda * t3 + 4 * t5 * lambda - 64 * t2 * t23 - 128 * y * t20 + 8 * y * t23 + 64 * t5 * t27 + 64 * y * t30 + 36 * t20 - 2 * t23 + 4 * t27 - 32 * t30 - 2 * t47;

      % Store outputs
      out_h = zeros(3,1);
      out_h(1) = out_1;
      out_h(2) = out_2;
      out_h(3) = out_3;
    end % h
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh = Jh( this, in_1, t )
      % Calculate the Jacobian of h with respect to x.

      % Extract properties
      g = this.m_g;
      m = this.m_m;

      % Extract inputs
      x = in_1(1);
      y = in_1(2);
      u = in_1(3);
      v = in_1(4);
      lambda = in_1(5);

      % Evaluate assignments
      % None

      % Evaluate function
      t1 = x ^ 2;
      t2 = t1 * x;
      out_1_1 = 4 * x * y - 4 * t2 - 2 * x;
      out_1_2 = 2 * t1 - 2 * y;
      t8 = t1 * u;
      t10 = u * y;
      t12 = v * x;
      out_2_1 = 12 * t8 - 4 * t10 - 4 * t12 + 2 * u;
      t15 = x * u;
      out_2_2 = -4 * t15 + 2 * v;
      out_2_3 = -out_1_1;
      out_2_4 = -out_1_2;
      t18 = t1 ^ 2;
      t22 = lambda * t2;
      t25 = u ^ 2;
      t29 = x * lambda;
      t30 = y ^ 2;
      t33 = x * t25;
      out_3_1 = 384 * t18 * x * lambda - 2 * g * x - 256 * t2 * t25 - 512 * y * t22 + 128 * t30 * t29 - 80 * y * t29 + 128 * y * t33 + 8 * u * v + 144 * t22 + 8 * t29 - 64 * t33;
      t46 = y * t1;
      out_3_2 = -40 * lambda * t1 - 128 * lambda * t18 + 128 * lambda * t46 + 8 * y * lambda + 64 * t25 * t1 + g + 8 * t25;
      out_3_3 = -128 * t18 * u + 128 * y * t8 + 16 * t10 + 8 * t12 - 64 * t8 - 4 * u;
      out_3_4 = 8 * t15 - 4 * v;
      out_3_5 = 64 * t18 * t1 + 64 * t30 * t1 - 128 * y * t18 + 4 * t1 + 36 * t18 + 4 * t30 - 40 * t46;

      % Store outputs
      out_Jh = zeros(3,5);
      out_Jh(1,1) = out_1_1;
      out_Jh(1,2) = out_1_2;
      out_Jh(2,1) = out_2_1;
      out_Jh(2,2) = out_2_2;
      out_Jh(2,3) = out_2_3;
      out_Jh(2,4) = out_2_4;
      out_Jh(3,1) = out_3_1;
      out_Jh(3,2) = out_3_2;
      out_Jh(3,3) = out_3_3;
      out_Jh(3,4) = out_3_4;
      out_Jh(3,5) = out_3_5;
    end % Jh
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end % ParabolicPendulum

% That's All Folks!