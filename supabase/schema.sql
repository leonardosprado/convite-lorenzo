-- ─────────────────────────────────────────────
-- SCHEMA — Convite Lorenzo (instalação NOVA)
-- ─────────────────────────────────────────────
-- Use este arquivo só em banco vazio / projeto novo.
-- Em banco que já rodou o schema antes, NÃO reexecute:
-- use os arquivos em supabase/migrations/
-- ─────────────────────────────────────────────

create extension if not exists "pgcrypto";

create table if not exists convidados (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,
  peso        int  not null default 1,   -- nº de pessoas do grupo
  fralda      text,                       -- rótulo: "Marca - Tamanho (N un)"
  confirmado  boolean not null default false,
  confirmado_em timestamptz,
  whatsapp    text,
  observacao  text,
  created_at  timestamptz not null default now()
);

create table if not exists fraldas (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,              -- marca / modelo
  tamanho     text not null,              -- P, M, G...
  quantidade  int  not null,              -- unidades sugeridas
  created_at  timestamptz not null default now(),
  unique (nome, tamanho, quantidade)
);

alter table convidados enable row level security;
alter table fraldas enable row level security;

drop policy if exists "convidado_leitura_propria" on convidados;
drop policy if exists "convidado_confirmar" on convidados;
drop policy if exists "admin_insert" on convidados;
drop policy if exists "admin_delete" on convidados;
drop policy if exists "fraldas_leitura_admin" on fraldas;
drop policy if exists "fraldas_insert_admin" on fraldas;
drop policy if exists "fraldas_update_admin" on fraldas;
drop policy if exists "fraldas_delete_admin" on fraldas;

create policy "convidado_leitura_propria"
  on convidados for select
  using (true);

create policy "convidado_confirmar"
  on convidados for update
  using (true)
  with check (true);

create policy "admin_insert"
  on convidados for insert
  with check (auth.role() = 'authenticated');

create policy "admin_delete"
  on convidados for delete
  using (auth.role() = 'authenticated');

create policy "fraldas_leitura_admin"
  on fraldas for select
  using (auth.role() = 'authenticated');

create policy "fraldas_insert_admin"
  on fraldas for insert
  with check (auth.role() = 'authenticated');

create policy "fraldas_update_admin"
  on fraldas for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

create policy "fraldas_delete_admin"
  on fraldas for delete
  using (auth.role() = 'authenticated');
