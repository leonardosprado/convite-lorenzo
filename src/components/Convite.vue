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
          <img class="crown-open" src="../assets/images/coroa.png" alt="Coroa" />
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
            :style="flipContainerStyle"
          >

            <!-- ═══ FRENTE ═══ -->
            <div v-show="!isFlipped" ref="frontRef" class="card flip-front paper">
              <div class="card-bg" />

              <!-- Decorações flutuantes -->
              <img class="deco deco-planet"   :style="parallax(0.8,-12,-8)" src="../assets/images/planeta.png" alt="" />
              <img class="deco deco-star deco-star-1" :style="parallax(1.2, 8, 5)" src="../assets/images/estrela.png" alt="" />
              <img class="deco deco-star deco-star-2" :style="parallax(0.6,-5,10)" src="../assets/images/estrela.png" alt="" />
              <img class="deco deco-cloud deco-cloud-1" :style="parallax(0.5, 5,-5)" src="../assets/images/nuvem.png" alt="" />
              <img class="deco deco-cloud deco-cloud-2" :style="parallax(0.4,-8, 8)" src="../assets/images/nuvem.png" alt="" />
              <img class="deco deco-cloud deco-cloud-3" :style="parallax(0.7, 6,-3)" src="../assets/images/nuvem.png" alt="" />

              <!-- Coroa -->
              <div class="crown-area">
                <img class="crown-img" src="../assets/images/estrela.png" alt="" />
                <img class="crown-main" src="../assets/images/coroa.png" alt="Coroa" />
                <img class="crown-img" src="../assets/images/estrela.png" alt="" />
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

              <!-- Nome do convidado -->
              <div v-if="convidadoNome" class="guest-hero">
                <p class="convidado-para-label">para</p>
                <p class="guest-hero-nome">{{ convidadoNome }}</p>
                <span class="guest-hero-heart">💛</span>
              </div>

              <!-- Dois cards: presente + evento -->
              <div class="info-cards">
                <div class="info-card info-card-presente">
                  <div class="info-card-icon">
                    <Gift :size="20" :stroke-width="1.75" />
                  </div>
                  <p class="info-card-kicker">Sugestão de presente</p>
                  <template v-if="fraldaTamanho">
                    <p class="info-card-title">Fralda tamanho {{ fraldaTamanho }}</p>
                    <p v-if="marcasLinha" class="info-card-brands">{{ marcasLinha }}</p>
                    <button
                      v-if="temMaisMarcas"
                      type="button"
                      class="info-card-more"
                      @click.stop="toggleFraldasExpandidas"
                    >
                      {{ fraldasExpandidas ? 'Ver menos' : 'Ver mais marcas' }}
                    </button>
                  </template>
                  <p v-else class="info-card-brands">Sua presença é o melhor presente</p>
                </div>

                <div class="info-card info-card-evento">
                  <div class="info-card-row">
                    <div class="info-chip">
                      <Calendar :size="15" :stroke-width="1.75" class="info-chip-ico" />
                      <span>26/09/2026</span>
                    </div>
                    <span class="info-chip-sep" />
                    <div class="info-chip">
                      <Clock :size="15" :stroke-width="1.75" class="info-chip-ico" />
                      <span>16h00</span>
                    </div>
                  </div>
                  <div class="info-card-dotline" />
                  <div class="info-card-local">
                    <MapPin :size="15" :stroke-width="1.75" class="info-chip-ico info-chip-ico-pin" />
                    <div>
                      <p class="info-local-nome">Salão de festas do condomínio</p>
                      <p class="info-local-end">Travessa Ita, 53<br />Condomínio Eldorado Parque Tijuca</p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Ilustração -->
              <div class="illustration-area">
                <img class="menino-img" :style="parallax(1.0,-3,2)" src="../assets/images/menino-com-gato.png" alt="Pequeno Príncipe" />
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
                  <div class="hub-actions hub-actions-inline">
                    <button type="button" class="hub-btn hub-btn-presentes" @click.stop="abrirPresentesModal">
                      <Gift :size="16" :stroke-width="2" />
                      Presentes
                    </button>
                    <button type="button" class="hub-btn hub-btn-mimos" @click.stop="abrirMimosModal">
                      <Sparkles :size="16" :stroke-width="2" />
                      Mimos
                    </button>
                  </div>
                  <a
                    class="btn-localizacao"
                    :href="MAPS_URL"
                    target="_blank"
                    rel="noopener noreferrer"
                    @click.stop
                  >
                    <MapPin :size="16" :stroke-width="2" />
                    Ver localização no mapa
                  </a>
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
            <div v-show="isFlipped" ref="backRef" class="card flip-back paper">

              <!-- Mesmo fundo creme -->
              <div class="card-bg" />

              <!-- Decorações em watermark -->
              <img class="deco deco-planet  wm" src="../assets/images/planeta.png" alt="" />
              <img class="deco deco-cloud deco-cloud-1 wm" src="../assets/images/nuvem.png" alt="" />
              <img class="deco deco-cloud deco-cloud-3 wm" src="../assets/images/nuvem.png" alt="" />
              <img class="deco deco-star deco-star-1 wm" src="../assets/images/estrela.png" alt="" />

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
                  <div class="hub-actions hub-actions-inline">
                    <button type="button" class="hub-btn hub-btn-presentes" @click.stop="abrirPresentesModal">
                      <Gift :size="16" :stroke-width="2" />
                      Presentes
                    </button>
                    <button type="button" class="hub-btn hub-btn-mimos" @click.stop="abrirMimosModal">
                      <Sparkles :size="16" :stroke-width="2" />
                      Mimos
                    </button>
                  </div>
                  <a
                    class="btn-localizacao"
                    :href="MAPS_URL"
                    target="_blank"
                    rel="noopener noreferrer"
                    @click.stop
                  >
                    <MapPin :size="16" :stroke-width="2" />
                    Ver localização no mapa
                  </a>
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
        <div class="modal-card paper">
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

    <!-- Modal pós-confirmação (hub) -->
    <Transition name="modal">
      <div v-if="showConfirmadoModal" class="modal-overlay" @click.self="fecharConfirmadoModal">
        <div class="modal-card modal-presente paper">
          <button class="modal-close" @click="fecharConfirmadoModal">✕</button>
          <div class="modal-crown">🎉</div>
          <h2 class="modal-title">Presença confirmada!</h2>
          <p class="modal-subtitle">
            <template v-if="convidadoNome">Obrigado, {{ convidadoNome }}!<br /></template>
            Mal podemos esperar para te ver.
          </p>

          <!-- Sugestão de presente com tamanho + CTA marcas -->
          <button
            v-if="fraldaTamanho"
            type="button"
            class="hub-presente-card"
            @click="abrirPresentesModal"
          >
            <div class="hub-presente-top">
              <span class="hub-presente-ico">
                <Gift :size="20" :stroke-width="1.75" />
              </span>
              <span class="hub-presente-kicker">Sugestão de presente</span>
            </div>
            <p class="hub-presente-tamanho">Fralda tamanho {{ fraldaTamanho }}</p>
            <span class="hub-presente-cta">
              Ver marcas sugeridas
              <span class="hub-presente-arrow">→</span>
            </span>
          </button>

          <div v-else class="info-card info-card-presente modal-presente-card">
            <p class="info-card-brands">Sua presença é o melhor presente</p>
          </div>

          <button type="button" class="hub-btn hub-btn-mimos hub-btn-mimos-full" @click="abrirMimosModal">
            <Sparkles :size="18" :stroke-width="2" />
            Ver mimos
          </button>

          <a
            class="btn-localizacao btn-localizacao-modal"
            :href="MAPS_URL"
            target="_blank"
            rel="noopener noreferrer"
          >
            <MapPin :size="16" :stroke-width="2" />
            Ver localização no mapa
          </a>
        </div>
      </div>
    </Transition>

    <!-- Modal Presentes (fraldas) -->
    <Transition name="modal">
      <div v-if="showPresentesModal" class="modal-overlay" @click.self="fecharPresentesModal">
        <div class="modal-card modal-presente paper">
          <button class="modal-close" @click="fecharPresentesModal">✕</button>
          <div class="modal-crown">
            <Gift :size="36" :stroke-width="1.5" color="#d4a853" />
          </div>
          <h2 class="modal-title">Presentes</h2>
          <p class="modal-subtitle">Sugestão de fraldinhas pro Lorenzo</p>

          <div class="info-card info-card-presente modal-presente-card">
            <template v-if="fraldaTamanho">
              <p class="info-card-title">Fralda tamanho {{ fraldaTamanho }}</p>
              <p class="info-card-brands">Sugestão de marcas</p>
            </template>
            <p v-else class="info-card-brands">Sua presença é o melhor presente</p>
          </div>

          <div v-if="presentesComFoto.length" class="mimos-grid">
            <article v-for="m in presentesComFoto" :key="m.id" class="mimo-card">
              <div class="mimo-foto-wrap">
                <img :src="m.src" :alt="m.label" class="mimo-foto" loading="lazy" />
              </div>
              <p class="mimo-nome">{{ m.label }}</p>
            </article>
          </div>

          <button type="button" class="btn-voltar-hub" @click="voltarAoHub('presentes')">
            ← Voltar
          </button>
        </div>
      </div>
    </Transition>

    <!-- Modal Mimos -->
    <Transition name="modal">
      <div v-if="showMimosModal" class="modal-overlay" @click.self="fecharMimosModal">
        <div class="modal-card modal-presente paper">
          <button class="modal-close" @click="fecharMimosModal">✕</button>
          <div class="modal-crown">
            <Sparkles :size="36" :stroke-width="1.5" color="#d4a853" />
          </div>
          <h2 class="modal-title">Mimos</h2>
          <p class="modal-subtitle">Ideias de carinho pro dia a dia do bebê</p>

          <ul class="mimos-lista-itens">
            <li v-for="item in LISTA_MIMOS" :key="item">
              <span class="mimo-bullet">✦</span>
              <span>{{ item }}</span>
            </li>
          </ul>

          <button type="button" class="btn-voltar-hub" @click="voltarAoHub('mimos')">
            ← Voltar
          </button>
        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { Gift, Calendar, Clock, MapPin, Sparkles } from '@lucide/vue'
