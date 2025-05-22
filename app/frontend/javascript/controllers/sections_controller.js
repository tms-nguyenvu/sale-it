import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.index = this.containerTarget.children.length
  }

  addSection(event) {
    event.preventDefault()
    const content = this.buildSection(this.index)
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    this.index++
  }

  removeSection(event) {
    event.preventDefault()
    const sectionGroup = event.target.closest(".section-group")

    const hiddenIdField = sectionGroup.querySelector('input[name$="[id]"]')

    if (hiddenIdField) {

      const sectionIndex = hiddenIdField.name.match(/\[(\d+)\]/)[1]
      const destroyField = document.createElement('input')
      destroyField.type = 'hidden'
      destroyField.name = `proposal_template[template_sections_attributes][${sectionIndex}][_destroy]`
      destroyField.value = '1'

      sectionGroup.style.display = 'none'
      sectionGroup.appendChild(destroyField)
    } else {
      sectionGroup.remove()
    }
  }

  buildSection(index) {
    return `
      <div class="section-group border border-gray-200 p-5 rounded-lg bg-white shadow-sm space-y-4 transition-all duration-200">
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700">Section Title</label>
          <input type="text" name="proposal_template[template_sections_attributes][${index}][title]" class="input w-full" placeholder="E.g., Project Overview" required />
        </div>
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700">Section Content</label>
          <textarea name="proposal_template[template_sections_attributes][${index}][content]" class="textarea w-full h-24" placeholder="Describe the section content..." required></textarea>
        </div>
        <button type="button" class="btn btn-sm btn-error text-white" data-action="click->sections#removeSection">
          Remove Section
        </button>
      </div>
    `
  }
}
