;+
; :Description:
;   This procedure allows users to interactively crop a dataset to a specified size and
;   optionally rescale it. The procedure prompts the user for new dimensions and origin
;   coordinates, displays the cropped data, and saves the crop details if specified.
;
; :Arguments:
;   data: in, required, Array<any>
;     The input data array to be cropped.
;
; :Keywords:
;   cropsav: in, optional, String
;     Specifies the filename to save the crop details. If not provided, the cropping
;     details are not saved. The default is 'cropped_data.sav'.
;
; :Name:
;   crop_data
;
; :Requirements:
;   None.
;
; :Examples:
;   Example of how to call crop_data:
;
;   ```idl
;   data = restore, 'data.sav'
;   crop_data, data, cropsav='cropped_data.sav'
;   ```
;
; :Created on:
;   2024-04-29
;
; :Author:
;   Avijeet Prasad
;
; :Revisions:
;   Initial version
;
;-
pro crop_data, data, cropsav = cropsav
  compile_opt idl2
  if not (keyword_set(cropsav)) then cropsav = 'cropped_data.sav'
  ; crop the data to the desired size
  ; ______________________ Cropping the field to optimum size ____________________
  ss = size(data)
  nx = ss[1]
  ny = ss[2]
  iaspect = float(nx) / float(ny)

  spawn, 'clear'
  print, 'initial nx = ' + string(nx)
  print, 'initial ny = ' + string(ny)
  print, 'initial aspect = ' + string(iaspect)

  set_plot, 'X'
  loadct, 0
  plot_image, -1000 > data < 1000, charsize = 2, charthick = 2
  cropin = ''
  while (cropin ne 'y') do begin
    plot_image, -1000 > data < 1000, charsize = 2, charthick = 2
    read, xsize, prompt = 'new xsize  =  '
    read, ysize, prompt = 'new ysize  =  '
    read, xorg, prompt = 'new xorg   =  '
    read, yorg, prompt = 'new yorg   =  '
    cropped_data = data[xorg : (xorg + xsize - 1), yorg : (yorg + ysize - 1)]
    plot_image, cropped_data
    print, 'mean = ', mean(cropped_data)
    mean_bz0 = mean(cropped_data)
    read, cropin, prompt = 'is the cropping fine? y(yes)/n(no): '
  endwhile

  xsize = fix(xsize)
  ysize = fix(ysize)
  xorg = fix(xorg)
  yorg = fix(yorg)

  print, 'cropped xsize = ' + string(xsize)
  print, 'cropped ysize = ' + string(ysize)
  print, 'crop xorg     = ' + string(xorg)
  print, 'crop yorg     = ' + string(yorg)
  print, 'mean = ', mean_bz0
  iscl = ''
  scale = 1
  read, iscl, prompt = 'do you want to rescale the data? y(yes)/n(no):  '
  if (iscl eq 'y') then begin
    read, nxsize, prompt = ' new xsize  = : '
    scale = xsize / nxsize
  endif
  nx = fix(xsize / scale)
  ny = fix(ysize / scale)
  print, ' final nx = ' + string(nx)
  print, ' final ny = ' + string(ny)

  xys = strtrim(xsize, 2) + '_' + strtrim(ysize, 2) + '_' + strtrim(fix(scale), 2)
  save, cropped_data, xsize, ysize, xorg, yorg, scale, nx, ny, xys, mean_bz0, $
    description = 'Cropping details for the data', $
    filename = cropsav
  print, 'New crop details saved in: ', cropsav
end