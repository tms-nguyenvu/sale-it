import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["companySelect", "contactSelect", "contactsData"]

  async updateContacts() {
    const companyId = this.companySelectTarget.value
    if (!companyId) {

      this.contactSelectTarget.innerHTML = '<option>Select contact</option>'
      return
    }

    try {
      const response = await fetch(`/companies/${companyId}/contacts`)
      const contacts = await response.json()
      this.contactSelectTarget.innerHTML = '<option>Select contact</option>'

      contacts.forEach(contact => {
        const option = document.createElement("option")
        option.text = `${contact.name}`
        option.value = contact.id
        this.contactSelectTarget.appendChild(option)
      })
    } catch (error) {
      console.error("Error fetching contacts:", error)
      alert("Failed to fetch contacts. Please try again.")
    }
  }
}
