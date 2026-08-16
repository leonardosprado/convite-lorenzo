<template>
  <div class="scene" @mousemove="onMouseMove" @touchmove.passive="onTouchMove">

    <!-- Estrelas de fundo -->
    <div class="stars-bg">
      <div
        v-for="s in bgStars" :key="s.id"
        class="bg-star"
        :style="{ left: s.x+'%', top: s.y+'%', width: s.size+'px', height: s.size+'px', animationDelay: s.delay+'s', animationDuration: s.duration+'s' }"
      />
    </div>

    <ConviteNaoEncontrado v-if="!buscandoConvidado && !convidadoOk" />

    <!-- Tela de abertura -->
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

    <!-- Convite principal -->
    <Transition name="reveal">
      <div v-if="convidadoOk && opened" class="card-wrapper">

        <!-- flip-scene aplica o tilt do mouse -->
        <div class="flip-scene" :style="sceneStyle">
          <!-- flip-container: altura animada + aplica o scaleX durante o flip -->
          <div
            class="flip-container"
            :style="{ height: containerHeight, ...flipCardStyle }"
          >

            <!-- ═══ FRENTE ═══ -->
            <div v-show="!isFlipped" ref="frontRef" class="card flip-front">
              <div class="card-bg" />

              <!-- Decorações flutuantes -->
              <img class="deco deco-planet"   :style="parallax(0.8,-12,-8)" src="/src/assets/images/planeta.png" alt="" />
              <img class="deco deco-star deco-star-1" :style="parallax(1.2, 8, 5)" src="/src/assets/images/estrela.png" alt="" />
              <img class="deco deco-star deco-star-2" :style="parallax(0.6,-5,10)" src="/src/assets/images/estrela.png" alt="" />
              <img class="deco deco-cloud deco-cloud-1" :style="parallax(0.5, 5,-5)" src="/src/assets/images/nuvem.png" alt="" />
              <img class="deco deco-cloud deco-cloud-2" :style="parallax(0.4,-8, 8)" src="/src/assets/images/nuvem.png" alt="" />
              <img class="deco deco-cloud deco-cloud-3" :style="parallax(0.7, 6,-3)" src="/src/assets/images/nuvem.png" alt="" />

              <!-- Coroa -->
              <div class="crown-area">
                <img class="crown-img" src="/src/assets/images/estrela.png" alt="" />
                <div class="crown-emoji">👑</div>
                <img class="crown-img" src="/src/assets/images/estrela.png" alt="" />
              </div>

              <!-- Oval + títulos -->
              <div class="oval-frame">
                <div class="title-section">
                  <p class="cha-do">chá do</p>
                  <p class="pequeno-principe">pequeno príncipe</p>
                  <h1 class="nome-lorenzo">Lorenzo</h1>
                  <div class="ornament">
                    <span class="ornament-line" /><span class="heart-icon">💙</span><span class="ornament-line" />
                  </div>
                </div>
              </div>

              <!-- Mensagem -->
              <div class="mensagem">
                <p>A contagem regressiva começou!</p>
                <p>Antes que eu saia correndo da barriga da mamãe,<br />venha celebrar a minha chegada e<br />encher meus papais de carinho<br />(e fraldinhas!).</p>
              </div>

              <!-- Bloco personalizado do convidado -->
              <div v-if="convidadoNome" class="convidado-bloco">
                <span class="convidado-ornamento">✦</span>
                <p class="convidado-para-label">para</p>
                <p class="convidado-para-nome">{{ convidadoNome }}</p>
                <div v-if="convidadoFralda" class="convidado-fralda">
                  <p class="convidado-fralda-frase">Trocar fralda é um esporte —<br>contamos com você nessa maratona!</p>
                  <p class="convidado-fralda-tamanho">✦ {{ convidadoFralda }} ✦</p>
                </div>
              </div>

              <div class="divider" />

              <!-- Informações -->
              <div class="info-list">
                <div class="info-item">
                  <div class="info-icon"><img src="/src/assets/images/relogio.png" alt="hora" /></div>
                  <div class="info-text"><span class="info-label">Hora:</span><span class="info-value">16:00</span></div>
                </div>
                <div class="info-divider" />
                <div class="info-item">
                  <div class="info-icon"><img src="/src/assets/images/estrela.png" alt="local" /></div>
                  <div class="info-text"><span class="info-label">Local:</span><span class="info-value">Salão de festa do condomínio</span></div>
                </div>
                <div class="info-divider" />
                <div class="info-item">
                  <div class="info-icon"><span class="icon-emoji">📅</span></div>
                  <div class="info-text"><span class="info-label">Data:</span><span class="info-value">26/09/2026</span></div>
                </div>
                <div class="info-divider" />
                <div class="info-item">
                  <div class="info-icon"><span class="icon-emoji">🏠</span></div>
                  <div class="info-text"><span class="info-label">Endereço:</span><span class="info-value">Travessa Ita, 53 - Condomínio Eldorado Parque Tijuca</span></div>
                </div>
              </div>

              <!-- Ilustração -->
              <div class="illustration-area">
                <img class="menino-img" :style="parallax(1.0,-3,2)" src="/src/assets/images/menino-com-gato.png" alt="Pequeno Príncipe" />
              </div>

              <!-- Botões RSVP -->
              <div class="rsvp-section">
                <template v-if="convidadoNome && !rsvpSent">
                  <button class="rsvp-btn" @click.stop="submitRsvpDireto">
                    <span class="rsvp-icon">✨</span>Confirmar Presença<span class="rsvp-icon">✨</span>
                  </button>
                </template>
                <template v-else-if="rsvpSent">
                  <div class="rsvp-confirmed-msg">🎉 Presença confirmada!<br/>Mal podemos esperar para te ver!</div>
                  <button v-if="convidadoId" class="rsvp-cancelar" @click.stop="cancelarPresenca">Não vou mais</button>
                </template>
                <template v-else>
                  <button class="rsvp-btn" @click.stop="onRsvp">
                    <span class="rsvp-icon">✨</span>Confirmar Presença<span class="rsvp-icon">✨</span>
                  </button>
                  <button class="rsvp-btn-flip" @click.stop="startFlip">
                    Virar o convite 🃏
                  </button>
                </template>
                <p class="rsvp-hint">Confirme até 20/09/2026</p>
              </div>

                <!-- Brilho 3D -->
              <div class="card-shine" :style="shineStyle" />
            </div><!-- fim flip-front -->

            <!-- ═══ VERSO ═══ -->
            <div v-show="isFlipped" ref="backRef" class="card flip-back">

              <!-- Mesmo fundo creme -->
              <div class="card-bg" />

              <!-- Decorações em watermark -->
              <img class="deco deco-planet  wm" src="/src/assets/images/planeta.png" alt="" />
              <img class="deco deco-cloud deco-cloud-1 wm" src="/src/assets/images/nuvem.png" alt="" />
              <img class="deco deco-cloud deco-cloud-3 wm" src="/src/assets/images/nuvem.png" alt="" />
              <img class="deco deco-star deco-star-1 wm" src="/src/assets/images/estrela.png" alt="" />

              <!-- Cabeçalho -->
              <div class="back-header">
                <div class="back-crown">👑</div>
                <h2 class="back-title">Confirmar<br/>Presença</h2>
                <p class="back-subtitle">Que alegria ter você na nossa festa!</p>
                <div class="ornament" style="margin-bottom:4px;">
                  <span class="ornament-line" /><span class="heart-icon">💙</span><span class="ornament-line" />
                </div>
              </div>

              <!-- Formulário -->
              <form class="back-form" @submit.prevent="submitFlipRsvp">
                <div v-if="!rsvpSent">
                  <div v-if="convidadoNome" class="back-nome-display">
                    Olá, <strong>{{ convidadoNome }}</strong>! 👋
                  </div>
                  <div v-if="!convidadoNome" class="back-form-group">
                    <label>Seu nome</label>
                    <input v-model="rsvpForm.nome" type="text" placeholder="Nome completo" required />
                  </div>
                  <div class="back-form-group">
                    <label>WhatsApp</label>
                    <input v-model="rsvpForm.whatsapp" type="tel" placeholder="(21) 99999-9999" />
                  </div>
                  <div v-if="!convidadoNome" class="back-form-group">
                    <label>Quantas pessoas virão?</label>
                    <select v-model="rsvpForm.pessoas">
                      <option value="1">Só eu 🌟</option>
                      <option value="2">2 pessoas</option>
                      <option value="3">3 pessoas</option>
                      <option value="4">4 ou mais</option>
                    </select>
                  </div>
                  <button type="submit" class="back-submit">Confirmar com amor 💙</button>
                </div>

                <div v-else class="back-success">
                  <div class="success-icon">🎉</div>
                  <p class="success-title">Presença Confirmada!</p>
                  <p class="success-msg">Mal podemos esperar para te ver!<br/>Lorenzo já está animado! 👑</p>
                </div>
              </form>

              <!-- Voltar -->
              <button class="back-return" @click.prevent="flipBack">← Voltar ao convite</button>
            </div><!-- fim flip-back -->

          </div><!-- fim flip-container -->
        </div><!-- fim flip-scene -->

      </div>
    </Transition>

    <!-- Modal RSVP (modo 1) -->
    <Transition name="modal">
      <div v-if="showRsvp" class="modal-overlay" @click.self="showRsvp = false">
        <div class="modal-card">
          <button class="modal-close" @click="showRsvp = false">✕</button>
          <div class="modal-crown">👑</div>
          <h2 class="modal-title">Confirmar Presença</h2>
          <p class="modal-subtitle">Que alegria ter você na nossa festa!</p>
          <form class="modal-form" @submit.prevent="submitRsvp">
            <div v-if="convidadoNome" class="modal-nome-display">
              Olá, <strong>{{ convidadoNome }}</strong>! 👋
            </div>
            <div v-if="!convidadoNome" class="form-group">
              <label>Seu nome</label>
              <input v-model="rsvpForm.nome" type="text" placeholder="Nome completo" required />
            </div>
            <div class="form-group">
              <label>WhatsApp</label>
              <input v-model="rsvpForm.whatsapp" type="tel" placeholder="(21) 99999-9999" />
            </div>
            <div v-if="!convidadoNome" class="form-group">
              <label>Quantas pessoas virão?</label>
              <select v-model="rsvpForm.pessoas">
                <option value="1">Só eu 🌟</option>
                <option value="2">2 pessoas</option>
                <option value="3">3 pessoas</option>
                <option value="4">4 ou mais</option>
              </select>
            </div>
            <button type="submit" class="modal-submit" :disabled="rsvpSent">
              <span v-if="!rsvpSent">Confirmar com amor 💙</span>
              <span v-else>Presença confirmada! 🎉</span>
            </button>
          </form>
        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import { supabase } from '../supabase.js'
