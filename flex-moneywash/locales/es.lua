local Translations = {
  error = {
      alreadymachine = 'Ya posees una máquina',
      nocoin = 'No tienes una moneda...'
  },
  success = {
      startedmachine = '¡Máquina encendida!',
      startwash = 'Inicio del lavado',
      getmoney = 'Tu lavado está listo y has ganado: €'
  },
  info = {
      free = 'Libre',
      bussy = 'Ocupado',
      enterloc = ' para entrar',
      leaveloc = ' para salir',
      addcoin = ' insertar moneda',
      startwash = ' para iniciar el lavado',
      totalwashtimer = 'Tiempo restante de la máquina: ',
      washtimer = 'Lavado listo en: ',
  },
  text = {
 },
}
if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
