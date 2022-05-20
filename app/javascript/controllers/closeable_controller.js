import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="closeable"
export default class extends Controller {
  close() {
    this.element.remove();
  }

  handleKeyup(e) {
    if (e.code == "Escape") {
      this.close()
    }
  }
}
