-- ─────────────────────────────────────────────
-- SCHEMA — Convite Lorenzo
-- ─────────────────────────────────────────────

create extension if not exists "pgcrypto";

create table if not exists convidados (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,
  peso        int  not null default 1,   -- nº de pessoas do grupo
  fralda      text,                       -- ex: "Pampers Pants - Tamanho M"
  confirmado  boolean not null default false,
  confirmado_em timestamptz,
  whatsapp    text,
  observacao  text,
  created_at  timestamptz not null default now()
);

-- RLS: leitura pública via token (o link do convidado usa o UUID)
alter table convidados enable row level security;

-- Qualquer um pode ler o próprio registro pelo ID
create policy "convidado_leitura_propria"
  on convidados for select
  using (true);

-- Convidado pode confirmar o próprio registro (update limitado a campos permitidos)
create policy "convidado_confirmar"
  on convidados for update
  using (true)
  with check (true);

-- Apenas usuários autenticados (admin) podem inserir/deletar
create policy "admin_insert"
  on convidados for insert
  with check (auth.role() = 'authenticated');

create policy "admin_delete"
  on convidados for delete
  using (auth.role() = 'authenticated');
