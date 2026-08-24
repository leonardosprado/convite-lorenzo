-- ─────────────────────────────────────────────
-- Migration 003 — leitura pública do catálogo de fraldas
-- (convite precisa listar marcas sem login)
-- ─────────────────────────────────────────────

drop policy if exists "fraldas_leitura_admin" on fraldas;

create policy "fraldas_leitura_publica"
  on fraldas for select
  using (true);
