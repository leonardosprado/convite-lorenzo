<template>
  <div class="scene2">

    <!-- Estrelas de fundo -->
    <div class="stars-bg">
      <div
        v-for="s in bgStars" :key="s.id"
        class="bg-star"
        :style="{ left: s.x+'%', top: s.y+'%', width: s.size+'px', height: s.size+'px',
                  animationDelay: s.delay+'s', animationDuration: s.duration+'s' }"
      />
    </div>

    <ConviteNaoEncontrado v-if="!buscandoConvidado && !convidadoOk" />

    <!-- ─── ABERTURA ─── -->
    <Transition name="envelope">
      <div v-if="convidadoOk && !opened" class="envelope-screen" @click="openInvite">
        <div class="envelope-wrap">
          <div class="envelope-glow" />
          <div class="crown-open">👑</div>
          <div class="envelope-title">Chá do</div>
          <div class="envelope-subtitle">Pequeno Príncipe</div>
          <div class="envelope-name">Lorenzo</div>
          <div class="envelope-hint">Toque para abrir ✨</div>
        </div>
      </div>
    </Transition>

    <!-- ─── TUTORIAL DE SWIPE ─── -->
    <Transition name="tutorial-fade">
      <div v-if="showTutorial" class="tutorial-overlay" @click="dismissTutorial">
        <div class="tutorial-box">
          <div class="tutorial-hand">👆</div>
          <div class="tutorial-text">Deslize o cartão<br/><strong>para cima</strong></div>
          <div class="tutorial-subtext">para ver o próximo</div>
          <button class="tutorial-btn" @click.stop="dismissTutorial">Entendido!</button>
        </div>
      </div>
    </Transition>

    <!-- ─── FASE: CARDS ─── -->
    <Transition name="phase-fade">
      <div
        v-if="convidadoOk && opened && !allDone"
        class="card-phase"
        @touchstart.passive="onTouchStart"
        @touchmove.passive="onTouchMove"
        @touchend="onTouchEnd"
        @mousedown="onMouseDown"
      >
        <!-- Dots -->
        <div class="page-dots">
          <div v-for="(_, i) in cards" :key="i" class="dot" :class="{ active: i === activeIndex }" />
        </div>

        <!-- Pilha de cards -->
        <div class="cards-anchor">
          <div
            v-for="(card, i) in cards"
            :key="card.id"
            class="s-card paper"
            :style="cardStyle(i)"
          >
            <div class="s-card-bg" />
            <div class="s-page-num">{{ i + 1 }}/{{ cards.length }}</div>

            <!-- CAPA -->
            <template v-if="card.type === 'cover'">
              <img class="s-deco s-planet" src="/src/assets/images/planeta.png" alt="" />
              <img class="s-deco s-star-tr" src="/src/assets/images/estrela.png" alt="" />
              <img class="s-deco s-cloud-br" src="/src/assets/images/nuvem.png" alt="" />
              <div class="s-cover">
                <div class="s-emoji-crown">👑</div>
                <div class="s-sm">chá do</div>
                <div class="s-md">pequeno príncipe</div>
                <div class="s-name">Lorenzo</div>
                <div class="ornament"><span class="ol"/><span>💙</span><span class="ol"/></div>
                <div v-if="convidadoNome" class="s-para">
                  <span class="s-para-label">para</span>
                  <span class="s-para-nome">{{ convidadoNome }}</span>
                </div>
              </div>
            </template>

            <!-- MENSAGEM -->
            <template v-else-if="card.type === 'message'">
              <img class="s-deco s-cloud-tl" src="/src/assets/images/nuvem.png" alt="" />
              <img class="s-deco s-star-br" src="/src/assets/images/estrela.png" alt="" />
              <div class="s-msg">
                <div class="s-msg-quote">❝</div>
                <p class="s-msg-lead">A contagem regressiva começou!</p>
                <p class="s-msg-body">Antes que eu saia correndo da barriga da mamãe, venha celebrar a minha chegada e encher meus papais de carinho (e fraldinhas!).</p>
                <div class="ornament" style="margin-top:14px"><span class="ol"/><span>💙</span><span class="ol"/></div>
              </div>
            </template>

            <!-- DATA & HORA -->
            <template v-else-if="card.type === 'datetime'">
              <img class="s-deco s-clock-tr" src="/src/assets/images/relogio.png" alt="" />
              <div class="s-dt">
                <div class="s-dt-lbl">Data</div>
                <div class="s-dt-date">26.09</div>
                <div class="s-dt-year">2026</div>
                <div class="s-dt-rule" />
                <div class="s-dt-lbl">Hora</div>
                <div class="s-dt-time">16:00</div>
                <div class="s-dt-hint">horas</div>
              </div>
            </template>

            <!-- LOCAL -->
            <template v-else-if="card.type === 'location'">
              <img class="s-deco s-planet-sm" src="/src/assets/images/planeta.png" alt="" />
              <div class="s-loc">
                <div class="s-loc-emoji">🏠</div>
                <div class="s-loc-lbl">Local</div>
                <div class="s-loc-name">Salão de festa<br/>do condomínio</div>
                <div class="s-loc-rule" />
                <div class="s-loc-addr">Travessa Ita, 53<br/>Cond. Eldorado Parque Tijuca</div>
              </div>
            </template>

            <!-- ÚLTIMO CARD: CTA -->
            <template v-else-if="card.type === 'rsvp-cta'">
              <img class="s-deco s-star-tr" src="/src/assets/images/estrela.png" alt="" />
              <img class="s-deco s-star-bl" src="/src/assets/images/estrela.png" alt="" />
              <div class="s-rsvpcta">
                <div class="s-rsvpcta-crown">👑</div>
                <div class="s-rsvpcta-title">Você está<br/>convidado!</div>
                <div class="ornament" style="margin:10px 0"><span class="ol"/><span>💙</span><span class="ol"/></div>
                <img class="s-rsvpcta-menino" src="/src/assets/images/menino-com-gato.png" alt="" />
              </div>
            </template>

          </div>
        </div>

        <!-- Indicador de swipe persistente -->
        <div class="swipe-indicator">
          <div class="swipe-ind-hand">👆</div>
          <span class="swipe-ind-text">deslize para cima</span>
        </div>

        <!-- Botão voltar -->
        <Transition name="back-fade">
          <button v-if="activeIndex > 0" class="back-btn" @click="goBack">
            ← Anterior
          </button>
        </Transition>

      </div>
    </Transition>

    <!-- ─── FASE: RSVP ─── -->
    <Transition name="rsvp-rise">
      <div v-if="convidadoOk && opened && allDone" class="rsvp-phase">
        <div class="rsvp-card paper">
          <div class="rsvp-f-crown">👑</div>
          <h2 class="rsvp-f-title">Confirmar<br/>Presença</h2>
          <p class="rsvp-f-sub">Confirme até 20/09/2026</p>

          <form v-if="!rsvpSent" class="rsvp-f-form" @submit.prevent="submitRsvp">
            <div v-if="convidadoNome" class="rsvp-nome-display">
              Olá, <strong>{{ convidadoNome }}</strong>! 👋
            </div>
            <div v-if="!convidadoNome" class="rsvp-f-group">
              <label>Seu nome</label>
              <input v-model="rsvpForm.nome" type="text" placeholder="Nome completo" required />
            </div>
            <div v-if="!convidadoNome" class="rsvp-f-group">
              <label>Quantas pessoas?</label>
              <select v-model="rsvpForm.pessoas">
                <option value="1">Só eu 🌟</option>
                <option value="2">2 pessoas</option>
                <option value="3">3 pessoas</option>
                <option value="4">4 ou mais</option>
              </select>
            </div>
            <button type="submit" class="rsvp-f-submit">Confirmar com amor 💙</button>
          </form>

          <div v-else class="rsvp-f-success">
            <div class="success-icon">🎉</div>
            <p class="success-title">Presença Confirmada!</p>
            <p class="success-msg">Mal podemos esperar para te ver!<br/>Lorenzo já está animado! 👑</p>
          </div>

          <button class="rsvp-back" @click="allDone = false; activeIndex = cards.length - 1">
            ← Voltar ao convite
          </button>
        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { supabase } from '../supabase.js'
