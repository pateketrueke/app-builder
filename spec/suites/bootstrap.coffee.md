
    $('<div id="wrapper" />').hide().appendTo document.body

    thinner.setup el: '#wrapper'
    thinner.loader().router.updateURL = $.noop
