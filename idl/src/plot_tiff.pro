;+
; :Description:
;   This procedure processes an image variable to apply histogram equalization
;   and then saves it as a TIFF file. It sets the device to Z buffer, adjusts image
;   resolution and pixel depth, displays the processed image, and writes it out.
;
; :Arguments:
;   var: in, required, Array<any>
;     The image data array to be processed and saved.
;   fname: in, required, String
;     Filename where the TIFF image will be saved.
;
; :Name:
;   plot_tiff
;
; :Requirements:
;   This function uses IDL's internal commands like SET_PLOT, DEVICE, LOADCT, and WRITE_TIFF.
;
; :Examples:
;   Example of how to call plot_tiff:
;
;   ```idl
;   data = restore, 'data.sav'
;   plot_tiff, data, 'output_image.tiff'
;   ```
;
; :Created on:
;   2024-04-30
;
; :Author:
;   Avijeet Prasad
;
; :Revisions:
;   Initial version
;
;-
pro plot_tiff, var, fname
  compile_opt idl2

  s = size(var)
  nx = s[1]
  ny = s[2]
  loadct, 0
  set_plot, 'Z'
  erase
  device, set_resolution = [nx, ny], set_pixel_depth = 24, decomposed = 0
  tv, hist_equal(var, percent = 0.05)
  write_tiff, fname, tvrd(/true), orientation = 4
  set_plot, 'x'
end