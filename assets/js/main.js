/* ============================================================
   Vishnu Priya Nuthanapati — Portfolio interactions
   Vanilla JS · no dependencies
   ============================================================ */
(function () {
  'use strict';

  var reduceMotion = window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- Scroll progress bar ---------- */
  var progress = document.getElementById('progress');
  function onScrollProgress() {
    var h = document.documentElement;
    var max = h.scrollHeight - h.clientHeight;
    var p = max > 0 ? (h.scrollTop || window.pageYOffset) / max : 0;
    if (progress) progress.style.width = (p * 100) + '%';
  }

  /* ---------- Nav: shadow on scroll + scroll-spy ---------- */
  var nav = document.getElementById('nav');
  var secs = document.querySelectorAll('main section[id]');
  var navAs = document.querySelectorAll('.nav-links a');
  function onScrollNav() {
    if (nav) nav.classList.toggle('scrolled', (window.pageYOffset || 0) > 12);
    var cur = '';
    secs.forEach(function (s) {
      if (window.scrollY >= s.offsetTop - 90) cur = s.id;
    });
    navAs.forEach(function (a) {
      a.classList.toggle('active', a.getAttribute('href') === '#' + cur);
    });
  }

  var ticking = false;
  window.addEventListener('scroll', function () {
    if (!ticking) {
      window.requestAnimationFrame(function () {
        onScrollProgress();
        onScrollNav();
        ticking = false;
      });
      ticking = true;
    }
  }, { passive: true });
  onScrollProgress();
  onScrollNav();

  /* ---------- Mobile menu ---------- */
  var mobMenu = document.getElementById('mobMenu');
  var mobBtn = document.querySelector('.nav-mob');
  function closeMob() {
    if (!mobMenu) return;
    mobMenu.classList.remove('open');
    if (mobBtn) mobBtn.setAttribute('aria-expanded', 'false');
  }
  if (mobBtn) {
    mobBtn.addEventListener('click', function () {
      var open = mobMenu.classList.toggle('open');
      mobBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
  }
  if (mobMenu) {
    mobMenu.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', closeMob);
    });
  }

  /* ---------- Scroll-reveal with stagger ---------- */
  var revEls = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && !reduceMotion) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          var el = e.target;
          var parent = el.parentElement;
          var sibs = parent ? Array.prototype.slice.call(parent.querySelectorAll(':scope > .reveal')) : [el];
          var idx = sibs.indexOf(el);
          el.style.transitionDelay = (idx > 0 ? idx * 80 : 0) + 'ms';
          el.classList.add('in');
          io.unobserve(el);
        }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });
    revEls.forEach(function (el) { io.observe(el); });
  } else {
    revEls.forEach(function (el) { el.classList.add('in'); });
  }

  /* ---------- Skill icon fallback ---------- */
  document.querySelectorAll('img.ic-img, img.tic').forEach(function (img) {
    img.addEventListener('error', function () {
      var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
      svg.setAttribute('class', img.className);
      var use = document.createElementNS('http://www.w3.org/2000/svg', 'use');
      use.setAttribute('href', '#ic-hex');
      svg.appendChild(use);
      img.replaceWith(svg);
    });
  });

  /* ---------- Footer year ---------- */
  var yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  /* ---------- Hero particle network ---------- */
  var canvas = document.getElementById('hero-canvas');
  if (!canvas || reduceMotion) return;
  var ctx = canvas.getContext('2d');
  var hero = document.getElementById('hero');
  var dpr = Math.min(window.devicePixelRatio || 1, 2);
  var W = 0, H = 0, nodes = [], raf = null, mouse = { x: -9999, y: -9999 };

  var COLORS = ['56,189,248', '129,140,248', '45,212,191'];

  function size() {
    W = hero.clientWidth;
    H = hero.clientHeight;
    canvas.width = W * dpr;
    canvas.height = H * dpr;
    canvas.style.width = W + 'px';
    canvas.style.height = H + 'px';
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    var target = Math.min(90, Math.round((W * H) / 16000));
    nodes = [];
    for (var i = 0; i < target; i++) {
      nodes.push({
        x: Math.random() * W,
        y: Math.random() * H,
        vx: (Math.random() - 0.5) * 0.35,
        vy: (Math.random() - 0.5) * 0.35,
        r: Math.random() * 1.6 + 0.6,
        c: COLORS[(Math.random() * COLORS.length) | 0]
      });
    }
  }

  function step() {
    ctx.clearRect(0, 0, W, H);
    var maxD = 130, maxD2 = maxD * maxD;
    for (var i = 0; i < nodes.length; i++) {
      var n = nodes[i];
      n.x += n.vx; n.y += n.vy;
      if (n.x < 0 || n.x > W) n.vx *= -1;
      if (n.y < 0 || n.y > H) n.vy *= -1;
      var dxm = n.x - mouse.x, dym = n.y - mouse.y;
      var dm2 = dxm * dxm + dym * dym;
      if (dm2 < 18000) {
        n.x += dxm * 0.0009 * -1;
        n.y += dym * 0.0009 * -1;
      }
      ctx.beginPath();
      ctx.arc(n.x, n.y, n.r, 0, Math.PI * 2);
      ctx.fillStyle = 'rgba(' + n.c + ',0.9)';
      ctx.fill();
    }
    for (var a = 0; a < nodes.length; a++) {
      for (var b = a + 1; b < nodes.length; b++) {
        var p = nodes[a], q = nodes[b];
        var dx = p.x - q.x, dy = p.y - q.y;
        var d2 = dx * dx + dy * dy;
        if (d2 < maxD2) {
          var alpha = (1 - d2 / maxD2) * 0.5;
          ctx.beginPath();
          ctx.moveTo(p.x, p.y);
          ctx.lineTo(q.x, q.y);
          ctx.strokeStyle = 'rgba(' + p.c + ',' + alpha.toFixed(3) + ')';
          ctx.lineWidth = 0.7;
          ctx.stroke();
        }
      }
    }
    raf = window.requestAnimationFrame(step);
  }

  function start() { if (!raf) step(); }
  function stop() { if (raf) { window.cancelAnimationFrame(raf); raf = null; } }

  hero.addEventListener('mousemove', function (e) {
    var rect = hero.getBoundingClientRect();
    mouse.x = e.clientX - rect.left;
    mouse.y = e.clientY - rect.top;
  });
  hero.addEventListener('mouseleave', function () { mouse.x = mouse.y = -9999; });

  var resizeT;
  window.addEventListener('resize', function () {
    clearTimeout(resizeT);
    resizeT = setTimeout(size, 200);
  });

  if ('IntersectionObserver' in window) {
    new IntersectionObserver(function (entries) {
      entries.forEach(function (e) { e.isIntersecting ? start() : stop(); });
    }, { threshold: 0 }).observe(hero);
  }

  size();
  start();
})();
