
function euvst_ints2counts, wvl_obs, ints_obs, exposure_time, photons=photons, $
                            verbose=verbose, test=test, pixel=pixel, text=text

  if keyword_set(test) then begin
    wvl_obs = 977.02
    ints_obs = 1.0E+3
    exposure_time = 1.0
  endif
  
  sr = (!arcsec2cm/!au_cm)^2  

  if not(keyword_set(pixel)) then begin
    px = 0.18
    py = 0.18
  endif else begin
    px = pixel
    py = pixel
  endelse
  
  if keyword_set(photons) then begin
    ;; --- input intensity is already in photon units
    ints_obs_erg = ints_obs/(1.99E-8/wvl_obs)
    ints_obs_ph = ints_obs
  endif else begin
    ;; --- input intensity is in ergs
    ints_obs_erg = ints_obs
    ints_obs_ph = ints_obs/(1.99E-8/wvl_obs)
  endelse

  ea = euvst_wave2ea(wvl_obs)

  counts = ea*(sr*px*py)*ints_obs_ph*exposure_time

  text = list()
  text.add, '     wavelength = '+trim(wvl_obs,'(f10.3)')+' Angstrom'
  text.add, '      intensity = '+trim(ints_obs_erg[0],'(f10.2)')+' erg/cm^2/s/sr'
  text.add, '      intensity = '+trim(ints_obs_ph[0],'(e10.2)')+' ph/cm^2/s/sr'    
  text.add, ' effective area = '+trim(ea,'(f10.2)')+' cm^2'
  text.add, '   x pixel size = '+trim(px,'(f10.2)')+' arcsec'
  text.add, '   y pixel size = '+trim(py,'(f10.2)')+' arcsec'
  text.add, '  exposure time = '+trim(exposure_time,'(f10.1)')+' s'
  text.add, '   total counts = '+trim(counts[0],'(f10.1)')
  text.add, ''
  if keyword_set(verbose) then begin    
    foreach t, text do print, t
  endif

  return, counts
end
