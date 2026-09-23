// OMNINVIM — interactions
const $ = (s, c = document) => c.querySelector(s);
const $$ = (s, c = document) => [...c.querySelectorAll(s)];

/* ---------- stars canvas ---------- */
(() => {
  const cv = $('#stars'), ctx = cv.getContext('2d');
  let stars = [];
  function resize() {
    cv.width = innerWidth; cv.height = innerHeight;
    stars = Array.from({ length: Math.min(140, innerWidth / 10) }, () => ({
      x: Math.random() * cv.width, y: Math.random() * cv.height,
      r: Math.random() * 1.6 + .3, s: Math.random() * .35 + .05,
      o: Math.random() * .6 + .2
    }));
  }
  resize(); addEventListener('resize', resize);
  (function loop() {
    ctx.clearRect(0, 0, cv.width, cv.height);
    const acc = getComputedStyle(document.documentElement).getPropertyValue('--acc') || '#fab387';
    for (const st of stars) {
      st.y += st.s; if (st.y > cv.height) st.y = 0;
      ctx.globalAlpha = st.o;
      ctx.fillStyle = acc.trim();
      ctx.beginPath(); ctx.arc(st.x, st.y, st.r, 0, 7); ctx.fill();
    }
    ctx.globalAlpha = 1;
    requestAnimationFrame(loop);
  })();
})();

/* ---------- typing effect (noice floating cmd) ---------- */
(() => {
  const cmds = [':LivePreview', ':Mason', ':Lazy sync', ' Space + t h  →  theme picker', ':Rayso  →  screenshot', ' s  →  flash jump'];
  const el = $('#typed');
  let ci = 0, ch = 0, del = false;
  function tick() {
    const word = cmds[ci];
    el.textContent = word.slice(0, ch);
    if (!del && ch < word.length) { ch++; setTimeout(tick, 55); }
    else if (!del) { del = true; setTimeout(tick, 1400); }
    else if (ch > 0) { ch--; setTimeout(tick, 26); }
    else { del = false; ci = (ci + 1) % cmds.length; setTimeout(tick, 350); }
  }
  tick();
})();

/* ---------- editor tabs ---------- */
$$('.tab').forEach(btn => btn.addEventListener('click', () => {
  $$('.tab').forEach(b => { b.classList.remove('active'); b.setAttribute('aria-selected', 'false'); });
  btn.classList.add('active');
  btn.setAttribute('aria-selected', 'true');
  $$('.code').forEach(c => c.classList.remove('active'));
  $('#code-' + btn.dataset.tab).classList.add('active');
}));

/* ---------- marquee duplicate for seamless loop ---------- */
(() => {
  const m = $('#marquee');
  m.innerHTML += m.innerHTML;
})();

/* ---------- counters ---------- */
(() => {
  const nums = $$('.stat-num');
  const io = new IntersectionObserver(es => es.forEach(e => {
    if (!e.isIntersecting) return;
    const el = e.target, target = +el.dataset.count;
    let v = 0; const step = () => {
      v += Math.max(1, Math.round(target / 40));
      if (v >= target) { el.textContent = target + '+'; }
      else { el.textContent = v; requestAnimationFrame(step); }
    };
    step(); io.unobserve(el);
  }), { threshold: .5 });
  nums.forEach(n => io.observe(n));
})();

/* ---------- reveal on scroll ---------- */
(() => {
  const io = new IntersectionObserver(es => es.forEach(e => {
    if (e.isIntersecting) { e.target.classList.add('visible'); io.unobserve(e.target); }
  }), { threshold: .12 });
  $$('.reveal').forEach(el => io.observe(el));
})();

/* ---------- themes ---------- */
const THEMES = [
  { id: 'frappe',     name: 'Catppuccin Frappe', code: 'catppuccin-frappe', c: '#fab387' },
  { id: 'tokyonight', name: 'Tokyo Night',       code: 'tokyonight-night',  c: '#ff9e64' },
  { id: 'rosepine',   name: 'Rose Pine Moon',    code: 'rose-pine-moon',    c: '#ebbcba' },
  { id: 'gruvbox',    name: 'Gruvbox Material',  code: 'gruvbox-material',  c: '#fe8019' },
  { id: 'everforest', name: 'Everforest',        code: 'everforest',        c: '#a7c080' },
  { id: 'nord',       name: 'Nord',              code: 'nord',              c: '#88c0d0' },
  { id: 'dracula',    name: 'Dracula',           code: 'dracula',           c: '#bd93f9' },
  { id: 'cyberdream', name: 'Cyberdream',        code: 'cyberdream',        c: '#ff7eb6' },
];
(() => {
  const picker = $('#themePicker');
  THEMES.forEach((t, i) => {
    const b = document.createElement('button');
    b.className = 't-btn' + (i === 0 ? ' active' : '');
    b.innerHTML = `<i style="background:${t.c}"></i>${t.name}`;
    b.onclick = () => {
      document.documentElement.dataset.theme = t.id;
      $$('.t-btn').forEach(x => x.classList.remove('active'));
      b.classList.add('active');
      $('#themeName').textContent = t.name.toLowerCase() + ' · default dark';
      $('#themeCode').textContent = `"${t.code}"`;
    };
    picker.appendChild(b);
  });
  $('#navThemeBtn').onclick = () => {
    const cur = THEMES.findIndex(t => t.id === document.documentElement.dataset.theme);
    $$('.t-btn')[(cur + 1) % THEMES.length].click();
  };
})();

