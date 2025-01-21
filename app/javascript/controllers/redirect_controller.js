import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", this.redirect.bind(this))
  }

  redirect(event) {
    // Check if the response is successful
    if (event.detail.success) {
      // Redirect to the root page
      window.location.href = "/"
    }
  }
}
