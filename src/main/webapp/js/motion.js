(function () {
  function start() {
    var selectors = ".hero-text, .hero-preview, .feature, .step, .section h2, .section-sub, .panel, .stat-card, .calc-card, .calc-history-placeholder, .auth-card, .dash-head";
    var items = document.querySelectorAll(selectors);
    if (!items.length) return;

    items.forEach(function (item, index) {
      item.classList.add("reveal");
      item.style.setProperty("--reveal-delay", Math.min(index % 6, 5) * 55 + "ms");
    });
    document.documentElement.classList.add("motion-ready");

    if (!window.IntersectionObserver) {
      items.forEach(function (item) { item.classList.add("is-visible"); });
      return;
    }
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      });
    }, { threshold: 0.12 });
    items.forEach(function (item) { observer.observe(item); });
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", start);
  else start();
})();
