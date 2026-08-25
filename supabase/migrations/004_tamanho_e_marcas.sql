-- ─────────────────────────────────────────────
-- Migration 004 — tamanho no convidado + fraldas só marca
-- Banco já existente.
-- ─────────────────────────────────────────────

-- 1) Coluna de tamanho no convidado
alter table convidados
  add column if not exists tamanho_fralda text;

-- 2) Preenche a partir do texto antigo "Marca - Tamanho (N un)"
update convidados
set tamanho_fralda = upper((regexp_match(fralda, '- ([A-Za-z0-9]+) \('))[1])
where fralda is not null
  and tamanho_fralda is null;

-- 3) Fallback pelos nomes da distribuição (caso fralda esteja vazia)
update convidados set tamanho_fralda = 'G' where nome = 'Adma e Roberto' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Simone' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'P' where nome = 'Adão' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Geovana e Bruno' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Luciene e Elker' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Ronaldo e Iraci' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Júnior e Denise' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Léo e Thassara e Bárbara' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Izabella e Felipe' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Eunice' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Aglair e Delson' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Renan e Mariana' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Rômulo e Geovanna e Isabel' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Renato e Cecília e Augusto' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Rômulo e Selma' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Gabriel e Ester Alice e Maria' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Araci e Adail' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Luís Miguel' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'P' where nome = 'Lucas' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Joana e Rafael' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Tia Fátima' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Isadora e Vitor' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Antônio e Joyce' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Rodrigo' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Gustavo' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Oswarina' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Tia Sueli' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Tia Sônia' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Jessyca e Pedro e Pedrinho e Emanuel' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Pollyanna e Amanda e Valdinei' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Laíssa e Walison' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Fernando e Anna Cecília' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Leonardo, Heloísa e Livia' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Jordana, Guilherme, Clarisse e Anthony' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Karyne e Rafael' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Thaynan e Augusto' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Halls e Caroline' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Silvio e Milena' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Luan e Esposa' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Gabriela e Pedro' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Murilo e Camila' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Luciana e Adriel' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'M' where nome = 'Amanda de Paula' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'P' where nome = 'Vinícius' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Sérgio e Verenice' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Vinícius (Tchê) e Daniela' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Bruno e Ravila' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Jorge, Larissa, Arthur e Alice' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Anderson, Tamara, Nicole e Arthur' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Auta Duarte (Lene) e Joaquim' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Janine e Maciel e Filho' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Marcão e Margarida' and tamanho_fralda is null;
update convidados set tamanho_fralda = 'G' where nome = 'Brenda e Marido' and tamanho_fralda is null;

-- 4) Remove coluna antiga de texto completo
alter table convidados drop column if exists fralda;

-- 5) Recria catálogo só com marca (+ foto opcional pra imagens depois)
drop table if exists fraldas cascade;

create table fraldas (
  id         uuid primary key default gen_random_uuid(),
  nome       text not null unique,
  foto       text,                          -- path/url da imagem (ex: fraldas/babysec.png)
  created_at timestamptz not null default now()
);

alter table fraldas enable row level security;

create policy "fraldas_leitura_publica"
  on fraldas for select
  using (true);

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

insert into fraldas (nome) values
('BabySec Premium Shortinho'),
('MamyPoko Calça Dia & Noite'),
('Pampers Premium Care')
on conflict (nome) do nothing;
