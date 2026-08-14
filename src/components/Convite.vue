<template>
  <div class="scene" @mousemove="onMouseMove" @touchmove.passive="onTouchMove">

    <!-- Partículas de estrelas ao fundo -->
    <div class="stars-bg">
      <div
        v-for="s in bgStars"
        :key="s.id"
        class="bg-star"
        :style="{ left: s.x + '%', top: s.y + '%', width: s.size + 'px', height: s.size + 'px', animationDelay: s.delay + 's', animationDuration: s.duration + 's' }"
      />
    </div>

    <!-- Tela de abertura -->
    <Transition name="envelope">
      <div v-if="!opened" class="envelope-screen" @click="openInvite">
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
      <div v-if="opened" class="card-wrapper">
        <div
          class="card"
          :style="cardStyle"
          @click="toggleTilt"
        >
          <!-- Fundo interno com textura -->
          <div class="card-bg" />

          <!-- Decorações flutuantes -->
          <img
            class="deco deco-planet"
            :style="floatStyle(0.8, -12, -8)"
            src="/src/assets/images/planeta.png"
            alt=""
          />
          <img
            class="deco deco-star deco-star-1"
            :style="floatStyle(1.2, 8, 5)"
            src="/src/assets/images/estrela.png"
            alt=""
          />
          <img
            class="deco deco-star deco-star-2"
            :style="floatStyle(0.6, -5, 10)"
            src="/src/assets/images/estrela.png"
            alt=""
          />
          <img
            class="deco deco-cloud deco-cloud-1"
            :style="floatStyle(0.5, 5, -5)"
            src="/src/assets/images/nuvem.png"
            alt=""
          />
          <img
            class="deco deco-cloud deco-cloud-2"
            :style="floatStyle(0.4, -8, 8)"
            src="/src/assets/images/nuvem.png"
            alt=""
          />
          <img
            class="deco deco-cloud deco-cloud-3"
            :style="floatStyle(0.7, 6, -3)"
            src="/src/assets/images/nuvem.png"
            alt=""
          />

          <!-- Coroa no topo -->
          <div class="crown-area">
            <img class="crown-img" src="/src/assets/images/estrela.png" alt="" />
            <div class="crown-emoji">👑</div>
            <img class="crown-img" src="/src/assets/images/estrela.png" alt="" />
          </div>

          <!-- Oval dourada -->
          <div class="oval-frame">
            <!-- Título -->
            <div class="title-section">
              <p class="cha-do">chá do</p>
              <p class="pequeno-principe">pequeno príncipe</p>
              <h1 class="nome-lorenzo">Lorenzo</h1>
              <div class="ornament">
                <span class="ornament-line" />
                <span class="heart-icon">💙</span>
                <span class="ornament-line" />
              </div>
            </div>
          </div>

          <!-- Mensagem -->
          <div class="mensagem">
            <p>A contagem regressiva começou!</p>
            <p>Antes que eu saia correndo da barriga da mamãe,<br />venha celebrar a minha chegada e<br />encher meus papais de carinho<br />(e fraldinhas!).</p>
          </div>

          <!-- Linha divisória -->
          <div class="divider" />

          <!-- Informações do evento -->
          <div class="info-list">
            <div class="info-item">
              <div class="info-icon">
                <img src="/src/assets/images/relogio.png" alt="hora" />
              </div>
              <div class="info-text">
                <span class="info-label">Hora:</span>
                <span class="info-value">16:00</span>
              </div>
            </div>
            <div class="info-divider" />

            <div class="info-item">
              <div class="info-icon">
                <img src="/src/assets/images/estrela.png" alt="local" />
              </div>
              <div class="info-text">
                <span class="info-label">Local:</span>
                <span class="info-value">Salão de festa do condomínio</span>
              </div>
            </div>
            <div class="info-divider" />

            <div class="info-item">
              <div class="info-icon">
                <span class="icon-emoji">📅</span>
              </div>
              <div class="info-text">
                <span class="info-label">Data:</span>
                <span class="info-value">26/09/2026</span>
              </div>
            </div>
            <div class="info-divider" />

            <div class="info-item">
              <div class="info-icon">
                <span class="icon-emoji">🏠</span>
              </div>
              <div class="info-text">
                <span class="info-label">Endereço:</span>
                <span class="info-value">Travessa Ita, 53 - Condomínio Eldorado Parque Tijuca</span>
              </div>
            </div>
          </div>

          <!-- Ilustração do menino com a raposa -->
          <div class="illustration-area">
            <img
              class="menino-img"
              :style="floatStyle(1.0, -3, 2)"
              src="/src/assets/images/menino-com-gato.png"
              alt="Pequeno Príncipe"
            />
          </div>

          <!-- Botão confirmar presença -->
          <div class="rsvp-section">
            <button class="rsvp-btn" @click.stop="onRsvp">
              <span class="rsvp-icon">✨</span>
              Confirmar Presença
              <span class="rsvp-icon">✨</span>
            </button>
            <p class="rsvp-hint">Confirme até 20/09/2026</p>
          </div>

          <!-- Reflexo 3D -->
          <div class="card-shine" :style="shineStyle" />
        </div>
      </div>
    </Transition>

    <!-- Modal RSVP -->
    <Transition name="modal">
      <div v-if="showRsvp" class="modal-overlay" @click.self="showRsvp = false">
        <div class="modal-card">
          <button class="modal-close" @click="showRsvp = false">✕</button>
          <div class="modal-crown">👑</div>
          <h2 class="modal-title">Confirmar Presença</h2>
          <p class="modal-subtitle">Que alegria ter você na nossa festa!</p>
          <form class="modal-form" @submit.prevent="submitRsvp">
            <div class="form-group">
              <label>Seu nome</label>
              <input v-model="rsvpForm.nome" type="text" placeholder="Nome completo" required />
            </div>
            <div class="form-group">
              <label>WhatsApp</label>
              <input v-model="rsvpForm.whatsapp" type="tel" placeholder="(21) 99999-9999" required />
            </div>
            <div class="form-group">
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
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'

