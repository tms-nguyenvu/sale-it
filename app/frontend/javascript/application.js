import { createIcons, icons } from "lucide"
import "chartkick/chart.js"
import "@hotwired/turbo-rails"
import "./controllers"


document.addEventListener("DOMContentLoaded", () => {
  createIcons({ icons })
})


document.addEventListener("turbo:load", () => {
  createIcons({ icons })
})


document.addEventListener("turbo:frame-load", () => {
  createIcons({ icons })
})
