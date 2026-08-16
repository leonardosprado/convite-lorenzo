<template>
  <div
    class="lost-wrapper"
    @mousemove="onMouseMove"
    @touchmove.passive="onTouchMove"
  >
    <div class="lost-scene" :style="sceneStyle">
      <div class="lost-card">
        <div class="lost-card-bg" />

        <img class="deco deco-planet" :style="parallax(0.8,-12,-8)" src="/src/assets/images/planeta.png" alt="" />
        <img class="deco deco-star deco-star-1" :style="parallax(1.2, 8, 5)" src="/src/assets/images/estrela.png" alt="" />
        <img class="deco deco-star deco-star-2" :style="parallax(0.6,-5,10)" src="/src/assets/images/estrela.png" alt="" />
        <img class="deco deco-cloud deco-cloud-1" :style="parallax(0.5, 5,-5)" src="/src/assets/images/nuvem.png" alt="" />
        <img class="deco deco-cloud deco-cloud-2" :style="parallax(0.4,-8, 8)" src="/src/assets/images/nuvem.png" alt="" />
        <img class="deco deco-cloud deco-cloud-3" :style="parallax(0.7, 6,-3)" src="/src/assets/images/nuvem.png" alt="" />

        <div class="crown-area">
          <img class="crown-img" src="/src/assets/images/estrela.png" alt="" />
          <div class="crown-emoji">👑</div>
          <img class="crown-img" src="/src/assets/images/estrela.png" alt="" />
        </div>

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

        <div class="mensagem">
          <p>Não sabe cadê seu convite?</p>
          <p>Fale com a mamãe ou o papai<br />para receber novamente 💌</p>
        </div>

        <div class="divider" />

        <div class="illustration-area">
          <img class="menino-img" :style="parallax(1.0,-3,2)" src="/src/assets/images/menino-com-gato.png" alt="Pequeno Príncipe" />
        </div>

        <div class="rsvp-section">
          <a
            class="rsvp-btn"
            href="https://wa.me/556285800309"
            target="_blank"
            rel="noopener noreferrer"
          >
            <span class="rsvp-icon">💌</span>Chamar no WhatsApp<span class="rsvp-icon">💌</span>
          </a>
        </div>

        <div class="card-shine" :style="shineStyle" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const mouseX  = ref(0)
const mouseY  = ref(0)
const ticking = ref(false)

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

const sceneStyle = computed(() => ({
  transform: `rotateX(${-mouseY.value * 4}deg) rotateY(${mouseX.value * 4}deg)`,
  transition: 'transform 0.12s ease-out',
}))

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
</script>

<style scoped>
.lost-wrapper {
  position: fixed;
  inset: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px 14px;
  perspective: 1200px;
  perspective-origin: 50% 50%;
}

.lost-scene {
  width: 100%;
  max-width: 430px;
}

.lost-card {
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
  padding-bottom: 16px;
  animation: lost-reveal 1s cubic-bezier(.16,1,.3,1) both;
}

@keyframes lost-reveal {
  from { opacity: 0; transform: translateY(60px) scale(.92); filter: blur(8px); }
  to   { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); }
}

.lost-card-bg {
  position: absolute; inset: 0; pointer-events: none;
  background:
    radial-gradient(ellipse at 20% 10%, rgba(212,168,83,.06) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 90%, rgba(180,210,240,.08) 0%, transparent 50%);
}

.card-shine {
  position: absolute; inset: 0; pointer-events: none; border-radius: 24px;
}

.deco { position: absolute; pointer-events: none; will-change: transform; transition: transform .1s ease-out; }
.deco-planet  { width: 88px; top: -20px; left: -16px; animation: float-gentle 4s .5s ease-in-out infinite alternate; z-index: 5; }
.deco-star    { z-index: 5; }
.deco-star-1  { width: 54px; top: 10px; right: 10px; animation: float-gentle 3.5s ease-in-out infinite alternate; }
.deco-star-2  { width: 30px; top: 130px; right: 28px; animation: float-gentle 4.5s 1s ease-in-out infinite alternate; opacity: .7; }
.deco-cloud   { z-index: 3; opacity: .85; }
.deco-cloud-1 { width: 110px; top: 115px; right: -18px; animation: float-gentle 5s .3s ease-in-out infinite alternate; }
.deco-cloud-2 { width: 80px; top: 200px; left: -14px; animation: float-gentle 4.2s 1.5s ease-in-out infinite alternate; }
.deco-cloud-3 { width: 100px; bottom: 180px; right: -10px; animation: float-gentle 4.8s .8s ease-in-out infinite alternate; }