// ---------- estado ---------
const opened = ref(false)
const showRsvp = ref(false)
const rsvpSent = ref(false)
const mouseX = ref(0)
const mouseY = ref(0)
const ticking = ref(false)

const rsvpForm = reactive({ nome: '', whatsapp: '', pessoas: '1' })

// ---------- estrelas de fundo ---------
const bgStars = Array.from({ length: 60 }, (_, i) => ({
  id: i,
  x: Math.random() * 100,
  y: Math.random() * 100,
  size: Math.random() * 3 + 1,
  delay: Math.random() * 4,
  duration: Math.random() * 3 + 2,
}))

// ---------- abertura ---------
function openInvite() {
  opened.value = true
}

function toggleTilt() {}

// ---------- parallax / tilt ---------
function onMouseMove(e) {
  if (!ticking.value) {
    requestAnimationFrame(() => {
      const rect = document.body.getBoundingClientRect()
      mouseX.value = ((e.clientX - rect.width / 2) / rect.width) * 2
      mouseY.value = ((e.clientY - rect.height / 2) / rect.height) * 2
      ticking.value = false
    })
    ticking.value = true
  }
}

function onTouchMove(e) {
  const t = e.touches[0]
  const rect = document.body.getBoundingClientRect()
  mouseX.value = ((t.clientX - rect.width / 2) / rect.width) * 2
  mouseY.value = ((t.clientY - rect.height / 2) / rect.height) * 2
}

const cardStyle = computed(() => {
  const rx = -mouseY.value * 6
  const ry = mouseX.value * 6
  return {
    transform: `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateZ(0)`,
  }
})

const shineStyle = computed(() => {
  const x = (mouseX.value + 1) * 50
  const y = (mouseY.value + 1) * 50
  return {
    background: `radial-gradient(circle at ${x}% ${y}%, rgba(255,255,200,0.18) 0%, transparent 70%)`,
  }
})