import ConviteNaoEncontrado from './ConviteNaoEncontrado.vue'

// ── convidado via URL (?convidado=uuid) ────────────────────────
const convidadoId       = new URLSearchParams(window.location.search).get('convidado')
const convidadoNome     = ref('')
const convidadoFralda   = ref('')
const buscandoConvidado = ref(true)
const convidadoOk       = ref(false)

// ── estado básico ──────────────────────────────────────────────
const opened   = ref(false)
const showRsvp = ref(false)
const rsvpSent = ref(false)
const mouseX   = ref(0)
const mouseY   = ref(0)
const ticking  = ref(false)

const rsvpForm = reactive({ nome: '', whatsapp: '', pessoas: '1' })

// ── flip (modo 2) ──────────────────────────────────────────────
const isFlipped       = ref(false)
const isFlipping      = ref(false)
const flipPhase       = ref('')      // '' | 'out' | 'in'
const frontRef        = ref(null)
const backRef         = ref(null)
const containerHeight = ref('auto')

// ── estrelas de fundo ──────────────────────────────────────────
const bgStars = Array.from({ length: 60 }, (_, i) => ({
  id: i,
  x: Math.random() * 100,
  y: Math.random() * 100,
  size: Math.random() * 3 + 1,
  delay: Math.random() * 4,
  duration: Math.random() * 3 + 2,
}))

