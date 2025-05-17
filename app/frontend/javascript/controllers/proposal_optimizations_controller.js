import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["button"]

  connect() {
    this.currentProposal = null
  }

  submit(event) {
    event.preventDefault()

    const form = this.element.closest("form")
    const company = form.querySelector('select[name="proposal[company_name]"]')
    const title = form.querySelector('input[name="proposal[title]"]')
    const requirements = form.querySelector('textarea[name="proposal[requirements]"]')
    const template = form.querySelector('select[name="proposal[template_sections][]"]')
    const sections = form.querySelectorAll('input[name="proposal[sections][]"]:checked')

    if (!company || !company.value) {
      this.showFlash('error', 'Please select a customer company.')
      return
    }
    if (!title || !title.value.trim()) {
      this.showFlash('error', 'Please enter a proposal title.')
      return
    }
    if (!requirements || !requirements.value.trim()) {
      this.showFlash('error', 'Please enter customer requirements.')
      return
    }
    if (!template || !template.value) {
      this.showFlash('error', 'Please select a template proposal.')
      return
    }
    if (!sections || sections.length === 0) {
      this.showFlash('error', 'Please select at least one section for the proposal.')
      return
    }

    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this._originalButtonHTML = this.buttonTarget.innerHTML
      this.buttonTarget.innerHTML = `<span class='loading loading-spinner loading-sm mr-2'></span> Optimizing...`
    }

    const formData = new FormData(form)

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Accept": "application/json"
      },
      body: formData
    })
      .then(response => response.json())
      .then(data => {
        if (data.optimized_proposal) {
          this.currentProposal = data.optimized_proposal
          this.showProposalModal(data.optimized_proposal)
        } else {
          this.showFlash(data.flash.type, data.flash.message)
        }
        this.enableButton()
      })
      .catch(() => {
        this.showFlash("error", "Optimization failed")
        this.enableButton()
      })
  }

  preview() {
    if (this.currentProposal) {
      this.showProposalModal(this.currentProposal)
    } else {
      this.showFlash("error", "No optimized proposal available. Please run Optimal AI first.")
    }
  }

  clearProposal() {
    const modalCheckbox = document.getElementById("proposal-preview-modal")
    const contentDiv = document.getElementById("proposal-preview-content")
    const hiddenField = document.getElementById("customized_proposal_field")

    this.currentProposal = null
    if (hiddenField) hiddenField.value = ''
    contentDiv.innerHTML = `<p class="text-gray-500 italic">Loading proposal...</p>`
    modalCheckbox.checked = false
    this.showFlash("success", "Proposal cleared successfully")
  }

  enableButton() {
    if (this.hasButtonTarget && this._originalButtonHTML) {
      this.buttonTarget.disabled = false
      this.buttonTarget.innerHTML = this._originalButtonHTML
    }
  }

  showFlash(type, message) {
    const container = document.getElementById("toast-container")
    if (!container) return

    const typeClassMap = {
      notice: "alert-info",
      success: "alert-success",
      error: "alert-error",
      alert: "alert-warning"
    }

    const toast = document.createElement("div")
    toast.setAttribute("data-controller", "flash")
    toast.className = `alert ${typeClassMap[type] || "alert-info"} shadow-lg animate-fade-in transition-opacity duration-500 ease-out`
    toast.innerHTML = `<span class="text-white">${message}</span>`

    container.appendChild(toast)

    setTimeout(() => {
      toast.classList.remove("animate-fade-in")
      toast.classList.add("animate-fade-out")

      toast.addEventListener("animationend", () => {
        toast.remove()
      })
    }, 4000)
  }

  showProposalModal(proposal) {
    const modalCheckbox = document.getElementById("proposal-preview-modal")
    const contentDiv = document.getElementById("proposal-preview-content")
    const editFormDiv = document.getElementById("proposal-edit-form")
    const modalBtns = document.getElementById("proposal-modal-buttons")
    const editBtns = document.getElementById("proposal-edit-buttons")
    const editBtn = document.getElementById("edit-proposal-btn")
    const clearBtn = document.getElementById("clear-proposal-btn")
    const saveBtn = document.getElementById("save-proposal-btn")
    const cancelBtn = document.getElementById("cancel-edit-btn")
    const hiddenField = document.getElementById("customized_proposal_field")

    let html = ''
    if (proposal.title) {
      html += `<h4 class='text-2xl font-bold mb-6 text-center text-primary'>${proposal.title}</h4>`
    }
    if (Array.isArray(proposal.content)) {
      proposal.content.forEach((section) => {
        html += `
          <div class='mb-6 border border-base-200 rounded-lg p-6 bg-white shadow-sm hover:shadow-md transition-shadow'>
            <h5 class='font-semibold text-lg mb-3 text-secondary'>${section.title}</h5>
            <div class='whitespace-pre-line text-base text-gray-700 leading-relaxed'>${section.content}</div>
          </div>
        `
      })
    } else {
      html += `<p class='text-gray-500 italic'>No sections available.</p>`
    }
    contentDiv.innerHTML = html
    contentDiv.classList.remove('hidden')
    editFormDiv.classList.add('hidden')
    modalBtns.classList.remove('hidden')
    editBtns.classList.add('hidden')

    modalCheckbox.checked = true

    if (editBtn) {
      editBtn.onclick = () => {
        this.renderEditForm(proposal)
        contentDiv.classList.add('hidden')
        editFormDiv.classList.remove('hidden')
        modalBtns.classList.add('hidden')
        editBtns.classList.remove('hidden')
      }
    }

    if (clearBtn) {
      clearBtn.onclick = () => {
        this.clearProposal()
      }
    }

    if (cancelBtn) {
      cancelBtn.onclick = () => {
        contentDiv.classList.remove('hidden')
        editFormDiv.classList.add('hidden')
        modalBtns.classList.remove('hidden')
        editBtns.classList.add('hidden')
      }
    }

    if (saveBtn) {
      saveBtn.onclick = () => {
        const newProposal = this.getEditedProposal()
        this.currentProposal = newProposal
        if (hiddenField) hiddenField.value = JSON.stringify(newProposal)
        this.showProposalModal(newProposal)
      }
    }
  }

  renderEditForm(proposal) {
    const editFormDiv = document.getElementById("proposal-edit-form")
    if (!editFormDiv) return

    let html = `
      <div class='mb-6'>
        <label class='font-bold mb-2 block text-gray-700'>Proposal Title</label>
        <input type='text' id='edit-proposal-title' class='input input-bordered w-full' value="${proposal.title || ''}">
      </div>
    `
    if (Array.isArray(proposal.content)) {
      proposal.content.forEach((section, idx) => {
        html += `
          <div class='mb-6 border border-base-200 rounded-lg p-4 bg-white'>
            <label class='font-semibold mb-2 block text-gray-700'>${section.title}</label>
            <textarea class='textarea textarea-bordered w-full' rows='6' id='edit-proposal-section-${idx}'>${section.content}</textarea>
          </div>
        `
      })
    }
    editFormDiv.innerHTML = html
  }

  getEditedProposal() {
    const title = document.getElementById('edit-proposal-title')?.value || ''
    const proposal = { title, content: [] }
    if (this.currentProposal && Array.isArray(this.currentProposal.content)) {
      this.currentProposal.content.forEach((section, idx) => {
        const content = document.getElementById(`edit-proposal-section-${idx}`)?.value || ''
        proposal.content.push({ title: section.title, content })
      })
    }
    return proposal
  }
}