function floatStyle(speed, ox, oy) {
  return {
    '--ox': `${ox * mouseX.value * speed}px`,
    '--oy': `${oy * mouseY.value * speed}px`,
    transform: `translate(var(--ox), var(--oy))`,
  }
}

// ---------- RSVP ---------
function onRsvp() {
  showRsvp.value = true
}

function submitRsvp() {
  // Aqui vai conectar ao Supabase
  rsvpSent.value = true
  setTimeout(() => {
    showRsvp.value = false
    rsvpSent.value = false
    Object.assign(rsvpForm, { nome: '', whatsapp: '', pessoas: '1' })
  }, 2000)
}

// ---------- lifecycle ---------
onMounted(() => {
  // Abre animação de entrada com delay
  setTimeout(() => {}, 300)
})
</script>

<style scoped>
/* ===================== SCENE ===================== */
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

/* ===================== ESTRELAS BG ===================== */
.stars-bg {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
}

.bg-star {
  position: absolute;
  background: #fff;
  border-radius: 50%;
  animation: twinkle var(--dur, 3s) var(--del, 0s) ease-in-out infinite alternate;
}

@keyframes twinkle {
  0% { opacity: 0.1; transform: scale(0.8); }
  100% { opacity: 0.9; transform: scale(1.2); }
}

/* ===================== ENVELOPE / TELA ABERTURA ===================== */
.envelope-screen {
  position: fixed;
  inset: 0;
  z-index: 50;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at 50% 40%, #2e1f5e 0%, #110920 70%, #07040f 100%);
  cursor: pointer;
}

.envelope-wrap {
  text-align: center;
  animation: float-gentle 3s ease-in-out infinite alternate;
}

.envelope-glow {
  width: 220px;
  height: 220px;
  background: radial-gradient(circle, rgba(212,168,83,0.35) 0%, transparent 70%);
  border-radius: 50%;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation: pulse-glow 2.5s ease-in-out infinite;
}

@keyframes pulse-glow {
  0%, 100% { opacity: 0.5; transform: translate(-50%, -50%) scale(1); }
  50% { opacity: 1; transform: translate(-50%, -50%) scale(1.15); }
}

.crown-open {
  font-size: 64px;
  display: block;
  margin-bottom: 12px;
  animation: crown-bounce 1.8s ease-in-out infinite;
  filter: drop-shadow(0 0 24px rgba(212,168,83,0.8));
}

@keyframes crown-bounce {
  0%, 100% { transform: translateY(0) rotate(-3deg); }
  50% { transform: translateY(-12px) rotate(3deg); }
}

.envelope-title {
  font-family: 'Playfair Display', serif;
  color: rgba(255,255,255,0.75);
  font-size: 18px;
  letter-spacing: 3px;
  text-transform: uppercase;
}

.envelope-subtitle {
  font-family: 'Playfair Display', serif;
  color: #d4a853;
  font-size: 22px;
  font-style: italic;
  margin: 4px 0;
}

.envelope-name {
  font-family: 'Dancing Script', cursive;
  color: #fff;
  font-size: 64px;
  font-weight: 700;
  line-height: 1;
  text-shadow: 0 0 40px rgba(212,168,83,0.7), 0 2px 20px rgba(0,0,0,0.5);
  margin: 8px 0 20px;
}

.envelope-hint {
  font-family: 'Lato', sans-serif;
  color: rgba(255,255,255,0.5);
  font-size: 14px;
  letter-spacing: 2px;
  animation: blink 2s ease-in-out infinite;
}

@keyframes blink {
  0%, 100% { opacity: 0.4; }
  50% { opacity: 1; }
}

