
.. _program_listing_file_+Indigo_+Utils_show_colors.m:

Program Listing for File show_colors.m
======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Utils_show_colors.m>` (``+Indigo/+Utils/show_colors.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Creates a figure window showing all the available colors with their names.
   %
   function show_colors()
     [~, name] = Indigo.Utils.get_colors();
     grp = {'White', 'Gray', 'Red', 'Pink', 'Orange', 'Yellow', 'Brown', ...
       'Green', 'Blue', 'Purple', 'Grey'};
     J  = [1, 3, 6, 8, 9, 10, 11];
     fl = lower(grp);
     nl = lower(name);
     n  = zeros(length(grp), 1);
     for i = 1:length(grp)
       n(i) = strmatch(fl{i}, nl, 'exact'); %#ok<MATCH3>
     end
     clf
     p   = get(0, 'screensize');
     wh  = 0.6*p(3:4);
     xy0 = p(1:2) + 0.5*p(3:4) - wh/2;
     set(gcf, 'position', [xy0 wh]);
     axes('position', [0 0 1 1], 'visible', 'off');
     hold on
     x = 0;
     N = 0;
     for i = 1:length(J)-1
       N = max(N, n(J(i+1)) - n(J(i)) + (J(i+1) - J(i))*1.3);
     end
     h = 1/N;
     w = 1/(length(J)-1);
     d = w/30;
     for col = 1:length(J)-1
       y = 1 - h;
       for i = J(col):J(col+1)-1
         t = text(x+w/2, y+h/10 , [grp{i} ' colors']);
         set(t, 'fontw', 'bold', 'vert', 'bot', 'horiz', 'cent', 'fontsize', 10);
         y = y - h;
         for k = n(i):n(i+1)-1
           c = Indigo.Utils.generate_rgb(name{k});
           bright = (c(1) + 2*c(2) + c(3)) / 4;
           if (bright < 0.5)
             txtcolor = 'w';
           else
             txtcolor = 'k';
           end
           rectangle('position', [x+d, y, w-2*d, h], 'facecolor', c);
           t = text(x+w/2, y+h/2, name{k}, 'color', txtcolor);
           set(t, 'vert', 'mid', 'horiz', 'cent', 'fontsize', 9);
           y = y - h;
         end
         y = y - 0.3*h;
       end
       x = x + w;
     end
   end
