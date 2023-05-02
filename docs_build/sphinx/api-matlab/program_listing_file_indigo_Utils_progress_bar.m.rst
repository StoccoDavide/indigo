
.. _program_listing_file_indigo_Utils_progress_bar.m:

Program Listing for File progress_bar.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_Utils_progress_bar.m>` (``indigo/Utils/progress_bar.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> PROGRESS Display a progress bar inside the command window.
   %>
   %> texttt{80%  [================    ] Completed!}
   %>
   %> **Usage:**
   %>
   %> - progress('_start') initializes a new progress bar. Must always be called
   %>   first.
   %> - progress(i) updates the progress bar. i is a percentage.
   %> - progress(i, m) is similar, but a percentage is automagically calculated,
   %>   where i is the current step and m the maximum number of steps.
   %> - progress('_end') ends the progress bar.
   %> - progress('_erase') ends the progress bar and removes if from the command
   %>   window, restoring it to the way it was before the progress bar was initiated.
   %> - progress(message) ends the progress bar and adds message after the bar.
   %> - progress(..., opts) uses options from the opts struct.
   %>
   %> \param [optional] opts.percentage_length: sets the number of characters
   %>                   reserved for the percentage display (default: 5)
   %> \param [optional] opts.bar_length: sets the number of characters reserved
   %>                   for the progress bar (default: 20)
   %> \param [optional] opts.char_empty: sets the "empty" character (default: ' ')
   %> \param [optional] opts.char_filled: sets the "filled" character (default: '=')
   %>
   %> \return out The output string.
   %
   function progress_bar( input, varargin )
   
     % Handle input
     p = inputParser;
     p.addRequired('input');
     p.addOptional('max', []);
     p.addOptional('opts', []);
     p.parse(input, varargin{:});
     p = p.Results;
   
     % Handle options
     opts = struct;
     opts.perc_length = default_option(p.opts, 'perc_length', 5);
     opts.bar_length  = default_option(p.opts, 'bar_length',  20);
     opts.char_empty  = default_option(p.opts, 'char_empty',  ' ');
     opts.char_filled = default_option(p.opts, 'char_filled', '=');
   
     % If input is a string
     if ischar(p.input)
   
       switch p.input
         case ('_start')
           % Start a new progress bar
           str_out = generate_string(0, opts);
           fprintf(str_out);
         case ('_end')
           % End a progress bar
         case ('_erase')
           % End and erase a progress bar
           str_out = generate_string(0, opts);
           str_cr  = repmat('\b', 1, length(str_out)-2);
           fprintf(str_cr);
         otherwise
           % End a progress bar with a message after the bar
           str_out = sprintf(' %s\n', p.input);
           str_cr = repmat('\b', 1, 1);
         fprintf([str_cr, str_out]);
       end
   
     % If input is a number
     elseif isnumeric(p.input)
   
       % If a max value is also provided, compute the percentage
       % If no, p.input is assumed to be a percentage
       if (~isempty(p.max) && isnumeric(p.max))
         p.input = round(100*input/p.max);
       else
         if (p.input < 0)
           p.input = 0;
         elseif (p.input > 100)
           p.input = 100;
         end
       end
       % Generate the output string
       str_out = generate_string(p.input, opts);
       str_cr  = repmat('\b', 1, length(str_out)-2);
       fprintf([str_cr, str_out]);
   
     % Unsupported argument type
     else
       error('indigo::progress_bar(...): invalid input detected.');
     end
   end
   %
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   %
   %> Generate the progress bar string.
   %>
   %> \param perc Percentage of the progress bar to be filled.
   %> \param opts Struct containing the options.
   %>
   %> \return out The output string.
   %
   function out = generate_string( perc, opts )
   
     perc     = floor(perc);
     perc_out = [num2str(perc), '%%'];
     perc_out = [perc_out, repmat(' ', 1, opts.perc_length-length(perc_out)+1)];
     n_empty  = floor(perc/100*opts.bar_length);
     bar_out  = ['[', repmat('=', 1, n_empty), ...
                      repmat(' ', 1, opts.bar_length-n_empty), ']'];
     out      = [perc_out, bar_out, '\n'];
   end
   %
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   %
   %
   %> Check whether a setting was found in the options struct.
   %>
   %> \param opts    The options struct.
   %> \param field   The field to be checked.
   %> \param default The default value to be returned if the field is not found.
   %>
   %> \return out The field, or the default value if the field is not
   %>             found.
   %
   function out = default_option( opts, field, default )
   
     if (isfield(opts, field))
       out = opts.(field);
     else
       out = default;
     end
   end
   %
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
