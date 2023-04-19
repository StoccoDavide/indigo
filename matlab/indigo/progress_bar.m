function progress_bar(input, varargin)
  % PROGRESS Display a progress bar inside the command window
  %
  %   64%  [==============================                  ]
  %
  % - progress('_start') initializes a new progress bar. Must always be called
  %     first.
  % - progress(i) updates the progress bar. i is a percentage.
  % - progress(i, m) is similar, but a percentage is automagically calculated,
  %   where i is the current step and m the maximum number of steps.
  % - progress('_end') ends the progress bar.
  % - progress('_erase') ends the progress bar and removes if from the command 
  %   window, restoring it to the way it was before the progress bar was 
  %   initiated.
  % - progress(message) ends the progress bar and adds message after the bar.
  % - progress(..., opts) uses options from the opts struct. See below.
  %
  % Option settings:
  % 
  % - opts.percentage_length: sets the number of characters reserved for the
  %   percentage display (default: 5)    
  % - opts.bar_length: sets the number of characters reserved for the progress 
  %   bar (default: 20)
  % - opts.char_empty: sets the "empty" character (default: ' ')
  % - opts.char_filled: sets the "filled" character (default: '=')

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

  % Act depending on the input
  if ischar(p.input) % If input is a string
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
  elseif isnumeric(p.input) % If input is a number
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
  else
    % Unsupported argument type
    error('indigo::progress(...): invalid input detected.');
  end
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function out = generate_string(perc, s)
  % Generate the progress bar string

  perc     = floor(perc);
  perc_out = [num2str(perc), '%%'];
  perc_out = [perc_out, repmat(' ', 1, s.perc_length-length(perc_out)+1)];
  n_empty  = floor(perc/100*s.bar_length);
  bar_out  = ['[' repmat('=',1,n_empty), repmat(' ',1,s.bar_length-n_empty), ']'];
  out      = [perc_out, bar_out, '\n'];
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function out = default_option(opts, field, default)
  % Check whether a setting was found in the options struct

  if isfield(opts, field)
    out = opts.(field);
  else
    out = default;
  end
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
