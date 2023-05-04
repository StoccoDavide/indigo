
.. _program_listing_file_+Indigo_+Utils_generate_rgb.m:

Program Listing for File generate_rgb.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Utils_generate_rgb.m>` (``+Indigo/+Utils/generate_rgb.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Compute Rgb triple for given CSS color name. The function returns the RGB
   %> (Red-Green-Blue) triple corresponding to the color name by the CSS3
   %> proposed standard [1], which contains 139 different colors (an RGB triple
   %> is a 1x3 vector of numbers between 0 and 1). The input color name is case
   %> insensitive, and for gray colors both spellings (gray and grey) are allowed.
   %>
   %>   **Usage:**
   %>   - c = Indigo.Utils.generate_rgb('DarkRed'): returns c = [0.5430 0 0].
   %>   - c = Indigo.Utils.generate_rgb('Green'): returns c = [0 0.5 0].
   %>   - plot(x, y, 'color', generate_rgb('Orange')): plots an orange line through
   %>     x and y.
   %>   - Indigo.Utils.show_colors(): shows all the available colors.
   %>
   %>   **Background:**
   %>     The color names of [1] have already been ratified in [2], and
   %>     according to [3] they are accepted by almost all web browsers and are
   %>     used in Microsoft's .net framework. All but four colors agree with
   %>     the X11 colornames, as detailed in [4]. Of these the most important
   %>     clash is green, defined as [0 0.5 0] by CSS and [0 1 0] by X11. The
   %>     definition of green in Matlab matches the X11 definition and gives a
   %>     very light green, called lime by CSS (many users of Matlab have
   %>     discovered this when trying to color graphs with 'g-'). Note that
   %>     cyan and aqua are synonyms as well as magenta and fuchsia.
   %>
   %>   **About:**
   %>     This program is public domain and may be distributed freely.
   %>     Author: Kristjan Jonasson, Dept. of Computer Science, University of
   %>     Iceland (jonasson@hi.is). June 2009.
   %>
   %>   **References:**
   %>     [1] "CSS Color module level 3", W3C (World Wide Web Consortium)
   %>         working draft 21 July 2008, http://www.w3.org/TR/css3-color
   %>     [2] "Scalable Vector Graphics (SVG) 1.1 specification", W3C
   %>         recommendation 14 January 2003, edited in place 30 April 2009,
   %>         http://www.w3.org/TR/SVG
   %>     [3] "Web colors", http://en.wikipedia.org/wiki/Web_colors
   %>     [4] "X11 color names" http://en.wikipedia.org/wiki/X11_color_names
   %>
   %> \param str Color string name.
   %>
   %> \return Red-Green-Blue triple.
   %
   function out = generate_rgb( str )
   
     CMD = 'Indigo.Utils.generate_rgb(...): ';
   
     % First time rgb is called
     [num, name] = Indigo.Utils.get_colors();
     name = lower(name);
     num  = reshape(hex2dec(num), [], 3);
   
     % Divide most numbers by 256 for "aesthetic" reasons (green = [0 0.5 0])
     I = num < 240;
     
     % Interpolate F0-FF linearly from 240/256 to 1.0
     num(I)  = num(I)/256;
     num(~I) = ((num(~I) - 240)/15 + 15)/16; % + 240;
   
     % Show colors chart
     if strcmpi(str, 'chart')
       Indigo.Utils.show_colors()
     else
       k = find(strcmpi(str, name)); %#ok<STLOW>
       if isempty(k)
         error([CMD, 'invalid color ''', str, '''.']);
       else
         out = num(k(1), :);
       end
     end
   end