import { supabase } from '../supabase.js'
import ConviteNaoEncontrado from './ConviteNaoEncontrado.vue'

import fotoBabySec from '../assets/fraldas/BabySec Premium Shortinho.png'
import fotoMamyPoko from '../assets/fraldas/MamyPoko Calça Dia & Noite.png'
import fotoPampers from '../assets/fraldas/Pampers Premium Care.webp'

const LISTA_MIMOS = [
  'Lenço umedecido sem álcool',
  'Shampoo para recém-nascido',
  'Condicionador',
  'Sabonete líquido para recém-nascido',
  'Pomada para assadura',
  'Óleo de bebê',
  'Toalha de banho com capuz',
  'Body / macacão RN',
  'Meias e luvinhas',
  'Escova de cabelo macia',
]

/** Fotos locais ↔ nomes do catálogo (match flexível pelo nome no banco) */
const FRALDA_FOTOS = [
  {
    id: 'babysec',
    label: 'BabySec Premium Shortinho',
    src: fotoBabySec,
    match: /baby\s*sec/i,
  },
  {
    id: 'mamypoko',
    label: 'MamyPoko Dia & Noite',
    src: fotoMamyPoko,
    match: /mamy\s*poko/i,
  },
  {
    id: 'pampers',
    label: 'Pampers Premium Care',
    src: fotoPampers,
    match: /pampers/i,
  },
]

