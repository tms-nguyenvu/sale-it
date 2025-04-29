// app/javascript/controllers/sidebar_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "content"]

  connect() {
    // Check if sidebar state is stored in localStorage
    const sidebarCollapsed = localStorage.getItem('sidebarCollapsed') === 'true'
    if (sidebarCollapsed) {
      this.collapse()
    }
  }

  toggle() {
    if (this.sidebarTarget.classList.contains('collapsed')) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  collapse() {
    this.sidebarTarget.classList.add('collapsed')
    localStorage.setItem('sidebarCollapsed', 'true')
  }
  
  expand() {
    this.sidebarTarget.classList.remove('collapsed')
    localStorage.setItem('sidebarCollapsed', 'false')
  }
  
  // For responsive design - auto collapse on small screens
  _handleResize() {
    if (window.innerWidth < 768 && !this.sidebarTarget.classList.contains('collapsed')) {
      this.collapse()
    }
  }
}