import ConviteNaoEncontrado from './ConviteNaoEncontrado.vue'

// ── convidado via URL ─────────────────────────────────────────
const convidadoId       = new URLSearchParams(window.location.search).get('convidado')
const convidadoNome     = ref('')
const buscandoConvidado = ref(true)
const convidadoOk       = ref(false)

onMounted(async () => {
  if (convidadoId) {
    const { data } = await supabase
      .from('convidados')
      .select('nome, confirmado')
      .eq('id', convidadoId)
      .single()
    if (data) {
      if (data.confirmado) {
        window.location.replace(`/?convidado=${convidadoId}`)
        return
      }
      convidadoNome.value = data.nome
      rsvpForm.nome = data.nome
      convidadoOk.value = true
    }
  }
  buscandoConvidado.value = false

  if (!convidadoOk.value) return

  const last = Number(localStorage.getItem(OPEN_KEY) || 0)
  if (Date.now() - last < OPEN_TTL) opened.value = true
})

// ── estado ────────────────────────────────────────────────────
const opened      = ref(false)
const showTutorial = ref(false)
const rsvpSent    = ref(false)
const rsvpForm    = reactive({ nome: '', whatsapp: '', pessoas: '1' })
const activeIndex = ref(0)
const allDone     = ref(false)

// ── cards ─────────────────────────────────────────────────────
const cards = [
  { id: 'cover',    type: 'cover' },
  { id: 'message',  type: 'message' },
  { id: 'datetime', type: 'datetime' },
  { id: 'location', type: 'location' },
  { id: 'rsvp-cta', type: 'rsvp-cta' },
]
const N = cards.length

