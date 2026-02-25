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
    <script src="script.js"></script>
</body>
</html>