@keyframes float-gentle {
  0%   { transform: translateY(0) rotate(-1deg); }
  100% { transform: translateY(-10px) rotate(1deg); }
}

.crown-area  { display: flex; align-items: center; justify-content: center; gap: 8px; padding: 8px 20px 0; position: relative; z-index: 6; }
.crown-img   { width: 24px; opacity: .7; }
.crown-emoji { font-size: 30px; filter: drop-shadow(0 4px 16px rgba(212,168,83,.6)); animation: crown-bounce 2.5s ease-in-out infinite; }
@keyframes crown-bounce {
  0%, 100% { transform: translateY(0) rotate(-3deg); }
  50%      { transform: translateY(-12px) rotate(3deg); }
}

.oval-frame {
  position: relative; margin: 0 24px; padding: 6px 16px 10px;
  border: 2px solid rgba(212,168,83,.5); border-radius: 50%/40%;
  background: rgba(255,255,255,.2); z-index: 6;
}
.oval-frame::before {
  content: ''; position: absolute; inset: 4px;
  border: 1px solid rgba(212,168,83,.25); border-radius: 50%/40%; pointer-events: none;
}

.title-section { text-align: center; }
.cha-do           { font-family: 'Playfair Display', serif; font-size: 15px; color: #2c3e6b; letter-spacing: 2px; }
.pequeno-principe { font-family: 'Playfair Display', serif; font-style: italic; font-size: 18px; color: #2c3e6b; }
.nome-lorenzo     { font-family: 'Dancing Script', cursive; font-size: 48px; font-weight: 700; color: #1a2744; line-height: 1; text-shadow: 0 2px 12px rgba(44,62,107,.2); letter-spacing: -1px; }

.ornament      { display: flex; align-items: center; justify-content: center; gap: 12px; margin-top: 2px; }
.ornament-line { display: block; width: 50px; height: 1px; background: linear-gradient(90deg, transparent, #d4a853, transparent); }
.heart-icon    { font-size: 16px; }

.mensagem { text-align: center; padding: 14px 22px 8px; position: relative; z-index: 6; }
.mensagem p:first-child { font-family: 'Playfair Display', serif; font-weight: 600; font-size: 16px; color: #2c3e6b; margin-bottom: 8px; }
.mensagem p:last-child  { font-family: 'Lato', sans-serif; font-size: 13px; color: #4a5a7a; line-height: 1.6; }

.divider { height: 1px; background: linear-gradient(90deg, transparent, rgba(212,168,83,.4), transparent); margin: 4px 24px 6px; }

.illustration-area { position: relative; z-index: 6; display: flex; justify-content: center; margin-top: 8px; pointer-events: none; }
.menino-img {
  width: 55%; max-width: 180px; object-fit: contain;
  will-change: transform; transition: transform .15s ease-out;
  animation: float-hero 4s ease-in-out infinite alternate;
  filter: drop-shadow(0 12px 24px rgba(44,62,107,.18));
}
@keyframes float-hero {
  0%   { transform: translateY(0); }
  100% { transform: translateY(-14px); }
}

.rsvp-section { text-align: center; padding: 8px 24px 6px; position: relative; z-index: 6; }
.rsvp-btn {
  display: inline-flex; align-items: center; gap: 10px;
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853; text-decoration: none; border-radius: 50px; padding: 14px 32px;
  font-family: 'Playfair Display', serif; font-size: 16px; font-weight: 600; letter-spacing: .5px;
  width: 100%; justify-content: center;
  box-shadow: 0 8px 30px rgba(44,62,107,.4), 0 0 0 1px rgba(212,168,83,.3), inset 0 1px 0 rgba(255,255,255,.1);
  transition: all .3s cubic-bezier(.34,1.56,.64,1);
}
.rsvp-btn:hover, .rsvp-btn:active {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 16px 40px rgba(44,62,107,.5), 0 0 0 1px rgba(212,168,83,.5), 0 0 30px rgba(212,168,83,.2);
}
.rsvp-icon { font-size: 16px; }
</style>
