document.addEventListener("DOMContentLoaded", function () {
  const user = JSON.parse(localStorage.getItem("user")) || null;
  const loginButton = document.getElementById("login-button");
  const logoutMenu = document.getElementById("logout-menu");
  const logoutButton = document.getElementById("logout-button");
  const userContainer = document.getElementById("user-container");

  if (!loginButton || !logoutMenu || !logoutButton || !userContainer) return;

  if (user && user.prenom && user.nom) {
    const initials = user.prenom.charAt(0).toUpperCase() + user.nom.charAt(0).toUpperCase();
    loginButton.textContent = initials;

    // Ajout du style rond
    loginButton.style.borderRadius = "50%";
    loginButton.style.width = "40px";
    loginButton.style.height = "40px";
    loginButton.style.padding = "0";
    loginButton.style.textAlign = "center";
    loginButton.style.fontWeight = "bold";

    // Survol pour afficher déconnexion
    userContainer.addEventListener("mouseenter", () => {
      logoutMenu.style.display = "block";
    });

    userContainer.addEventListener("mouseleave", () => {
      logoutMenu.style.display = "none";
    });

    logoutButton.addEventListener("click", () => {
      localStorage.removeItem("user");
      window.location.href = "login.html";
    });
  } else {
    loginButton.textContent = "Se connecter";
    loginButton.style.borderRadius = "5px"; // bouton classique
    loginButton.addEventListener("click", () => {
      window.location.href = "login.html";
    });
  }
});
