import { Controller } from "@hotwired/stimulus";
import { jsPDF } from 'jspdf';

export default class extends Controller {
  static values = { url: String };
  static targets = ["button"];

  connect() {
    this.currentProposal = null;
    this.initializeFormFields();
  }

  initializeFormFields() {
    // Set the initial company_id value
    const companySelect = document.getElementById('company_name_select');
    const companyIdField = document.getElementById('company_id_field');

    if (companySelect && companyIdField) {
      const selectedOption = companySelect.options[companySelect.selectedIndex];
      if (selectedOption) {
        companyIdField.value = selectedOption.dataset.companyId;
      }

      // Update company_id when company selection changes
      companySelect.addEventListener('change', () => {
        const selectedOption = companySelect.options[companySelect.selectedIndex];
        if (selectedOption) {
          companyIdField.value = selectedOption.dataset.companyId;
        }
      });
    }

    // Set the initial template_proposal_id value
    const templateSelect = document.getElementById('template_proposal_select');
    const templateIdField = document.getElementById('template_proposal_id_field');

    if (templateSelect && templateIdField) {
      const selectedOption = templateSelect.options[templateSelect.selectedIndex];
      if (selectedOption) {
        templateIdField.value = selectedOption.dataset.templateId;
      }

      // Update template_proposal_id when template selection changes
      templateSelect.addEventListener('change', () => {
        const selectedOption = templateSelect.options[templateSelect.selectedIndex];
        if (selectedOption) {
          templateIdField.value = selectedOption.dataset.templateId;
        }
      });
    }
  }

  submit(event) {
    event.preventDefault();

    const form = this.element.closest("form");
    const company = form.querySelector('select[name="proposal[company_name]"]');
    const title = form.querySelector('input[name="proposal[title]"]');
    const requirements = form.querySelector('#proposal_requirements');
    const template = form.querySelector('select[name="proposal[template_sections][]"]');
    const sections = form.querySelectorAll('input[name="proposal[sections][]"]:checked');

    if (!company || !company.value) {
      this.showFlash('error', 'Please select a customer company.');
      return;
    }
    if (!title || !title.value.trim()) {
      this.showFlash('error', 'Please enter a proposal title.');
      return;
    }
    if (!requirements || !requirements.value.trim()) {
      this.showFlash('error', 'Please enter customer requirements.');
      return;
    }
    if (!template || !template.value) {
      this.showFlash('error', 'Please select a template proposal.');
      return;
    }
    if (!sections || sections.length === 0) {
      this.showFlash('error', 'Please select at least one section for the proposal.');
      return;
    }

    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true;
      this._originalButtonHTML = this.buttonTarget.innerHTML;
      this.buttonTarget.innerHTML = `<span class='loading loading-spinner loading-sm mr-2'></span> Optimizing...`;
    }

    // Get template sections data
    const templateSections = template.value;

    // Get selected sections
    const selectedSections = Array.from(sections).map(checkbox => checkbox.value);

