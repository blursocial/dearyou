document.addEventListener("DOMContentLoaded", () => {
  const postsContainer = document.getElementById("posts")
  const loadingDiv = document.getElementById("loading")

  // Check if the `posts` container exists
  if (!postsContainer) return

  let isLoading = false

  // Get CSRF token from meta tag
  const csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute("content")

  // Attach scroll event listener
  window.addEventListener("scroll", async () => {
    // Check if near the bottom of the page
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement

    if (scrollHeight - scrollTop <= clientHeight + 100 && !isLoading) {
      const nextPage = postsContainer.dataset.nextPage

      if (!nextPage) {
        console.log("No more pages to load.")
        return
      }

      isLoading = true
      loadingDiv.style.display = "block"

      try {
        // Fetch the next page with CSRF token
        const response = await fetch(`/posts?page=${nextPage}`, {
          method: "GET",
          headers: {
            Accept: "text/javascript",
            "X-CSRF-Token": csrfToken, // Include CSRF token
          },
        })

        if (!response.ok) {
          throw new Error("Network response was not ok")
        }

        const script = await response.text()
        eval(script) // Execute the JavaScript response from the server
      } catch (error) {
        console.error("There was a problem with the fetch operation:", error)
      } finally {
        isLoading = false
        loadingDiv.style.display = "none"
      }
    }
  })
})
