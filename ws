<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>The Writer's Scroll</title>
    <link rel="stylesheet" href="styles.css" * { margin: 0; padding: 0; box-sizing: border-box; }
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background-color: #1B102A;
    color: #fff;
}
.app { min-height: 100vh; display:flex; flex-direction:column; }

/* APPBAR */
.appbar {
    background-color: #2A1740;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.3);
}
.appbar h1 { font-size:24px; margin-bottom:4px; }
.appbar p { font-size:12px; color:#aaa; }

/* MAIN */
.main { flex:1; padding:20px; max-width:800px; margin:0 auto; width:100%; }

/* CARDS & LIST */
.card, .list-item {
    background-color:#2A1740; border-radius:8px; padding:16px; margin-bottom:12px;
    cursor:pointer; transition:all .2s ease; border:1px solid #3A2750;
}
.card:hover, .list-item:hover { background-color:#351850; border-color:#9C6ADE; }
.list-item { display:flex; align-items:center; }
.list-item-icon { margin-right:16px; font-size:24px; }
.list-item-text h3 { font-size:16px; margin:0; }

/* BUTTONS */
.button { background:#9C6ADE; color:#fff; border:none; padding:12px 24px; border-radius:6px; cursor:pointer; }
.button-secondary { background:transparent; border:1px solid #9C6ADE; color:#9C6ADE; }

/* FAB */
.fab {
    position:fixed; bottom:24px; right:24px; width:56px; height:56px; background:#9C6ADE;
    border-radius:50%; border:none; cursor:pointer; font-size:24px; color:#fff;
    display:flex; align-items:center; justify-content:center; box-shadow:0 4px 12px rgba(156,106,222,0.4);
}

/* MODAL */
.modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.7); display:flex; align-items:center; justify-content:center; z-index:1000; }
.modal { background:#2A1740; border-radius:8px; padding:24px; max-width:500px; width:90%; box-shadow:0 8px 32px rgba(0,0,0,0.5); }
.modal-input { width:100%; padding:12px; margin-bottom:20px; background:#1B102A; border:1px solid #3A2750; border-radius:6px; color:white; }

/* EXPANSION TILE */
.expansion-tile { margin-bottom:12px; }
.expansion-tile-header {
    background:#2A1740; border:1px solid #3A2750; border-radius:8px; padding:16px; cursor:pointer;
    display:flex; justify-content:space-between; align-items:center;
}
.expansion-tile-header.open { border-bottom:none; border-radius:8px 8px 0 0; }
.expansion-tile-content { background:#2A1740; border:1px solid #3A2750; border-top:none; border-radius:0 0 8px 8px; padding:8px; display:none; }
.expansion-tile-content.open { display:block; }
.expansion-tile-textarea { width:100%; min-height:200px; padding:12px; background:#1B102A; border:none; border-radius:6px; color:white; font-family:monospace; resize:vertical; }

/* PAGE HEADER */
.page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
.page-actions { display:flex; gap:8px; }

/* SNACKBAR */
.snackbar { position:fixed; bottom:24px; left:24px; background:#333; color:#fff; padding:16px 24px; border-radius:6px; box-shadow:0 4px 12px rgba(0,0,0,0.5); animation:slideIn .3s ease; z-index:999; }
@keyframes slideIn { from { transform:translateX(-100%); opacity:0 } to { transform:translateX(0); opacity:1 } }

/* EMPTY */
.empty-state { text-align:center; padding:40px 20px; color:#aaa; }

/* AD BANNER */
.ad-banner { background:linear-gradient(135deg,#9C6ADE 0%,#6D4BA0 100%); color:white; padding:12px 20px; text-align:center; font-weight:bold; border-bottom:1px solid #3A2750; }

/* RESPONSIVE */
@media (max-width:600px) {
    .fab { width:48px; height:48px; font-size:20px; bottom:16px; right:16px; }
    .appbar { padding:16px; }
    .main { padding:16px; }
}/>
</head>
<body>
    <div id="app"></div>
    <script src="script.js">// ===== STATE =====
let state = {
    view: 'library',
    projects: [],
    selectedProject: null,
    selectedTemplate: null,
    selectedTier: null,
    user: {
        tier: 'free', // 'free', 'mid', 'premium'
        premiumUntil: null, // ISO timestamp
    },
};

// ===== INIT =====
function init() {
    loadProjects();
    loadUserTier();
    render();
}

// ===== STORAGE =====
function loadProjects() {
    const raw = localStorage.getItem('projects');
    state.projects = raw ? JSON.parse(raw) : [];
}

function saveProjects() {
    localStorage.setItem('projects', JSON.stringify(state.projects));
}

function loadUserTier() {
    const raw = localStorage.getItem('user');
    if (raw) {
        const user = JSON.parse(raw);
        state.user = user;

        if (user.tier === 'premium' && user.premiumUntil && new Date(user.premiumUntil) < new Date()) {
            state.user.tier = 'free';
            state.user.premiumUntil = null;
            saveUserTier();
        }
    }
}

function saveUserTier() {
    localStorage.setItem('user', JSON.stringify(state.user));
}

function loadContent(projectId) {
    const raw = localStorage.getItem(`content_${projectId}`);
    return raw ? JSON.parse(raw) : {};
}

function saveContent(projectId, content) {
    localStorage.setItem(`content_${projectId}`, JSON.stringify(content));
}

// ===== TEMPLATES =====
const TEMPLATES = {
    fiction: {
        label: 'Fiction',
        desc: 'Plots, worlds, characters.',
        sections: ['Plot', 'Characters', 'Worldbuilding', 'Chapter Draft'],
    },
    fanFiction: {
        label: 'Fan Fiction',
        desc: 'Canon-safe timelines & AU tracking.',
        sections: [
            'Canon Events',
            'Divergence Point',
            'Timeline',
            'Character Consistency',
            'Chapter Draft',
        ],
    },
    nonFiction: {
        label: 'Non-Fiction',
        desc: 'Research-driven structure.',
        sections: ['Thesis', 'Research Notes', 'Outline', 'Draft'],
    },
};

const TIERS = {
    free: { label: 'FREE', desc: 'Basic story structure.' },
    mid: { label: 'MID', desc: 'Basic structure + ads' },
    premium: { label: 'PREMIUM', desc: 'Everything unlocked, no ads.' },
};

// ===== ACTIONS =====
function addProject() {
    const title = prompt('Project title:');
    if (!title || !title.trim()) return;

    const project = {
        id: crypto.randomUUID(),
        title: title.trim(),
    };

    state.projects.push(project);
    saveProjects();
    render();
    showSnackbar('Project created');
}

function selectProject(projectId) {
    state.selectedProject = state.projects.find((p) => p.id === projectId);
    state.view = 'templateSelect';
    render();
}

function selectTemplate(template) {
    state.selectedTemplate = template;
    state.view = 'tierSelect';
    render();
}

function selectTier(tier) {
    state.selectedTier = tier;

    if (tier === 'premium') {
        state.view = 'checkout';
    } else {
        state.user.tier = tier;
        if (tier === 'mid') {
            state.user.premiumUntil = null;
        }
        saveUserTier();
        state.view = 'storyBoard';
    }
    render();
}

function goBack() {
    if (state.view === 'templateSelect') {
        state.view = 'library';
        state.selectedProject = null;
    } else if (state.view === 'tierSelect') {
        state.view = 'templateSelect';
    } else if (state.view === 'checkout') {
        state.view = 'tierSelect';
        state.selectedTier = null;
    } else if (state.view === 'storyBoard') {
        state.view = 'library';
        state.selectedProject = null;
        state.selectedTemplate = null;
        state.selectedTier = null;
    }
    render();
}

function saveSection(section, text) {
    if (!state.selectedProject) return;

    const content = loadContent(state.selectedProject.id);
    content[section] = text;
    saveContent(state.selectedProject.id, content);
}

function exportProject() {
    if (!state.selectedProject || !state.selectedTemplate) return;

    const content = loadContent(state.selectedProject.id);
    const template = TEMPLATES[state.selectedTemplate];

    let text = `# ${state.selectedProject.title}\n`;
    text += `Template: ${template.label}\n`;
    text += `Tier: ${state.user.tier.toUpperCase()}\n\n`;

    template.sections.forEach((section) => {
        text += `## ${section}\n`;
        text += content[section] || '';
        text += '\n\n';
    });

    const blob = new Blob([text], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${state.selectedProject.title.replace(/[^\w\s-]/g, '')}.txt`;
    a.click();
    URL.revokeObjectURL(url);

    showSnackbar('Project exported');
}

function showSnackbar(message) {
    const snackbar = document.createElement('div');
    snackbar.className = 'snackbar';
    snackbar.textContent = message;
    document.body.appendChild(snackbar);

    setTimeout(() => {
        snackbar.remove();
    }, 3000);
}

function upgradeToPremium() {
    // Replace this with real payment integration (Stripe, Paddle, etc.)
    state.user.tier = 'premium';

    // 30-day trial expiration
    const expirationDate = new Date();
    expirationDate.setDate(expirationDate.getDate() + 30);
    state.user.premiumUntil = expirationDate.toISOString();

    saveUserTier();
    showSnackbar('🎉 Welcome to Premium! 30-day trial activated');

    state.view = 'storyBoard';
    render();
}

// ===== RENDER =====
function render() {
    const app = document.getElementById('app');

    if (state.view === 'library') {
        app.innerHTML = renderLibrary();
    } else if (state.view === 'templateSelect') {
        app.innerHTML = renderTemplateSelect();
    } else if (state.view === 'tierSelect') {
        app.innerHTML = renderTierSelect();
    } else if (state.view === 'checkout') {
        app.innerHTML = renderCheckout();
    } else if (state.view === 'storyBoard') {
        app.innerHTML = renderStoryBoard();
    }

    attachEventListeners();
}

function renderLibrary() {
    let html = `
        <div class="app">
            <div class="appbar">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                        <h1>The Writer's Scroll</h1>
                        <p>Fiction & Fan-Fiction Writers' Best Friend</p>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 12px; color: #9C6ADE; font-weight: bold; margin-bottom: 4px;">${state.user.tier.toUpperCase()} TIER</div>
                        ${state.user.tier === 'premium' && state.user.premiumUntil ? `<div style="font-size: 11px; color: #aaa;">Until ${new Date(state.user.premiumUntil).toLocaleDateString()}</div>` : ''}
                    </div>
                </div>
            </div>
            <div class="main">
    `;

    if (state.projects.length === 0) {
        html += `
            <div class="empty-state">
                <p>No scrolls yet. Create one to get started!</p>
            </div>
        `;
    } else {
        state.projects.forEach((project) => {
            html += `
                <div class="list-item" data-project-id="${project.id}">
                    <div class="list-item-icon">📖</div>
                    <div class="list-item-text">
                        <h3>${escapeHtml(project.title)}</h3>
                    </div>
                </div>
            `;
        });
    }

    html += `
            </div>
            <button class="fab" id="add-btn">+</button>
        </div>
    `;

    return html;
}

function renderTemplateSelect() {
    let html = `
        <div class="app">
            <div class="appbar">
                <h1>Choose Your Scroll Type</h1>
            </div>
            <div class="main">
    `;

    Object.entries(TEMPLATES).forEach(([key, template]) => {
        html += `
            <div class="card" data-template="${key}">
                <h3>${template.label}</h3>
                <p>${template.desc}</p>
            </div>
        `;
    });

    html += `
            </div>
            <button class="fab" onclick="goBack()" style="bottom: 80px;">←</button>
        </div>
    `;

    return html;
}

function renderTierSelect() {
    let html = `
        <div class="app">
            <div class="appbar">
                <h1>Choose Tier</h1>
            </div>
            <div class="main">
    `;

    Object.entries(TIERS).forEach(([key, tier]) => {
        let priceHTML = '';
        if (key === 'free') {
            priceHTML = '<div style="font-size: 18px; color: #9C6ADE; font-weight: bold; margin-top: 8px;">Free</div>';
        } else if (key === 'mid') {
            priceHTML = '<div style="font-size: 18px; color: #9C6ADE; font-weight: bold; margin-top: 8px;">Free (with ads)</div>';
        } else if (key === 'premium') {
            priceHTML = '<div style="font-size: 18px; color: #9C6ADE; font-weight: bold; margin-top: 8px;">$5/month</div><div style="font-size: 11px; color: #aaa; margin-top: 4px;">30-day free trial</div>';
        }

        html += `
            <div class="card" data-tier="${key}" style="position: relative;">
                <h3>${tier.label}</h3>
                <p>${tier.desc}</p>
                ${priceHTML}
            </div>
        `;
    });

    html += `
            </div>
            <button class="fab" onclick="goBack()" style="bottom: 80px;">←</button>
        </div>
    `;

    return html;
}

function renderCheckout() {
    const html = `
        <div class="app">
            <div class="appbar">
                <h1>Upgrade to Premium</h1>
            </div>
            <div class="main">
                <div class="card" style="border: 2px solid #9C6ADE;">
                    <h3>✨ Premium Tier</h3>
                    <p>Everything unlocked, no ads</p>
                    <div style="margin: 20px 0;">
                        <div style="font-size: 32px; font-weight: bold; color: #9C6ADE; margin-bottom: 8px;">$5</div>
                        <div style="color: #aaa; margin-bottom: 16px;">per month (cancel anytime)</div>
                    </div>
                    
                    <div style="background-color: #1B102A; padding: 16px; border-radius: 6px; margin-bottom: 16px;">
                        <div style="color: #9C6ADE; font-weight: bold; margin-bottom: 12px;">✓ 30-day free trial included</div>
                        <div style="color: #aaa; font-size: 13px;">Get full access for 30 days at no cost. Cancel anytime before the trial ends.</div>
                    </div>

                    <div style="border-top: 1px solid #3A2750; padding-top: 16px; margin-top: 16px;">
                        <div style="color: #aaa; margin-bottom: 12px;">Premium includes:</div>
                        <ul style="list-style: none; color: #aaa; font-size: 14px;">
                            <li>✓ No ads</li>
                            <li>✓ Unlimited projects</li>
                            <li>✓ All features unlocked</li>
                            <li>✓ Priority support</li>
                        </ul>
                    </div>
                </div>

                <button class="button" id="checkout-btn" style="width: 100%; margin-top: 16px; padding: 16px; font-size: 16px;">
                    Start Free Trial
                </button>
            </div>
            <button class="fab" onclick="goBack()" style="bottom: 80px;">←</button>
        </div>
    `;

    return html;
}

function renderStoryBoard() {
    const template = TEMPLATES[state.selectedTemplate];
    const content = loadContent(state.selectedProject.id);
    const showAds = state.user.tier === 'mid';

    let html = `
        <div class="app">
            ${showAds ? '<div class="ad-banner">📢 Advertisement - Get Premium to remove ads</div>' : ''}
            <div class="appbar">
                <div class="page-header">
                    <h1>${escapeHtml(state.selectedProject.title)} • ${template.label}</h1>
                    <div class="page-actions">
                        <button class="icon-button" id="export-btn" title="Export">📥</button>
                    </div>
                </div>
            </div>
            <div class="main">
    `;

    template.sections.forEach((section) => {
        html += `
            <div class="expansion-tile">
                <div class="expansion-tile-header" data-section="${section}">
                    <h3>${section}</h3>
                    <span>▼</span>
                </div>
                <div class="expansion-tile-content" data-section="${section}">
                    <textarea class="expansion-tile-textarea" 
                              data-section="${section}"
                              placeholder="Write here...">${escapeHtml(content[section] || '')}</textarea>
                </div>
            </div>
        `;
    });

    html += `
            </div>
            <button class="fab" onclick="goBack()" style="bottom: 80px;">←</button>
        </div>
    `;

    return html;
}

// ===== EVENT LISTENERS =====
function attachEventListeners() {
    document.getElementById('add-btn')?.addEventListener('click', addProject);

    document.querySelectorAll('.list-item').forEach((item) => {
        item.addEventListener('click', () => {
            selectProject(item.dataset.projectId);
        });
    });

    document.querySelectorAll('[data-template]').forEach((card) => {
        card.addEventListener('click', () => {
            selectTemplate(card.dataset.template);
        });
    });

    document.querySelectorAll('[data-tier]').forEach((card) => {
        card.addEventListener('click', () => {
            selectTier(card.dataset.tier);
        });
    });

    document.getElementById('checkout-btn')?.addEventListener('click', upgradeToPremium);

    document.getElementById('export-btn')?.addEventListener('click', exportProject);

    document.querySelectorAll('.expansion-tile-header').forEach((header) => {
        header.addEventListener('click', () => {
            const section = header.dataset.section;
            header.classList.toggle('open');
            const content = document.querySelector(`.expansion-tile-content[data-section="${section}"]`);
            content.classList.toggle('open');
        });
    });

    document.querySelectorAll('.expansion-tile-textarea').forEach((textarea) => {
        textarea.addEventListener('change', () => {
            saveSection(textarea.dataset.section, textarea.value);
        });
    });

    // Ad placeholder: if you want to integrate a real ad provider, insert load logic here.
}

// ===== UTILITIES =====
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// ===== START =====
init();</script>
</body>
</html>