// ── abertura ──────────────────────────────────────────────────
const OPEN_KEY = 'convite1_opened_at'
const OPEN_TTL = 2 * 60 * 1000

function openInvite() {
  localStorage.setItem(OPEN_KEY, Date.now())
  opened.value = true
}

// ── parallax / tilt ───────────────────────────────────────────
function onMouseMove(e) {
  if (ticking.value) return
  ticking.value = true
  requestAnimationFrame(() => {
    const w = document.body.clientWidth
    const h = document.body.clientHeight
    mouseX.value = ((e.clientX - w / 2) / w) * 2
    mouseY.value = ((e.clientY - h / 2) / h) * 2
    ticking.value = false
  })
}

function onTouchMove(e) {
  const t = e.touches[0]
  const w = document.body.clientWidth
  const h = document.body.clientHeight
  mouseX.value = ((t.clientX - w / 2) / w) * 2
  mouseY.value = ((t.clientY - h / 2) / h) * 2
}

// tilt do mouse — só ativo quando não está virando
const sceneStyle = computed(() => {
  if (isFlipping.value) return { transition: 'transform 0.3s ease' }
  return {
    transform: `rotateX(${-mouseY.value * 4}deg) rotateY(${mouseX.value * 4}deg)`,
    transition: 'transform 0.12s ease-out',
  }
})

const shineStyle = computed(() => {
  const x = (mouseX.value + 1) * 50
  const y = (mouseY.value + 1) * 50
  return { background: `radial-gradient(circle at ${x}% ${y}%, rgba(255,255,200,0.18) 0%, transparent 70%)` }
})

function parallax(speed, ox, oy) {
  return {
    transform: `translate(${ox * mouseX.value * speed}px, ${oy * mouseY.value * speed}px)`,
  }
}

// ── flip — técnica scaleX (100% compatível iOS/Android) ───────
// Fase "out": card encolhe em X até 0 (some de lado)
// Fase "in":  card cresce de 0 até 1 mostrando o verso
// Sem backface-visibility, sem overflow + preserve-3d bug do Safari

async function startFlip() {
  if (isFlipping.value) return
  isFlipping.value = true

  flipPhase.value = 'out'
  await wait(380)

  isFlipped.value = true

  flipPhase.value = 'in'
  await wait(380)

  flipPhase.value = ''
  isFlipping.value = false
}

async function flipBack() {
  if (isFlipping.value) return
  isFlipping.value = true

  flipPhase.value = 'out'
  await wait(380)

  isFlipped.value = false
  rsvpSent.value = false
  Object.assign(rsvpForm, { nome: '', whatsapp: '', pessoas: '1' })

  flipPhase.value = 'in'
  await wait(380)

  flipPhase.value = ''
  isFlipping.value = false
}

