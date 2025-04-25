import { createIcons, icons } from "lucide"
import "@hotwired/turbo-rails"
import "./controllers"



document.addEventListener("DOMContentLoaded", () => {
  createIcons({ icons })
})

document.addEventListener("turbo:load", () => {
  createIcons({ icons })
})