/* ===================== ENVELOPE TRANSITION ===================== */
.envelope-enter-active { transition: all 0.6s ease; }
.envelope-leave-active { transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
.envelope-enter-from { opacity: 0; }
.envelope-leave-to {
  opacity: 0;
  transform: scale(1.15) translateY(-20px);
  filter: blur(12px);
}

/* ===================== CARD WRAPPER ===================== */
.card-wrapper {
  z-index: 10;
  width: 100%;
  max-width: 430px;
  padding: 24px 16px 40px;
  display: flex;
  justify-content: center;
}

/* ===================== REVEAL TRANSITION ===================== */
.reveal-enter-active {
  transition: all 1s cubic-bezier(0.16, 1, 0.3, 1);
}
.reveal-enter-from {
  opacity: 0;
  transform: translateY(60px) scale(0.92) rotateX(8deg);
  filter: blur(8px);
}

/* ===================== CARD ===================== */
.card {
  width: 100%;
  border-radius: 24px;
  background: linear-gradient(160deg, #fdf8ef 0%, #f5ecd4 40%, #efe3c2 100%);
  box-shadow:
    0 30px 80px rgba(0,0,0,0.5),
    0 0 0 1px rgba(212,168,83,0.3),
    0 0 60px rgba(212,168,83,0.15),
    inset 0 1px 0 rgba(255,255,255,0.8);
  position: relative;
  overflow: hidden;
  transform-style: preserve-3d;
  will-change: transform;
  transition: transform 0.15s ease-out;
  padding-bottom: 32px;
}

.card-bg {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse at 20% 10%, rgba(212,168,83,0.06) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 90%, rgba(180,210,240,0.08) 0%, transparent 50%);
  pointer-events: none;
}

.card-shine {
  position: absolute;
  inset: 0;
  pointer-events: none;
  border-radius: 24px;
  transition: background 0.1s ease;
}

/* ===================== DECORAÇÕES FLUTUANTES ===================== */
.deco {
  position: absolute;
  pointer-events: none;
  will-change: transform;
  transition: transform 0.1s ease-out;
}

.deco-planet {
  width: 88px;
  top: -20px;
  left: -16px;
  animation: float-gentle 4s 0.5s ease-in-out infinite alternate;
  z-index: 5;
}

.deco-star {
  z-index: 5;
}
.deco-star-1 {
  width: 54px;
  top: 10px;
  right: 10px;
  animation: float-gentle 3.5s ease-in-out infinite alternate;
}
.deco-star-2 {
  width: 30px;
  top: 130px;
  right: 28px;
  animation: float-gentle 4.5s 1s ease-in-out infinite alternate;
  opacity: 0.7;
}

.deco-cloud {
  z-index: 3;
  opacity: 0.85;
}
.deco-cloud-1 {
  width: 110px;
  top: 115px;
  right: -18px;
  animation: float-gentle 5s 0.3s ease-in-out infinite alternate;
}
.deco-cloud-2 {
  width: 80px;
  top: 200px;
  left: -14px;
  animation: float-gentle 4.2s 1.5s ease-in-out infinite alternate;
}
.deco-cloud-3 {
  width: 100px;
  bottom: 220px;
  right: -10px;
  animation: float-gentle 4.8s 0.8s ease-in-out infinite alternate;
}

@keyframes float-gentle {
  0% { transform: translateY(0px) rotate(-1deg); }
  100% { transform: translateY(-10px) rotate(1deg); }
}

/* ===================== COROA ===================== */
.crown-area {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 28px 20px 0;
  position: relative;
  z-index: 6;
}

.crown-img {
  width: 24px;
  opacity: 0.7;
}

.crown-emoji {
  font-size: 44px;
  filter: drop-shadow(0 4px 16px rgba(212,168,83,0.6));
  animation: crown-bounce 2.5s ease-in-out infinite;
}

/* ===================== OVAL FRAME ===================== */
.oval-frame {
  position: relative;
  margin: 0 30px;
  padding: 16px 20px 20px;
  border: 2px solid rgba(212,168,83,0.5);
  border-radius: 50% / 40%;
  background: rgba(255,255,255,0.2);
  z-index: 6;
}

.oval-frame::before {
  content: '';
  position: absolute;
  inset: 4px;
  border: 1px solid rgba(212,168,83,0.25);
  border-radius: 50% / 40%;
  pointer-events: none;
}

/* ===================== TÍTULOS ===================== */
.title-section {
  text-align: center;
}

.cha-do {
  font-family: 'Playfair Display', serif;
  font-size: 18px;
  color: #2c3e6b;
  letter-spacing: 2px;
}

.pequeno-principe {
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 22px;
  color: #2c3e6b;
}

.nome-lorenzo {
  font-family: 'Dancing Script', cursive;
  font-size: 72px;
  font-weight: 700;
  color: #1a2744;
  line-height: 1.05;
  text-shadow: 0 2px 12px rgba(44,62,107,0.2);
  letter-spacing: -1px;
}

.ornament {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-top: 6px;
}

.ornament-line {
  display: block;
  width: 50px;
  height: 1px;
  background: linear-gradient(90deg, transparent, #d4a853, transparent);
}

.heart-icon {
  font-size: 16px;
}

/* ===================== MENSAGEM ===================== */
.mensagem {
  text-align: center;
  padding: 18px 28px 10px;
  position: relative;
  z-index: 6;
}

.mensagem p:first-child {
  font-family: 'Playfair Display', serif;
  font-weight: 600;
  font-size: 14px;
  color: #2c3e6b;
  margin-bottom: 8px;
}

.mensagem p:last-child {
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: #4a5a7a;
  line-height: 1.7;
}

/* ===================== DIVIDER ===================== */
.divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(212,168,83,0.4), transparent);
  margin: 8px 24px 16px;
}