function wait(ms) { return new Promise(r => setTimeout(r, ms)) }

// estilo dinâmico do card visível durante o flip
const flipCardStyle = computed(() => {
  if (flipPhase.value === 'out') {
    return {
      transform: 'scaleX(0) translateY(-4px)',
      transition: 'transform 340ms cubic-bezier(0.55, 0, 1, 0.45)',
    }
  }
  if (flipPhase.value === 'in') {
    return {
      transform: 'scaleX(1) translateY(0)',
      transition: 'transform 340ms cubic-bezier(0, 0.55, 0.45, 1)',
    }
  }
  return {}
})

// ── RSVP modal (modo 1) ───────────────────────────────────────
function onRsvp() { showRsvp.value = true }

async function submitRsvpDireto() {
  await confirmarNoSupabase()
  rsvpSent.value = true
}

async function submitRsvp() {
  await confirmarNoSupabase()
  rsvpSent.value = true
  setTimeout(() => {
    showRsvp.value = false
    rsvpSent.value = false
    Object.assign(rsvpForm, { nome: convidadoNome.value || '', whatsapp: '', pessoas: '1' })
  }, 2000)
}

// ── RSVP flip (modo 2) ────────────────────────────────────────
async function submitFlipRsvp() {
  await confirmarNoSupabase()
  rsvpSent.value = true
}

// ── salva confirmação no Supabase ─────────────────────────────
async function cancelarPresenca() {
  if (!convidadoId) return
  await supabase.from('convidados').update({
    confirmado: false,
    confirmado_em: null,
  }).eq('id', convidadoId)
  rsvpSent.value = false
}

async function confirmarNoSupabase() {
  if (!convidadoId) return
  await supabase.from('convidados').update({
    confirmado: true,
    confirmado_em: new Date().toISOString(),
    whatsapp: rsvpForm.whatsapp || null,
  }).eq('id', convidadoId)
}

// ── init: carrega convidado + trava altura do card ────────────
onMounted(async () => {
  if (convidadoId) {
    const { data } = await supabase
      .from('convidados')
      .select('nome, fralda, confirmado')
      .eq('id', convidadoId)
      .single()
    if (data) {
      convidadoNome.value = data.nome
      convidadoFralda.value = data.fralda || ''
      rsvpForm.nome = data.nome
      if (data.confirmado) rsvpSent.value = true
      convidadoOk.value = true
    }
  }
  buscandoConvidado.value = false

  if (!convidadoOk.value) return

  const last = Number(localStorage.getItem(OPEN_KEY) || 0)
  if (Date.now() - last < OPEN_TTL) opened.value = true

  nextTick(() => {
    if (frontRef.value) {
      containerHeight.value = frontRef.value.scrollHeight + 'px'
    }
  })
})
</script>

