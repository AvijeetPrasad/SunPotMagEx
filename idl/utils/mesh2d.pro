;+
; :Description:
;   This procedure generates a two-dimensional mesh grid from specified x and y range arrays.
;   It creates two 2D arrays representing the grid coordinates, which are essential for graphical
;   representations and further spatial analysis in various data processing tasks.
;
; :Arguments:
;   x_range: in, required, any
;     A one-dimensional array specifying the x-coordinates for the mesh grid.
;   y_range: in, required, any
;     A one-dimensional array specifying the y-coordinates for the mesh grid.
;   x: out, required, any
;     A two-dimensional floating-point array filled horizontally with values from x_range.
;   y: out, required, any
;     A two-dimensional floating-point array filled vertically with values from y_range.
;
; :Name:
;   mesh2d
;
; :Examples:
;   See this example of how to use mesh2d:
;
;   ```idl
;   x_range = [0, 1, 2, 3, 4]
;   y_range = [0, 1, 2, 3, 4]
;   mesh2d, x_range, y_range, x, y
;   ; Now 'x' and 'y' contain the grid coordinates.
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
pro mesh2d, x_range, y_range, x, y
  compile_opt idl2
  ; Calculate nx and ny from the input arrays
  nx = n_elements(x_range)
  ny = n_elements(y_range)

  ; Create the arrays to store the coordinates
  x = fltarr(nx, ny)
  y = fltarr(nx, ny)

  ; Fill the arrays with the corresponding coordinates
  for i = 0, nx - 1 do begin
    for j = 0, ny - 1 do begin
      x[i, j] = x_range[i]
      y[i, j] = y_range[j]
    endfor
  endfor
end