;+
; :Description:
;   This procedure writes a variable to a Visualization and Data Convertor (VDC)
;   file using raw binary intermediate files. It is designed to handle time-series
;   data types and utilizes external utilities for data conversion.
;
; :Arguments:
;   outdir: in, required, String
;     The directory path where temporary and final output files will be saved.
;   vdcfile: in, required, String
;     The filename of the VDC file where the variable data will be stored.
;   type: in, required, String
;     The data type of the variable to be written, e.g., 'float64'.
;   varname: in, required, String
;     The name of the variable as it will appear in the VDC file.
;   var: in, required, any
;     The variable data to be written.
;   timestep: in, required, Int
;     The timestep associated with the data, used in the conversion command.
;
; :Name:
;   write_var2vdc_ts
;
; :Requirements:
;   External utilities required: raw2vdc, rm
;   This function relies on external commands `raw2vdc` and `rm` for handling files.
;
; :Examples:
;   Example of how to call write_var2vdc_ts:
;
;   ```idl
;   outdir = '/path/to/data/'
;   vdcfile = 'output.vdc'
;   write_var2vdc_ts, outdir, vdcfile, 'float64', 'bz', bz, 0
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
pro write_var2vdc_ts, outdir, vdcfile, type, varname, var, timestep
  compile_opt idl2
  ; example call: write_var2vdc_ts, outdir, vdcfile, 'float64', 'bz', bz, timestep
  ; write data into vdc file from raw binary data
  rawfile = outdir + 'temp_' + varname + '.raw'
  openw, 1, rawfile
  writeu, 1, var
  close, 1
  spawn, 'raw2vdc -ts ' + timestep + ' -type ' + type + ' -varname ' + varname + ' ' + vdcfile + ' ' + rawfile
  spawn, 'rm ' + rawfile
  print, 'variable ' + varname + ' written'
end