<style scoped>
/* ═══════════════════════════════════════════════
   SCENE
═══════════════════════════════════════════════ */
.scene {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  overflow-x: hidden;
  background: radial-gradient(ellipse at 50% 30%, #2a1a4e 0%, #120a2e 55%, #0a0618 100%);
  position: relative;
}

/* ═══════════════════════════════════════════════
   ESTRELAS BG
═══════════════════════════════════════════════ */
.stars-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0; }
.bg-star   { position: absolute; background: #fff; border-radius: 50%; animation: twinkle var(--dur,3s) var(--del,0s) ease-in-out infinite alternate; }

@keyframes twinkle {
  0%   { opacity: 0.1; transform: scale(0.8); }
  100% { opacity: 0.9; transform: scale(1.2); }
}

/* ═══════════════════════════════════════════════
   TELA DE ABERTURA
═══════════════════════════════════════════════ */
.envelope-screen {
  position: fixed; inset: 0; z-index: 50;
  display: flex; align-items: center; justify-content: center;
  background: radial-gradient(ellipse at 50% 40%, #2e1f5e 0%, #110920 70%, #07040f 100%);
  cursor: pointer;
}
.envelope-wrap { text-align: center; animation: float-gentle 3s ease-in-out infinite alternate; }
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
.crown-open  { font-size:64px; display:block; margin-bottom:12px; animation:crown-bounce 1.8s ease-in-out infinite; filter:drop-shadow(0 0 24px rgba(212,168,83,.8)); }
@keyframes crown-bounce { 0%,100%{transform:translateY(0) rotate(-3deg)} 50%{transform:translateY(-12px) rotate(3deg)} }

.envelope-title    { font-family:'Playfair Display',serif; color:rgba(255,255,255,.75); font-size:18px; letter-spacing:3px; text-transform:uppercase; }
.envelope-subtitle { font-family:'Playfair Display',serif; color:#d4a853; font-size:22px; font-style:italic; margin:4px 0; }
.envelope-name     { font-family:'Dancing Script',cursive; color:#fff; font-size:64px; font-weight:700; line-height:1; text-shadow:0 0 40px rgba(212,168,83,.7),0 2px 20px rgba(0,0,0,.5); margin:8px 0 20px; }
.envelope-hint     { font-family:'Lato',sans-serif; color:rgba(255,255,255,.5); font-size:14px; letter-spacing:2px; animation:blink 2s ease-in-out infinite; }
@keyframes blink { 0%,100%{opacity:.4} 50%{opacity:1} }

.envelope-enter-active { transition: all .6s ease; }
.envelope-leave-active { transition: all .8s cubic-bezier(.4,0,.2,1); }
.envelope-enter-from   { opacity:0; }
.envelope-leave-to     { opacity:0; transform:scale(1.15) translateY(-20px); filter:blur(12px); }

/* ═══════════════════════════════════════════════
   CARD WRAPPER
═══════════════════════════════════════════════ */
.card-wrapper {
  z-index: 10;
  width: 100%;
  max-width: 430px;
  padding: 6px 14px 10px;
  display: flex;
  justify-content: center;
  perspective: 1200px;
  perspective-origin: 50% 35%;
}

.reveal-enter-active { transition: all 1s cubic-bezier(.16,1,.3,1); }
.reveal-enter-from   { opacity:0; transform:translateY(60px) scale(.92) rotateX(8deg); filter:blur(8px); }

/* ═══════════════════════════════════════════════
   FLIP SCENE  (tilt de mouse, sem preserve-3d no iOS)
═══════════════════════════════════════════════ */
.flip-scene { width: 100%; }

/* ═══════════════════════════════════════════════
   FLIP CONTAINER  (scaleX anima a virada)
═══════════════════════════════════════════════ */
.flip-container {
  width: 100%;
  position: relative;
  transform-origin: center center;
  will-change: transform;
  /* altura travada no tamanho da frente — não muda ao virar */
}

/* ═══════════════════════════════════════════════
   CARD BASE (frente e verso compartilham)
═══════════════════════════════════════════════ */
.card {
  width: 100%;
  border-radius: 24px;
  background: linear-gradient(160deg, #fdf8ef 0%, #f5ecd4 40%, #efe3c2 100%);
  box-shadow:
    0 30px 80px rgba(0,0,0,.5),
    0 0 0 1px rgba(212,168,83,.3),
    0 0 60px rgba(212,168,83,.12),
    inset 0 1px 0 rgba(255,255,255,.8);
  overflow: hidden;
  position: relative;
}

.flip-front { padding-bottom: 10px; }

.flip-back {
  padding-bottom: 10px;
  min-height: 100%;          /* ocupa exatamente o mesmo espaço da frente */
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  box-shadow:
    0 30px 80px rgba(0,0,0,.52),
    0 0 0 1px rgba(212,168,83,.35),
    0 0 50px rgba(212,168,83,.1),
    inset 0 1px 0 rgba(255,255,255,.9);
}

/* ═══════════════════════════════════════════════
   CARD — elementos internos comuns
═══════════════════════════════════════════════ */
.card-bg {
  position: absolute; inset: 0; pointer-events: none;
  background:
    radial-gradient(ellipse at 20% 10%, rgba(212,168,83,.06) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 90%, rgba(180,210,240,.08) 0%, transparent 50%);
}
.card-shine { position:absolute; inset:0; pointer-events:none; border-radius:24px; transition:background .1s ease; }

/* ═══════════════════════════════════════════════
   DECORAÇÕES FLUTUANTES (frente)
═══════════════════════════════════════════════ */
.deco { position:absolute; pointer-events:none; will-change:transform; transition:transform .1s ease-out; }

.deco-planet  { width:88px; top:-20px; left:-16px; animation:float-gentle 4s .5s ease-in-out infinite alternate; z-index:5; }
.deco-star    { z-index:5; }
.deco-star-1  { width:54px; top:10px; right:10px; animation:float-gentle 3.5s ease-in-out infinite alternate; }
.deco-star-2  { width:30px; top:130px; right:28px; animation:float-gentle 4.5s 1s ease-in-out infinite alternate; opacity:.7; }
.deco-cloud   { z-index:3; opacity:.85; }
.deco-cloud-1 { width:110px; top:115px; right:-18px; animation:float-gentle 5s .3s ease-in-out infinite alternate; }
.deco-cloud-2 { width:80px; top:200px; left:-14px; animation:float-gentle 4.2s 1.5s ease-in-out infinite alternate; }
.deco-cloud-3 { width:100px; bottom:220px; right:-10px; animation:float-gentle 4.8s .8s ease-in-out infinite alternate; }

/* Watermark no verso */
.wm { opacity:.08 !important; filter:grayscale(1); animation:none !important; }

@keyframes float-gentle {
  0%   { transform:translateY(0) rotate(-1deg); }
  100% { transform:translateY(-10px) rotate(1deg); }
}

/* ═══════════════════════════════════════════════
   FRENTE — conteúdo
═══════════════════════════════════════════════ */
.convidado-bloco {
  margin: 2px 0 0;
  padding: 10px 20px 12px;
  text-align: center;
  position: relative;
  z-index: 6;
}
.convidado-ornamento {
  display: block;
  font-size: 10px;
  color: #d4a853;
  letter-spacing: 4px;
  margin-bottom: 3px;
  opacity: .7;
}
.convidado-para-label {
  font-family: 'Lato', sans-serif;
  font-size: 9px;
  font-weight: 700;
  color: rgba(44,62,107,.45);
  text-transform: uppercase;
  letter-spacing: 2px;
  margin: 0 0 2px;
}
.convidado-para-nome {
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 20px;
  color: #1a2744;
  line-height: 1.2;
  margin: 0;
}
.convidado-fralda {
  margin-top: 8px;
}
.convidado-fralda-frase {
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 10.5px;
  color: #5a6a8a;
  line-height: 1.55;
  margin: 0 0 6px;
}
.convidado-fralda-tamanho {
  font-family: 'Lato', sans-serif;
  font-size: 11px;
  font-weight: 700;
  color: #d4a853;
  letter-spacing: 1.5px;
  margin: 0;
}

.crown-area  { display:flex; align-items:center; justify-content:center; gap:8px; padding:8px 20px 0; position:relative; z-index:6; }
.crown-img   { width:24px; opacity:.7; }
.crown-emoji { font-size:30px; filter:drop-shadow(0 4px 16px rgba(212,168,83,.6)); animation:crown-bounce 2.5s ease-in-out infinite; }

.oval-frame {
  position:relative; margin:0 24px; padding:6px 16px 10px;
  border:2px solid rgba(212,168,83,.5); border-radius:50%/40%;
  background:rgba(255,255,255,.2); z-index:6;
}
.oval-frame::before {
  content:''; position:absolute; inset:4px;
  border:1px solid rgba(212,168,83,.25); border-radius:50%/40%; pointer-events:none;
}

.title-section { text-align:center; }
.cha-do          { font-family:'Playfair Display',serif; font-size:15px; color:#2c3e6b; letter-spacing:2px; }
.pequeno-principe{ font-family:'Playfair Display',serif; font-style:italic; font-size:18px; color:#2c3e6b; }
.nome-lorenzo    { font-family:'Dancing Script',cursive; font-size:48px; font-weight:700; color:#1a2744; line-height:1; text-shadow:0 2px 12px rgba(44,62,107,.2); letter-spacing:-1px; }

.ornament      { display:flex; align-items:center; justify-content:center; gap:12px; margin-top:2px; }
.ornament-line { display:block; width:50px; height:1px; background:linear-gradient(90deg,transparent,#d4a853,transparent); }
.heart-icon    { font-size:16px; }

.mensagem { text-align:center; padding:6px 22px 4px; position:relative; z-index:6; }
.mensagem p:first-child { font-family:'Playfair Display',serif; font-weight:600; font-size:12px; color:#2c3e6b; margin-bottom:3px; }
.mensagem p:last-child  { font-family:'Lato',sans-serif; font-size:11.5px; color:#4a5a7a; line-height:1.55; }

.divider { height:1px; background:linear-gradient(90deg,transparent,rgba(212,168,83,.4),transparent); margin:4px 24px 6px; }

.info-list { padding:0 24px; position:relative; z-index:6; }
.info-item { display:flex; align-items:center; gap:10px; padding:4px 0; }
.info-icon { width:30px; height:30px; flex-shrink:0; display:flex; align-items:center; justify-content:center; background:rgba(212,168,83,.1); border-radius:8px; border:1px solid rgba(212,168,83,.3); }
.info-icon img { width:20px; height:20px; object-fit:contain; }
.icon-emoji { font-size:18px; }
.info-text  { display:flex; flex-direction:row; gap:4px; align-items:baseline; flex-wrap:wrap; }
.info-label { font-family:'Lato',sans-serif; font-weight:700; font-size:12px; color:#2c3e6b; letter-spacing:.5px; }
.info-value { font-family:'Lato',sans-serif; font-size:12px; color:#4a5a7a; line-height:1.4; }
.info-divider { height:1px; background:linear-gradient(90deg,transparent,rgba(44,62,107,.12),transparent); margin:0 8px; }

.illustration-area { position:relative; z-index:6; display:flex; justify-content:center; margin-top:4px; pointer-events:none; }
.menino-img { width:55%; max-width:180px; object-fit:contain; will-change:transform; transition:transform .15s ease-out; animation:float-hero 4s ease-in-out infinite alternate; filter:drop-shadow(0 12px 24px rgba(44,62,107,.18)); }
@keyframes float-hero { 0%{transform:translateY(0)} 100%{transform:translateY(-14px)} }

.rsvp-section { text-align:center; padding:4px 24px 2px; position:relative; z-index:6; }
.rsvp-btn {
  display:inline-flex; align-items:center; gap:10px;
  background:linear-gradient(135deg,#2c3e6b 0%,#1a2744 100%);
  color:#d4a853; border:none; border-radius:50px; padding:14px 32px;
  font-family:'Playfair Display',serif; font-size:16px; font-weight:600; letter-spacing:.5px;
  cursor:pointer; width:100%; justify-content:center;
  box-shadow:0 8px 30px rgba(44,62,107,.4),0 0 0 1px rgba(212,168,83,.3),inset 0 1px 0 rgba(255,255,255,.1);
  transition:all .3s cubic-bezier(.34,1.56,.64,1);
}
.rsvp-btn:hover,.rsvp-btn:active { transform:translateY(-3px) scale(1.02); box-shadow:0 16px 40px rgba(44,62,107,.5),0 0 0 1px rgba(212,168,83,.5),0 0 30px rgba(212,168,83,.2); }
.rsvp-icon { font-size:16px; animation:spin-star 3s linear infinite; }
@keyframes spin-star { 0%,100%{transform:rotate(0) scale(1)} 50%{transform:rotate(180deg) scale(1.2)} }

.rsvp-btn-flip {
  display:block; width:100%; margin-top:8px;
  background:transparent; border:1.5px solid rgba(44,62,107,.22); border-radius:50px; padding:9px;
  font-family:'Lato',sans-serif; font-size:13px; color:rgba(44,62,107,.55);
  cursor:pointer; letter-spacing:.3px; transition:all .25s ease;
}
.rsvp-btn-flip:hover,.rsvp-btn-flip:active { border-color:rgba(212,168,83,.5); color:#c9962e; background:rgba(212,168,83,.04); }

.rsvp-hint { font-family:'Lato',sans-serif; font-size:11px; color:rgba(44,62,107,.45); margin-top:8px; letter-spacing:.5px; }
.rsvp-confirmed-msg { font-family:'Playfair Display',serif; font-size:15px; color:#2c3e6b; text-align:center; padding:10px 0; line-height:1.5; animation:success-pop .5s cubic-bezier(.34,1.56,.64,1) both; }
.rsvp-cancelar { display:block; margin:4px auto 0; background:none; border:none; font-family:'Lato',sans-serif; font-size:11px; color:rgba(44,62,107,.3); cursor:pointer; letter-spacing:.5px; text-decoration:underline; padding:2px; transition:color .2s; }
.rsvp-cancelar:hover { color:rgba(44,62,107,.6); }
@keyframes success-pop { from{opacity:0;transform:scale(.85)} to{opacity:1;transform:scale(1)} }

/* ═══════════════════════════════════════════════
   VERSO — conteúdo
═══════════════════════════════════════════════ */
.back-nome-display { font-family:'Lato',sans-serif; font-size:15px; color:#2c3e6b; text-align:center; padding:8px 0 12px; }
.back-nome-display strong { color:#1a2744; }
.modal-nome-display { font-family:'Lato',sans-serif; font-size:15px; color:#2c3e6b; text-align:center; padding:4px 0 12px; }
.modal-nome-display strong { color:#1a2744; }
.back-header { text-align:center; padding:20px 20px 8px; position:relative; z-index:2; }
.back-crown  { font-size:30px; filter:drop-shadow(0 0 14px rgba(212,168,83,.7)); animation:crown-bounce 2.5s ease-in-out infinite; margin-bottom:4px; }
.back-title  { font-family:'Dancing Script',cursive; font-size:40px; font-weight:700; color:#1a2744; line-height:1.05; margin-bottom:4px; text-shadow:0 1px 8px rgba(44,62,107,.15); }
.back-subtitle { font-family:'Lato',sans-serif; font-size:12px; color:#4a5a7a; margin-bottom:8px; letter-spacing:.3px; }

.back-form { padding:0 20px; position:relative; z-index:2; }
.back-form-group { display:flex; flex-direction:column; gap:5px; margin-bottom:10px; }
.back-form-group label {
  font-family:'Lato',sans-serif; font-size:10px; font-weight:700;
  color:rgba(44,62,107,.7); text-transform:uppercase; letter-spacing:1px;
}
.back-form-group input,
.back-form-group select {
  background:rgba(255,255,255,.65);
  border:1.5px solid rgba(212,168,83,.4);
  border-radius:10px; padding:10px 14px;
  font-family:'Lato',sans-serif; font-size:14px; color:#1a2744;
  outline:none; transition:border-color .2s,box-shadow .2s; -webkit-appearance:none;
}
.back-form-group input::placeholder { color:rgba(44,62,107,.35); }
.back-form-group input:focus,
.back-form-group select:focus { border-color:#d4a853; box-shadow:0 0 0 3px rgba(212,168,83,.15); }

.back-submit {
  width:100%; margin-top:4px;
  background:linear-gradient(135deg,#2c3e6b 0%,#1a2744 100%);
  color:#d4a853; border:none; border-radius:50px; padding:13px;
  font-family:'Playfair Display',serif; font-size:15px; font-weight:700;
  cursor:pointer; transition:all .3s cubic-bezier(.34,1.56,.64,1);
  box-shadow:0 6px 24px rgba(44,62,107,.35),0 0 0 1px rgba(212,168,83,.3);
}
.back-submit:hover,.back-submit:active { transform:translateY(-2px) scale(1.02); box-shadow:0 12px 32px rgba(44,62,107,.5); }

.back-success { text-align:center; padding:16px 0 8px; animation:success-pop .5s cubic-bezier(.34,1.56,.64,1) both; }
@keyframes success-pop { from{opacity:0;transform:scale(.8)} to{opacity:1;transform:scale(1)} }
.success-icon  { font-size:52px; margin-bottom:8px; filter:drop-shadow(0 0 20px rgba(212,168,83,.5)); }
.success-title { font-family:'Dancing Script',cursive; font-size:34px; color:#1a2744; margin-bottom:6px; }
.success-msg   { font-family:'Lato',sans-serif; font-size:13px; color:#4a5a7a; line-height:1.6; }

.back-return {
  display:block; width:calc(100% - 40px); margin:10px 20px 14px;
  background:transparent; border:1px solid rgba(212,168,83,.3); border-radius:50px; padding:9px;
  font-family:'Lato',sans-serif; font-size:12px; color:rgba(44,62,107,.55);
  cursor:pointer; letter-spacing:.5px; transition:all .25s ease; position:relative; z-index:2;
}
.back-return:hover,.back-return:active { border-color:rgba(212,168,83,.6); color:#c9962e; background:rgba(212,168,83,.04); }

/* ═══════════════════════════════════════════════
   MODAL RSVP (modo 1)
═══════════════════════════════════════════════ */
.modal-overlay {
  position:fixed; inset:0; z-index:100;
  background:rgba(10,6,24,.85); backdrop-filter:blur(8px);
  display:flex; align-items:flex-end; justify-content:center;
}
.modal-card {
  width:100%; max-width:430px;
  background:linear-gradient(160deg,#fdf8ef 0%,#f5ecd4 100%);
  border-radius:28px 28px 0 0; padding:32px 28px 48px; position:relative;
  box-shadow:0 -20px 60px rgba(0,0,0,.4),0 0 0 1px rgba(212,168,83,.3);
}
.modal-close {
  position:absolute; top:16px; right:16px; background:rgba(44,62,107,.1);
  border:none; width:32px; height:32px; border-radius:50%; font-size:14px;
  color:#2c3e6b; cursor:pointer; display:flex; align-items:center; justify-content:center;
}
.modal-crown    { font-size:40px; text-align:center; margin-bottom:8px; }
.modal-title    { font-family:'Dancing Script',cursive; font-size:36px; color:#1a2744; text-align:center; margin-bottom:4px; }
.modal-subtitle { font-family:'Lato',sans-serif; font-size:13px; color:#4a5a7a; text-align:center; margin-bottom:24px; }
.modal-form     { display:flex; flex-direction:column; gap:14px; }
.form-group     { display:flex; flex-direction:column; gap:6px; }
.form-group label { font-family:'Lato',sans-serif; font-size:12px; font-weight:700; color:#2c3e6b; text-transform:uppercase; letter-spacing:.8px; }
.form-group input,
.form-group select {
  background:rgba(255,255,255,.7); border:1.5px solid rgba(212,168,83,.4);
  border-radius:12px; padding:12px 16px;
  font-family:'Lato',sans-serif; font-size:15px; color:#1a2744;
  outline:none; transition:border-color .2s; -webkit-appearance:none;
}
.form-group input:focus,.form-group select:focus { border-color:#d4a853; box-shadow:0 0 0 3px rgba(212,168,83,.15); }
.modal-submit {
  margin-top:8px; background:linear-gradient(135deg,#2c3e6b 0%,#1a2744 100%);
  color:#d4a853; border:none; border-radius:50px; padding:16px;
  font-family:'Playfair Display',serif; font-size:16px; font-weight:600;
  cursor:pointer; transition:all .3s ease; box-shadow:0 8px 24px rgba(44,62,107,.35);
}
.modal-submit:disabled { background:linear-gradient(135deg,#4a8a4a 0%,#2d5a2d 100%); color:#90ee90; }

.modal-enter-active { transition:opacity .4s ease; }
.modal-leave-active { transition:opacity .3s ease-in; }
.modal-enter-from,.modal-leave-to { opacity:0; }
.modal-enter-active .modal-card { animation:slide-up .5s cubic-bezier(.16,1,.3,1) both; }
.modal-leave-active .modal-card  { animation:slide-down .3s ease-in both; }
@keyframes slide-up   { from{transform:translateY(100%)} to{transform:translateY(0)} }
@keyframes slide-down { from{transform:translateY(0)} to{transform:translateY(100%)} }

/* ═══════════════════════════════════════════════
   DESKTOP
═══════════════════════════════════════════════ */
@media (min-width: 480px) {
  .card-wrapper { padding:20px 16px 30px; }
}
</style>