function resolverFraldaFoto(nome) {
  if (!nome) return null
  return FRALDA_FOTOS.find(f => f.match.test(nome)) || null
}

// ── convidado via URL (?convidado=uuid) ────────────────────────
const MAPS_URL = 'https://www.google.com/maps?q=-16.693334579467773,-49.32759475708008&z=17&hl=pt-BR'
const convidadoId       = new URLSearchParams(window.location.search).get('convidado')
const convidadoNome     = ref('')
const fraldaTamanho     = ref('')
const marcasFralda        = ref([])
const marcasSorteadas     = ref([])
const fraldasExpandidas   = ref(false)
const buscandoConvidado = ref(true)
const convidadoOk       = ref(false)

function sortearMarcas(lista, qtd = 3) {
  const copia = [...lista]
  for (let i = copia.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[copia[i], copia[j]] = [copia[j], copia[i]]
  }
  return copia.slice(0, Math.min(qtd, copia.length))
}

const marcasVisiveis = computed(() =>
  fraldasExpandidas.value ? marcasFralda.value : marcasSorteadas.value
)

const temMaisMarcas = computed(() => marcasFralda.value.length > 3)

const marcasCurtas = computed(() => {
  const abrev = {
    'MamyPoko Fralda Calça Super Proteção': 'MamyPoko',
    'MamyPoko Fralda Calça Dia & Noite': 'MamyPoko',
    'MamyPoko Calça Dia & Noite': 'MamyPoko',
    'Pampers Confort Sec': 'Pampers',
    'Pampers Premium Care': 'Pampers',
    'Pampers': 'Pampers',
    'Babysec Premium': 'BabySec',
    'BabySec Premium Shortinho': 'BabySec',
  }
  const lista = marcasVisiveis.value.map(m => {
    const foto = resolverFraldaFoto(m)
    return abrev[m] || foto?.label?.split(' ')[0] || m
  })
  return [...new Set(lista)]
})

