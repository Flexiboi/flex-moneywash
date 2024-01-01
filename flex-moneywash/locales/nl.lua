local Translations = {
    error = {
        alreadymachine = 'Je hebt al een machine draaiende',
        nocoin = 'Je hebt geen muntje..'
    },
    success = {
        startedmachine = 'Machine aangezet!',
        startwash = 'Gestart met wassen',
        getmoney = 'Je waste je geld en kreeg: €'
    },
    info = {
        free = 'Vrij',
        bussy = 'Bezet',
        enterloc = ' om binnen te gaan',
        leaveloc = ' om buiten te gaan',
        addcoin = ' steek muntje er in',
        startwash = ' om te beginnen wassen',
        totalwashtimer = 'Tijd om te wassen: ',
        washtimer = 'Wasje klaar in: ',
    },
    text = {
    },
}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
