document.addEventListener("DOMContentLoaded", function () {
  const links = document.querySelectorAll(".nav-link");

  links.forEach((link) => {
    if (link.textContent.trim() === "utilisateur") {
      const initiales = localStorage.getItem("initiales");
      const btn = document.createElement("button");

      if (initiales) {
        // Bouton avec initiales (utilisateur connecté)
        btn.textContent = initiales;
        btn.title = "Se déconnecter";
        btn.style.cssText = `
          background-color: #007BFF;
          color: white;
          border: none;
          border-radius: 50%;
          width: 40px;
          height: 40px;
          font-weight: bold;
          cursor: pointer;
        `;
        btn.onclick = function () {
          localStorage.clear();
          location.reload();
        };
      } else {
        // Bouton "Se connecter" (utilisateur non connecté)
        btn.textContent = "Se connecter";
        btn.title = "Se connecter";
        btn.style.cssText = `
          background-color: #007BFF;
          color: white;
          border: none;
          border-radius: 5px;
          padding: 8px 15px;
          cursor: pointer;
        `;
        btn.onclick = function () {
          window.location.href = "login.html";
        };
      }

      link.replaceWith(btn);
    }
  });
});