const marcasLinha = computed(() => marcasCurtas.value.join(' • '))

/** Marcas únicas com foto para a modal de presentes */
const presentesComFoto = computed(() => {
  const seen = new Set()
  const out = []
  const nomes = marcasFralda.value.length
    ? marcasFralda.value
    : FRALDA_FOTOS.map(f => f.label)

  for (const nome of nomes) {
    const item = resolverFraldaFoto(nome)
    if (!item || seen.has(item.id)) continue
    seen.add(item.id)
    out.push(item)
  }
  return out
})

function abrirConfirmadoModal() {
  showMimosModal.value = false
  showPresentesModal.value = false
  showConfirmadoModal.value = true
}

function fecharConfirmadoModal() {
  showConfirmadoModal.value = false
}

function abrirPresentesModal() {
  showConfirmadoModal.value = false
  showMimosModal.value = false
  showPresentesModal.value = true
}

function fecharPresentesModal() {
  showPresentesModal.value = false
}

function abrirMimosModal() {
  showConfirmadoModal.value = false
  showPresentesModal.value = false
  showMimosModal.value = true
}

function fecharMimosModal() {
  showMimosModal.value = false
}

function voltarAoHub(de) {
  if (de === 'presentes') showPresentesModal.value = false
  if (de === 'mimos') showMimosModal.value = false
  showConfirmadoModal.value = true
}

function toggleFraldasExpandidas() {
  fraldasExpandidas.value = !fraldasExpandidas.value
}

async function carregarMarcasFralda() {
  const { data } = await supabase
    .from('fraldas')
    .select('nome')
    .order('nome')
  const nomes = (data || []).map(f => f.nome)
  marcasFralda.value = nomes
  marcasSorteadas.value = sortearMarcas(nomes, 3)
}

// ── estado básico ──────────────────────────────────────────────
const opened              = ref(false)
const showRsvp            = ref(false)
const showConfirmadoModal = ref(false)
const showPresentesModal  = ref(false)
const showMimosModal      = ref(false)
const rsvpSent            = ref(false)
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
  if (rsvpSent.value) abrirConfirmadoModal()
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

function wait(ms) { return new Promise(r => setTimeout(r, ms)) }

function medirAlturaFrente() {
  if (!frontRef.value) return null
  return frontRef.value.scrollHeight
}

function travarAlturaParaFlip() {
  const h = medirAlturaFrente()
  if (h) containerHeight.value = h + 'px'
}

function soltarAltura() {
  containerHeight.value = 'auto'
}

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

const flipContainerStyle = computed(() => ({
  height: containerHeight.value,
  ...flipCardStyle.value,
}))

async function startFlip() {
  if (isFlipping.value) return
  isFlipping.value = true
  travarAlturaParaFlip()

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
  travarAlturaParaFlip()

  flipPhase.value = 'out'
  await wait(380)

  isFlipped.value = false
  rsvpSent.value = false
  Object.assign(rsvpForm, { nome: '', whatsapp: '', pessoas: '1' })

  flipPhase.value = 'in'
  await wait(380)

  flipPhase.value = ''
  isFlipping.value = false
  soltarAltura()
}
// ── RSVP modal (modo 1) ───────────────────────────────────────
function onRsvp() { showRsvp.value = true }

async function submitRsvpDireto() {
  await confirmarNoSupabase()
  rsvpSent.value = true
  abrirConfirmadoModal()
}

