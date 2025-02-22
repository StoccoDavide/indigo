% +--------------------------------------------------------------------------+
% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |
% | Current version authors:                                                 |
% |   Davide Stocco and Enrico Bertolazzi.                                   |
% +--------------------------------------------------------------------------+

% Matlab generated code for implicit system: Akzo
% This file has been automatically generated by Indigo.
% DISCLAIMER: If you need to edit it, do it wisely!

classdef Akzo < Indigo.DAE.Implicit
  %
  % No class description provided.
  %
  properties (SetAccess = protected, Hidden = true)
    % User data
    m_k__1 = 18.7;
    m_k__2 = .58;
    m_k__3 = .9e-1;
    m_k__4 = .42;
    m_K = 34.4;
    m_klA = 3.3;
    m_K__s = 115.83;
    m_p__CO2 = .9;
    m_H = 737.0;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = Akzo( varargin )
      % Class constructor.

      % Superclass constructor
      num_eqns = 6;
      num_veil = 0;
      num_invs = 1;
      this = this@Indigo.DAE.Implicit('Akzo', num_eqns, num_veil, num_invs);

      % User data
      if (nargin == 0)
        % Keep default values
      elseif (nargin == 1 && isstruct(varargin{1}))
        this.m_k__1 = varargin{1}.k__1;
        this.m_k__2 = varargin{1}.k__2;
        this.m_k__3 = varargin{1}.k__3;
        this.m_k__4 = varargin{1}.k__4;
        this.m_K = varargin{1}.K;
        this.m_klA = varargin{1}.klA;
        this.m_K__s = varargin{1}.K__s;
        this.m_p__CO2 = varargin{1}.p__CO2;
        this.m_H = varargin{1}.H;
      elseif (nargin == 9)
        this.m_k__1 = varargin{1};
        this.m_k__2 = varargin{2};
        this.m_k__3 = varargin{3};
        this.m_k__4 = varargin{4};
        this.m_K = varargin{5};
        this.m_klA = varargin{6};
        this.m_K__s = varargin{7};
        this.m_p__CO2 = varargin{8};
        this.m_H = varargin{9};
      else
        error('wrong number of input arguments.');
      end
    end % Akzo
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_F = F( this, in_1, in_2, ~, ~ )
      % Evaluate the function F.

      % Extract properties
      k__1 = this.m_k__1;
      k__2 = this.m_k__2;
      k__3 = this.m_k__3;
      k__4 = this.m_k__4;
      K = this.m_K;
      klA = this.m_klA;
      K__s = this.m_K__s;
      p__CO2 = this.m_p__CO2;
      H = this.m_H;

      % Extract inputs
      y__1 = in_1(1);
      y__2 = in_1(2);
      y__3 = in_1(3);
      y__4 = in_1(4);
      y__5 = in_1(5);
      y__6 = in_1(6);
      y__1_dot = in_2(1);
      y__2_dot = in_2(2);
      y__3_dot = in_2(3);
      y__4_dot = in_2(4);
      y__5_dot = in_2(5);
      y__6_dot = in_2(6);

      % Evaluate function
      t1 = y__1 ^ 2;
      t2 = t1 ^ 2;
      t3 = t2 * k__1;
      t4 = sqrt(y__2);
      t5 = K * t4;
      t6 = t5 * t3;
      t8 = k__3 * y__1;
      t9 = y__4 ^ 2;
      t11 = K * t9 * t8;
      t14 = k__2 * y__3 * y__4 * K;
      t16 = k__2 * y__1 * y__5;
      t19 = 0.1e1 / K;
      out_1 = t19 * (y__1_dot * K + t11 - t14 + t16 + 2 * t6);
      t20 = y__6 ^ 2;
      t21 = k__4 * t20;
      out_2 = 0.1e1 / H * (t4 * (t3 + t21) * H + 2 * y__2_dot * H + 2 * H * t9 * t8 + 2 * klA * (H * y__2 - p__CO2)) / 2;
      out_3 = t19 * (y__3_dot * K + t14 - t16 - t6);
      out_4 = y__4_dot + t19 * (2 * t11 + t14 - t16);
      out_5 = t19 * (y__5_dot * K - t5 * t21 - t14 + t16);
      out_6 = K__s * y__1 * y__4_dot + K__s * y__1_dot * y__4 - y__6_dot;

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
    function out_JF_x = JF_x( this, in_1, in_2, ~, ~ )
      % Evaluate the Jacobian of F with respect to x.

      % Extract properties
      k__1 = this.m_k__1;
      k__2 = this.m_k__2;
      k__3 = this.m_k__3;
      k__4 = this.m_k__4;
      K = this.m_K;
      klA = this.m_klA;
      K__s = this.m_K__s;
      H = this.m_H;

      % Extract inputs
      y__1 = in_1(1);
      y__2 = in_1(2);
      y__3 = in_1(3);
      y__4 = in_1(4);
      y__5 = in_1(5);
      y__6 = in_1(6);
      y__1_dot = in_2(1);
      y__4_dot = in_2(4);

      % Evaluate function
      t1 = y__1 ^ 2;
      t2 = t1 * y__1;
      t4 = sqrt(y__2);
      t6 = K * t4 * t2 * k__1;
      t8 = y__4 ^ 2;
      t9 = t8 * k__3;
      t10 = K * t9;
      t11 = k__2 * y__5;
      t13 = 0.1e1 / K;
      out_1_1 = t13 * (8 * t6 + t10 + t11);
      t21 = 0.1e1 / H;
      out_2_1 = t21 * (4 * t4 * t2 * H * k__1 + 2 * H * t9) / 2;
      out_3_1 = t13 * (-4 * t6 - t11);
      out_4_1 = t13 * (2 * t10 - t11);
      out_5_1 = t13 * t11;
      out_6_1 = K__s * y__4_dot;
      t27 = t1 ^ 2;
      t28 = t27 * k__1;
      t29 = 0.1e1 / t4;
      out_1_2 = t29 * t28;
      t30 = y__6 ^ 2;
      t31 = k__4 * t30;
      out_2_2 = t21 * (t29 * (t28 + t31) * H / 2 + 2 * klA * H) / 2;
      out_3_2 = -out_1_2 / 2;
      out_5_2 = -t29 * t31 / 2;
      t43 = k__2 * y__4;
      out_1_3 = -t43;
      out_3_3 = t43;
      out_4_3 = out_3_3;
      out_5_3 = out_1_3;
      t44 = k__3 * y__1;
      t46 = y__4 * K * t44;
      t49 = k__2 * y__3 * K;
      out_1_4 = t13 * (2 * t46 - t49);
      out_2_4 = 2 * y__4 * t44;
      out_3_4 = k__2 * y__3;
      out_4_4 = t13 * (4 * t46 + t49);
      out_5_4 = -out_3_4;
      out_6_4 = K__s * y__1_dot;
      out_1_5 = t13 * y__1 * k__2;
      out_3_5 = -out_1_5;
      out_4_5 = out_3_5;
      out_5_5 = out_1_5;
      out_2_6 = t4 * k__4 * y__6;
      out_5_6 = -2 * out_2_6;

      % Store outputs
      out_JF_x = zeros(6, 6);
      out_JF_x(1, 1) = out_1_1;
      out_JF_x(2, 1) = out_2_1;
      out_JF_x(3, 1) = out_3_1;
      out_JF_x(4, 1) = out_4_1;
      out_JF_x(5, 1) = out_5_1;
      out_JF_x(6, 1) = out_6_1;
      out_JF_x(1, 2) = out_1_2;
      out_JF_x(2, 2) = out_2_2;
      out_JF_x(3, 2) = out_3_2;
      out_JF_x(5, 2) = out_5_2;
      out_JF_x(1, 3) = out_1_3;
      out_JF_x(3, 3) = out_3_3;
      out_JF_x(4, 3) = out_4_3;
      out_JF_x(5, 3) = out_5_3;
      out_JF_x(1, 4) = out_1_4;
      out_JF_x(2, 4) = out_2_4;
      out_JF_x(3, 4) = out_3_4;
      out_JF_x(4, 4) = out_4_4;
      out_JF_x(5, 4) = out_5_4;
      out_JF_x(6, 4) = out_6_4;
      out_JF_x(1, 5) = out_1_5;
      out_JF_x(3, 5) = out_3_5;
      out_JF_x(4, 5) = out_4_5;
      out_JF_x(5, 5) = out_5_5;
      out_JF_x(2, 6) = out_2_6;
      out_JF_x(5, 6) = out_5_6;
    end % JF_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x_dot = JF_x_dot( this, in_1, ~, ~, ~ )
      % Evaluate the Jacobian of F with respect to x_dot.

      % Extract properties
      K__s = this.m_K__s;

      % Extract inputs
      y__1 = in_1(1);
      y__4 = in_1(4);

      % Evaluate function
      out_1_1 = 1;
      out_6_1 = K__s * y__4;
      out_2_2 = 1;
      out_3_3 = 1;
      out_4_4 = 1;
      out_6_4 = K__s * y__1;
      out_5_5 = 1;
      out_6_6 = -1;

      % Store outputs
      out_JF_x_dot = zeros(6, 6);
      out_JF_x_dot(1, 1) = out_1_1;
      out_JF_x_dot(6, 1) = out_6_1;
      out_JF_x_dot(2, 2) = out_2_2;
      out_JF_x_dot(3, 3) = out_3_3;
      out_JF_x_dot(4, 4) = out_4_4;
      out_JF_x_dot(6, 4) = out_6_4;
      out_JF_x_dot(5, 5) = out_5_5;
      out_JF_x_dot(6, 6) = out_6_6;
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
      out_JF_v = zeros(6, 0);
    end % JF_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_v = v( ~, ~, ~ )
      % Evaluate the the veils v.

      % Extract properties
      % No properties

      % Extract inputs

      % Evaluate function
      % No body

      % Store outputs
      out_v = zeros(0, 1);
    end % v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jv_x = Jv_x( ~, ~, ~, ~ )
      % Evaluate the Jacobian of v with respect to x.

      % Extract properties
      % No properties

      % Extract inputs

      % Evaluate function
      % No body

      % Store outputs
      out_Jv_x = zeros(0, 6);
    end % Jv_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_h = h( this, in_1, ~, ~ )
      % Calculate the residual of the invariants h.

      % Extract properties
      K__s = this.m_K__s;

      % Extract inputs
      y__1 = in_1(1);
      y__4 = in_1(4);
      y__6 = in_1(6);

      % Evaluate function
      out_1 = K__s * y__1 * y__4 - y__6;

      % Store outputs
      out_h = zeros(1, 1);
      out_h(1) = out_1;
    end % h
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_x = Jh_x( this, in_1, ~, ~ )
      % Calculate the Jacobian of h with respect to x.

      % Extract properties
      K__s = this.m_K__s;

      % Extract inputs
      y__1 = in_1(1);
      y__4 = in_1(4);

      % Evaluate function
      out_1_1 = K__s * y__4;
      out_1_4 = K__s * y__1;
      out_1_6 = -1;

      % Store outputs
      out_Jh_x = zeros(1, 6);
      out_Jh_x(1, 1) = out_1_1;
      out_Jh_x(1, 4) = out_1_4;
      out_Jh_x(1, 6) = out_1_6;
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
      % No body

      % Store outputs
      out_Jh_v = zeros(1, 0);
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
end % Akzo

% That's All Folks!
