-- ─────────────────────────────────────────────
-- Migration 005 — catálogo alinhado às 3 fotos
-- src/assets/fraldas/
--   BabySec Premium Shortinho.png
--   MamyPoko Calça Dia & Noite.png
--   Pampers Premium Care.webp
-- ─────────────────────────────────────────────

delete from fraldas;

insert into fraldas (nome) values
('BabySec Premium Shortinho'),
('MamyPoko Calça Dia & Noite'),
('Pampers Premium Care')
on conflict (nome) do nothing;