async function submitRsvp() {
  await confirmarNoSupabase()
  rsvpSent.value = true
  showRsvp.value = false
  abrirConfirmadoModal()
}

// ── RSVP flip (modo 2) ────────────────────────────────────────
async function submitFlipRsvp() {
  await confirmarNoSupabase()
  rsvpSent.value = true
  abrirConfirmadoModal()
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

// ── init: carrega convidado ───────────────────────────────────
onMounted(async () => {
  if (convidadoId) {
    const [{ data }, ] = await Promise.all([
      supabase
        .from('convidados')
        .select('nome, tamanho_fralda, confirmado')
        .eq('id', convidadoId)
        .single(),
      carregarMarcasFralda(),
    ])
    if (data) {
      convidadoNome.value = data.nome
      fraldaTamanho.value = data.tamanho_fralda || ''
      rsvpForm.nome = data.nome
      if (data.confirmado) rsvpSent.value = true
      convidadoOk.value = true
    }
  }
  buscandoConvidado.value = false

  if (!convidadoOk.value) return

  const last = Number(localStorage.getItem(OPEN_KEY) || 0)
  if (Date.now() - last < OPEN_TTL) {
    opened.value = true
    if (rsvpSent.value) abrirConfirmadoModal()
  }
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
.crown-open  {
  width: 72px;
  height: auto;
  display: block;
  margin: 0 auto 12px;
  animation: crown-bounce 1.8s ease-in-out infinite;
  filter: drop-shadow(0 0 24px rgba(212,168,83,.8));
}
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
  margin-top: auto;
  margin-bottom: auto;
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
  /* height: auto no dia a dia; só trava em px durante o flip */
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
.guest-hero {
  text-align: center;
  padding: 4px 20px 2px;
  position: relative;
  z-index: 6;
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
.guest-hero-nome {
  margin: 0;
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 22px;
  font-weight: 600;
  color: #1a2744;
  line-height: 1.2;
}
.guest-hero-heart {
  display: block;
  font-size: 12px;
  margin-top: 2px;
}

.info-cards {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  padding: 8px 16px 4px;
  position: relative;
  z-index: 6;
}
.info-card {
  background: rgba(255,255,255,.34);
  border: 1.5px solid rgba(212,168,83,.45);
  border-radius: 16px;
  padding: 12px 10px 11px;
  text-align: center;
}
.info-card-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 4px;
  color: #d4a853;
}
.info-chip-ico {
  color: #d4a853;
  flex-shrink: 0;
}
.info-chip-ico-pin {
  margin-top: 1px;
}
.info-card-kicker {
  margin: 0 0 6px;
  font-family: 'Playfair Display', serif;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 1.2px;
  text-transform: uppercase;
  color: #d4a853;
}
.info-card-title {
  margin: 0 0 4px;
  font-family: 'Playfair Display', serif;
  font-size: 13px;
  font-weight: 700;
  color: #1a2744;
  line-height: 1.25;
  text-transform: uppercase;
  letter-spacing: .3px;
}
.info-card-brands {
  margin: 0;
  font-family: 'Playfair Display', serif;
  font-size: 11px;
  color: #4a5a7a;
  line-height: 1.4;
}
.info-card-more {
  margin-top: 6px;
  background: none;
  border: none;
  font-family: 'Lato', sans-serif;
  font-size: 10px;
  font-weight: 600;
  color: #d4a853;
  cursor: pointer;
  padding: 0;
}
.info-card-evento {
  text-align: left;
  display: flex;
  flex-direction: column;
  gap: 8px;
  justify-content: center;
}
.info-card-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 6px;
}
.info-chip {
  display: flex;
  align-items: center;
  gap: 4px;
  font-family: 'Lato', sans-serif;
  font-size: 11px;
  font-weight: 700;
  color: #1a2744;
}
.info-chip-sep {
  width: 1px;
  height: 16px;
  background: rgba(212,168,83,.45);
  flex-shrink: 0;
}
.info-card-dotline {
  border-top: 1px dashed rgba(212,168,83,.45);
}
.info-card-local {
  display: flex;
  align-items: flex-start;
  gap: 6px;
}
.info-local-nome {
  margin: 0 0 2px;
  font-family: 'Playfair Display', serif;
  font-size: 11.5px;
  font-weight: 700;
  color: #1a2744;
  line-height: 1.25;
}
.info-local-end {
  margin: 0;
  font-family: 'Lato', sans-serif;
  font-size: 10px;
  color: #4a5a7a;
  line-height: 1.35;
}

@media (max-width: 420px) {
  .info-cards { grid-template-columns: 1fr; gap: 8px; }
}

.crown-area  { display:flex; align-items:center; justify-content:center; gap:8px; padding:8px 20px 0; position:relative; z-index:6; }
.crown-img   { width:24px; opacity:.7; }
.crown-main  {
  width: 42px;
  height: auto;
  filter: drop-shadow(0 4px 16px rgba(212,168,83,.6));
  animation: crown-bounce 2.5s ease-in-out infinite;
}

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
.rsvp-confirmed-msg { font-family:'Playfair Display',serif; font-size:15px; color:#2c3e6b; text-align:center; padding:10px 0 4px; line-height:1.5; animation:success-pop .5s cubic-bezier(.34,1.56,.64,1) both; }
.btn-localizacao {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  width: 100%;
  margin: 8px 0 4px;
  padding: 11px 16px;
  border-radius: 50px;
  border: 1.5px solid rgba(212,168,83,.55);
  background: linear-gradient(135deg, rgba(212,168,83,.18), rgba(212,168,83,.08));
  color: #1a2744;
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  font-weight: 700;
  text-decoration: none;
  letter-spacing: .3px;
  box-shadow: 0 4px 14px rgba(212,168,83,.2);
  transition: all .25s ease;
}
.btn-localizacao:hover {
  background: linear-gradient(135deg, rgba(212,168,83,.3), rgba(212,168,83,.12));
  border-color: #d4a853;
  transform: translateY(-1px);
}
.btn-localizacao :deep(svg) {
  color: #d4a853;
}
.rsvp-cancelar { display:block; margin:4px auto 0; background:none; border:none; font-family:'Lato',sans-serif; font-size:11px; color:rgba(44,62,107,.3); cursor:pointer; letter-spacing:.5px; text-decoration:underline; padding:2px; transition:color .2s; }
.rsvp-cancelar:hover { color:rgba(44,62,107,.6); }
@keyframes success-pop { from{opacity:0;transform:scale(.85)} to{opacity:1;transform:scale(1)} }

.presente-box {
  margin: 8px 0 6px;
  padding: 14px 16px 12px;
  border-radius: 16px;
  background: linear-gradient(160deg, rgba(212,168,83,.2), rgba(212,168,83,.07));
  border: 1.5px solid rgba(212,168,83,.55);
  box-shadow: 0 0 24px rgba(212,168,83,.2);
  animation: success-pop .55s cubic-bezier(.34,1.56,.64,1) both;
}
.presente-kicker {
  font-family: 'Lato', sans-serif;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #d4a853;
  margin: 0 0 6px;
}

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

.modal-presente {
  padding-bottom: 36px;
  max-height: min(92dvh, 720px);
  overflow-y: auto;
}
.modal-presente-card {
  margin: 0 0 12px;
  text-align: center;
}
.hub-presente-card {
  display: block;
  width: 100%;
  margin: 0 0 12px;
  padding: 16px 14px 14px;
  text-align: center;
  border: none;
  border-radius: 18px;
  background: linear-gradient(160deg, rgba(255,255,255,.85), rgba(245,236,212,.9));
  border: 1.5px solid rgba(212,168,83,.55);
  box-shadow: 0 8px 24px rgba(44,62,107,.1), 0 0 0 1px rgba(212,168,83,.12);
  cursor: pointer;
  transition: transform .2s ease, box-shadow .2s ease, border-color .2s;
}
.hub-presente-card:hover,
.hub-presente-card:active {
  transform: translateY(-2px);
  border-color: #d4a853;
  box-shadow: 0 12px 28px rgba(44,62,107,.16), 0 0 0 1px rgba(212,168,83,.25);
}
.hub-presente-top {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 6px;
}
.hub-presente-ico {
  display: inline-flex;
  color: #d4a853;
}
.hub-presente-kicker {
  font-family: 'Playfair Display', serif;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.2px;
  text-transform: uppercase;
  color: #d4a853;
}
.hub-presente-tamanho {
  margin: 0 0 12px;
  font-family: 'Playfair Display', serif;
  font-size: 22px;
  font-weight: 700;
  color: #1a2744;
  letter-spacing: .2px;
}
.hub-presente-cta {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 9px 16px;
  border-radius: 50px;
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853;
  font-family: 'Lato', sans-serif;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: .3px;
  box-shadow: 0 6px 16px rgba(44,62,107,.28);
}
.hub-presente-arrow {
  transition: transform .2s ease;
}
.hub-presente-card:hover .hub-presente-arrow,
.hub-presente-card:active .hub-presente-arrow {
  transform: translateX(3px);
}
.hub-hint {
  margin: 0 0 12px;
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: #4a5a7a;
  text-align: center;
}
.hub-actions {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  margin: 0 0 16px;
}
.hub-actions-inline {
  margin: 8px 0 10px;
}
.hub-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 13px 12px;
  border-radius: 50px;
  border: none;
  font-family: 'Playfair Display', serif;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: transform .2s ease, box-shadow .2s ease;
}
.hub-btn:active { transform: translateY(-1px) scale(1.01); }
.hub-btn-presentes {
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853;
  box-shadow: 0 8px 22px rgba(44,62,107,.3), 0 0 0 1px rgba(212,168,83,.28);
}
.hub-btn-presentes :deep(svg) { color: #d4a853; }
.hub-btn-mimos {
  background: linear-gradient(135deg, #f5ecd4 0%, #efe3c2 100%);
  color: #1a2744;
  box-shadow: 0 6px 18px rgba(212,168,83,.25), 0 0 0 1.5px rgba(212,168,83,.5);
}
.hub-btn-mimos :deep(svg) { color: #c9962e; }
.hub-btn-mimos-full {
  width: 100%;
  margin: 0 0 14px;
}
.mimos-lista-itens {
  list-style: none;
  margin: 0 0 16px;
  padding: 6px 4px 2px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.mimos-lista-itens li {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 11px 12px;
  border-radius: 12px;
  background: rgba(255,255,255,.65);
  border: 1.5px solid rgba(212,168,83,.35);
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: #1a2744;
  line-height: 1.35;
}
.mimo-bullet {
  color: #d4a853;
  flex-shrink: 0;
  margin-top: 1px;
}
.btn-voltar-hub {
  display: block;
  width: 100%;
  margin: 0 0 4px;
  padding: 11px;
  border-radius: 50px;
  border: 1.5px solid rgba(44,62,107,.2);
  background: transparent;
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: rgba(44,62,107,.65);
  cursor: pointer;
  transition: border-color .2s, color .2s, background .2s;
}
.btn-voltar-hub:hover,
.btn-voltar-hub:active {
  border-color: rgba(212,168,83,.55);
  color: #c9962e;
  background: rgba(212,168,83,.06);
}
.mimos-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  margin: 0 0 16px;
}
.mimo-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 8px 6px 10px;
  border-radius: 14px;
  background: rgba(255,255,255,.72);
  border: 1.5px solid rgba(212,168,83,.45);
  box-shadow: 0 6px 18px rgba(44,62,107,.08);
  animation: success-pop .55s cubic-bezier(.34,1.56,.64,1) both;
}
.mimo-card:nth-child(2) { animation-delay: .06s; }
.mimo-card:nth-child(3) { animation-delay: .12s; }
.mimo-foto-wrap {
  width: 100%;
  aspect-ratio: 3 / 4;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 10px;
  background:
    radial-gradient(ellipse at 50% 30%, rgba(212,168,83,.12), transparent 70%),
    #f7f1e4;
  overflow: hidden;
}
.mimo-foto {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 4px;
  filter: drop-shadow(0 4px 10px rgba(26,39,68,.18));
}
.mimo-nome {
  margin: 0;
  font-family: 'Lato', sans-serif;
  font-size: 10px;
  font-weight: 700;
  line-height: 1.25;
  text-align: center;
  color: #1a2744;
  letter-spacing: .2px;
}
.btn-localizacao-modal {
  margin-top: 4px;
}

@media (max-width: 360px) {
  .mimos-grid { gap: 6px; }
  .mimo-nome { font-size: 9px; }
}

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
