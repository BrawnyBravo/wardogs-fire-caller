'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const source = fs.readFileSync(path.join(__dirname, '..', 'index.html'), 'utf8');
function between(start, end) {
  const first = source.indexOf(start);
  const last = source.indexOf(end, first);
  assert.ok(first >= 0 && last > first, 'production function boundaries exist');
  return source.slice(first, last);
}
function page(saved = {}) {
  const st = { map: 'A', gun: null, view: {}, mode: 'gun', locked: false };
  const context = {
    st, MAPS: { A: { start: [0, 0], w: 100, h: 100 }, B: { start: [0, 0], w: 100, h: 100 } },
    store: { get: (k, d) => saved[k] ?? d, set: (k, v) => { saved[k] = v; } },
    ASSUMED_ERR_M: 8, W: 1000, H: 1000,
    setLocked: v => { st.locked = v; }, setMode: v => { st.mode = v; },
    role: () => ({ view: 10 }), renderSaved() {}, buildSeg() {}, $() {}, update() {},
    toGame: (x, y) => [x, y], clickErr: () => 2, say() {}, posCap: () => 'Gun',
  };
  vm.createContext(context);
  vm.runInContext(
    (source.match(/^  const confirmedMaps = new Set\(\);$/m)?.[0] || '') + '\n' +
    source.match(/^  function keepGun\(\).*$/m)[0] + '\n' +
    between('  function loadMapState(', '  function pickRole(') + '\n' +
    between('  function inMap(', '  // ---------- squad rooms'), context);
  return context;
}
test('switching maps never confirms an old position, including the first visit to another map', () => {
  const p = page({ 'gun.A': [1, 2], 'gun.B': [3, 4] });
  p.loadMapState(true);
  assert.equal(p.st.staleGun, true);
  assert.equal(p.st.locked, false);
  p.pickMap('B');
  assert.equal(p.st.staleGun, true);
  assert.equal(p.st.locked, false);
  p.pickMap('A');
  assert.equal(p.st.staleGun, true);
  assert.equal(p.st.mode, 'gun');
});
test('keeping a position confirms only its map for this visit', () => {
  const saved = { 'gun.A': [1, 2], 'gun.B': [3, 4] };
  const p = page(saved);
  p.loadMapState(true); p.keepGun();
  assert.equal(p.st.locked, true);
  p.pickMap('B'); assert.equal(p.st.staleGun, true);
  p.pickMap('A'); assert.equal(p.st.staleGun, false);
  assert.equal(p.st.locked, true);
  const reopened = page(saved); reopened.loadMapState(true);
  assert.equal(reopened.st.staleGun, true, 'confirmation must not persist across visits');
});
test('placing a new gun confirms it and preserves that confirmation when returning to the map', () => {
  const saved = {};
  const p = page(saved); p.loadMapState(true);
  assert.equal(p.st.staleGun, false);
  assert.equal(p.st.locked, false);
  p.place(10, 20);
  assert.deepEqual(saved['gun.A'], [10, 20]);
  assert.equal(p.st.locked, true);
  p.pickMap('B'); p.pickMap('A');
  assert.equal(p.st.staleGun, false);
  assert.equal(p.st.locked, true);
});
