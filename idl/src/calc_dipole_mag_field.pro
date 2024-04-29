;+
; :Description:
;   This procedure computes the magnetic field components due to a magnetic dipole over
;   a specified 3D grid defined by x_range, y_range, and z_range. It calculates the
;   magnetic field based on the dipole moment and adjusts the field strength according
;   to a specified maximum at the closest z-plane to the origin.
;
; :Arguments:
;   x_range: in, required, Array<any>
;     Array defining the x-coordinate range for the grid.
;   y_range: in, required, Array<any>
;     Array defining the y-coordinate range for the grid.
;   z_range: in, required, Array<any>
;     Array defining the z-coordinate range for the grid.
;   dipole_moment: in, required, Array<any>
;     Array [mx, my, mz] representing the dipole moment of the magnetic source.
;   B_field: out, required, Array<any>
;     A 3D array to store the computed magnetic field components at each grid point.
;
; :Keywords:
;   bz0_max: in, optional, Float
;     The value to normalize the maximum magnetic field strength at the z0_index.
;   r0: in, optional, Array<any>
;     Origin from which the position vectors are calculated. Default is [0, 0, 0].
;
; :Name:
;   calc_dipole_mag_field
;
; :Requirements:
;   mesh3d: user-defined, required
;     Relies on the `mesh3d` procedure to generate the 3D grid coordinates.
;
; :Examples:
;   Example of how to call calc_dipole_mag_field:
;
;   ```idl
;   x_range = findgen(101) * 0.24 - 12
;   y_range = findgen(101) * 0.24 - 12
;   z_range = findgen(101) * 0.24 - 3
;   dipole_moment = [1.0, 0.0, 0.0]  ; Dipole along the x-axis
;   r0 = [0, 0, -5]
;   bz0_max = 0.1
;   B_field = fltarr(3, 101, 101, 101)
;   calc_dipole_mag_field, x_range, y_range, z_range, dipole_moment, B_field, r0=r0, bz0_max=bz0_max
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
pro calc_dipole_mag_field, x_range, y_range, z_range, dipole_moment, B_field, r0 = r0, bz0_max = bz0_max
  compile_opt idl2
  ; check and set the default values for r0 and bz0_max
  if not (keyword_set(r0)) then r0 = [0, 0, 0]
  if not (keyword_set(bz0_max)) then bz0_max = 1.0
  ; find the z0_index using the z_range
  z0_index = where(abs(z_range) eq min(abs(z_range)))
  z0_index = z0_index[0]
  ; generate the grid points in x, y, z
  mesh3d, x_range, y_range, z_range, x, y, z
  ; Constants
  mu0 = 4.0 * !pi * 1.0e-7 ; Permeability of free space (H/m)
  ; calculate nx, ny, nz from the input arrays
  ss = size(x)
  nx = ss[1]
  ny = ss[2]
  nz = ss[3]
  if not keyword_set(r0) then r0 = [0, 0, 0]
  ; Compute the position vectors with respect to r0
  x = x - r0[0]
  y = y - r0[1]
  z = z - r0[2]
  ; Compute the magnitudes of the position vectors
  r = sqrt(x ^ 2 + y ^ 2 + z ^ 2)
  ; Ensure we do not divide by zero at the origin
  good = where(r ne 0, count)
  if count gt 0 then begin
    ; Calculate the dot product of m (dipole moment) and r for each grid point
    m_dot_r = dipole_moment[0] * x[good] + dipole_moment[1] * y[good] + dipole_moment[2] * z[good]

    ; Initialize magnetic field components
    Bx = fltarr(nx, ny, nz)
    By = fltarr(nx, ny, nz)
    Bz = fltarr(nx, ny, nz)

    ; Calculate the magnetic field components on the grid
    Bx[good] = mu0 / (4.0 * !pi) * (3.0 * m_dot_r * x[good] / r[good] ^ 5 - dipole_moment[0] / r[good] ^ 3)
    By[good] = mu0 / (4.0 * !pi) * (3.0 * m_dot_r * y[good] / r[good] ^ 5 - dipole_moment[1] / r[good] ^ 3)
    Bz[good] = mu0 / (4.0 * !pi) * (3.0 * m_dot_r * z[good] / r[good] ^ 5 - dipole_moment[2] / r[good] ^ 3)

    ; Combine the field components into a single 3D vector field
    B_field = fltarr(3, nx, ny, nz)
    B_field[0, *, *, *] = Bx
    B_field[1, *, *, *] = By
    B_field[2, *, *, *] = Bz

    ; Calculate the maximum magnitude of the magnetic field at z0 plane and set it to bz0_max
    bz0 = B_field[2, *, *, z0_index]
    bz0_max_current = max(bz0)
    B_field *= bz0_max / bz0_max_current
  endif
end