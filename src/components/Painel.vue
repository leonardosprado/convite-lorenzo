<template>
  <div class="painel-root">

    <!-- LOGIN -->
    <div v-if="!session" class="login-wrap">
      <div class="login-card">
        <div class="login-crown">👑</div>
        <h1 class="login-title">Painel Lorenzo</h1>
        <p class="login-sub">Acesso restrito aos organizadores</p>
        <form class="login-form" @submit.prevent="doLogin">
          <div class="f-group">
            <label>E-mail</label>
            <input v-model="loginForm.email" type="email" placeholder="seu@email.com" required />
          </div>
          <div class="f-group">
            <label>Senha</label>
            <input v-model="loginForm.senha" type="password" placeholder="••••••••" required />
          </div>
          <p v-if="loginError" class="login-error">{{ loginError }}</p>
          <button type="submit" class="btn-primary" :disabled="loginLoading">
            {{ loginLoading ? 'Entrando...' : 'Entrar' }}
          </button>
        </form>
      </div>
    </div>

    <!-- PAINEL PRINCIPAL -->
    <div v-else class="painel-inner">

      <!-- Header -->
      <header class="painel-header">
        <div class="header-left">
          <span class="header-crown">👑</span>
          <div>
            <div class="header-title">Chá do Lorenzo</div>
            <div class="header-sub">Gestão de convidados</div>
          </div>
        </div>
        <button class="btn-logout" @click="doLogout">Sair</button>
      </header>

      <!-- Resumo -->
      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-value">{{ convidados.length }}</div>
          <div class="stat-label">Convidados</div>
        </div>
        <div class="stat-card stat-confirmed">
          <div class="stat-value">{{ confirmados }}</div>
          <div class="stat-label">Confirmados</div>
        </div>
        <div class="stat-card">
          <div class="stat-value">{{ totalPessoas }}</div>
          <div class="stat-label">Pessoas esperadas</div>
        </div>
        <div class="stat-card stat-confirmed">
          <div class="stat-value">{{ pessoasConfirmadas }}</div>
          <div class="stat-label">Pessoas confirmadas</div>
        </div>
      </div>

      <!-- Ações -->
      <div class="actions-row">
        <input v-model="busca" class="input-busca" placeholder="🔍  Buscar convidado..." />
        <button class="btn-primary btn-sm" @click="showAddModal = true">+ Adicionar</button>
        <button class="btn-outline btn-sm" @click="showFraldasModal = true">Fraldas</button>
        <button
          class="btn-outline btn-sm"
          :class="{ 'btn-fraldas-bulk-active': editarTodasFraldas }"
          @click="toggleEditarTodasFraldas"
        >
          {{ editarTodasFraldas ? '✓ Concluir fraldas' : 'Editar todas fraldas' }}
        </button>
        <button class="btn-outline btn-sm" @click="exportarLinks">Exportar links</button>
      </div>

      <!-- Tabela -->
      <div class="table-wrap">
        <table class="convidados-table">
          <thead>
            <tr>
              <th>Nome</th>
              <th>Peso</th>
              <th>Fralda</th>
              <th>Confirmado</th>
              <th>Link</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="c in convidadosFiltrados" :key="c.id" :class="{ confirmed: c.confirmado }">
              <td class="td-nome">
                <span class="nome-badge" :class="{ 'nome-confirmed': c.confirmado }">{{ c.nome }}</span>
                <span v-if="c.whatsapp" class="td-zap">📱 {{ c.whatsapp }}</span>
              </td>
              <td class="td-peso">{{ c.peso }} pess.</td>
              <td class="td-fralda" :class="{ 'td-fralda-bulk': editarTodasFraldas }">
                <div class="fralda-cell" :class="{ 'fralda-cell-bulk': editarTodasFraldas }">
                  <template v-if="editarTodasFraldas">
                    <span v-if="c.fralda" class="fralda-atual">{{ c.fralda }}</span>
                    <span v-else class="td-empty">Sem fralda</span>
                    <div v-if="fraldas.length" class="fralda-atalhos">
                      <button
                        v-for="f in fraldas"
                        :key="f.id"
                        type="button"
                        class="fralda-chip"
                        :class="{ active: c.fralda === labelFralda(f) }"
                        :title="labelFralda(f)"
                        @click="vincularFralda(c, labelFralda(f))"
                      >
                        {{ chipFralda(f) }}
                      </button>
                      <button
                        v-if="c.fralda"
                        type="button"
                        class="fralda-chip fralda-chip-clear"
                        title="Remover fralda"
                        @click="vincularFralda(c, null)"
                      >
                        limpar
                      </button>
                    </div>
                  </template>
                  <template v-else>
                    <span v-if="c.fralda" class="fralda-atual">{{ c.fralda }}</span>
                    <span v-else class="td-empty">—</span>
                    <button
                      type="button"
                      class="btn-fralda-edit"
                      title="Editar fralda"
                      @click="abrirEditarFralda(c)"
                    >
                      ✏️
                    </button>
                  </template>
                </div>
              </td>
              <td class="td-status">
                <span class="badge" :class="c.confirmado ? 'badge-ok' : 'badge-pend'">
                  {{ c.confirmado ? '✓ Sim' : 'Pendente' }}
                </span>
                <span v-if="c.confirmado_em" class="td-date">
                  {{ formatDate(c.confirmado_em) }}
                </span>
              </td>
              <td class="td-link">
                <button class="btn-copy" @click="copiarLink(c, 1)" :title="linkFor(c, 1)">
                  Convite 1
                </button>
                <button class="btn-copy btn-copy-2" @click="copiarLink(c, 2)" :title="linkFor(c, 2)">
                  Convite 2
                </button>
              </td>
              <td class="td-actions">
                <button class="btn-icon" @click="editarConvidado(c)" title="Editar">✏️</button>
                <button class="btn-icon btn-del" @click="confirmarDelete(c)" title="Excluir">🗑</button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="loading" class="table-loading">Carregando...</p>
        <p v-if="!loading && convidadosFiltrados.length === 0" class="table-empty">Nenhum convidado encontrado.</p>
      </div>
    </div>

    <!-- MODAL ADICIONAR / EDITAR -->
    <Transition name="modal">
      <div v-if="showAddModal || editTarget" class="modal-overlay" @click.self="fecharModal">
        <div class="modal-card">
          <h2 class="modal-title">{{ editTarget ? 'Editar convidado' : 'Novo convidado' }}</h2>
          <form class="modal-form" @submit.prevent="salvarConvidado">
            <div class="f-group">
              <label>Nome completo</label>
              <input v-model="form.nome" type="text" placeholder="Ex: Ronaldo e Iraci" required />
            </div>
            <div class="f-group">
              <label>Peso (nº de pessoas)</label>
              <input v-model.number="form.peso" type="number" min="1" max="20" required />
            </div>
            <div class="f-group">
              <label>Fralda atribuída</label>
              <input v-model="form.fralda" type="text" placeholder="Ex: Babysec Premium - G (60 un)" />
              <div v-if="fraldas.length" class="fralda-atalhos fralda-atalhos-modal">
                <button
                  v-for="f in fraldas"
                  :key="f.id"
                  type="button"
                  class="fralda-chip"
                  :class="{ active: form.fralda === labelFralda(f) }"
                  @click="form.fralda = labelFralda(f)"
                >
                  {{ chipFralda(f) }}
                </button>
              </div>
            </div>
            <div class="f-group">
              <label>WhatsApp (opcional)</label>
              <input v-model="form.whatsapp" type="tel" placeholder="(21) 99999-9999" />
            </div>
            <div class="f-group">
              <label>Observação</label>
              <input v-model="form.observacao" type="text" placeholder="Qualquer anotação..." />
            </div>
            <div class="modal-footer">
              <button type="button" class="btn-outline" @click="fecharModal">Cancelar</button>
              <button type="submit" class="btn-primary" :disabled="salvando">
                {{ salvando ? 'Salvando...' : 'Salvar' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </Transition>

    <!-- MODAL EDITAR FRALDA (convidado) -->
    <Transition name="modal">
      <div v-if="fraldaEditTarget" class="modal-overlay" @click.self="fecharEditarFralda">
        <div class="modal-card modal-card-wide">
          <h2 class="modal-title">Fralda — {{ fraldaEditTarget.nome }}</h2>
          <p v-if="fraldaEditTarget.fralda" class="modal-hint">
            Atual: <strong>{{ fraldaEditTarget.fralda }}</strong>
          </p>
          <p v-else class="modal-hint">Nenhuma fralda vinculada ainda.</p>
          <div v-if="fraldas.length" class="fralda-atalhos fralda-atalhos-modal fralda-atalhos-pick">
            <button
              v-for="f in fraldas"
              :key="f.id"
              type="button"
              class="fralda-chip"
              :class="{ active: fraldaEditTarget.fralda === labelFralda(f) }"
              :title="labelFralda(f)"
              @click="escolherFralda(labelFralda(f))"
            >
              {{ chipFralda(f) }}
            </button>
            <button
              v-if="fraldaEditTarget.fralda"
              type="button"
              class="fralda-chip fralda-chip-clear"
              title="Remover fralda"
              @click="escolherFralda(null)"
            >
              limpar
            </button>
          </div>
          <p v-else class="modal-hint">Cadastre fraldas no botão <strong>Fraldas</strong> do painel.</p>
          <div class="modal-footer">
            <button type="button" class="btn-outline" @click="fecharEditarFralda">Fechar</button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- MODAL FRALDAS (catálogo) -->
    <Transition name="modal">
      <div v-if="showFraldasModal" class="modal-overlay" @click.self="showFraldasModal = false">
        <div class="modal-card modal-card-wide">
          <h2 class="modal-title">Catálogo de fraldas</h2>
          <p class="modal-hint">Cadastre aqui e use os atalhos na tabela / no formulário do convidado.</p>
          <form class="fraldas-add-form" @submit.prevent="adicionarFralda">
            <input v-model="novaFralda.nome" type="text" placeholder="Marca / modelo" required />
            <div class="fraldas-add-row">
              <input v-model="novaFralda.tamanho" type="text" placeholder="Tam. (ex: G)" required />
              <input v-model.number="novaFralda.quantidade" type="number" min="1" placeholder="Qtd" required />
              <button type="submit" class="btn-primary btn-sm" :disabled="salvandoFralda">
                {{ salvandoFralda ? '...' : 'Adicionar' }}
              </button>
            </div>
          </form>
          <ul class="fraldas-lista">
            <li v-for="f in fraldas" :key="f.id">
              <span>{{ labelFralda(f) }}</span>
              <button type="button" class="btn-icon btn-del" title="Excluir" @click="excluirFralda(f)">🗑</button>
            </li>
            <li v-if="!fraldas.length" class="fraldas-lista-empty">Nenhuma fralda cadastrada.</li>
          </ul>
          <div class="modal-footer">
            <button type="button" class="btn-outline" @click="showFraldasModal = false">Fechar</button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- TOAST -->
    <Transition name="toast">
      <div v-if="toast" class="toast">{{ toast }}</div>
    </Transition>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { supabase } from '../supabase.js'

// ── auth ───────────────────────────────────────────────────────
const session    = ref(null)
const loginForm  = reactive({ email: '', senha: '' })
const loginError = ref('')
const loginLoading = ref(false)

onMounted(async () => {
  const { data } = await supabase.auth.getSession()
  session.value = data.session
  if (session.value) {
    carregarConvidados()
    carregarFraldas()
  }

  supabase.auth.onAuthStateChange((_, s) => {
    session.value = s
    if (s) {
      carregarConvidados()
      carregarFraldas()
    }
  })
})

async function doLogin() {
  loginLoading.value = true
  loginError.value = ''
  const { error } = await supabase.auth.signInWithPassword({
    email: loginForm.email,
    password: loginForm.senha,
  })
  if (error) loginError.value = 'E-mail ou senha incorretos.'
  loginLoading.value = false
}

async function doLogout() {
  await supabase.auth.signOut()
  session.value = null
}

// ── convidados ────────────────────────────────────────────────
const convidados = ref([])
const loading    = ref(false)
const busca      = ref('')

const convidadosFiltrados = computed(() => {
  const q = busca.value.toLowerCase().trim()
  if (!q) return convidados.value
  return convidados.value.filter(c =>
    c.nome.toLowerCase().includes(q) ||
    (c.fralda || '').toLowerCase().includes(q)
  )
})

const confirmados       = computed(() => convidados.value.filter(c => c.confirmado).length)
const totalPessoas      = computed(() => convidados.value.reduce((s, c) => s + c.peso, 0))
const pessoasConfirmadas = computed(() =>
  convidados.value.filter(c => c.confirmado).reduce((s, c) => s + c.peso, 0)
)

async function carregarConvidados() {
  loading.value = true
  const { data } = await supabase
    .from('convidados')
    .select('*')
    .order('nome')
  convidados.value = data || []
  loading.value = false
}

// ── fraldas (catálogo) ────────────────────────────────────────
const fraldas          = ref([])
const showFraldasModal = ref(false)
const fraldaEditTarget = ref(null)
const editarTodasFraldas = ref(false)
const novaFralda       = reactive({ nome: '', tamanho: '', quantidade: 50 })
const salvandoFralda   = ref(false)

function labelFralda(f) {
  return `${f.nome} - ${f.tamanho} (${f.quantidade} un)`
}

function chipFralda(f) {
  const abrev = {
    'MamyPoko Fralda Calça Super Proteção': 'MP Super',
    'MamyPoko Fralda Calça Dia & Noite': 'MP Dia/Noite',
    'Pampers Confort Sec': 'Confort Sec',
    'Pampers': 'Pampers',
    'Babysec Premium': 'Babysec',
  }
  return `${abrev[f.nome] || f.nome} ${f.tamanho}·${f.quantidade}`
}

async function carregarFraldas() {
  const { data } = await supabase
    .from('fraldas')
    .select('*')
    .order('nome')
    .order('tamanho')
    .order('quantidade')
  fraldas.value = data || []
}

async function vincularFralda(convidado, nomeFralda) {
  const { error } = await supabase
    .from('convidados')
    .update({ fralda: nomeFralda })
    .eq('id', convidado.id)
  if (error) {
    showToast('Erro ao vincular fralda.')
    return false
  }
  convidado.fralda = nomeFralda
  showToast(nomeFralda ? `Fralda vinculada a ${convidado.nome}` : `Fralda removida de ${convidado.nome}`)
  return true
}

function abrirEditarFralda(c) {
  fraldaEditTarget.value = c
}

function fecharEditarFralda() {
  fraldaEditTarget.value = null
}

function toggleEditarTodasFraldas() {
  editarTodasFraldas.value = !editarTodasFraldas.value
  if (editarTodasFraldas.value) fecharEditarFralda()
}

async function escolherFralda(nomeFralda) {
  if (!fraldaEditTarget.value) return
  const ok = await vincularFralda(fraldaEditTarget.value, nomeFralda)
  if (ok) fecharEditarFralda()
}

async function adicionarFralda() {
  const nome = novaFralda.nome.trim()
  const tamanho = novaFralda.tamanho.trim().toUpperCase()
  const quantidade = Number(novaFralda.quantidade)
  if (!nome || !tamanho || !quantidade) return
  salvandoFralda.value = true
  const { error } = await supabase.from('fraldas').insert({ nome, tamanho, quantidade })
  salvandoFralda.value = false
  if (error) {
    showToast(error.code === '23505' ? 'Essa fralda já existe.' : 'Erro ao adicionar fralda.')
    return
  }
  Object.assign(novaFralda, { nome: '', tamanho: '', quantidade: 50 })
  showToast('Fralda cadastrada!')
  carregarFraldas()
}

async function excluirFralda(f) {
  if (!confirm(`Excluir "${labelFralda(f)}" do catálogo?`)) return
  await supabase.from('fraldas').delete().eq('id', f.id)
  showToast('Fralda removida do catálogo.')
  carregarFraldas()
}

// ── link do convidado ─────────────────────────────────────────
function linkFor(c, modelo = 1) {
  const base = window.location.origin
  return modelo === 2
    ? `${base}/2?convidado=${c.id}`
    : `${base}/?convidado=${c.id}`
}

function copiarLink(c, modelo = 1) {
  navigator.clipboard.writeText(linkFor(c, modelo))
  showToast(`Link ${modelo === 2 ? '(Convite 2) ' : ''}de ${c.nome} copiado!`)
}

function exportarLinks() {
  const linhas = convidados.value.map(c => `${c.nome}\t${linkFor(c, 1)}\t${linkFor(c, 2)}`)
  const blob   = new Blob([linhas.join('\n')], { type: 'text/plain' })
  const a      = document.createElement('a')
  a.href       = URL.createObjectURL(blob)
  a.download   = 'links-convidados.txt'
  a.click()
}

// ── adicionar / editar ────────────────────────────────────────
const showAddModal = ref(false)
const editTarget   = ref(null)
const salvando     = ref(false)
const form         = reactive({ nome: '', peso: 1, fralda: '', whatsapp: '', observacao: '' })

function editarConvidado(c) {
  editTarget.value = c
  Object.assign(form, { nome: c.nome, peso: c.peso, fralda: c.fralda || '', whatsapp: c.whatsapp || '', observacao: c.observacao || '' })
}

function fecharModal() {
  showAddModal.value = false
  editTarget.value   = null
  Object.assign(form, { nome: '', peso: 1, fralda: '', whatsapp: '', observacao: '' })
}

async function salvarConvidado() {
  salvando.value = true
  const payload = { nome: form.nome, peso: form.peso, fralda: form.fralda || null, whatsapp: form.whatsapp || null, observacao: form.observacao || null }

  if (editTarget.value) {
    await supabase.from('convidados').update(payload).eq('id', editTarget.value.id)
    showToast('Convidado atualizado!')
  } else {
    await supabase.from('convidados').insert(payload)
    showToast('Convidado adicionado!')
  }

  salvando.value = false
  fecharModal()
  carregarConvidados()
}

// ── excluir ───────────────────────────────────────────────────
async function confirmarDelete(c) {
  if (!confirm(`Excluir "${c.nome}"?`)) return
  await supabase.from('convidados').delete().eq('id', c.id)
  showToast('Convidado removido.')
  carregarConvidados()
}

// ── helpers ───────────────────────────────────────────────────
const toast = ref('')
let toastTimer = null
function showToast(msg) {
  toast.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toast.value = '' }, 2800)
}

