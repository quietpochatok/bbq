require("@rails/ujs").start()
var jQuery = require('jquery')

// include jQuery in global and window scope (so you can access it globally)
// in your web browser, when you type $('.div'), it is actually refering to global.$('.div')
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import 'bootstrap/dist/js/bootstrap'
import 'ekko-lightbox/dist/ekko-lightbox.js'
import '../styles/application'
import '../scripts/map'
import '../scripts/lightbox'

const images = require.context('../images', true)

