% +--------------------------------------------------------------------------+
% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |
% | Current version authors:                                                 |
% |   Davide Stocco and Enrico Bertolazzi.                                   |
% +--------------------------------------------------------------------------+

% Matlab generated code for implicit system: SliderCrankRecursive
% This file has been automatically generated by Indigo.
% DISCLAIMER: If you need to edit it, do it wisely!

classdef SliderCrankRecursive < Indigo.Systems.Implicit
  %
  % No class description provided.
  %
  properties (SetAccess = protected, Hidden = true)
    % User data
    m_l__1 = 1.0;
    m_l__2 = 2.0;
    m_m__1 = 1.0;
    m_m__2 = 1.0;
    m_m__3 = 2.0;
    m_g = 9.8;
    m_J__1 = 4.5;
    m_J__2 = 5.5;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = SliderCrankRecursive( varargin )
      % Class constructor.

      % Superclass constructor
      num_eqns = 5;
      num_veil = 0;
      num_invs = 3;
      this = this@Indigo.Systems.Implicit('SliderCrankRecursive', num_eqns, num_veil, num_invs);

      % User data
      if (nargin == 0)
        % Keep default values
      elseif (nargin == 1 && isstruct(varargin{1}))
        this.m_l__1 = varargin{1}.l__1;
        this.m_l__2 = varargin{1}.l__2;
        this.m_m__1 = varargin{1}.m__1;
        this.m_m__2 = varargin{1}.m__2;
        this.m_m__3 = varargin{1}.m__3;
        this.m_g = varargin{1}.g;
        this.m_J__1 = varargin{1}.J__1;
        this.m_J__2 = varargin{1}.J__2;
      elseif (nargin == 8)
        this.m_l__1 = varargin{1};
        this.m_l__2 = varargin{2};
        this.m_m__1 = varargin{3};
        this.m_m__2 = varargin{4};
        this.m_m__3 = varargin{5};
        this.m_g = varargin{6};
        this.m_J__1 = varargin{7};
        this.m_J__2 = varargin{8};
      else
        error('wrong number of input arguments.');
      end
    end % SliderCrankRecursive
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_F = F( this, in_1, in_2, in_3, t )
      % Evaluate the function F.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);
      theta__1_dot = in_2(1);
      theta__2_dot = in_2(2);
      omega__1_dot = in_2(3);
      omega__2_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate function
      out_1 = -omega__1 + theta__1_dot;
      out_2 = -omega__2 + theta__2_dot;
      t1 = l__1 ^ 2;
      t2 = l__2 ^ 2;
      t3 = t2 * t1;
      t4 = 2 * m__3;
      t5 = m__2 + t4;
      t6 = t5 ^ 2;
      t7 = theta__2 + theta__1;
      t8 = cos(t7);
      t9 = t8 ^ 2;
      t13 = m__1 / 4;
      t20 = t2 * (m__2 / 4 + m__3) + J__2;
      t24 = 4 * m__3;
      t29 = 0.1e1 / (t2 * (m__2 + t24) + 4 * J__2);
      t32 = omega__1 ^ 2;
      t34 = t6 * t2;
      t35 = 2 * t7;
      t36 = sin(t35);
      t42 = t5 * g + 2 * lambda;
      t44 = 2 * theta__2;
      t45 = theta__1 + t44;
      t46 = cos(t45);
      t50 = omega__2 ^ 2;
      t52 = l__2 * t5;
      t53 = sin(t7);
      t56 = cos(theta__1);
      t57 = m__3 * t2;
      t58 = 2 * J__2;
      t61 = m__3 ^ 2;
      t62 = 0.3e1 / 0.2e1 * m__2;
      t66 = m__2 * (m__1 + m__2);
      t70 = 2 * m__2;
      t72 = (m__1 + t70 + t4) * J__2;
      t75 = lambda * (t57 + t58) + (t2 * (t61 + m__3 * (m__1 + t62) + t66 / 4) + t72) * g;
      out_3 = omega__1_dot * t29 * (-4 * t9 * t6 * t3 + 16 * t20 * (t1 * (t13 + m__2 + m__3) + J__1)) + 8 * t29 * l__1 * (t36 * t34 * l__1 * t32 / 4 - t46 * t2 * t42 * t5 / 4 + t53 * t52 * t20 * t50 + t75 * t56);
      t81 = cos(theta__2);
      t84 = t2 * t42;
      t85 = t1 * t5;
      t86 = cos(t35);
      t89 = t1 * t50;
      t93 = 2 * theta__1;
      t94 = 3 * theta__2 + t93;
      t95 = sin(t94);
      t99 = t57 / 2 + J__2;
      t101 = t93 + theta__2;
      t102 = sin(t101);
      t103 = t102 * t89;
      t108 = sin(t45);
      t112 = t1 * t75;
      t113 = cos(t93);
      t116 = cos(t44);
      t124 = (m__1 + t70) * m__2;
      t130 = (m__1 + 4 * m__2 + t24) * J__2;
      t131 = t130 / 4;
      t134 = J__1 * t20;
      t137 = sin(theta__1);
      t138 = t137 * l__1;
      t147 = 3 * m__2;
      t150 = (m__1 + t147 + t4) * J__2 / 4;
      t155 = sin(theta__2);
      t156 = t155 * t50;
      out_4 = -omega__2_dot * l__2 * t81 - 0.1e1 / (2 * t86 * t6 * t3 + t1 * (t2 * (-8 * t61 + (-4 * m__1 - 12 * m__2) * m__3 - t124) - 4 * t130) - 16 * t134) * (t86 * t85 * t84 - t95 * t6 * t2 * l__2 * t89 - 4 * t103 * t99 * t52 - 2 * t108 * t34 * t1 * l__1 * t32 - 4 * t113 * t112 + t116 * t85 * t84 - 16 * t138 * (t1 * (t2 * (t61 / 2 + m__3 * (t13 + 0.3e1 / 0.4e1 * m__2) + t124 / 16) + t131) + t134) * t32 + 16 * t156 * l__2 * (t1 * (t2 * (m__3 * (t13 + 0.3e1 / 0.8e1 * m__2) + t66 / 16) + t150) + t134) - 4 * t112);
      t178 = t5 * t2;
      t183 = t1 * (4 * lambda + (t147 + m__1 + t24) * g);
      t186 = t36 * t183 * t178 / 2;
      t188 = t5 * t2 * t32;
      t193 = l__1 * (t1 * (t13 + m__2 / 2) + J__1);
      t195 = t46 * t193 * t188;
      t196 = m__2 * t2;
      t199 = (-t196 / 4 + J__2) * t52;
      t200 = cos(t101);
      t202 = t200 * t89 * t199;
      t205 = -t196 / 2 + t58;
      t207 = m__2 ^ 2;
      t209 = m__3 * m__1;
      t216 = t1 * (lambda * t205 + g * (t2 * (-t207 / 4 + t209 / 2) + t72));
      t217 = sin(t93);
      t226 = t1 * (t2 * (t209 / 8 - t207 / 8) + t131) + t99 * J__1;
      t227 = t226 * t32;
      t233 = cos(t94);
      t241 = m__1 / 16;
      t246 = (m__1 + t4) * m__3;
      t252 = t1 * (t2 * (t207 / 8 + m__2 * (t241 + 0.3e1 / 0.4e1 * m__3) + t246 / 4) + t131) + t134;
      t254 = -t233 * t6 * t3 / 16 - t200 * t6 * t3 / 16 + t252 * t81;
      t256 = 0.1e1 / l__2;
      t257 = t256 / t254;
      t262 = t108 * t193;
      t266 = m__1 / 2;
      t270 = t1 * (t266 + m__2) + 2 * J__1;
      t278 = t2 * (lambda * t270 + t5 * (m__2 * t1 / 4 + J__1) * g);
      t290 = l__2 * (t1 * (t2 * (t207 / 16 + m__2 * (t241 + 0.3e1 / 0.8e1 * m__3) + t209 / 4) + t150) + t134);
      t298 = t1 * (t2 * (t266 + t62 + t4) + t58);
      t299 = J__1 * t2;
      t300 = 2 * t299;
      t315 = (-t86 * t183 * t178 / 4 - t262 * t188 + t103 * t199 + t113 * t216 + t116 * t278 - 4 * t156 * t290 + 4 * t138 * t227 + lambda * (t298 + t300) + (t1 * (t2 * (0.3e1 / 0.4e1 * t207 + m__2 * (t13 + 3 * m__3) + t246) + t72) + t5 * t299) * g) * t20;
      t316 = t254 ^ 2;
      t318 = t256 / t316;
      t320 = t95 * t6 * t3;
      t322 = t102 * t6 * t3;
      t330 = sin(t44);
      out_5 = theta__1_dot * (t257 * (4 * t56 * l__1 * t227 - 2 * t217 * t216 + t186 - t195 + 2 * t202) * t20 - (t320 / 8 + t322 / 8) * t318 * t315) + theta__2_dot * (t257 * (-4 * t81 * t50 * t290 - 2 * t330 * t278 + t186 - 2 * t195 + t202) * t20 - (0.3e1 / 0.16e2 * t320 + t322 / 16 - t252 * t155) * t318 * t315) + omega__1_dot * t257 * (-2 * t262 * t5 * t2 * omega__1 + 8 * t138 * t226 * omega__1) * t20 + omega__2_dot * t257 * (2 * t102 * t1 * omega__2 * t199 - 8 * t155 * omega__2 * t290) * t20 + lambda_dot * t257 * (t113 * t1 * t205 - t86 * t1 * t178 + t116 * t2 * t270 + t298 + t300) * t20;

      % Store outputs
      out_F = zeros(5, 1);
      out_F(1) = out_1;
      out_F(2) = out_2;
      out_F(3) = out_3;
      out_F(4) = out_4;
      out_F(5) = out_5;
    end % F
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x = JF_x( this, in_1, in_2, in_3, t )
      % Evaluate the Jacobian of F with respect to x.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);
      theta__1_dot = in_2(1);
      theta__2_dot = in_2(2);
      omega__1_dot = in_2(3);
      omega__2_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate function
      t1 = l__1 ^ 2;
      t2 = l__2 ^ 2;
      t3 = t2 * t1;
      t4 = 2 * m__3;
      t5 = m__2 + t4;
      t6 = t5 ^ 2;
      t8 = theta__2 + theta__1;
      t9 = cos(t8);
      t10 = sin(t8);
      t12 = 4 * m__3;
      t17 = 0.1e1 / (t2 * (m__2 + t12) + 4 * J__2);
      t20 = omega__1_dot * t17 * t10 * t9 * t6 * t3;
      t21 = omega__1 ^ 2;
      t23 = t6 * t2;
      t24 = 2 * t8;
      t25 = cos(t24);
      t28 = t25 * t23 * l__1 * t21 / 2;
      t31 = t5 * g + 2 * lambda;
      t33 = 2 * theta__2;
      t34 = theta__1 + t33;
      t35 = sin(t34);
      t37 = t35 * t2 * t31 * t5;
      t39 = omega__2 ^ 2;
      t43 = t2 * (m__2 / 4 + m__3) + J__2;
      t45 = l__2 * t5;
      t47 = t9 * t45 * t43 * t39;
      t48 = sin(theta__1);
      t49 = m__3 * t2;
      t50 = 2 * J__2;
      t51 = t49 + t50;
      t53 = m__3 ^ 2;
      t54 = 0.3e1 / 0.2e1 * m__2;
      t58 = m__2 * (m__1 + m__2);
      t62 = 2 * m__2;
      t64 = (m__1 + t62 + t4) * J__2;
      t67 = lambda * t51 + (t2 * (t53 + m__3 * (m__1 + t54) + t58 / 4) + t64) * g;
      out_3_1 = 8 * t20 + 8 * t17 * l__1 * (t28 + t37 / 4 + t47 - t67 * t48);
      t73 = t2 * t31;
      t74 = t1 * t5;
      t75 = sin(t24);
      t78 = 2 * t75 * t74 * t73;
      t79 = t1 * t39;
      t81 = t6 * t2 * l__2;
      t83 = 2 * theta__1;
      t84 = 3 * theta__2 + t83;
      t85 = cos(t84);
      t87 = t85 * t81 * t79;
      t90 = t49 / 2 + J__2;
      t91 = t90 * t45;
      t92 = t83 + theta__2;
      t93 = cos(t92);
      t94 = t93 * t79;
      t95 = t94 * t91;
      t97 = t1 * l__1;
      t98 = t97 * t21;
      t99 = cos(t34);
      t101 = t99 * t23 * t98;
      t103 = t1 * t67;
      t104 = sin(t83);
      t108 = m__1 / 4;
      t113 = (m__1 + t62) * m__2;
      t119 = (m__1 + 4 * m__2 + t12) * J__2;
      t120 = t119 / 4;
      t123 = J__1 * t43;
      t124 = t1 * (t2 * (t53 / 2 + m__3 * (t108 + 0.3e1 / 0.4e1 * m__2) + t113 / 16) + t120) + t123;
      t125 = t124 * t21;
      t126 = cos(theta__1);
      t127 = t126 * l__1;
      t145 = 2 * t25 * t6 * t3 + t1 * (t2 * (-8 * t53 + (-4 * m__1 - 12 * m__2) * m__3 - t113) - 4 * t119) - 16 * t123;
      t146 = 0.1e1 / t145;
      t150 = sin(t84);
      t151 = t150 * t81;
      t153 = sin(t92);
      t154 = t153 * t79;
      t157 = t35 * t23;
      t160 = cos(t83);
      t163 = cos(t33);
      t166 = t48 * l__1;
      t175 = 3 * m__2;
      t178 = (m__1 + t175 + t4) * J__2 / 4;
      t182 = l__2 * (t1 * (t2 * (m__3 * (t108 + 0.3e1 / 0.8e1 * m__2) + t58 / 16) + t178) + t123);
      t183 = sin(theta__2);
      t184 = t183 * t39;
      t189 = t145 ^ 2;
      t195 = 4 * t75 * t23 * t1 / t189 * (t163 * t73 * t74 + t25 * t73 * t74 - 4 * t103 * t160 - 16 * t125 * t166 - t151 * t79 - 4 * t154 * t91 - 2 * t157 * t98 + 16 * t182 * t184 - 4 * t103);
      out_4_1 = -t146 * (8 * t103 * t104 - 16 * t125 * t127 - 2 * t101 - t78 - 2 * t87 - 8 * t95) - t195;
      t196 = t5 * t2;
      t201 = t1 * (4 * lambda + (t175 + m__1 + t12) * g);
      t203 = t25 * t201 * t196;
      t205 = t5 * t2 * t21;
      t210 = l__1 * (t1 * (t108 + m__2 / 2) + J__1);
      t211 = t35 * t210;
      t212 = t211 * t205;
      t213 = m__2 * t2;
      t215 = -t213 / 4 + J__2;
      t216 = t215 * t45;
      t217 = t154 * t216;
      t220 = -t213 / 2 + t50;
      t222 = m__2 ^ 2;
      t224 = m__3 * m__1;
      t231 = t1 * (lambda * t220 + g * (t2 * (-t222 / 4 + t224 / 2) + t64));
      t232 = t160 * t231;
      t240 = t1 * (t2 * (t224 / 8 - t222 / 8) + t120) + t90 * J__1;
      t241 = t240 * t21;
      t243 = 4 * t166 * t241;
      t247 = t85 * t6 * t3;
      t250 = t93 * t6 * t3;
      t251 = t250 / 16;
      t252 = cos(theta__2);
      t254 = m__1 / 16;
      t259 = (m__1 + t4) * m__3;
      t265 = t1 * (t2 * (t222 / 8 + m__2 * (t254 + 0.3e1 / 0.4e1 * m__3) + t259 / 4) + t120) + t123;
      t266 = t265 * t252;
      t267 = -t247 / 16 - t251 + t266;
      t268 = 0.1e1 / t267;
      t269 = 0.1e1 / l__2;
      t270 = t269 * t268;
      t274 = t75 * t201 * t196 / 2;
      t275 = t99 * t210;
      t276 = t275 * t205;
      t277 = t94 * t216;
      t284 = (-2 * t104 * t231 + 4 * t127 * t241 + t274 - t276 + 2 * t277) * t43;
      t285 = t267 ^ 2;
      t286 = 0.1e1 / t285;
      t287 = t269 * t286;
      t289 = t150 * t6 * t3;
      t291 = t153 * t6 * t3;
      t293 = t289 / 8 + t291 / 8;
      t294 = t293 * t287;
      t298 = m__1 / 2;
      t302 = t1 * (t298 + m__2) + 2 * J__1;
      t310 = t2 * (lambda * t302 + t5 * (m__2 * t1 / 4 + J__1) * g);
      t311 = t163 * t310;
      t322 = l__2 * (t1 * (t2 * (t222 / 16 + m__2 * (t254 + 0.3e1 / 0.8e1 * m__3) + t224 / 4) + t178) + t123);
      t324 = 4 * t184 * t322;
      t328 = t1 * (t2 * (t298 + t54 + t4) + t50);
      t329 = J__1 * t2;
      t330 = 2 * t329;
      t345 = (-t203 / 4 - t212 + t217 + t232 + t311 - t324 + t243 + lambda * (t328 + t330) + (t1 * (t2 * (0.3e1 / 0.4e1 * t222 + m__2 * (t108 + 3 * m__3) + t259) + t64) + t5 * t329) * g) * t43;
      t347 = 0.1e1 / t285 / t267;
      t348 = t269 * t347;
      t349 = t293 ^ 2;
      t365 = sin(t33);
      t368 = t252 * t39;
      t372 = (-2 * t310 * t365 - 4 * t322 * t368 + t274 - 2 * t276 + t277) * t43;
      t377 = 0.3e1 / 0.16e2 * t289 + t291 / 16 - t265 * t183;
      t378 = t377 * t287;
      t390 = t270 * (t203 + 2 * t212 - 2 * t217) * t43 - t294 * t372 - t378 * t284 + 2 * t293 * t377 * t269 * t347 * t345 - (0.3e1 / 0.8e1 * t247 + t250 / 8) * t287 * t345;
      t393 = t5 * t2 * omega__1;
      t396 = t240 * omega__1;
      t400 = (8 * t127 * t396 - 2 * t275 * t393) * t43;
      t401 = omega__1_dot * t270;
      t408 = (8 * t166 * t396 - 2 * t211 * t393) * t43;
      t409 = t286 * t408;
      t410 = omega__1_dot * t269;
      t413 = t5 * t43;
      t421 = t1 * omega__2;
      t422 = t153 * t421;
      t425 = t183 * omega__2;
      t429 = (2 * t216 * t422 - 8 * t322 * t425) * t43;
      t430 = t286 * t429;
      t431 = omega__2_dot * t269;
      t435 = t75 * t1 * t196;
      t436 = t1 * t220;
      t440 = (-2 * t104 * t436 + 2 * t435) * t43;
      t441 = lambda_dot * t270;
      t444 = t25 * t1 * t196;
      t446 = t2 * t302;
      t449 = (t160 * t436 + t163 * t446 + t328 + t330 - t444) * t43;
      t450 = t286 * t449;
      t451 = lambda_dot * t269;
      out_5_1 = theta__1_dot * (t270 * (t203 + t212 - 4 * t217 - 4 * t232 - t243) * t43 - 2 * t294 * t284 + 2 * t349 * t348 * t345 - (t247 / 4 + t250 / 4) * t287 * t345) + theta__2_dot * t390 + t401 * t400 - t293 * t410 * t409 + 4 * omega__2_dot * t268 * t93 * t1 * omega__2 * t215 * t413 - t293 * t431 * t430 + t441 * t440 - t293 * t451 * t450;
      out_3_2 = 8 * t20 + 8 * t17 * l__1 * (t28 + t37 / 2 + t47);
      out_4_2 = omega__2_dot * l__2 * t183 - t146 * (-2 * t365 * t73 * t74 + 16 * t182 * t368 - 4 * t101 - t78 - 3 * t87 - 4 * t95) - t195;
      t479 = t377 ^ 2;
      t490 = t45 * omega__1 * t43;
      t491 = t268 * t99;
      t505 = (2 * t216 * t421 * t93 - 8 * t252 * t322 * omega__2) * t43;
      t506 = omega__2_dot * t270;
      t513 = (-2 * t365 * t446 + 2 * t435) * t43;
      out_5_2 = theta__1_dot * t390 + theta__2_dot * (t270 * (t203 + 4 * t212 - t217 - 4 * t311 + t324) * t43 - 2 * t378 * t372 + 2 * t479 * t348 * t345 - (0.9e1 / 0.16e2 * t247 + t251 - t266) * t287 * t345) - 4 * omega__1_dot * t491 * t210 * t490 - t377 * t410 * t409 + t506 * t505 - t377 * t431 * t430 + t441 * t513 - t377 * t451 * t450;
      out_1_3 = -1;
      out_3_3 = 4 * t17 * t75 * t6 * t2 * t1 * omega__1;
      out_4_3 = -t146 * (-32 * t124 * t166 * omega__1 - 4 * t157 * t97 * omega__1);
      out_5_3 = theta__1_dot * (t270 * t400 - t294 * t408) + theta__2_dot * (-4 * t210 * t490 * t491 - t378 * t408) + t401 * (8 * l__1 * t240 * t48 - 2 * t196 * t211) * t43;
      out_2_4 = -1;
      out_3_4 = 16 * t17 * l__1 * t10 * l__2 * t5 * t43 * omega__2;
      out_4_4 = -t146 * (-2 * t151 * t421 + 32 * t182 * t425 - 8 * t422 * t91);
      out_5_4 = theta__1_dot * (4 * t215 * t268 * t413 * t421 * t93 - t294 * t429) + theta__2_dot * (t270 * t505 - t378 * t429) + t506 * (2 * t1 * t153 * t215 * t45 - 8 * t183 * t322) * t43;
      out_3_5 = 8 * t17 * l__1 * (-t99 * t196 / 2 + t51 * t126);
      t590 = t1 * t51;
      out_4_5 = -t146 * (2 * t1 * t163 * t196 - 4 * t160 * t590 + 2 * t444 - 4 * t590);
      out_5_5 = theta__1_dot * (t270 * t440 - t294 * t449) + theta__2_dot * (t270 * t513 - t378 * t449);

      % Store outputs
      out_JF_x = zeros(5, 5);
      out_JF_x(3, 1) = out_3_1;
      out_JF_x(4, 1) = out_4_1;
      out_JF_x(5, 1) = out_5_1;
      out_JF_x(3, 2) = out_3_2;
      out_JF_x(4, 2) = out_4_2;
      out_JF_x(5, 2) = out_5_2;
      out_JF_x(1, 3) = out_1_3;
      out_JF_x(3, 3) = out_3_3;
      out_JF_x(4, 3) = out_4_3;
      out_JF_x(5, 3) = out_5_3;
      out_JF_x(2, 4) = out_2_4;
      out_JF_x(3, 4) = out_3_4;
      out_JF_x(4, 4) = out_4_4;
      out_JF_x(5, 4) = out_5_4;
      out_JF_x(3, 5) = out_3_5;
      out_JF_x(4, 5) = out_4_5;
      out_JF_x(5, 5) = out_5_5;
    end % JF_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_x_dot = JF_x_dot( this, in_1, in_2, in_3, t )
      % Evaluate the Jacobian of F with respect to x_dot.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);
      theta__1_dot = in_2(1);
      theta__2_dot = in_2(2);
      omega__1_dot = in_2(3);
      omega__2_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate function
      out_1_1 = 1;
      t3 = l__2 ^ 2;
      t5 = t3 * (m__2 / 4 + m__3) + J__2;
      t6 = 2 * m__3;
      t7 = m__2 + t6;
      t8 = t7 * t3;
      t10 = 3 * m__2;
      t11 = 4 * m__3;
      t15 = l__1 ^ 2;
      t16 = t15 * (4 * lambda + (t10 + m__1 + t11) * g);
      t17 = theta__2 + theta__1;
      t18 = 2 * t17;
      t19 = sin(t18);
      t22 = t19 * t16 * t8 / 2;
      t23 = omega__1 ^ 2;
      t25 = t7 * t3 * t23;
      t26 = m__1 / 4;
      t31 = l__1 * (t15 * (t26 + m__2 / 2) + J__1);
      t32 = 2 * theta__2;
      t33 = theta__1 + t32;
      t34 = cos(t33);
      t36 = t34 * t31 * t25;
      t38 = m__2 * t3;
      t41 = (-t38 / 4 + J__2) * t7 * l__2;
      t42 = omega__2 ^ 2;
      t43 = t15 * t42;
      t44 = 2 * theta__1;
      t45 = t44 + theta__2;
      t46 = cos(t45);
      t48 = t46 * t43 * t41;
      t51 = 2 * J__2;
      t52 = -t38 / 2 + t51;
      t54 = m__2 ^ 2;
      t56 = m__3 * m__1;
      t62 = (m__1 + 2 * m__2 + t6) * J__2;
      t66 = t15 * (lambda * t52 + g * (t3 * (-t54 / 4 + t56 / 2) + t62));
      t67 = sin(t44);
      t76 = (m__1 + 4 * m__2 + t11) * J__2 / 4;
      t83 = t15 * (t3 * (t56 / 8 - t54 / 8) + t76) + (m__3 * t3 / 2 + J__2) * J__1;
      t84 = t83 * t23;
      t85 = cos(theta__1);
      t91 = t3 * t15;
      t92 = t7 ^ 2;
      t94 = 3 * theta__2 + t44;
      t95 = cos(t94);
      t102 = cos(theta__2);
      t104 = m__1 / 16;
      t109 = (m__1 + t6) * m__3;
      t115 = J__1 * t5;
      t116 = t15 * (t3 * (t54 / 8 + m__2 * (t104 + 0.3e1 / 0.4e1 * m__3) + t109 / 4) + t76) + t115;
      t118 = -t95 * t92 * t91 / 16 - t46 * t92 * t91 / 16 + t116 * t102;
      t120 = 0.1e1 / l__2;
      t121 = t120 / t118;
      t123 = cos(t18);
      t127 = sin(t33);
      t128 = t127 * t31;
      t130 = sin(t45);
      t133 = cos(t44);
      t135 = m__1 / 2;
      t139 = t15 * (t135 + m__2) + 2 * J__1;
      t147 = t3 * (lambda * t139 + t7 * (m__2 * t15 / 4 + J__1) * g);
      t148 = cos(t32);
      t163 = l__2 * (t15 * (t3 * (t54 / 16 + m__2 * (t104 + 0.3e1 / 0.8e1 * m__3) + t56 / 4) + (m__1 + t10 + t6) * J__2 / 4) + t115);
      t164 = sin(theta__2);
      t168 = sin(theta__1);
      t169 = t168 * l__1;
      t176 = t15 * (t3 * (t135 + 0.3e1 / 0.2e1 * m__2 + t6) + t51);
      t177 = J__1 * t3;
      t178 = 2 * t177;
      t193 = (-t123 * t16 * t8 / 4 - t128 * t25 + t130 * t43 * t41 + t133 * t66 + t148 * t147 - 4 * t164 * t42 * t163 + 4 * t169 * t84 + lambda * (t176 + t178) + (t15 * (t3 * (0.3e1 / 0.4e1 * t54 + m__2 * (t26 + 3 * m__3) + t109) + t62) + t7 * t177) * g) * t5;
      t194 = t118 ^ 2;
      t196 = t120 / t194;
      t197 = sin(t94);
      t199 = t197 * t92 * t91;
      t201 = t130 * t92 * t91;
      out_5_1 = t121 * (4 * t85 * l__1 * t84 - 2 * t67 * t66 + t22 - t36 + 2 * t48) * t5 - (t199 / 8 + t201 / 8) * t196 * t193;
      out_2_2 = 1;
      t207 = sin(t32);
      out_5_2 = t121 * (-4 * t102 * t42 * t163 - 2 * t207 * t147 + t22 - 2 * t36 + t48) * t5 - (0.3e1 / 0.16e2 * t199 + t201 / 16 - t116 * t164) * t196 * t193;
      t222 = cos(t17);
      t223 = t222 ^ 2;
      out_3_3 = 0.1e1 / (t3 * (m__2 + t11) + 4 * J__2) * (-4 * t223 * t92 * t91 + 16 * t5 * (t15 * (t26 + m__2 + m__3) + J__1));
      out_5_3 = t121 * (-2 * t128 * t7 * t3 * omega__1 + 8 * t169 * t83 * omega__1) * t5;
      out_4_4 = -l__2 * t102;
      out_5_4 = t121 * (2 * t130 * t15 * omega__2 * t41 - 8 * t164 * omega__2 * t163) * t5;
      out_5_5 = t121 * (-t123 * t15 * t8 + t133 * t15 * t52 + t148 * t3 * t139 + t176 + t178) * t5;

      % Store outputs
      out_JF_x_dot = zeros(5, 5);
      out_JF_x_dot(1, 1) = out_1_1;
      out_JF_x_dot(5, 1) = out_5_1;
      out_JF_x_dot(2, 2) = out_2_2;
      out_JF_x_dot(5, 2) = out_5_2;
      out_JF_x_dot(3, 3) = out_3_3;
      out_JF_x_dot(5, 3) = out_5_3;
      out_JF_x_dot(4, 4) = out_4_4;
      out_JF_x_dot(5, 4) = out_5_4;
      out_JF_x_dot(5, 5) = out_5_5;
    end % JF_x_dot
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_JF_v = JF_v( this, in_1, in_2, in_3, t )
      % Evaluate the Jacobian of F with respect to v.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);
      theta__1_dot = in_2(1);
      theta__2_dot = in_2(2);
      omega__1_dot = in_2(3);
      omega__2_dot = in_2(4);
      lambda_dot = in_2(5);

      % Evaluate function
      % No body

      % Store outputs
      out_JF_v = zeros(5, 0);
    end % JF_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_v = v( this, in_1, t )
      % Evaluate the the veils v.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);

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
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);

      % Evaluate function
      % No body

      % Store outputs
      out_Jv_x = zeros(0, 5);
    end % Jv_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_h = h( this, in_1, in_2, t )
      % Calculate the residual of the invariants h.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);

      % Evaluate function
      t1 = sin(theta__2);
      t3 = sin(theta__1);
      t4 = l__1 * t3;
      out_1 = l__2 * t1 - t4;
      t5 = cos(theta__1);
      t8 = cos(theta__2);
      out_2 = omega__1 * l__1 * t5 - omega__2 * l__2 * t8;
      t13 = l__2 ^ 2;
      t15 = t13 * (m__2 / 4 + m__3) + J__2;
      t16 = 2 * m__3;
      t17 = m__2 + t16;
      t20 = 3 * m__2;
      t21 = 4 * m__3;
      t24 = 4 * lambda + (t20 + m__1 + t21) * g;
      t25 = 2 * theta__2;
      t26 = cos(t25);
      t29 = t17 * l__2;
      t30 = m__2 * t13;
      t33 = omega__2 ^ 2;
      t34 = t33 * (-t30 / 4 + J__2);
      t39 = 8 * J__2;
      t42 = m__2 ^ 2;
      t44 = m__3 * m__1;
      t50 = (m__1 + 2 * m__2 + t16) * J__2;
      t55 = l__1 ^ 2;
      t57 = 2 * theta__1;
      t58 = cos(t57);
      t60 = omega__1 ^ 2;
      t62 = m__1 / 4;
      t66 = t55 * (t62 + m__2 / 2) + J__1;
      t86 = sin(t25);
      t92 = sin(t57);
      t103 = m__1 / 16;
      t115 = J__1 * t15;
      t127 = (m__1 + 4 * m__2 + t21) * J__2 / 4;
      t145 = J__1 * t13;
      t154 = (m__1 + t16) * m__3;
      t165 = t13 * t55;
      t166 = t17 ^ 2;
      t167 = 3 * theta__2;
      t168 = cos(t167);
      t173 = sin(t167);
      out_3 = 4 / l__2 / (t58 * (t8 + t168) * t166 * t165 - t92 * (t1 + t173) * t166 * t165 - 16 * (t55 * (t13 * (t42 / 8 + m__2 * (t103 + 0.3e1 / 0.4e1 * m__3) + t154 / 4) + t127) + t115) * t8) * (t58 * t55 * (t26 * t24 * t17 * t13 - 4 * t1 * t34 * t29 + lambda * (2 * t30 - t39) - 4 * g * (t13 * (-t42 / 4 + t44 / 2) + t50)) - 4 * t26 * (-t3 * l__1 * t66 * t17 * t60 + lambda * (t55 * (m__1 / 2 + m__2) + 2 * J__1) + t17 * (m__2 * t55 / 4 + J__1) * g) * t13 - t92 * (t86 * t24 * l__2 + 4 * t8 * t34) * t55 * t29 + 4 * t86 * l__1 * t66 * t17 * t13 * t60 * t5 + 16 * t1 * t33 * l__2 * (t55 * (t13 * (t42 / 16 + m__2 * (t103 + 0.3e1 / 0.8e1 * m__3) + t44 / 4) + (m__1 + t20 + t16) * J__2 / 4) + t115) - 16 * t4 * (t55 * (t13 * (t44 / 8 - t42 / 8) + t127) + (m__3 * t13 / 2 + J__2) * J__1) * t60 + lambda * (t55 * (t13 * (-2 * m__1 - 6 * m__2 - 8 * m__3) - t39) - 8 * t145) - 4 * (t55 * (t13 * (0.3e1 / 0.4e1 * t42 + m__2 * (t62 + 3 * m__3) + t154) + t50) + t17 * t145) * g) * t15;

      % Store outputs
      out_h = zeros(3, 1);
      out_h(1) = out_1;
      out_h(2) = out_2;
      out_h(3) = out_3;
    end % h
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_x = Jh_x( this, in_1, in_2, t )
      % Calculate the Jacobian of h with respect to x.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);

      % Evaluate function
      t1 = cos(theta__1);
      t2 = l__1 * t1;
      out_1_1 = -t2;
      t3 = sin(theta__1);
      out_2_1 = -l__1 * omega__1 * t3;
      t8 = l__2 ^ 2;
      t10 = t8 * (m__2 / 4 + m__3) + J__2;
      t11 = 2 * m__3;
      t12 = m__2 + t11;
      t13 = t12 * t8;
      t15 = 3 * m__2;
      t16 = 4 * m__3;
      t19 = 4 * lambda + (t15 + m__1 + t16) * g;
      t20 = 2 * theta__2;
      t21 = cos(t20);
      t24 = t12 * l__2;
      t25 = m__2 * t8;
      t27 = -t25 / 4 + J__2;
      t28 = omega__2 ^ 2;
      t29 = t28 * t27;
      t30 = sin(theta__2);
      t31 = t30 * t29;
      t34 = 2 * t25;
      t35 = 8 * J__2;
      t38 = m__2 ^ 2;
      t40 = m__3 * m__1;
      t46 = (m__1 + 2 * m__2 + t11) * J__2;
      t51 = l__1 ^ 2;
      t52 = t51 * (t21 * t19 * t13 - 4 * t31 * t24 + lambda * (t34 - t35) - 4 * g * (t8 * (-t38 / 4 + t40 / 2) + t46));
      t53 = 2 * theta__1;
      t54 = sin(t53);
      t57 = omega__1 ^ 2;
      t60 = m__1 / 4;
      t64 = t51 * (t60 + m__2 / 2) + J__1;
      t65 = l__1 * t64;
      t68 = t21 * t1 * t65 * t12 * t57 * t8;
      t70 = t19 * l__2;
      t71 = sin(t20);
      t73 = cos(theta__2);
      t74 = t73 * t29;
      t77 = (t71 * t70 + 4 * t74) * t51;
      t78 = cos(t53);
      t86 = t71 * l__1 * t64 * t12;
      t95 = (m__1 + 4 * m__2 + t16) * J__2 / 4;
      t102 = t51 * (t8 * (t40 / 8 - t38 / 8) + t95) + (m__3 * t8 / 2 + J__2) * J__1;
      t103 = t102 * t57;
      t108 = t8 * t51;
      t109 = t12 ^ 2;
      t110 = 3 * theta__2;
      t111 = cos(t110);
      t113 = (t73 + t111) * t109;
      t116 = sin(t110);
      t118 = (t30 + t116) * t109;
      t122 = m__1 / 16;
      t127 = (m__1 + t11) * m__3;
      t133 = J__1 * t10;
      t134 = t51 * (t8 * (t38 / 8 + m__2 * (t122 + 0.3e1 / 0.4e1 * m__3) + t127 / 4) + t95) + t133;
      t137 = t78 * t113 * t108 - t54 * t118 * t108 - 16 * t134 * t73;
      t139 = 0.1e1 / l__2;
      t140 = t139 / t137;
      t150 = t51 * (m__1 / 2 + m__2) + 2 * J__1;
      t158 = (-t3 * t65 * t12 * t57 + lambda * t150 + t12 * (m__2 * t51 / 4 + J__1) * g) * t8;
      t180 = l__2 * (t51 * (t8 * (t38 / 16 + m__2 * (t122 + 0.3e1 / 0.8e1 * m__3) + t40 / 4) + (m__1 + t15 + t11) * J__2 / 4) + t133);
      t184 = t3 * l__1;
      t193 = t51 * (t8 * (-2 * m__1 - 6 * m__2 - 8 * m__3) - t35);
      t194 = J__1 * t8;
      t195 = 8 * t194;
      t211 = (t78 * t52 - 4 * t21 * t158 - t54 * t77 * t24 + 4 * t86 * t8 * t57 * t1 + 16 * t30 * t28 * t180 - 16 * t184 * t103 + lambda * (t193 - t195) - 4 * (t51 * (t8 * (0.3e1 / 0.4e1 * t38 + m__2 * (t60 + 3 * m__3) + t127) + t46) + t12 * t194) * g) * t10;
      t212 = t137 ^ 2;
      t214 = t139 / t212;
      out_3_1 = 4 * t140 * (-4 * t86 * t8 * t57 * t3 - 2 * t78 * t77 * t24 - 16 * t2 * t103 - 2 * t54 * t52 + 4 * t68) * t10 - 4 * (-2 * t54 * t113 * t108 - 2 * t78 * t118 * t108) * t214 * t211;
      out_1_2 = l__2 * t73;
      t224 = t30 * omega__2;
      out_2_2 = l__2 * t224;
      out_3_2 = 4 * t140 * (t78 * t51 * (-2 * t71 * t19 * t13 - 4 * t74 * t24) + 8 * t71 * t158 - t54 * (2 * t21 * t70 - 4 * t31) * t51 * t24 + 8 * t68 + 16 * t73 * t28 * t180) * t10 - 4 * (t78 * (-t30 - 3 * t116) * t109 * t108 - t54 * (t73 + 3 * t111) * t109 * t108 + 16 * t134 * t30) * t214 * t211;
      out_2_3 = t2;
      out_3_3 = 4 * t140 * (8 * t21 * t3 * t65 * t12 * omega__1 * t8 + 8 * t86 * t8 * omega__1 * t1 - 32 * t184 * t102 * omega__1) * t10;
      out_2_4 = -out_1_2;
      out_3_4 = 4 * t140 * (-8 * t54 * t73 * omega__2 * t27 * t51 * t24 - 8 * t78 * t51 * t224 * t27 * t24 + 32 * t224 * t180) * t10;
      out_3_5 = 4 * t140 * (t78 * t51 * (4 * t21 * t13 + t34 - t35) - 4 * t21 * t8 * t150 - 4 * t54 * t71 * t51 * t13 + t193 - t195) * t10;

      % Store outputs
      out_Jh_x = zeros(3, 5);
      out_Jh_x(1, 1) = out_1_1;
      out_Jh_x(2, 1) = out_2_1;
      out_Jh_x(3, 1) = out_3_1;
      out_Jh_x(1, 2) = out_1_2;
      out_Jh_x(2, 2) = out_2_2;
      out_Jh_x(3, 2) = out_3_2;
      out_Jh_x(2, 3) = out_2_3;
      out_Jh_x(3, 3) = out_3_3;
      out_Jh_x(2, 4) = out_2_4;
      out_Jh_x(3, 4) = out_3_4;
      out_Jh_x(3, 5) = out_3_5;
    end % Jh_x
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out_Jh_v = Jh_v( this, in_1, in_2, t )
      % Calculate the Jacobian of h with respect to v.

      % Extract properties
      l__1 = this.m_l__1;
      l__2 = this.m_l__2;
      m__1 = this.m_m__1;
      m__2 = this.m_m__2;
      m__3 = this.m_m__3;
      g = this.m_g;
      J__1 = this.m_J__1;
      J__2 = this.m_J__2;

      % Extract inputs
      theta__1 = in_1(1);
      theta__2 = in_1(2);
      omega__1 = in_1(3);
      omega__2 = in_1(4);
      lambda = in_1(5);

      % Evaluate function
      % No body

      % Store outputs
      out_Jh_v = zeros(3, 0);
    end % Jh_v
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end % SliderCrankRecursive

% That's All Folks!