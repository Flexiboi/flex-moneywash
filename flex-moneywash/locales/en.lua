local Translations = {
    error = {
        alreadymachine = 'You already own a machine',
        nocoin = 'You don\'t have a coin..'
    },
    success = {
        startedmachine = 'Machine turned on!',
        startwash = 'Started washing',
        getmoney = 'Your wash is ready and earned: €'
    },
    info = {
        free = 'Free',
        bussy = 'Occupied',
        enterloc = ' to enter',
        leaveloc = ' to leave',
        addcoin = ' insert coin',
        startwash = ' to start washing',
        totalwashtimer = 'Time till machine runs out: ',
        washtimer = 'Wash ready in: ',
    },
    text = {
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
