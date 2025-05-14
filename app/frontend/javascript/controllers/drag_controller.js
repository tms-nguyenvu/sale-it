import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["list"]

  connect() {
    new Sortable(this.listTarget, {
      group: "kanban-leads",
      animation: 150,
      draggable: ".item",
      onEnd: this.end.bind(this),
    })
  }

  async end(event) {
    const leadId = event.item.dataset.id
    const newStatus = event.to.dataset.status

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

    try {
      const response = await fetch(`/leads/${leadId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({ lead: { status: newStatus } }),
      })

      const data = await response.json()

      if (data.status === 'success') {
        console.log('Lead updated successfully:', data.lead)
      } else {
        console.error('Failed to update lead:', data.message)
        event.from.appendChild(event.item)
      }
    } catch (error) {
      console.error('Error during the update request:', error)
      event.from.appendChild(event.item)
    }
  }
}