function formatDate(iso) {
  return new Date(iso).toLocaleDateString('pt-BR', { day:'2-digit', month:'2-digit', hour:'2-digit', minute:'2-digit' })
}
</script>

<style scoped>
/* ══════════════════════════════════
   ROOT
══════════════════════════════════ */
.painel-root {
  min-height: 100vh;
  background: #f5f0e8;
  font-family: 'Lato', sans-serif;
}

/* ══════════════════════════════════
   LOGIN
══════════════════════════════════ */
.login-wrap {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at 50% 30%, #2a1a4e 0%, #120a2e 55%, #0a0618 100%);
  padding: 20px;
}
.login-card {
  width: 100%;
  max-width: 380px;
  background: linear-gradient(160deg, #fdf8ef, #f5ecd4);
  border-radius: 24px;
  padding: 36px 28px;
  box-shadow: 0 30px 80px rgba(0,0,0,.5), 0 0 0 1px rgba(212,168,83,.3);
  text-align: center;
}
.login-crown { font-size: 48px; margin-bottom: 8px; }
.login-title { font-family: 'Dancing Script', cursive; font-size: 36px; color: #1a2744; margin-bottom: 4px; }
.login-sub   { font-size: 13px; color: #4a5a7a; margin-bottom: 24px; }
.login-form  { display: flex; flex-direction: column; gap: 14px; text-align: left; }
.login-error { color: #c0392b; font-size: 13px; text-align: center; margin: -6px 0; }

/* ══════════════════════════════════
   FORMULÁRIO GENÉRICO
══════════════════════════════════ */
.f-group { display: flex; flex-direction: column; gap: 5px; }
.f-group label { font-size: 11px; font-weight: 700; color: rgba(44,62,107,.7); text-transform: uppercase; letter-spacing: 1px; }
.f-group input {
  background: rgba(255,255,255,.7);
  border: 1.5px solid rgba(212,168,83,.4);
  border-radius: 10px;
  padding: 11px 14px;
  font-family: 'Lato', sans-serif;
  font-size: 14px;
  color: #1a2744;
  outline: none;
  transition: border-color .2s, box-shadow .2s;
}
.f-group input:focus { border-color: #d4a853; box-shadow: 0 0 0 3px rgba(212,168,83,.15); }

/* ══════════════════════════════════
   BOTÕES
══════════════════════════════════ */
.btn-primary {
  background: linear-gradient(135deg, #2c3e6b 0%, #1a2744 100%);
  color: #d4a853;
  border: none;
  border-radius: 50px;
  padding: 13px 28px;
  font-family: 'Playfair Display', serif;
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 6px 20px rgba(44,62,107,.35);
  transition: all .25s ease;
}
.btn-primary:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 10px 28px rgba(44,62,107,.45); }
.btn-primary:disabled { opacity: .6; cursor: not-allowed; }
.btn-outline {
  background: transparent;
  border: 1.5px solid rgba(44,62,107,.3);
  border-radius: 50px;
  padding: 11px 24px;
  font-family: 'Lato', sans-serif;
  font-size: 13px;
  color: #2c3e6b;
  cursor: pointer;
  transition: all .2s ease;
}
.btn-outline:hover { border-color: #d4a853; color: #c9962e; }
.btn-sm { padding: 9px 18px; font-size: 13px; }

/* ══════════════════════════════════
   PAINEL INNER
══════════════════════════════════ */
.painel-inner { padding: 0 0 60px; }

.painel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(135deg, #1a2744, #2c3e6b);
  padding: 16px 24px;
  position: sticky;
  top: 0;
  z-index: 30;
  box-shadow: 0 4px 20px rgba(0,0,0,.2);
}
.header-left   { display: flex; align-items: center; gap: 12px; }
.header-crown  { font-size: 28px; }
.header-title  { font-family: 'Dancing Script', cursive; font-size: 22px; color: #d4a853; line-height: 1.1; }
.header-sub    { font-size: 11px; color: rgba(255,255,255,.5); letter-spacing: 1px; }
.btn-logout    { background: rgba(255,255,255,.1); border: 1px solid rgba(255,255,255,.2); border-radius: 20px;
                 padding: 7px 16px; color: rgba(255,255,255,.7); font-size: 12px; cursor: pointer;
                 transition: all .2s ease; }
.btn-logout:hover { background: rgba(255,255,255,.18); color: #fff; }

/* ══════════════════════════════════
   STATS
══════════════════════════════════ */
.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  padding: 20px 24px 0;
}
@media (max-width: 600px) {
  .stats-row { grid-template-columns: repeat(2, 1fr); }
}
.stat-card {
  background: #fff;
  border-radius: 14px;
  padding: 16px;
  text-align: center;
  border: 1px solid rgba(212,168,83,.2);
  box-shadow: 0 2px 10px rgba(0,0,0,.06);
}
.stat-confirmed { background: #f0faf0; border-color: rgba(40,167,69,.2); }
.stat-value { font-family: 'Dancing Script', cursive; font-size: 36px; color: #1a2744; line-height: 1; }
.stat-confirmed .stat-value { color: #28a745; }
.stat-label { font-size: 11px; color: #4a5a7a; letter-spacing: .5px; margin-top: 2px; }

/* ══════════════════════════════════
   AÇÕES
══════════════════════════════════ */
.actions-row {
  display: flex;
  gap: 10px;
  align-items: center;
  padding: 16px 24px;
  flex-wrap: wrap;
}
.input-busca {
  flex: 1;
  min-width: 180px;
  background: #fff;
  border: 1.5px solid rgba(212,168,83,.3);
  border-radius: 50px;
  padding: 10px 18px;
  font-family: 'Lato', sans-serif;
  font-size: 14px;
  color: #1a2744;
  outline: none;
  transition: border-color .2s;
}
.input-busca:focus { border-color: #d4a853; }

/* ══════════════════════════════════
   TABELA
══════════════════════════════════ */
.table-wrap {
  overflow-x: auto;
  padding: 0 24px;
}
.convidados-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0,0,0,.07);
  font-size: 13px;
}
.convidados-table thead { background: linear-gradient(135deg, #1a2744, #2c3e6b); }
.convidados-table th {
  color: rgba(212,168,83,.9);
  font-family: 'Lato', sans-serif;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  padding: 13px 14px;
  text-align: left;
}
.convidados-table td { padding: 12px 14px; border-bottom: 1px solid #f0ebe0; vertical-align: middle; }
.convidados-table tr.confirmed { background: #f8fff8; }
.convidados-table tr:last-child td { border-bottom: none; }
.convidados-table tr:hover { background: #fdf8ef; }

.td-nome   { min-width: 180px; }
.nome-badge { font-weight: 600; color: #1a2744; display: block; }
.nome-confirmed { color: #28a745; }
.td-zap    { font-size: 11px; color: #4a5a7a; display: block; margin-top: 2px; }
.td-peso   { white-space: nowrap; color: #2c3e6b; font-weight: 600; }
.td-fralda { color: #4a5a7a; max-width: 220px; min-width: 140px; }
.td-fralda-bulk { max-width: 320px; min-width: 200px; }
.td-empty  { color: #ccc; }
.fralda-cell {
  display: flex;
  align-items: flex-start;
  gap: 6px;
}
.fralda-cell-bulk {
  flex-direction: column;
  gap: 6px;
}
.btn-fraldas-bulk-active {
  background: rgba(212,168,83,.18);
  border-color: #d4a853;
  color: #8a6818;
  font-weight: 700;
}
.fralda-atual {
  flex: 1;
  font-weight: 600;
  color: #2c3e6b;
  font-size: 12px;
  line-height: 1.3;
}
.btn-fralda-edit {
  flex-shrink: 0;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 14px;
  padding: 2px 4px;
  border-radius: 6px;
  line-height: 1;
  opacity: .55;
  transition: opacity .15s, background .15s;
}
.btn-fralda-edit:hover {
  opacity: 1;
  background: rgba(212,168,83,.15);
}
.fralda-atalhos {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}
.fralda-atalhos-modal { margin-top: 8px; }
.fralda-atalhos-pick { margin-top: 4px; }
.fralda-atalhos-pick .fralda-chip { max-width: none; }
.fralda-chip {
  background: rgba(44,62,107,.06);
  border: 1px solid rgba(44,62,107,.15);
  border-radius: 14px;
  padding: 3px 8px;
  font-size: 10px;
  color: #2c3e6b;
  cursor: pointer;
  line-height: 1.3;
  max-width: 160px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: all .15s ease;
}
.fralda-chip:hover { background: rgba(212,168,83,.18); border-color: #d4a853; color: #a07820; }
.fralda-chip.active {
  background: rgba(212,168,83,.25);
  border-color: #d4a853;
  color: #8a6818;
  font-weight: 700;
}
.fralda-chip-clear {
  color: #856404;
  background: #fff3cd;
  border-color: rgba(133,100,4,.25);
}
.td-status { white-space: nowrap; }
.td-date   { display: block; font-size: 10px; color: #4a5a7a; margin-top: 2px; }
.td-link   { white-space: nowrap; }
.td-actions { white-space: nowrap; }

.badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
.badge-ok   { background: #d4edda; color: #28a745; }
.badge-pend { background: #fff3cd; color: #856404; }

.btn-copy {
  background: rgba(44,62,107,.08);
  border: 1px solid rgba(44,62,107,.18);
  border-radius: 20px;
  padding: 5px 12px;
  font-size: 11px;
  color: #2c3e6b;
  cursor: pointer;
  transition: all .2s ease;
  margin-right: 4px;
}
.btn-copy:hover { background: rgba(212,168,83,.15); border-color: #d4a853; color: #a07820; }
.btn-copy-2 {
  background: rgba(212,168,83,.1);
  border-color: rgba(212,168,83,.35);
  color: #a07820;
  margin-right: 0;
}
.btn-copy-2:hover { background: rgba(212,168,83,.25); border-color: #d4a853; }

.btn-icon { background: none; border: none; cursor: pointer; font-size: 16px; padding: 4px; border-radius: 6px; transition: background .15s; }
.btn-icon:hover { background: rgba(0,0,0,.06); }
.btn-del:hover  { background: rgba(192,57,43,.1); }

.table-loading, .table-empty { text-align: center; color: #4a5a7a; padding: 32px; font-size: 14px; }

/* ══════════════════════════════════
   MODAL
══════════════════════════════════ */
.modal-overlay {
  position: fixed; inset: 0; z-index: 100;
  background: rgba(10,6,24,.8);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}
.modal-card {
  width: 100%;
  max-width: 420px;
  background: linear-gradient(160deg, #fdf8ef, #f5ecd4);
  border-radius: 24px;
  padding: 28px 24px;
  box-shadow: 0 30px 80px rgba(0,0,0,.5), 0 0 0 1px rgba(212,168,83,.3);
}
.modal-card-wide { max-width: 480px; }
.modal-title { font-family: 'Dancing Script', cursive; font-size: 28px; color: #1a2744; margin-bottom: 18px; }
.modal-hint { font-size: 13px; color: #4a5a7a; margin: -10px 0 16px; line-height: 1.4; }
.modal-form  { display: flex; flex-direction: column; gap: 12px; }
.modal-footer { display: flex; gap: 10px; margin-top: 6px; justify-content: flex-end; }

.fraldas-add-form {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 14px;
}
.fraldas-add-form > input,
.fraldas-add-row input {
  background: rgba(255,255,255,.7);
  border: 1.5px solid rgba(212,168,83,.4);
  border-radius: 10px;
  padding: 11px 14px;
  font-family: 'Lato', sans-serif;
  font-size: 14px;
  color: #1a2744;
  outline: none;
}
.fraldas-add-form > input:focus,
.fraldas-add-row input:focus { border-color: #d4a853; box-shadow: 0 0 0 3px rgba(212,168,83,.15); }
.fraldas-add-row {
  display: flex;
  gap: 8px;
}
.fraldas-add-row input:first-child { width: 90px; flex: 0 0 90px; }
.fraldas-add-row input:nth-child(2) { width: 80px; flex: 0 0 80px; }
.fraldas-lista {
  list-style: none;
  margin: 0 0 12px;
  padding: 0;
  max-height: 280px;
  overflow-y: auto;
  background: rgba(255,255,255,.45);
  border-radius: 12px;
  border: 1px solid rgba(212,168,83,.25);
}
.fraldas-lista li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  padding: 10px 12px;
  border-bottom: 1px solid rgba(212,168,83,.15);
  font-size: 13px;
  color: #1a2744;
}
.fraldas-lista li:last-child { border-bottom: none; }
.fraldas-lista-empty { color: #4a5a7a !important; justify-content: center !important; }

.modal-enter-active { transition: opacity .3s ease; }
.modal-leave-active { transition: opacity .25s ease; }
.modal-enter-from, .modal-leave-to { opacity: 0; }
.modal-enter-active .modal-card { animation: modal-pop .35s cubic-bezier(.16,1,.3,1) both; }
@keyframes modal-pop { from{transform:scale(.95) translateY(10px)} to{transform:scale(1) translateY(0)} }

/* ══════════════════════════════════
   TOAST
══════════════════════════════════ */
.toast {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: #1a2744;
  color: #d4a853;
  padding: 12px 24px;
  border-radius: 50px;
  font-size: 14px;
  z-index: 200;
  box-shadow: 0 8px 28px rgba(0,0,0,.35);
  white-space: nowrap;
}
.toast-enter-active { transition: opacity .3s ease, transform .3s cubic-bezier(.16,1,.3,1); }
.toast-leave-active { transition: opacity .25s ease; }
.toast-enter-from  { opacity: 0; transform: translateX(-50%) translateY(10px); }
.toast-leave-to    { opacity: 0; }
</style>
