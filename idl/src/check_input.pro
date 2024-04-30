;+
; :Description:
;   This procedure validates the presence and correctness of specified input parameters,
;   such as file paths and directories, before proceeding with further processing. It ensures
;   that all required input files and directories exist and that the input itself is a string.
;
; :Arguments:
;   input: in, required, String
;     The filename or directory path expected to be validated.
;
; :Name:
;   check_input
;
; :Requirements:
;   This function requires the IDL environment to have proper file and directory handling
;   capabilities and uses file_test and file_search functions to verify the existence
;   of files and directories.
;
; :Examples:
;   Example of how to call check_input:
;
;   ```idl
;   input_filename = 'input.pro'
;   check_input, input_filename
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
pro check_input, input
  compile_opt idl2

  ; check if input is a string
  if not isa(input, 'string') then begin
    print, 'Input must be a string.'
  endif

  ; check if input file exists
  input = file_search(input, count = fcount)
  if fcount eq 0 then begin
    print, 'Input file not found.'
  endif

  ; read the input file
  @input

  ; check if the input_dir exists
  if not file_test(input_dir, /directory) then begin
    print, 'Input directory does not exist.'
  endif

  ; check if the input_sav file exists
  if not file_test(input_sav) then begin
    print, 'Input sav file does not exist.'
  endif

  ; check if the output_dir exists
  if not file_test(output_dir, /directory) then begin
    print, 'Output directory does not exist.'
  endif
end