/* ===================== LISTA DE INFO ===================== */
.info-list {
  padding: 0 24px;
  position: relative;
  z-index: 6;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 10px 0;
}

.info-icon {
  width: 42px;
  height: 42px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(212,168,83,0.1);
  border-radius: 10px;
  border: 1px solid rgba(212,168,83,0.3);
}

.info-icon img {
  width: 26px;
  height: 26px;
  object-fit: contain;
}

.icon-emoji {
  font-size: 22px;
}

.info-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding-top: 4px;
}

.info-label {
  font-family: 'Lato', sans-serif;
  font-weight: 700;
  font-size: 13px;
  color: #2c3e6b;
  letter-spacing: 0.5px;
}

.info-value {
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: #4a5a7a;
  line-height: 1.5;
}

.info-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(44,62,107,0.12), transparent);
  margin: 0 8px;
}

/* ===================== ILUSTRAÇÃO ===================== */
.illustration-area {
  position: relative;
  z-index: 6;
  display: flex;
  justify-content: center;
  margin-top: 12px;
  pointer-events: none;
}

.menino-img {
  width: 80%;
  max-width: 300px;
  object-fit: contain;
  will-change: transform;
  transition: transform 0.15s ease-out;
  animation: float-hero 4s ease-in-out infinite alternate;
  filter: drop-shadow(0 16px 32px rgba(44,62,107,0.18));
}

@keyframes float-hero {
  0% { transform: translateY(0px); }
  100% { transform: translateY(-14px); }
}

/* ===================== RSVP ===================== */
.rsvp-section {
  text-align: center;
  padding: 16px 24px 8px;
  position: relative;
  z-index: 6;
}

.rsvp-btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853;
  border: none;
  border-radius: 50px;
  padding: 14px 32px;
  font-family: 'Playfair Display', serif;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 0.5px;
  cursor: pointer;
  box-shadow:
    0 8px 30px rgba(44,62,107,0.4),
    0 0 0 1px rgba(212,168,83,0.3),
    inset 0 1px 0 rgba(255,255,255,0.1);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  width: 100%;
  justify-content: center;
}

.rsvp-btn:hover,
.rsvp-btn:active {
  transform: translateY(-3px) scale(1.02);
  box-shadow:
    0 16px 40px rgba(44,62,107,0.5),
    0 0 0 1px rgba(212,168,83,0.5),
    0 0 30px rgba(212,168,83,0.2);
}