// rotações sutis para cada carta na pilha
const STACK_ROT = [0, 1.5, -1.2, 2, -1.5]

// ── drag state ────────────────────────────────────────────────
const dragY        = ref(0)   // px arrastados para cima (≥ 0)
const isDragging   = ref(false)
const isAnimating  = ref(false)
let   touchStartY  = 0

// opacidade do hint de swipe (some quando começa a arrastar)
const swipeHintOpacity = computed(() =>
  Math.max(0, 1 - dragY.value / 40)
)

// ── touch / mouse ─────────────────────────────────────────────
function onTouchStart(e) {
  if (isAnimating.value) return
  touchStartY  = e.touches[0].clientY
  isDragging.value = true
}

function onTouchMove(e) {
  if (!isDragging.value) return
  const diff = touchStartY - e.touches[0].clientY
  dragY.value = Math.max(0, diff)
}

function onTouchEnd(e) {
  if (!isDragging.value) return
  isDragging.value = false
  const diff = touchStartY - e.changedTouches[0].clientY
  if (diff > 55) {
    flyCard()
  } else {
    dragY.value = 0
  }
}

// suporte desktop: mousedown + mousemove + mouseup
let mouseStartY = 0
function onMouseDown(e) {
  if (isAnimating.value) return
  mouseStartY = e.clientY
  isDragging.value = true

  function onMove(ev) {
    const diff = mouseStartY - ev.clientY
    dragY.value = Math.max(0, diff)
  }
  function onUp(ev) {
    isDragging.value = false
    window.removeEventListener('mousemove', onMove)
    window.removeEventListener('mouseup', onUp)
    const diff = mouseStartY - ev.clientY
    if (diff > 55) flyCard()
    else dragY.value = 0
  }
  window.addEventListener('mousemove', onMove)
  window.addEventListener('mouseup', onUp)
}

// ── voo do card ───────────────────────────────────────────────
function flyCard() {
  if (isAnimating.value) return
  isAnimating.value = true
  dragY.value = 0

  // pequeno delay para a animação CSS de saída terminar
  setTimeout(() => {
    if (activeIndex.value < N - 1) {
      activeIndex.value++
    } else {
      allDone.value = true
    }
    isAnimating.value = false
  }, 480)
}

// ── estilo de cada carta ──────────────────────────────────────
function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }

function cardStyle(i) {
  const active = activeIndex.value

  // ── JÁ VOOU ──
  if (i < active) {
    return {
      transform: 'translateY(-130vh) rotate(-3deg)',
      opacity: '0',
      transition: 'transform 0.5s cubic-bezier(0.4,0,0.6,1), opacity 0.35s ease',
      zIndex: 0,
      pointerEvents: 'none',
    }
  }

  // ── CARTA ATIVA (topo) ──
  if (i === active) {
    // durante drag: segue o dedo
    if (isDragging.value && dragY.value > 0) {
      const t = dragY.value / window.innerHeight
      const rotate = t * -8  // inclina levemente ao arrastar
      return {
        transform: `translateY(-${dragY.value}px) rotate(${rotate}deg)`,
        opacity: String(1 - t * 0.3),
        transition: 'none',
        zIndex: N * 10,
        boxShadow: '0 28px 70px rgba(0,0,0,0.55)',
        pointerEvents: 'none',
      }
    }
    // animando saída (flyCard chamado)
    if (isAnimating.value) {
      return {
        transform: 'translateY(-130vh) rotate(-4deg)',
        opacity: '0',
        transition: 'transform 0.48s cubic-bezier(0.4,0,0.6,1), opacity 0.3s ease',
        zIndex: N * 10,
        pointerEvents: 'none',
      }
    }
    // repouso no topo
    return {
      transform: 'translateY(0) rotate(0deg) scale(1)',
      opacity: '1',
      transition: 'transform 0.5s cubic-bezier(0.34,1.56,0.64,1), opacity 0.3s ease',
      zIndex: N * 10,
      boxShadow: '0 28px 70px rgba(0,0,0,0.55), 0 0 0 1px rgba(212,168,83,0.35)',
    }
  }

  // ── CARTAS ABAIXO (pilha) ──
  const depth = i - active  // 1, 2, 3 …
  const scale  = 1 - depth * 0.035
  const topOff = depth * 10
  const rot    = STACK_ROT[i % STACK_ROT.length] * clamp(depth, 0.4, 1)
  const op     = depth <= 3 ? 1 : 0

  // quando estamos arrastando, as cartas de baixo sobem um pouco (perspectiva)
  const peekY = isDragging.value ? clamp(dragY.value * 0.18, 0, 18) * depth * -1 : 0

  return {
    transform: `scale(${scale}) translateY(${topOff + peekY}px) rotate(${rot}deg)`,
    opacity: String(op),
    transition: isDragging.value
      ? 'transform 0.08s ease'
      : 'transform 0.5s cubic-bezier(0.34,1.56,0.64,1), opacity 0.3s ease',
    zIndex: (N - depth) * 10,
    boxShadow: `0 ${16 - depth * 2}px ${44 - depth * 8}px rgba(0,0,0,${0.42 - depth * 0.07})`,
  }
}

