document.addEventListener("DOMContentLoaded", () => {
  const toggleButton = document.getElementById("theme-toggle")
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches

  // Load theme from localStorage or fallback to system preference
  if (
    localStorage.getItem("theme") === "dark" ||
    (!localStorage.getItem("theme") && prefersDark)
  ) {
    document.documentElement.classList.add("dark-mode")
  }

  toggleButton.addEventListener("click", () => {
    document.documentElement.classList.toggle("dark-mode")

    if (document.documentElement.classList.contains("dark-mode")) {
      localStorage.setItem("theme", "dark")
    } else {
      localStorage.setItem("theme", "light")
    }
  })
})
