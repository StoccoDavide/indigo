% +--------------------------------------------------------------------------+
% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |
% | Current version authors:                                                 |
% |   Davide Stocco and Enrico Bertolazzi.                                   |
% +--------------------------------------------------------------------------+

% Matlab generated code for implicit system: SliderCrankRigid
% This file has been automatically generated by Indigo.
% DISCLAIMER: If you need to edit it, do it wisely!

classdef SliderCrankRigid < Indigo.DAE.Implicit
  %
  % No class description provided.
  %
  properties (SetAccess = protected, Hidden = true)
    % User data
    m_l__1 = .15;
    m_l__2 = .3;
    m_m__1 = .36;
    m_m__2 = .151104;
    m_m__3 = .75552e-1;
    m_J__1 = .2727e-2;
    m_J__2 = .45339259e-2;
    m_h = .8e-2;
    m_d = .8e-2;
    m_rho = 7870;
    m_E = .20e12;
    m_Omega = 150;
    m_theta = 0;
    m_C__1 = 0;
    m_C__2 = 0;
    m_C__3 = 0;
    m_C__4 = 0;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = SliderCrankRigid( varargin )
      % Class constructor.

      % Superclass constructor
      num_eqns = 9;
      num_veil = 0;
      num_invs = 3;
      this = this@Indigo.DAE.Implicit('SliderCrankRigid', num_eqns, num_veil, num_invs);

      % User data
      if (nargin == 0)
        % Keep default values
      elseif (nargin == 1 && isstruct(varargin{1}))
        this.m_l__1 = varargin{1}.l__1;
        this.m_l__2 = varargin{1}.l__2;
        this.m_m__1 = varargin{1}.m__1;
        this.m_m__2 = varargin{1}.m__2;
        this.m_m__3 = varargin{1}.m__3;
        this.m_J__1 = varargin{1}.J__1;
        this.m_J__2 = varargin{1}.J__2;
        this.m_h = varargin{1}.h;
        this.m_d = varargin{1}.d;
        this.m_rho = varargin{1}.rho;
        this.m_E = varargin{1}.E;
        this.m_Omega = varargin{1}.Omega;
        this.m_theta = varargin{1}.theta;
        this.m_C__1 = varargin{1}.C__1;
        this.m_C__2 = varargin{1}.C__2;
        this.m_C__3 = varargin{1}.C__3;
        this.m_C__4 = varargin{1}.C__4;
      elseif (nargin == 17)
        this.m_l__1 = varargin{1};
        this.m_l__2 = varargin{2};
        this.m_m__1 = varargin{3};
        this.m_m__2 = varargin{4};
        this.m_m__3 = varargin{5};
        this.m_J__1 = varargin{6};
        this.m_J__2 = varargin{7};
        this.m_h = varargin{8};
        this.m_d = varargin{9};
        this.m_rho = varargin{10};
        this.m_E = varargin{11};
        this.m_Omega = varargin{12};
        this.m_theta = varargin{13};
        this.m_C__1 = varargin{14};
        this.m_C__2 = varargin{15};
        this.m_C__3 = varargin{16};
        this.m_C__4 = varargin{17};
      else
        error('wrong number of input arguments.');
      end
    end % SliderCrankRigid
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_F = F( this, in_1, in_2, ~, t )
      % Evaluate the function F.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;
      Omega = this.m_Omega;
      theta = this.m_theta;

      % Extract inputs
      phi__1 = in_1(1);
      phi__2 = in_1(2);
      x__3 = in_1(3);
      phi__1__dot = in_1(4);
      phi__2__dot = in_1(5);
      x__3__dot = in_1(6);
      lambda__1 = in_1(7);
      lambda__2 = in_1(8);
      lambda__3 = in_1(9);
      phi__1_dot = in_2(1);
      phi__2_dot = in_2(2);
      x__3_dot = in_2(3);
      phi__1__dot_dot = in_2(4);
      phi__2__dot_dot = in_2(5);
      x__3__dot_dot = in_2(6);

      % Evaluate function
      out_1 = -phi__1__dot + phi__1_dot;
      out_2 = -phi__2__dot + phi__2_dot;
      out_3 = -x__3__dot + x__3_dot;
      out_4 = m__3 * x__3__dot_dot + lambda__2;
      t2 = l__1 * l__2;
      t3 = phi__1 - phi__2;
      t4 = cos(t3);
      t9 = sin(t3);
      t10 = phi__1_dot ^ 2;
      t18 = theta * m__2 / 2 + lambda__1;
      t19 = cos(phi__2);
      t21 = sin(phi__2);
      out_5 = phi__1__dot_dot * t4 * m__2 * t2 / 2 - m__2 * t2 * t10 * t9 / 2 + J__2 * phi__2__dot_dot + l__2 * (t19 * t18 + lambda__2 * t21);
      t25 = l__1 ^ 2;
      t27 = l__2 ^ 2;
      t28 = m__2 ^ 2;
      t29 = t28 * t27;
      t30 = 2 * t3;
      t31 = cos(t30);
      t35 = sin(t30);
      t41 = phi__1 - 2 * phi__2;
      t42 = cos(t41);
      t47 = m__2 * t27;
      t48 = sin(t41);
      t52 = phi__2_dot ^ 2;
      t59 = J__2 * m__2;
      t68 = -t47 / 4 + J__2;
      t78 = cos(phi__1);
      t82 = sin(phi__1);
      t83 = t82 * l__1;
      out_6 = 0.1e1 / J__2 * (-t31 * t29 * t25 * phi__1__dot_dot + t35 * t29 * t25 * t10 - 2 * t42 * t18 * t27 * l__1 * m__2 + 2 * t48 * t47 * lambda__2 * l__1 + 4 * l__2 * m__2 * J__2 * l__1 * t52 * t9 + phi__1__dot_dot * (t25 * (-t29 + 8 * t59) + 8 * J__1 * J__2) + 8 * t78 * l__1 * (lambda__1 * t68 + (-t29 / 4 + J__2 * m__1 + 2 * t59) * theta / 2) + 8 * t83 * t68 * lambda__2 + 8 * lambda__3 * J__2) / 8;
      out_7 = -t21 * l__2 - t83;
      out_8 = t78 * l__1 + t19 * l__2 - x__3;
      out_9 = Omega * t - phi__1;

      % Store outputs
      out_F = zeros(9, 1);
      out_F(1) = out_1;
      out_F(2) = out_2;
      out_F(3) = out_3;
      out_F(4) = out_4;
      out_F(5) = out_5;
      out_F(6) = out_6;
      out_F(7) = out_7;
      out_F(8) = out_8;
      out_F(9) = out_9;
    end % F
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x = JF_x( this, in_1, in_2, ~, ~ )
      % Evaluate the Jacobian of F with respect to x.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      J__2 = this.m_J__2;
      theta = this.m_theta;

      % Extract inputs
      phi__1 = in_1(1);
      phi__2 = in_1(2);
      lambda__1 = in_1(7);
      lambda__2 = in_1(8);
      phi__1_dot = in_2(1);
      phi__2_dot = in_2(2);
      phi__1__dot_dot = in_2(4);

      % Evaluate function
      t1 = l__1 * l__2;
      t2 = phi__1 - phi__2;
      t3 = sin(t2);
      t7 = cos(t2);
      t8 = phi__1_dot ^ 2;
      t10 = m__2 * t1;
      out_5_1 = -phi__1__dot_dot * t3 * m__2 * t1 / 2 - t10 * t8 * t7 / 2;
      t13 = l__1 ^ 2;
      t14 = t13 * phi__1__dot_dot;
      t15 = l__2 ^ 2;
      t16 = m__2 ^ 2;
      t17 = t16 * t15;
      t18 = 2 * t2;
      t19 = sin(t18);
      t23 = t13 * t8;
      t24 = cos(t18);
      t28 = l__1 * m__2;
      t31 = theta * m__2 / 2 + lambda__1;
      t32 = t31 * t15;
      t34 = phi__1 - 2 * phi__2;
      t35 = sin(t34);
      t39 = lambda__2 * l__1;
      t40 = m__2 * t15;
      t41 = cos(t34);
      t45 = phi__2_dot ^ 2;
      t49 = l__2 * m__2 * J__2;
      t53 = -t40 / 4 + J__2;
      t64 = sin(phi__1);
      t68 = cos(phi__1);
      t69 = t68 * l__1;
      t73 = 0.1e1 / J__2;
      out_6_1 = t73 * (2 * t19 * t17 * t14 + 2 * t24 * t17 * t23 + 2 * t35 * t32 * t28 + 2 * t41 * t40 * t39 + 4 * t49 * l__1 * t45 * t7 - 8 * t64 * l__1 * (lambda__1 * t53 + (-t17 / 4 + J__2 * m__1 + 2 * J__2 * m__2) * theta / 2) + 8 * t69 * t53 * lambda__2) / 8;
      out_7_1 = -t69;
      out_8_1 = -t64 * l__1;
      out_9_1 = -1;
      t76 = -t2;
      t77 = sin(t76);
      t82 = cos(t76);
      t86 = sin(phi__2);
      t88 = cos(phi__2);
      out_5_2 = -phi__1__dot_dot * t77 * m__2 * t1 / 2 + t10 * t8 * t82 / 2 + l__2 * (-t86 * t31 + lambda__2 * t88);
      t92 = -t18;
      t93 = sin(t92);
      t97 = cos(t92);
      t101 = -t34;
      t102 = sin(t101);
      t106 = cos(t101);
      out_6_2 = t73 * (-4 * t49 * l__1 * t45 * t82 + 4 * t102 * t32 * t28 - 4 * t106 * t40 * t39 + 2 * t93 * t17 * t14 - 2 * t97 * t17 * t23) / 8;
      t116 = t88 * l__2;
      out_7_2 = -t116;
      t117 = t86 * l__2;
      out_8_2 = -t117;
      out_8_3 = -1;
      out_1_4 = -1;
      out_2_5 = -1;
      out_3_6 = -1;
      out_5_7 = t116;
      t121 = l__1 * t53;
      out_6_7 = t73 * (-2 * t41 * t15 * t28 + 8 * t68 * t121) / 8;
      out_4_8 = 1;
      out_5_8 = t117;
      out_6_8 = t73 * (2 * t35 * m__2 * t15 * l__1 + 8 * t64 * t121) / 8;
      out_6_9 = 1;

      % Store outputs
      out_JF_x = zeros(9, 9);
      out_JF_x(5, 1) = out_5_1;
      out_JF_x(6, 1) = out_6_1;
      out_JF_x(7, 1) = out_7_1;
      out_JF_x(8, 1) = out_8_1;
      out_JF_x(9, 1) = out_9_1;
      out_JF_x(5, 2) = out_5_2;
      out_JF_x(6, 2) = out_6_2;
      out_JF_x(7, 2) = out_7_2;
      out_JF_x(8, 2) = out_8_2;
      out_JF_x(8, 3) = out_8_3;
      out_JF_x(1, 4) = out_1_4;
      out_JF_x(2, 5) = out_2_5;
      out_JF_x(3, 6) = out_3_6;
      out_JF_x(5, 7) = out_5_7;
      out_JF_x(6, 7) = out_6_7;
      out_JF_x(4, 8) = out_4_8;
      out_JF_x(5, 8) = out_5_8;
      out_JF_x(6, 8) = out_6_8;
      out_JF_x(6, 9) = out_6_9;
    end % JF_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x_dot = JF_x_dot( this, in_1, in_2, ~, ~ )
      % Evaluate the Jacobian of F with respect to x_dot.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      phi__1 = in_1(1);
      phi__2 = in_1(2);
      phi__1_dot = in_2(1);
      phi__2_dot = in_2(2);

      % Evaluate function
      out_1_1 = 1;
      t1 = phi__1 - phi__2;
      t2 = sin(t1);
      t4 = l__1 * l__2;
      t5 = m__2 * t4;
      out_5_1 = -t5 * phi__1_dot * t2;
      t7 = l__1 ^ 2;
      t9 = l__2 ^ 2;
      t11 = m__2 ^ 2;
      t12 = 2 * t1;
      t13 = sin(t12);
      t15 = 0.1e1 / J__2;
      out_6_1 = t15 * t13 * t11 * t9 * t7 * phi__1_dot / 4;
      out_2_2 = 1;
      out_6_2 = t5 * phi__2_dot * t2;
      out_3_3 = 1;
      t19 = cos(t1);
      out_5_4 = t19 * m__2 * t4 / 2;
      t23 = cos(t12);
      out_6_4 = t15 * (-t23 * t11 * t9 * t7 + t7 * (8 * J__2 * m__2 - t11 * t9) + 8 * J__1 * J__2) / 8;
      out_5_5 = J__2;
      out_4_6 = m__3;

      % Store outputs
      out_JF_x_dot = zeros(9, 9);
      out_JF_x_dot(1, 1) = out_1_1;
      out_JF_x_dot(5, 1) = out_5_1;
      out_JF_x_dot(6, 1) = out_6_1;
      out_JF_x_dot(2, 2) = out_2_2;
      out_JF_x_dot(6, 2) = out_6_2;
      out_JF_x_dot(3, 3) = out_3_3;
      out_JF_x_dot(5, 4) = out_5_4;
      out_JF_x_dot(6, 4) = out_6_4;
      out_JF_x_dot(5, 5) = out_5_5;
      out_JF_x_dot(4, 6) = out_4_6;
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
      out_JF_v = zeros(9, 0);
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
      out_Jv_x = zeros(0, 9);
    end % Jv_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_h = h( this, in_1, ~, t )
      % Calculate the residual of the invariants h.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      Omega = this.m_Omega;

      % Extract inputs
      phi__1 = in_1(1);
      phi__2 = in_1(2);
      x__3 = in_1(3);

      % Evaluate function
      t1 = sin(phi__1);
      t3 = sin(phi__2);
      out_1 = -t1 * l__1 - t3 * l__2;
      t5 = cos(phi__1);
      t7 = cos(phi__2);
      out_2 = t5 * l__1 + t7 * l__2 - x__3;
      out_3 = Omega * t - phi__1;

      % Store outputs
      out_h = zeros(3, 1);
      out_h(1) = out_1;
      out_h(2) = out_2;
      out_h(3) = out_3;
    end % h
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_x = Jh_x( this, in_1, ~, ~ )
      % Calculate the Jacobian of h with respect to x.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;

      % Extract inputs
      phi__1 = in_1(1);
      phi__2 = in_1(2);

      % Evaluate function
      t1 = cos(phi__1);
      out_1_1 = -t1 * l__1;
      t3 = sin(phi__1);
      out_2_1 = -t3 * l__1;
      out_3_1 = -1;
      t5 = cos(phi__2);
      out_1_2 = -t5 * l__2;
      t7 = sin(phi__2);
      out_2_2 = -t7 * l__2;
      out_2_3 = -1;

      % Store outputs
      out_Jh_x = zeros(3, 9);
      out_Jh_x(1, 1) = out_1_1;
      out_Jh_x(2, 1) = out_2_1;
      out_Jh_x(3, 1) = out_3_1;
      out_Jh_x(1, 2) = out_1_2;
      out_Jh_x(2, 2) = out_2_2;
      out_Jh_x(2, 3) = out_2_3;
    end % Jh_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_pivots = pivots( this, in_1, ~, ~ )
      % Calculate the pivoting values

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      phi__1 = in_1(1);
      phi__2 = in_1(2);

      % Evaluate function
      out_1_1 = 1;
      out_2_1 = 1;
      out_3_1 = 1;
      out_4_1 = m__3;
      out_5_1 = J__2;
      t1 = l__1 ^ 2;
      t2 = l__2 ^ 2;
      t4 = m__2 ^ 2;
      t6 = cos(phi__1 - phi__2);
      t7 = t6 ^ 2;
      out_6_1 = 0.1e1 / J__2 * (-t7 * t4 * t2 * t1 + 4 * (m__2 * t1 + J__1) * J__2) / 4;
      out_7_1 = -1;
      out_8_1 = -1;
      out_9_1 = -1;

      % Store outputs
      out_pivots = zeros(9, 1);
      out_pivots(1, 1) = out_1_1;
      out_pivots(2, 1) = out_2_1;
      out_pivots(3, 1) = out_3_1;
      out_pivots(4, 1) = out_4_1;
      out_pivots(5, 1) = out_5_1;
      out_pivots(6, 1) = out_6_1;
      out_pivots(7, 1) = out_7_1;
      out_pivots(8, 1) = out_8_1;
      out_pivots(9, 1) = out_9_1;
    end % pivots
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
      out_Jh_v = zeros(3, 0);
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
end % SliderCrankRigid

% That's All Folks!
