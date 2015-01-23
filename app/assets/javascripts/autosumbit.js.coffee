$ ->
    $('[data-autosubmit]').change (e) ->
        tget = e.currentTarget
        if (tget.value != "")
            tget.form.submit()
