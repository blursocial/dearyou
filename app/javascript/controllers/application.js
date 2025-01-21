import { Application } from "@hotwired/stimulus"

// Initialize Stimulus Application
const application = Application.start()

// Configure Stimulus Development Experience
application.debug = false
window.Stimulus = application

export { application }