/* ---------- keymaps data + filter ---------- */
const KEYMAPS = [
  ['<C-s>', 'Guardar archivo', 'general'],
  ['<Space>th', 'Theme picker · 25 temas', 'general'],
  ['<Space>z', 'Zen mode', 'general'],
  ['<Esc>', 'Quitar highlight / salir de terminal', 'general'],
  ['<Space>e / <Space>E', 'Toggle / focus nvim-tree (derecha)', 'files'],
  ['-  / <Space>o', 'Oil: directorio como buffer', 'files'],
  ['<S-h> / <S-l>', 'Buffer anterior / siguiente', 'files'],
  ['<Space>bd', 'Cerrar buffer actual', 'files'],
  ['<Space>a · <Space>1-4', 'Fijar archivo Harpoon · saltar a slots', 'files'],
  ['<Space>fn · fr · fm', 'Nuevo archivo · renombrar · mover (Genghis)', 'files'],
  ['s', 'Flash jump', 'files'],
  ['<C-w>v / <C-w>s', 'Split vertical / horizontal', 'general'],
  ['<C-h/j/k/l>', 'Moverse entre splits (Navigator)', 'general'],
  ['<C-p> / <C-n>', 'Navegar historial de yanks', 'general'],
  ['gd / gD', 'Go to definition / declaration', 'lsp'],
  ['K', 'Hover docs', 'lsp'],
  ['grn / gra', 'Rename símbolo / code action', 'lsp'],
  ['grr / gri', 'References / implementation', 'lsp'],
  ['<Tab> / <Enter>', 'Siguiente sugerencia / aceptar (blink.cmp)', 'lsp'],
  [']h / [h', 'Siguiente / anterior hunk', 'git'],
  ['<Space>gs / gr', 'Stage / reset hunk', 'git'],
  ['<Space>gp / gb', 'Preview hunk / blame línea', 'git'],
  ['<Space>sc', 'Screenshot con Ray.so (visual)', 'git'],
  ['<Space>pv / <Space>pV', 'Live preview on / off (:LivePreview)', 'general'],
  [':w', 'Guardar → formatea solo (conform.nvim)', 'general'],
];
(() => {
  const grid = $('#kmGrid'), search = $('#kmSearch'), tabs = $('#kmTabs');
  let cat = 'all';
  function render() {
    const q = search.value.toLowerCase();
    grid.innerHTML = '';
    KEYMAPS
      .filter(([k, a, c]) => (cat === 'all' || c === cat) && (k + a).toLowerCase().includes(q))
      .forEach(([k, a, c]) => {
        const d = document.createElement('div');
        d.className = 'km';
        d.innerHTML = `<span class="k">${k}</span><span class="a">${a}</span><span class="cat">${c}</span>`;
        grid.appendChild(d);
      });
    if (!grid.children.length) grid.innerHTML = '<p style="color:var(--mut)">Sin resultados… prueba con otra palabra.</p>';
  }
  search.addEventListener('input', render);
  tabs.addEventListener('click', e => {
    if (e.target.tagName !== 'BUTTON') return;
    $$('#kmTabs button').forEach(b => b.classList.remove('active'));
    e.target.classList.add('active');
    cat = e.target.dataset.cat; render();
  });
  render();
})();

/* ---------- copy buttons ---------- */
$$('.copy').forEach(b => b.addEventListener('click', async () => {
  try { await navigator.clipboard.writeText(b.dataset.copy); } catch {}
  const old = b.textContent;
  b.textContent = '✔ copiado';
  setTimeout(() => b.textContent = old, 1400);
}));

/* ---------- mobile nav + active link ---------- */
$('#burger').onclick = () => {
  const nav = $('#navLinks');
  nav.classList.toggle('open');
  $('#burger').setAttribute('aria-expanded', nav.classList.contains('open') ? 'true' : 'false');
};
$$('#navLinks a').forEach(a => a.addEventListener('click', () => $('#navLinks').classList.remove('open')));
(() => {
  const links = $$('#navLinks a');
  const io = new IntersectionObserver(es => es.forEach(e => {
    if (e.isIntersecting) {
      links.forEach(l => l.classList.toggle('active', l.hash === '#' + e.target.id));
    }
  }), { rootMargin: '-40% 0px -55% 0px' });
  ['features', 'stack', 'temas', 'keymaps', 'instalar'].forEach(id => {
    const s = document.getElementById(id); if (s) io.observe(s);
  });
})();