    // Prepare the data to send to AI
    const formData = new FormData(form);
    formData.append("proposal[company_name]", company.value);
    formData.append("proposal[template_sections]", templateSections);
    formData.append("proposal[selected_sections]", JSON.stringify(selectedSections));

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Accept": "application/json",
      },
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.optimized_proposal) {
          this.currentProposal = data.optimized_proposal;
          // Store the optimized proposal in the hidden field for later form submission
          document.getElementById("customized_proposal_field").value = JSON.stringify(data.optimized_proposal);
          this.showProposalModal(data.optimized_proposal);

          // Enable the submit button after successful optimization
          const submitButton = form.querySelector('button[type="submit"]');
          if (submitButton) submitButton.disabled = false;
        } else {
          this.showFlash(data.flash.type, data.flash.message);
        }
        this.enableButton();
      })
      .catch(() => {
        this.showFlash("error", "Optimization failed");
        this.enableButton();
      });
  }

  preview() {
    if (this.currentProposal) {
      this.showProposalModal(this.currentProposal);
    } else {
      this.showFlash("error", "No optimized proposal available. Please run Optimal AI first.");
    }
  }

  clearProposal() {
    const modalCheckbox = document.getElementById("proposal-preview-modal");
    const contentDiv = document.getElementById("proposal-preview-content");
    const hiddenField = document.getElementById("customized_proposal_field");

    this.currentProposal = null;
    if (hiddenField) hiddenField.value = '';
    contentDiv.innerHTML = `<p class="text-gray-500 italic">Loading proposal...</p>`;
    modalCheckbox.checked = false;
    this.showFlash("success", "Proposal cleared successfully");
  }

  enableButton() {
    if (this.hasButtonTarget && this._originalButtonHTML) {
      this.buttonTarget.disabled = false;
      this.buttonTarget.innerHTML = this._originalButtonHTML;
    }
  }

  showFlash(type, message) {
    const container = document.getElementById("toast-container");
    if (!container) return;

    const typeClassMap = {
      notice: "alert-info",
      success: "alert-success",
      error: "alert-error",
      alert: "alert-warning",
    };

    const toast = document.createElement("div");
    toast.setAttribute("data-controller", "flash");
    toast.className = `alert ${typeClassMap[type] || "alert-info"} shadow-lg animate-fade-in transition-opacity duration-500 ease-out`;
    toast.innerHTML = `<span class="text-white">${message}</span>`;

    container.appendChild(toast);

    setTimeout(() => {
      toast.classList.remove("animate-fade-in");
      toast.classList.add("animate-fade-out");

      toast.addEventListener("animationend", () => {
        toast.remove();
      });
    }, 4000);
  }

  showProposalModal(proposal) {
    const modalCheckbox = document.getElementById("proposal-preview-modal");
    const contentDiv = document.getElementById("proposal-preview-content");
    const editFormDiv = document.getElementById("proposal-edit-form");
    const modalBtns = document.getElementById("proposal-modal-buttons");
    const editBtns = document.getElementById("proposal-edit-buttons");
    const editBtn = document.getElementById("edit-proposal-btn");
    const saveBtn = document.getElementById("save-proposal-btn");
    const form = document.getElementById("proposal-form");

    let html = '';
    if (proposal.title) {
      html += `<h4 class='text-2xl font-bold mb-6 text-center text-primary'>${proposal.title}</h4>`;
    }
    if (Array.isArray(proposal.content)) {
      proposal.content.forEach((section) => {
        html += `
          <div class='mb-6 border border-base-200 rounded-lg p-6 bg-white shadow-sm hover:shadow-md transition-shadow'>
            <h5 class='font-semibold text-lg mb-3'>${section.title}</h5>
            <div class='whitespace-pre-line text-base text-gray-700 leading-relaxed'>${section.content}</div>
          </div>
        `;
      });
    } else {
      html += `<p class='text-gray-500 italic'>No sections available.</p>`;
    }
    contentDiv.innerHTML = html;
    contentDiv.classList.remove('hidden');
    editFormDiv.classList.add('hidden');
    modalBtns.classList.remove('hidden');
    editBtns.classList.add('hidden');

    modalCheckbox.checked = true;

    if (saveBtn) {
      saveBtn.onclick = () => {
        // Store optimized proposal in hidden field
        document.getElementById("customized_proposal_field").value = JSON.stringify(proposal);

        // Enable submit button
        const submitButton = form.querySelector('button[type="submit"]');
        if (submitButton) {
          submitButton.disabled = false;
        }

        // Close modal
        modalCheckbox.checked = false;
        this.showFlash('success', 'Proposal saved successfully');

        // Add form submit handler
        if (form) {
          form.onsubmit = async (event) => {
            event.preventDefault();
            const formData = new FormData(form);

            try {
              const response = await fetch(form.action, {
                method: 'POST',
                headers: {
                  'Accept': 'application/json',
                  'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
                },
                body: formData
              });

              const data = await response.json();

              if (data.success) {
                this.showFlash('success', data.message);
                setTimeout(() => {
                  window.location.href = '/proposals';
                }, 500);
              } else {
                this.showFlash('error', data.errors || data.error || 'Failed to create proposal');
              }
            } catch (error) {
              console.error('Submit error:', error);
              this.showFlash('error', 'An error occurred while creating the proposal');
            }
          };
        }
      };
    }

    if (editBtn) {
      editBtn.onclick = () => {
        this.renderEditForm(proposal);
        contentDiv.classList.add('hidden');
        editFormDiv.classList.remove('hidden');
        modalBtns.classList.add('hidden');
        editBtns.classList.remove('hidden');
      };
    }

    const clearBtn = document.getElementById("clear-proposal-btn");
    if (clearBtn) {
      clearBtn.onclick = () => {
        this.clearProposal();
      };
    }

    const cancelBtn = document.getElementById("cancel-edit-btn");
    if (cancelBtn) {
      cancelBtn.onclick = () => {
        contentDiv.classList.remove('hidden');
        editFormDiv.classList.add('hidden');
        modalBtns.classList.remove('hidden');
        editBtns.classList.add('hidden');
      };
    }

    const exportBtn = document.getElementById("export-pdf-btn");
    if (exportBtn) {
      exportBtn.onclick = () => {
        this.exportPDF();
      };
    }
  }

  renderEditForm(proposal) {
    const editFormDiv = document.getElementById("proposal-edit-form");
    if (!editFormDiv) return;

    let html = `
      <div class='mb-6'>
        <label class='font-bold mb-2 block text-gray-700'>Proposal Title</label>
        <input type='text' id='edit-proposal-title' class='input input-bordered w-full' value="${proposal.title || ''}">
      </div>
    `;
    if (Array.isArray(proposal.content)) {
      proposal.content.forEach((section, idx) => {
        html += `
          <div class='mb-6 border border-base-200 rounded-lg p-4 bg-white'>
            <label class='font-semibold mb-2 block text-gray-700'>${section.title}</label>
            <textarea class='textarea textarea-bordered w-full' rows='6' id='edit-proposal-section-${idx}'>${section.content}</textarea>
          </div>
        `;
      });
    }
    editFormDiv.innerHTML = html;
  }

  getEditedProposal() {
    const title = document.getElementById('edit-proposal-title')?.value || '';
    const proposal = { title, content: [] };
    if (this.currentProposal && Array.isArray(this.currentProposal.content)) {
      this.currentProposal.content.forEach((section, idx) => {
        const content = document.getElementById(`edit-proposal-section-${idx}`)?.value || '';
        proposal.content.push({ title: section.title, content });
      });
    }
    return proposal;
  }

  exportPDF() {
    if (!this.currentProposal) {
      this.showFlash("error", "No proposal available to export. Please run Optimal AI first.");
      return;
    }

    const doc = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4',
    });

    const marginLeft = 10;
    const pageWidth = doc.internal.pageSize.getWidth() - (2 * marginLeft);
    const pageHeight = doc.internal.pageSize.getHeight();
    let yOffset = 20;

    // Set default font
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(16);

    // Title with wrapping
    if (this.currentProposal.title) {
      const splitTitle = doc.splitTextToSize(this.currentProposal.title, pageWidth);
      doc.text(splitTitle, pageWidth / 2 + marginLeft, yOffset, { align: 'center' });
      yOffset += (splitTitle.length * 7) + 10; // 7mm per line, plus 10mm spacing
    }

    // Sections
    if (Array.isArray(this.currentProposal.content)) {
      this.currentProposal.content.forEach((section) => {
        // Check if new page is needed
        if (yOffset > pageHeight - 40) {
          doc.addPage();
          yOffset = 20;
        }

        // Section title
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text(section.title, marginLeft, yOffset);
        yOffset += 10;

        // Section content
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const contentLines = doc.splitTextToSize(section.content, pageWidth);
        contentLines.forEach((line) => {
          if (yOffset > pageHeight - 20) {
            doc.addPage();
            yOffset = 20;
          }
          doc.text(line, marginLeft, yOffset);
          yOffset += 7;
        });

        yOffset += 5;
      });
    }

    const fileName = this.currentProposal.title
      ? `${this.currentProposal.title.replace(/\s+/g, '_')}.pdf`
      : 'proposal.pdf';

    doc.save(fileName);
    this.showFlash("success", "PDF exported successfully!");
  }
}
