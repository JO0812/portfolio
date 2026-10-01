import { Controller } from "@hotwired/stimulus"

// Reveals [data-reveal] targets as they enter the viewport. The CSS only
// hides targets once html[data-motion] is set, so this is purely additive:
// no JS (or reduced motion) means everything stays visible.
export default class extends Controller {
  connect() {
    if (!document.documentElement.hasAttribute("data-motion")) return

    this.observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            entry.target.setAttribute("data-revealed", "")
            this.observer.unobserve(entry.target)
          }
        }
      },
      { threshold: 0.08 }
    )

    this.element.querySelectorAll("[data-reveal]").forEach((el) => {
      this.observer.observe(el)
    })
  }

  disconnect() {
    this.observer?.disconnect()
  }
}
