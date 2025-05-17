import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["display", "edit", "input"];

  toggleEdit() {
    this.displayTarget.classList.toggle("hidden");
    this.editTarget.classList.toggle("hidden");
  }

  saveChanges(event) {
    event.preventDefault();
    this.editTarget.submit();
  }
}
