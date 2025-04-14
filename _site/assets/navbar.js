document.addEventListener("DOMContentLoaded", function () {
  const user = JSON.parse(localStorage.getItem("user")) || null;

  // 🔍 Cherche la bonne section pour placer les boutons à droite (ajuste si besoin)
  const navbarRight = document.querySelector('.quarto-navbar .quarto-navbar-tools') 
                   || document.querySelector('.navbar-nav.navbar-right') 
                   || document.querySelector('.navbar-nav');

  if (!navbarRight) return;

  // Crée le menu utilisateur
  const userMenu = document.createElement("div");
  userMenu.style.position = "relative";
  userMenu.style.display = "inline-block";
  userMenu.style.marginLeft = "1rem";

  const loginButton = document.createElement("button");
  loginButton.id = "login-button";
  loginButton.style.cssText = "padding: 8px 15px; background-color: #007BFF; color: white; border: none; border-radius: 5px; cursor: pointer;";

  const logoutMenu = document.createElement("div");
  logoutMenu.id = "logout-menu";
  logoutMenu.style.cssText = "display: none; position: absolute; top: 100%; right: 0; background: white; border: 1px solid #ccc; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); z-index: 999;";

  const logoutButton = document.createElement("button");
  logoutButton.id = "logout-button";
  logoutButton.textContent = "Déconnexion";
  logoutButton.style.cssText = "padding: 8px 16px; background: white; color: black; border: none; width: 100%; cursor: pointer;";

  logoutMenu.appendChild(logoutButton);
  userMenu.appendChild(loginButton);
  userMenu.appendChild(logoutMenu);
  navbarRight.appendChild(userMenu); // ✅ C’est ici que le bouton est ajouté

  if (user) {
    const initials = user.prenom.charAt(0).toUpperCase() + user.nom.charAt(0).toUpperCase();
    loginButton.innerText = initials;

    // Affiche le menu de déconnexion au survol
    loginButton.addEventListener("mouseenter", () => {
      logoutMenu.style.display = "block";
    });

    userMenu.addEventListener("mouseleave", () => {
      logoutMenu.style.display = "none";
    });

    logoutButton.addEventListener("click", () => {
      localStorage.removeItem("user");
      window.location.href = "login.html";
    });
  } else {
    loginButton.innerText = "Se connecter";
    loginButton.addEventListener("click", () => {
      window.location.href = "login.html";
    });
  }
});
