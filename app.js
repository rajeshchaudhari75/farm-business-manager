// ANTARANG MOBILE — App Shell (Step 1)
(() => {
  const $$ = (sel, ctx=document) => Array.from(ctx.querySelectorAll(sel));
  const $ = (sel, ctx=document) => ctx.querySelector(sel);

  const views = {
    dashboard: $('#view-dashboard'),
    records:   $('#view-records'),
    reports:   $('#view-reports'),
    settings:  $('#view-settings'),
  };

  function showView(name){
    Object.entries(views).forEach(([key,el]) => {
      if(!el) return;
      const active = key === name;
      el.classList.toggle('view-active', active);
      if(active){ el.removeAttribute('hidden'); } else { el.setAttribute('hidden',''); }
    });
    // update bottom nav
    $$('.bn-item').forEach(b => b.classList.toggle('bn-active', b.dataset.target===name));
    // update aria
    $$('.bn-item').forEach(b => b.setAttribute('aria-current', b.classList.contains('bn-active') ? 'page' : 'false'));
  }

  function wireBottomNav(){
    $$('.bn-item').forEach(btn => btn.addEventListener('click', () => {
      const target = btn.dataset.target; showView(target);
    }));
  }

  function wireTabs(){
    // Records tabs
    $$('.tabs').forEach(tg => {
      const tabs = $$('.tab', tg);
      const panels = tg.parentElement.querySelectorAll('.panel');
      tabs.forEach(tab => tab.addEventListener('click', () => {
        tabs.forEach(t => t.classList.remove('tab-active'));
        tab.classList.add('tab-active');
        const id = tab.dataset.tab;
        panels.forEach(p => p.classList.toggle('panel-active', p.id === 'panel-' + id));
      }));
    });
  }

  function wireFab(){
    const fab = $('#fab');
    fab.addEventListener('click', () => openModal('Add Entry'));
  }

  function openModal(title){
    const ov = $('#overlay');
    $('#modal-title').textContent = title || 'Modal';
    ov.hidden = false; $('#btnCloseModal').focus();
  }
  $('#btnCloseModal')?.addEventListener('click', () => $('#overlay').hidden = true);
  $('#btnSaveModal')?.addEventListener('click', () => { /* Step 2: save handler */ $('#overlay').hidden = true; });

  function wireSettings(){
    $('#sel-theme')?.addEventListener('change', e => {
      document.documentElement.dataset.theme = e.target.value;
    });
    $('#chk-reduce-motion')?.addEventListener('change', e => {
      document.documentElement.style.setProperty('--motion', e.target.checked ? '0' : '1');
    });
  }

  // Placeholder renderers (Step 2 will connect Supabase + charts)
  function renderDashboard(){
    // draw simple placeholders if needed
    $('#k-exp').textContent   = '₹0';
    $('#k-earn').textContent  = '₹0';
    $('#k-net').textContent   = '₹0';
    $('#k-rows').textContent  = '0';
  }
  function renderRecords(){ /* build rows once data available */ }
  function renderReports(){ /* monthly widgets */ }

  function init(){
    wireBottomNav();
    wireTabs();
    wireFab();
    wireSettings();
    showView('dashboard');
    renderDashboard();
  }

  document.addEventListener('DOMContentLoaded', init);
})();
