#= require jquery
#= require jquery_ujs
#= require foundation
#= require_tree .

$ ->
    $(document).foundation()

    $('.cloudi-menu-toggle').click ->
        $('.cloudi-menu').toggleClass('visible')
        false

    $('.profile-expand').click ->
        $('.menu-profile').toggleClass('expanded')
        false

    null
