import { Controller } from "@hotwired/stimulus"

// Pointer-following glow. The element is display:none on touch devices and
// reduced-motion setups (see CSS), so this only runs where it can be seen.
export default class extends Controller {
  connect() {
    if (matchMedia("(hover: none)").matches) return
    if (matchMedia("(prefers-reduced-motion: reduce)").matches) return

    this.frame = null
    this.onMove = (event) => {
      if (this.frame) return
      this.frame = requestAnimationFrame(() => {
        this.frame = null
        this.element.style.transform = `translate(${event.clientX}px, ${event.clientY}px)`
        this.element.style.opacity = "1"
      })
    }

    addEventListener("pointermove", this.onMove, { passive: true })
  }

  disconnect() {
    removeEventListener("pointermove", this.onMove)
    if (this.frame) cancelAnimationFrame(this.frame)
  }
}
