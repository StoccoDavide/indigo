
.. _program_listing_file_indigo_Utils_save_png.m:

Program Listing for File save_png.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_Utils_save_png.m>` (``indigo/Utils/save_png.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

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
