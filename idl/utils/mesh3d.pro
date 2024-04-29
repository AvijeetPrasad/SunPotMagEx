;+
; :Description:
;   This procedure generates a three-dimensional mesh grid from specified x, y, and z range arrays.
;   It creates three 3D arrays representing the grid coordinates in each dimension, which are essential
;   for volume rendering, 3D surface plotting, and multi-dimensional data analysis.
;
; :Arguments:
;   x_range: in, required, any
;     A one-dimensional array specifying the x-coordinates for the mesh grid.
;   y_range: in, required, any
;     A one-dimensional array specifying the y-coordinates for the mesh grid.
;   z_range: in, required, any
;     A one-dimensional array specifying the z-coordinates for the mesh grid.
;   x: out, required, any
;     A three-dimensional floating-point array filled with values from x_range, expanding along the first dimension.
;   y: out, required, any
;     A three-dimensional floating-point array filled with values from y_range, expanding along the second dimension.
;   z: out, required, any
;     A three-dimensional floating-point array filled with values from z_range, expanding along the third dimension.
;
; :Name:
;   mesh3d
;
; :Examples:
;   See this example of how to use mesh3d:
;
;   ```idl
;   x_range = [0, 1, 2, 3]
;   y_range = [0, 1, 2, 3]
;   z_range = [0, 1, 2, 3]
;   mesh3d, x_range, y_range, z_range, x, y, z
;   ; Now 'x', 'y', and 'z' contain the 3D grid coordinates.
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
pro mesh3d, x_range, y_range, z_range, x, y, z
  compile_opt idl2
  ; calculte nx, ny, nz from the input arrays
  nx = n_elements(x_range)
  ny = n_elements(y_range)
  nz = n_elements(z_range)

  ; Create the arrays to store the coordinates
  x = fltarr(nx, ny, nz)
  y = fltarr(nx, ny, nz)
  z = fltarr(nx, ny, nz)

  ; Fill the arrays with the corresponding coordinates
  for i = 0, nx - 1 do begin
    for j = 0, ny - 1 do begin
      for k = 0, nz - 1 do begin
        x[i, j, k] = x_range[i]
        y[i, j, k] = y_range[j]
        z[i, j, k] = z_range[k]
      endfor
    endfor
  endfor
end