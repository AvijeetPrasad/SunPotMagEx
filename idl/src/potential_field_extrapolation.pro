;+
; :Description:
;   This procedure calculates a potential field extrapolation for a magnetic field,
;   starting from the boundary conditions given by bz0, and generates three-dimensional
;   arrays for the magnetic field components bx, by, and bz using a Fourier-based method.
;   The algorithm uses Fast Fourier Transforms (FFT) for efficient computation of the
;   potential field in a stratified atmosphere.
;
; :Arguments:
;   bz0: in, required, Array<any>
;     A two-dimensional array representing the boundary magnetic field component perpendicular
;     to the photosphere.
;   bx: out, required, Array<any>
;     A three-dimensional array representing the x-component of the magnetic field.
;   by: out, required, Array<any>
;     A three-dimensional array representing the y-component of the magnetic field.
;   bz: out, required, Array<any>
;     A three-dimensional array representing the z-component of the magnetic field.
;
; :Keywords:
;   nz: in, optional, any
;     Allows the user to specify the number of grid points in the z-direction, otherwise,
;     it uses the number of grid points in the y dimension as default.
;
; :Name:
;   potential_field_extrapolation
;
; :Examples:
;   Example of how to call potential_field_extrapolation:
;
;   ```idl
;   ; assume we have a boundary magnetic field bz0 stored in a file
;   bz0 = resotre, 'bz0.sav'
;   potential_field_extrapolation, bz0, bx, by, bz, nz=100
;   ; This will compute the bx, by, and bz fields over 100 levels in z.
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
pro potential_field_extrapolation, bz0, bx, by, bz, nz = nz
  compile_opt idl2
  ss = size(bz0, /dimensions)
  nx = ss[0]
  ny = ss[1]
  if not (keyword_set(nz)) then nz = ss[1]
  ; creating the kl, km grid based on the structure given for FFT in IDL
  kla = indgen((nx / 2) + 1)
  klb = indgen((nx / 2) - 1) - ((nx / 2) - 1)
  klc = [kla, klb]
  kma = indgen((ny / 2) + 1)
  kmb = indgen((ny / 2) - 1) - ((ny / 2) - 1)
  kmc = [kma, kmb]
  kl = ((2 * !pi) / nx) * klc
  km = ((2 * !pi) / ny) * kmc

  ; creating the corresponding 2D arrays for kl and km
  kl = kl # replicate(1, ny) ; # performs array multiplication with column of first with row of second
  km = replicate(1, nx) # km
  klm = sqrt(kl ^ 2 + km ^ 2)
  blm = fft(bz0, -1) ; keyword -1 refers to forward FFT, 1 would mean inverse
  alm = blm / (klm > klm[1, 0]) ; avoiding division by zero by overwriting the 0,0 term by 1,0
  im = complex(0, 1)
  argx = -alm * im * kl
  argy = -alm * im * km

  bx = dblarr(nx, ny, nz, /nozero)
  by = dblarr(nx, ny, nz, /nozero)
  bz = dblarr(nx, ny, nz, /nozero)
  for k = 0, nz - 1 do begin
    bx[*, *, k] = fft(argx * exp(-klm * k), 1)
    by[*, *, k] = fft(argy * exp(-klm * k), 1)
    bz[*, *, k] = fft(blm * exp(-klm * k), 1)
  endfor
end