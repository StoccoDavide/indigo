%
%> Save the current file in '*.png' format.
%>
%> \param fname File name.
%>
%> \return The image in '*.png' format.
%
function save_png( fname )
  exportgraphics(gcf, [fname, '.pdf'], 'ContentType', 'image', 'ContentType', 'vector');
  system(['/usr/local/bin/pdf2svg ', fname, '.pdf ', fname, '.svg'] );
  system(['/usr/local/bin/pdftoppm -r 600 -png ', fname, '.pdf ', fname]);
  movefile([fname, '-1.png'], [fname, '.png'])
end