// ── estrelas ──────────────────────────────────────────────────
const bgStars = Array.from({ length: 60 }, (_, i) => ({
  id: i,
  x: Math.random() * 100,
  y: Math.random() * 100,
  size: Math.random() * 3 + 1,
  delay: Math.random() * 4,
  duration: Math.random() * 3 + 2,
}))

const OPEN_KEY = 'convite2_opened_at'
const OPEN_TTL = 2 * 60 * 1000

function openInvite() {
  localStorage.setItem(OPEN_KEY, Date.now())
  opened.value = true
  setTimeout(() => { showTutorial.value = true }, 700)
}
function dismissTutorial() { showTutorial.value = false }
async function submitRsvp() {
  if (convidadoId) {
    await supabase.from('convidados').update({
      confirmado: true,
      confirmado_em: new Date().toISOString(),
    }).eq('id', convidadoId)
    window.location.replace(`/?convidado=${convidadoId}`)
  } else {
    rsvpSent.value = true
  }
}

function goBack() {
  if (isAnimating.value) return
  if (activeIndex.value > 0) activeIndex.value--
}
</script>

<style scoped>
/* ══════════════════════════════════
   BASE
══════════════════════════════════ */
.scene2 {
  width: 100%;
  min-height: 100vh;
  background: radial-gradient(ellipse at 50% 30%, #2a1a4e 0%, #120a2e 55%, #0a0618 100%);
  position: relative;
  user-select: none;
}

.stars-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0; }
.bg-star  { position: absolute; background: #fff; border-radius: 50%;
            animation: twinkle 3s ease-in-out infinite alternate; }
@keyframes twinkle {
  0%   { opacity: .1; transform: scale(.8); }
  100% { opacity: .9; transform: scale(1.2); }
}

