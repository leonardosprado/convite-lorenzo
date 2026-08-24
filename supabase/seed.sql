-- ─────────────────────────────────────────────
-- SEED — Marcas de fralda (catálogo)
-- fotos: coloque em src/assets/fraldas/ e preencha a coluna foto depois
-- ─────────────────────────────────────────────

insert into fraldas (nome) values
('Babysec Premium'),
('MamyPoko Fralda Calça Dia & Noite'),
('MamyPoko Fralda Calça Super Proteção'),
('Pampers'),
('Pampers Confort Sec')
on conflict (nome) do nothing;

-- ─────────────────────────────────────────────
-- SEED — Convidados + tamanho sugerido
-- Fonte: distribuicao_fraldas_cha.csv / migration 002
-- ─────────────────────────────────────────────

insert into convidados (nome, peso, tamanho_fralda) values

-- Grupo geral
('Adma e Roberto',                           2, 'G'),
('Simone',                                   1, 'M'),
('Adão',                                     1, 'P'),
('Geovana e Bruno',                          2, 'G'),
('Luciene e Elker',                          2, 'G'),

-- Familiares meus
('Ronaldo e Iraci',                          2, 'G'),
('Júnior e Denise',                          2, 'G'),
('Léo e Thassara e Bárbara',                 2, 'G'),
('Izabella e Felipe',                        2, 'M'),
('Eunice',                                   1, 'M'),
('Aglair e Delson',                          2, 'G'),
('Renan e Mariana',                          2, 'G'),
('Rômulo e Geovanna e Isabel',               2, 'G'),
('Renato e Cecília e Augusto',               2, 'G'),
('Rômulo e Selma',                           2, 'M'),
('Gabriel e Ester Alice e Maria',            3, 'G'),
('Araci e Adail',                            2, 'G'),
('Luís Miguel',                              1, 'G'),
('Lucas',                                    1, 'P'),
('Joana e Rafael',                           2, 'G'),
('Tia Fátima',                               1, 'M'),
('Isadora e Vitor',                          2, 'G'),
('Antônio e Joyce',                          2, 'G'),
('Rodrigo',                                  1, 'G'),
('Gustavo',                                  1, 'M'),

-- Familiares Crô
('Oswarina',                                 1, 'M'),
('Tia Sueli',                                1, 'G'),
('Tia Sônia',                                1, 'M'),
('Jessyca e Pedro e Pedrinho e Emanuel',     2, 'G'),
('Pollyanna e Amanda e Valdinei',            3, 'G'),

-- Amigos
('Laíssa e Walison',                         2, 'G'),
('Fernando e Anna Cecília',                  2, 'G'),
('Leonardo, Heloísa e Livia',                2, 'G'),
('Jordana, Guilherme, Clarisse e Anthony',   2, 'G'),
('Karyne e Rafael',                          2, 'G'),
('Thaynan e Augusto',                        2, 'M'),
('Halls e Caroline',                         2, 'G'),
('Silvio e Milena',                          2, 'G'),
('Luan e Esposa',                            2, 'G'),
('Gabriela e Pedro',                         2, 'M'),
('Murilo e Camila',                          2, 'G'),
('Luciana e Adriel',                         2, 'G'),
('Amanda de Paula',                          1, 'M'),
('Vinícius',                                 1, 'P'),
('Sérgio e Verenice',                        2, 'G'),
('Vinícius (Tchê) e Daniela',               2, 'G'),
('Bruno e Ravila',                           2, 'G'),
('Jorge, Larissa, Arthur e Alice',           4, 'G'),
('Anderson, Tamara, Nicole e Arthur',        4, 'G'),
('Auta Duarte (Lene) e Joaquim',             2, 'G'),
('Janine e Maciel e Filho',                  3, 'G'),
('Marcão e Margarida',                       2, 'G'),
('Brenda e Marido',                          2, 'G');
