import Rails from "@rails/ujs"

Rails.start()

import "../styles/application"

const images = require.context('../images', true)