.rsvp-btn:active {
  transform: translateY(0) scale(0.98);
}

.rsvp-icon {
  font-size: 16px;
  animation: spin-star 3s linear infinite;
}

@keyframes spin-star {
  0%, 100% { transform: rotate(0deg) scale(1); }
  50% { transform: rotate(180deg) scale(1.2); }
}

.rsvp-hint {
  font-family: 'Lato', sans-serif;
  font-size: 11px;
  color: rgba(44,62,107,0.5);
  margin-top: 8px;
  letter-spacing: 0.5px;
}

/* ===================== MODAL ===================== */
.modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 100;
  background: rgba(10, 6, 24, 0.85);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: flex-end;
  justify-content: center;
  padding: 0;
}

.modal-card {
  width: 100%;
  max-width: 430px;
  background: linear-gradient(160deg, #fdf8ef 0%, #f5ecd4 100%);
  border-radius: 28px 28px 0 0;
  padding: 32px 28px 48px;
  position: relative;
  box-shadow: 0 -20px 60px rgba(0,0,0,0.4), 0 0 0 1px rgba(212,168,83,0.3);
}

.modal-close {
  position: absolute;
  top: 16px;
  right: 16px;
  background: rgba(44,62,107,0.1);
  border: none;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  font-size: 14px;
  color: #2c3e6b;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-crown {
  font-size: 40px;
  text-align: center;
  margin-bottom: 8px;
}

.modal-title {
  font-family: 'Dancing Script', cursive;
  font-size: 36px;
  color: #1a2744;
  text-align: center;
  margin-bottom: 4px;
}

.modal-subtitle {
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: #4a5a7a;
  text-align: center;
  margin-bottom: 24px;
}

.modal-form {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-group label {
  font-family: 'Lato', sans-serif;
  font-size: 12px;
  font-weight: 700;
  color: #2c3e6b;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

.form-group input,
.form-group select {
  background: rgba(255,255,255,0.7);
  border: 1.5px solid rgba(212,168,83,0.4);
  border-radius: 12px;
  padding: 12px 16px;
  font-family: 'Lato', sans-serif;
  font-size: 15px;
  color: #1a2744;
  outline: none;
  transition: border-color 0.2s;
  -webkit-appearance: none;
}

.form-group input:focus,
.form-group select:focus {
  border-color: #d4a853;
  box-shadow: 0 0 0 3px rgba(212,168,83,0.15);
}

.modal-submit {
  margin-top: 8px;
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853;
  border: none;
  border-radius: 50px;
  padding: 16px;
  font-family: 'Playfair Display', serif;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 8px 24px rgba(44,62,107,0.35);
}

.modal-submit:disabled {
  background: linear-gradient(135deg, #4a8a4a 0%, #2d5a2d 100%);
  color: #90ee90;
}

/* ===================== MODAL TRANSITION ===================== */
.modal-enter-active {
  transition: opacity 0.4s ease;
}
.modal-leave-active {
  transition: opacity 0.3s ease-in;
}
.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .modal-card {
  animation: slide-up 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
}
.modal-leave-active .modal-card {
  animation: slide-down 0.3s ease-in both;
}

@keyframes slide-up {
  from { transform: translateY(100%); }
  to   { transform: translateY(0); }
}
@keyframes slide-down {
  from { transform: translateY(0); }
  to   { transform: translateY(100%); }
}

/* ===================== FLOAT GENTLE (global animation) ===================== */
@keyframes float-gentle {
  0% { transform: translate(var(--ox, 0px), var(--oy, 0px)) translateY(0px) rotate(-1deg); }
  100% { transform: translate(var(--ox, 0px), var(--oy, 0px)) translateY(-10px) rotate(1deg); }
}

/* Garante que partículas de bg usem as variáveis css corretas */
.bg-star {
  animation-name: twinkle;
}

/* ===================== DESKTOP ===================== */
@media (min-width: 480px) {
  .card-wrapper {
    padding: 40px 16px 60px;
  }
}
</style>
