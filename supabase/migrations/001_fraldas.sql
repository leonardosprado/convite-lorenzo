-- ─────────────────────────────────────────────
-- Migration 001 — tabela fraldas + seed do catálogo
-- Banco já existente (convidados já criado).
-- Não mexe em convidados / policies antigas.
-- ─────────────────────────────────────────────

drop table if exists fraldas cascade;

create table fraldas (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,
  tamanho     text not null,
  quantidade  int  not null,
  created_at  timestamptz not null default now(),
  unique (nome, tamanho, quantidade)
);

alter table fraldas enable row level security;

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

insert into fraldas (nome, tamanho, quantidade) values
('MamyPoko Fralda Calça Super Proteção', 'G', 50),
('MamyPoko Fralda Calça Super Proteção', 'M', 38),
('MamyPoko Fralda Calça Super Proteção', 'G', 38),
('MamyPoko Fralda Calça Dia & Noite',    'G', 50),
('MamyPoko Fralda Calça Dia & Noite',    'G', 38),
('Pampers',                              'M', 44),
('Pampers',                              'P', 26),
('Pampers Confort Sec',                  'G', 60),
('Pampers Confort Sec',                  'G', 70),
('Pampers Confort Sec',                  'M', 70),
('Babysec Premium',                      'G', 60),
('Babysec Premium',                      'G', 48),
('Babysec Premium',                      'M', 68),
('Babysec Premium',                      'M', 60);