/* ══════════════════════════════════
   ABERTURA
══════════════════════════════════ */
.envelope-screen {
  position: fixed; inset: 0; z-index: 50;
  display: flex; align-items: center; justify-content: center;
  background: radial-gradient(ellipse at 50% 40%, #2e1f5e 0%, #110920 70%, #07040f 100%);
  cursor: pointer;
}
.envelope-wrap { text-align: center; animation: float-gentle 3s ease-in-out infinite alternate; position: relative; }
.envelope-glow {
  width: 220px; height: 220px;
  background: radial-gradient(circle, rgba(212,168,83,.35) 0%, transparent 70%);
  border-radius: 50%; position: absolute; top: 50%; left: 50%;
  transform: translate(-50%,-50%); animation: pulse-glow 2.5s ease-in-out infinite;
}
@keyframes pulse-glow {
  0%,100% { opacity:.5; transform:translate(-50%,-50%) scale(1); }
  50%     { opacity: 1; transform:translate(-50%,-50%) scale(1.15); }
}
.crown-open {
  font-size:64px; display:block; margin-bottom:12px;
  animation: crown-bounce 1.8s ease-in-out infinite;
  filter: drop-shadow(0 0 24px rgba(212,168,83,.8));
}
@keyframes crown-bounce { 0%,100%{transform:translateY(0) rotate(-3deg)} 50%{transform:translateY(-12px) rotate(3deg)} }
.envelope-title    { font-family:'Playfair Display',serif; color:rgba(255,255,255,.75); font-size:18px; letter-spacing:3px; text-transform:uppercase; }
.envelope-subtitle { font-family:'Playfair Display',serif; color:#d4a853; font-size:22px; font-style:italic; margin:4px 0; }
.envelope-name     { font-family:'Dancing Script',cursive; color:#fff; font-size:64px; font-weight:700; line-height:1;
                     text-shadow:0 0 40px rgba(212,168,83,.7),0 2px 20px rgba(0,0,0,.5); margin:8px 0 20px; }
.envelope-hint     { font-family:'Lato',sans-serif; color:rgba(255,255,255,.5); font-size:14px; letter-spacing:2px; animation:blink 2s ease-in-out infinite; }
@keyframes blink { 0%,100%{opacity:.4} 50%{opacity:1} }

.envelope-enter-active { transition: all .6s ease; }
.envelope-leave-active { transition: all .8s cubic-bezier(.4,0,.2,1); }
.envelope-enter-from   { opacity:0; }
.envelope-leave-to     { opacity:0; transform:scale(1.15) translateY(-20px); filter:blur(12px); }

/* ══════════════════════════════════
   FASE CARDS
══════════════════════════════════ */
.phase-fade-enter-active { transition: opacity .6s ease .2s; }
.phase-fade-enter-from   { opacity: 0; }

.card-phase {
  position: fixed;
  inset: 0;
  z-index: 10;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  touch-action: none;
  cursor: grab;
}
.card-phase:active { cursor: grabbing; }

/* ══════════════════════════════════
   DOTS
══════════════════════════════════ */
.page-dots { display: flex; gap: 8px; margin-bottom: 24px; z-index: 20; }
.dot {
  width: 7px; height: 7px; border-radius: 50%;
  background: rgba(255,255,255,.25);
  transition: all .4s cubic-bezier(.34,1.56,.64,1);
}
.dot.active {
  background: #d4a853;
  transform: scale(1.4);
  box-shadow: 0 0 8px rgba(212,168,83,.6);
}

/* ══════════════════════════════════
   CARDS ANCHOR
══════════════════════════════════ */
.cards-anchor {
  position: relative;
  width: min(300px, calc(100vw - 48px));
  height: min(420px, 56vh);
  perspective: 1200px;
}

/* ══════════════════════════════════
   CARD BASE
══════════════════════════════════ */
.s-card {
  position: absolute;
  left: 0; right: 0;
  height: 100%;
  border-radius: 22px;
  background: linear-gradient(160deg, #fdf8ef 0%, #f5ecd4 45%, #efe3c2 100%);
  border: 1px solid rgba(212,168,83,.35);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  will-change: transform, opacity;
  transform-origin: center bottom;
}

.s-card-bg {
  position: absolute; inset: 0; pointer-events: none;
  background:
    radial-gradient(ellipse at 20% 10%, rgba(212,168,83,.07) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 90%, rgba(180,210,240,.09) 0%, transparent 50%);
}
.s-page-num {
  position: absolute; bottom: 12px; right: 16px;
  font-family: 'Lato',sans-serif; font-size: 10px;
  color: rgba(44,62,107,.35); letter-spacing: 1px;
}

/* ══════════════════════════════════
   SWIPE HINT
══════════════════════════════════ */
.swipe-hint {
  position: absolute;
  bottom: 18px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  pointer-events: none;
  transition: opacity .2s ease;
}
.swipe-hint span {
  font-family: 'Lato', sans-serif;
  font-size: 10px;
  color: rgba(44,62,107,.4);
  letter-spacing: 1px;
  white-space: nowrap;
}
.swipe-arrow {
  font-size: 16px; color: #d4a853;
  animation: arrow-bounce 1.2s ease-in-out infinite;
  filter: drop-shadow(0 0 5px rgba(212,168,83,.5));
}
@keyframes arrow-bounce { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-5px)} }

/* ══════════════════════════════════
   DECORAÇÕES
══════════════════════════════════ */
.s-deco { position: absolute; pointer-events: none; animation: float-gentle 4s ease-in-out infinite alternate; }
.s-planet   { width:72px; top:-16px; left:-12px; opacity:.7; animation-delay:.5s; }
.s-star-tr  { width:44px; top: 8px; right:8px; opacity:.65; }
.s-star-br  { width:28px; bottom:36px; right:12px; opacity:.5; animation-delay:1s; }
.s-star-bl  { width:32px; bottom:36px; left:12px; opacity:.5; animation-delay:.7s; }
.s-cloud-br { width:90px; bottom:-8px; right:-12px; opacity:.6; animation-delay:1.2s; }
.s-cloud-tl { width:80px; top: 0px; left:-12px; opacity:.55; animation-delay:.3s; }
.s-clock-tr { width:52px; top:10px; right:10px; opacity:.6; animation-delay:.8s; }
.s-planet-sm{ width:56px; top:-10px; right:-8px; opacity:.6; animation-delay:.4s; }

/* ══════════════════════════════════
   CONTEÚDO DOS CARDS
══════════════════════════════════ */
.ornament    { display:flex; align-items:center; gap:10px; }
.ol          { display:block; width:44px; height:1px; background:linear-gradient(90deg,transparent,#d4a853,transparent); }

/* Capa */
.s-cover { display:flex; flex-direction:column; align-items:center; gap:4px; text-align:center; position:relative; z-index:2; }
.s-emoji-crown { font-size:36px; filter:drop-shadow(0 4px 14px rgba(212,168,83,.7));
                 animation:crown-bounce 2.5s ease-in-out infinite; margin-bottom:4px; }
.s-para {
  margin-top: 10px;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
}
.s-para-label {
  font-family: 'Lato', sans-serif;
  font-size: 9px;
  font-weight: 700;
  color: rgba(44,62,107,.4);
  text-transform: uppercase;
  letter-spacing: 2px;
}
.s-para-nome {
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 20px;
  color: #1a2744;
  line-height: 1.2;
  font-weight: 400;
}
.s-sm   { font-family:'Playfair Display',serif; color:#2c3e6b; font-size:13px; letter-spacing:2px; }
.s-md   { font-family:'Playfair Display',serif; color:#2c3e6b; font-size:16px; font-style:italic; }
.s-name { font-family:'Dancing Script',cursive; color:#1a2744; font-size:52px; font-weight:700; line-height:1;
          text-shadow:0 2px 12px rgba(44,62,107,.18); }

/* Mensagem */
.s-msg { text-align:center; padding:0 22px; display:flex; flex-direction:column; align-items:center; gap:10px; position:relative; z-index:2; }
.s-msg-quote { font-family:'Playfair Display',serif; font-size:52px; color:#d4a853; line-height:.8; margin-bottom:-8px; }
.s-msg-lead  { font-family:'Playfair Display',serif; font-weight:600; font-size:14px; color:#2c3e6b; }
.s-msg-body  { font-family:'Lato',sans-serif; font-size:13px; color:#4a5a7a; line-height:1.65; }

/* Data & Hora */
.s-dt { display:flex; flex-direction:column; align-items:center; gap:4px; text-align:center; position:relative; z-index:2; }
.s-dt-lbl  { font-family:'Lato',sans-serif; font-size:10px; font-weight:700; color:#2c3e6b; text-transform:uppercase; letter-spacing:2px; }
.s-dt-date { font-family:'Dancing Script',cursive; font-size:58px; font-weight:700; color:#1a2744; line-height:1; }
.s-dt-year { font-family:'Lato',sans-serif; font-size:18px; color:#4a5a7a; margin-top:-4px; }
.s-dt-rule { width:60px; height:1px; background:linear-gradient(90deg,transparent,#d4a853,transparent); margin:10px 0; }
.s-dt-time { font-family:'Dancing Script',cursive; font-size:48px; font-weight:700; color:#1a2744; line-height:1; }
.s-dt-hint { font-family:'Lato',sans-serif; font-size:11px; color:#4a5a7a; letter-spacing:1px; }

/* Local */
.s-loc { display:flex; flex-direction:column; align-items:center; gap:6px; text-align:center; padding:0 20px; position:relative; z-index:2; }
.s-loc-emoji { font-size:36px; filter:drop-shadow(0 4px 12px rgba(212,168,83,.4)); }
.s-loc-lbl  { font-family:'Lato',sans-serif; font-size:10px; font-weight:700; color:#2c3e6b; text-transform:uppercase; letter-spacing:2px; }
.s-loc-name { font-family:'Dancing Script',cursive; font-size:30px; font-weight:700; color:#1a2744; line-height:1.1; }
.s-loc-rule { width:60px; height:1px; background:linear-gradient(90deg,transparent,#d4a853,transparent); margin:6px 0; }
.s-loc-addr { font-family:'Lato',sans-serif; font-size:13px; color:#4a5a7a; line-height:1.65; }

/* RSVP CTA */
.s-rsvpcta { display:flex; flex-direction:column; align-items:center; gap:4px; text-align:center; position:relative; z-index:2; padding:0 16px; }
.s-rsvpcta-crown { font-size:32px; filter:drop-shadow(0 0 14px rgba(212,168,83,.7)); animation:crown-bounce 2.5s ease-in-out infinite; }
.s-rsvpcta-title { font-family:'Dancing Script',cursive; font-size:40px; font-weight:700; color:#1a2744; line-height:1.05; }
.s-rsvpcta-menino { width:100px; object-fit:contain; filter:drop-shadow(0 8px 16px rgba(44,62,107,.2));
                    animation:float-hero 4s ease-in-out infinite alternate; }

/* ══════════════════════════════════
   FASE RSVP
══════════════════════════════════ */
.rsvp-rise-enter-active { transition: opacity .7s ease, transform .7s cubic-bezier(.16,1,.3,1); }
.rsvp-rise-enter-from   { opacity:0; transform: translateY(40px) scale(.97); }

.rsvp-phase {
  position: fixed;
  inset: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  overflow-y: auto;
}

.rsvp-card {
  width: 100%;
  max-width: 360px;
  background: linear-gradient(160deg, #fdf8ef 0%, #f5ecd4 50%, #efe3c2 100%);
  border-radius: 28px;
  padding: 32px 24px 28px;
  text-align: center;
  box-shadow:
    0 30px 80px rgba(0,0,0,.5),
    0 0 0 1px rgba(212,168,83,.3),
    inset 0 1px 0 rgba(255,255,255,.8);
}

.rsvp-f-crown { font-size:36px; filter:drop-shadow(0 0 16px rgba(212,168,83,.7));
                animation:crown-bounce 2.5s ease-in-out infinite; margin-bottom:8px; }
.rsvp-f-title { font-family:'Dancing Script',cursive; font-size:42px; font-weight:700;
                color:#1a2744; line-height:1.05; margin-bottom:6px; }
.rsvp-f-sub   { font-family:'Lato',sans-serif; font-size:12px; color:#4a5a7a; margin-bottom:20px; letter-spacing:.3px; }

.rsvp-nome-display { font-family:'Lato',sans-serif; font-size:16px; color:#2c3e6b; text-align:center; padding:4px 0 10px; }
.rsvp-nome-display strong { color:#1a2744; font-size:18px; }
.rsvp-f-form { display:flex; flex-direction:column; gap:12px; text-align:left; }
.rsvp-f-group { display:flex; flex-direction:column; gap:5px; }
.rsvp-f-group label { font-family:'Lato',sans-serif; font-size:10px; font-weight:700;
                      color:rgba(44,62,107,.7); text-transform:uppercase; letter-spacing:1px; }
.rsvp-f-group input,
.rsvp-f-group select {
  background:rgba(255,255,255,.65); border:1.5px solid rgba(212,168,83,.4);
  border-radius:10px; padding:11px 14px;
  font-family:'Lato',sans-serif; font-size:14px; color:#1a2744;
  outline:none; transition:border-color .2s,box-shadow .2s; -webkit-appearance:none;
}
.rsvp-f-group input::placeholder { color:rgba(44,62,107,.35); }
.rsvp-f-group input:focus,
.rsvp-f-group select:focus { border-color:#d4a853; box-shadow:0 0 0 3px rgba(212,168,83,.15); }

.rsvp-f-submit {
  margin-top:6px;
  background:linear-gradient(135deg,#2c3e6b 0%,#1a2744 100%);
  color:#d4a853; border:none; border-radius:50px; padding:15px;
  font-family:'Playfair Display',serif; font-size:16px; font-weight:700;
  cursor:pointer;
  box-shadow:0 8px 28px rgba(44,62,107,.4),0 0 0 1px rgba(212,168,83,.3);
  transition:all .3s cubic-bezier(.34,1.56,.64,1);
}
.rsvp-f-submit:hover, .rsvp-f-submit:active {
  transform:translateY(-2px) scale(1.02);
  box-shadow:0 14px 36px rgba(44,62,107,.5);
}

.rsvp-back {
  display:block; width:100%; margin-top:14px;
  background:transparent; border:1px solid rgba(212,168,83,.3); border-radius:50px; padding:9px;
  font-family:'Lato',sans-serif; font-size:12px; color:rgba(44,62,107,.5);
  cursor:pointer; transition:all .25s ease;
}
.rsvp-back:hover { border-color:rgba(212,168,83,.6); color:#c9962e; }

.rsvp-f-success { padding:16px 0 8px; animation:success-pop .6s cubic-bezier(.34,1.56,.64,1) both; }
@keyframes success-pop { from{opacity:0;transform:scale(.8)} to{opacity:1;transform:scale(1)} }
.success-icon  { font-size:52px; margin-bottom:8px; }
.success-title { font-family:'Dancing Script',cursive; font-size:36px; color:#1a2744; margin-bottom:6px; }
.success-msg   { font-family:'Lato',sans-serif; font-size:13px; color:#4a5a7a; line-height:1.6; }

/* ══════════════════════════════════
   KEYFRAMES GLOBAIS
══════════════════════════════════ */
/* ══════════════════════════════════
   TUTORIAL
══════════════════════════════════ */
.tutorial-overlay {
  position: fixed;
  inset: 0;
  z-index: 80;
  background: rgba(8,4,20,.75);
  backdrop-filter: blur(6px);
  display: flex;
  align-items: flex-end;
  justify-content: center;
  padding-bottom: 48px;
}

.tutorial-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  text-align: center;
  animation: tut-rise .5s cubic-bezier(.16,1,.3,1) both;
}
@keyframes tut-rise { from{opacity:0;transform:translateY(30px)} to{opacity:1;transform:translateY(0)} }

.tutorial-hand {
  font-size: 64px;
  animation: hand-swipe 1.4s ease-in-out infinite;
  filter: drop-shadow(0 0 20px rgba(212,168,83,.5));
  line-height: 1;
}
@keyframes hand-swipe {
  0%   { transform: translateY(0);    opacity: 1; }
  55%  { transform: translateY(-52px); opacity: .3; }
  56%  { transform: translateY(12px);  opacity: 0; }
  57%  { opacity: 0; }
  70%  { transform: translateY(12px);  opacity: 1; }
  100% { transform: translateY(0);    opacity: 1; }
}

.tutorial-text {
  font-family: 'Playfair Display', serif;
  font-size: 26px;
  color: #fff;
  line-height: 1.25;
}
.tutorial-text strong { color: #d4a853; }

.tutorial-subtext {
  font-family: 'Lato', sans-serif;
  font-size: 15px;
  color: rgba(255,255,255,.55);
  letter-spacing: .5px;
}

.tutorial-btn {
  margin-top: 10px;
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853;
  border: none;
  border-radius: 50px;
  padding: 14px 40px;
  font-family: 'Playfair Display', serif;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 8px 28px rgba(44,62,107,.5), 0 0 0 1px rgba(212,168,83,.3);
  transition: transform .2s ease, box-shadow .2s ease;
}
.tutorial-btn:active { transform: scale(.97); }

.tutorial-fade-enter-active { transition: opacity .4s ease; }
.tutorial-fade-leave-active { transition: opacity .35s ease; }
.tutorial-fade-enter-from, .tutorial-fade-leave-to { opacity: 0; }

/* ══════════════════════════════════
   INDICADOR SWIPE PERSISTENTE
══════════════════════════════════ */
.swipe-indicator {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  margin-top: 16px;
}

.swipe-ind-hand {
  font-size: 28px;
  animation: hand-swipe-sm 1.6s ease-in-out infinite;
  filter: drop-shadow(0 0 8px rgba(212,168,83,.4));
  line-height: 1;
}
@keyframes hand-swipe-sm {
  0%   { transform: translateY(4px);  opacity: .7; }
  50%  { transform: translateY(-10px); opacity: 1; }
  100% { transform: translateY(4px);  opacity: .7; }
}

.swipe-ind-text {
  font-family: 'Lato', sans-serif;
  font-size: 12px;
  color: rgba(255,255,255,.45);
  letter-spacing: 1.5px;
  text-transform: lowercase;
}

/* ══════════════════════════════════
   BOTÃO VOLTAR
══════════════════════════════════ */
.back-btn {
  margin-top: 18px;
  background: transparent;
  border: 1px solid rgba(255,255,255,.2);
  border-radius: 50px;
  padding: 9px 24px;
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: rgba(255,255,255,.5);
  cursor: pointer;
  letter-spacing: .5px;
  transition: all .25s ease;
}
.back-btn:hover, .back-btn:active {
  border-color: rgba(212,168,83,.5);
  color: #d4a853;
}

.back-fade-enter-active { transition: opacity .3s ease, transform .3s ease; }
.back-fade-leave-active { transition: opacity .2s ease, transform .2s ease; }
.back-fade-enter-from, .back-fade-leave-to { opacity: 0; transform: translateY(6px); }

@keyframes float-gentle { 0%{transform:translateY(0) rotate(-1deg)} 100%{transform:translateY(-9px) rotate(1deg)} }
@keyframes float-hero   { 0%{transform:translateY(0)} 100%{transform:translateY(-12px)} }
</style>
