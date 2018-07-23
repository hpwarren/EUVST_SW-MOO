
function euvst_wave2ea, wave

  common euvst_wave2ea_com, init, path
  if n_elements(init) eq 0 then begin
    file = find_with_def('euvst_wave2ea.pro', !path)
    break_file, file, disk, path, name, ext
    init = 1
  endif

  ;; --- find the right wavelength range
  wvl = [ [170., 215.],  [690., 850.], [925., 1085.], [ 1115., 1275.], $
          0.5*[925., 1085.], 0.5*[ 1115., 1275.] ]
  wvl = reform(wvl, 2, 6)
  p = list()
  for i=0, 5 do begin
    p.add, (wave-wvl[0,i])*(wvl[1,i]-wave)
  endfor
  p = p.ToArray()
  m = where(p gt 0, c)
  if c eq 0 then begin
    ;; --- the input wavelength was not found
    print, ' the input wavelegnth will not be observed by EUVST . . '
    return, -1
  endif else begin
    ;; --- interpolate the input wavelength
    ipf = 'euvst_ea_'+trim(m[0]+1)+'.txt'
    src = rd_tfile(concat_dir(path, ipf), /auto)
    ea = spline(double(src[0,*]), double(src[1,*]), wave, /double)
  endelse

  return, ea
end
