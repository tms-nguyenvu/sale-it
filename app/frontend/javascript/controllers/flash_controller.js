import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 4000 }
  }

  connect() {
    setTimeout(() => {
      this.element.classList.add("animate-fade-out")
      this.element.addEventListener("animationend", () => {
        this.element.remove()
      }, { once: true })
    }, this.delayValue)
  }
}
