
classdef Pendulum5EQ < DAC_ODEclass
  properties (SetAccess = protected, Hidden = true)
    mass;
    ell;
    gravity;
  end
  methods
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function self = Pendulum5EQ( mass, ell, gravity )
      % call the constructor of the basic class
      neq  = 5;
      ninv = 3;
      self@DAC_ODEclass('Pendulum5EQ',neq,ninv);
      % setup of the parmater of the ODE
      self.mass    = mass;
      self.ell     = ell;
      self.gravity = gravity;
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function res__f = f( self, t, vars__ )

      % Store locally the class members
      m   = self.mass;
      ell = self.ell;
      g   = self.gravity;

      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);
      lambda = vars__(5);

      % evaluate function
      res__1 = u;
      res__2 = v;
      t1 = 0.1e1 / m;
      res__3 = -lambda * t1 * x;
      res__4 = t1 * (-m * g - y * lambda);
      t17 = x ^ 2;
      t18 = y ^ 2;
      res__5 = 0.1e1 / (t17 + t18) * (-3 * v * g * m - 4 * lambda * u * x - 4 * lambda * v * y);
      

      % store on output
      res__f = zeros(5,1);
      res__f(1) = res__1;
      res__f(2) = res__2;
      res__f(3) = res__3;
      res__f(4) = res__4;
      res__f(5) = res__5;

    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function res__DfDx = DfDx( self, t, vars__ )

      % Store locally the class members
      m   = self.mass;
      ell = self.ell;
      g   = self.gravity;

      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);
      lambda = vars__(5);

      % evaluate function
      res__1_3 = 1;
      res__2_4 = 1;
      t1 = 0.1e1 / m;
      res__3_1 = -lambda * t1;
      res__3_5 = -t1 * x;
      res__4_2 = res__3_1;
      res__4_5 = -t1 * y;
      t5 = v * g;
      t9 = u * lambda;
      t10 = x ^ 2;
      t13 = y ^ 2;
      t16 = v * lambda;
      t17 = x * y;
      t21 = t10 + t13;
      t22 = t21 ^ 2;
      t23 = 0.1e1 / t22;
      res__5_1 = t23 * (6 * m * x * t5 + 4 * t10 * t9 - 4 * t13 * t9 + 8 * t17 * t16);
      res__5_2 = t23 * (6 * m * y * t5 - 4 * t10 * t16 + 4 * t13 * t16 + 8 * t17 * t9);
      t34 = 0.1e1 / t21;
      res__5_3 = -4 * lambda * t34 * x;
      res__5_4 = t34 * (-3 * m * g - 4 * y * lambda);
      res__5_5 = t34 * (-4 * x * u - 4 * y * v);
      
      % store on output
      res__DfDx = zeros(5,5);
      res__DfDx(1,3) = res__1_3;
      res__DfDx(2,4) = res__2_4;
      res__DfDx(3,1) = res__3_1;
      res__DfDx(3,5) = res__3_5;
      res__DfDx(4,2) = res__4_2;
      res__DfDx(4,5) = res__4_5;
      res__DfDx(5,1) = res__5_1;
      res__DfDx(5,2) = res__5_2;
      res__DfDx(5,3) = res__5_3;
      res__DfDx(5,4) = res__5_4;
      res__DfDx(5,5) = res__5_5;
    end

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function res__h = h( self, t, vars__ )

      % Store locally the class members
      m   = self.mass;
      ell = self.ell;
      g   = self.gravity;

      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);
      lambda = vars__(5);

      % evaluate function
      t1 = ell ^ 2;
      t2 = x ^ 2;
      t3 = y ^ 2;
      res__1 = t1 - t2 - t3;
      res__2 = 2 * x * u + 2 * y * v;
      t8 = u ^ 2;
      t9 = v ^ 2;
      res__3 = 0.1e1 / m * (m * (2 * g * y - 2 * t8 - 2 * t9) + 2 * (t2 + t3) * lambda);
      

      % store on output
      res__h = zeros(3,1);
      res__h(1) = res__1;
      res__h(2) = res__2;
      res__h(3) = res__3;
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function res__DhDx = DhDx( self, t, vars__ )

      % Store locally the class members
      m   = self.mass;
      ell = self.ell;
      g   = self.gravity;

      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);
      lambda = vars__(5);

      % evaluate function
      t1 = 2 * x;
      res__1_1 = -t1;
      t2 = 2 * y;
      res__1_2 = -t2;
      res__2_1 = 2 * u;
      res__2_2 = 2 * v;
      res__2_3 = t1;
      res__2_4 = t2;
      t3 = 0.1e1 / m;
      res__3_1 = 4 * lambda * t3 * x;
      res__3_2 = t3 * (2 * m * g + 4 * lambda * y);
      res__3_3 = -4 * u;
      res__3_4 = -4 * v;
      t13 = x ^ 2;
      t14 = y ^ 2;
      res__3_5 = t3 * (2 * t13 + 2 * t14);
      
      % store on output
      res__DhDx = zeros(3,5);
      res__DhDx(1,1) = res__1_1;
      res__DhDx(1,2) = res__1_2;
      res__DhDx(2,1) = res__2_1;
      res__DhDx(2,2) = res__2_2;
      res__DhDx(2,3) = res__2_3;
      res__DhDx(2,4) = res__2_4;
      res__DhDx(3,1) = res__3_1;
      res__DhDx(3,2) = res__3_2;
      res__DhDx(3,3) = res__3_3;
      res__DhDx(3,4) = res__3_4;
      res__DhDx(3,5) = res__3_5;
end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function plot( self, t, vars__ )
      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);

      tt = 0:pi/30:2*pi;
      xx = self.ell*cos(tt);
      yy = self.ell*sin(tt);
      hold off;
      plot(xx,yy,'LineWidth',2,'Color','red');
      LL = 1-self.ell/hypot(x,y);
      x0 = LL*x;
      y0 = LL*y;
      hold on;
      L = 1.5*self.ell;
      drawLine(-L,0,L,0,'LineWidth',2,'Color','k');
      drawLine(0,-L,0,L,'LineWidth',2,'Color','k');
      drawAxes(2,0.25,1,0,0);
      drawLine(x0,y0,x,y,'LineWidth',8,'Color','b');
      drawCOG( 0.1*self.ell, x0, y0 );
      fillCircle( 'r', x, y, 0.1*self.ell );
      axis([-L L -L L]);
      title(sprintf('time=%5.2f',t));
      axis equal;
    end
  end
end