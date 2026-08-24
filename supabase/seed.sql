-- ─────────────────────────────────────────────
-- SEED — Fraldas (catálogo — distribuicao_fraldas_cha.csv)
-- ─────────────────────────────────────────────

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
('Babysec Premium',                      'M', 60)
on conflict (nome, tamanho, quantidade) do nothing;

-- ─────────────────────────────────────────────
-- SEED — Convidados do Chá do Lorenzo
-- Gerado a partir de semente.txt
-- Nome limpo para exibição no convite | peso = nº de pessoas
-- ─────────────────────────────────────────────

insert into convidados (nome, peso) values

-- Grupo geral
('Adma e Roberto',                           2),
('Simone',                                   1),
('Adão',                                     1),
('Geovana e Bruno',                          2),
('Luciene e Elker',                          2),

-- Familiares meus
('Ronaldo e Iraci',                          2),
('Júnior e Denise',                          2),
('Léo e Thassara e Bárbara',                 2),
('Izabella e Felipe',                        2),
('Eunice',                                   1),
('Aglair e Delson',                          2),
('Renan e Mariana',                          2),
('Rômulo e Geovanna e Isabel',               2),
('Renato e Cecília e Augusto',               2),
('Rômulo e Selma',                           2),
('Gabriel e Ester Alice e Maria',            3),
('Araci e Adail',                            2),
('Luís Miguel',                              1),
('Lucas',                                    1),
('Joana e Rafael',                           2),
('Tia Fátima',                               1),
('Isadora e Vitor',                          2),
('Antônio e Joyce',                          2),
('Rodrigo',                                  1),
('Gustavo',                                  1),

-- Familiares Crô
('Oswarina',                                 1),
('Tia Sueli',                                1),
('Tia Sônia',                                1),
('Jessyca e Pedro e Pedrinho e Emanuel',     2),
('Pollyanna e Amanda e Valdinei',            3),

-- Amigos
('Laíssa e Walison',                         2),
('Fernando e Anna Cecília',                  2),
('Leonardo, Heloísa e Livia',                2),
('Jordana, Guilherme, Clarisse e Anthony',   2),
('Karyne e Rafael',                          2),
('Thaynan e Augusto',                        2),
('Halls e Caroline',                         2),
('Silvio e Milena',                          2),
('Luan e Esposa',                            2),
('Gabriela e Pedro',                         2),
('Murilo e Camila',                          2),
('Luciana e Adriel',                         2),
('Amanda de Paula',                          1),
('Vinícius',                                 1),
('Sérgio e Verenice',                        2),
('Vinícius (Tchê) e Daniela',               2),
('Bruno e Ravila',                           2),
('Jorge, Larissa, Arthur e Alice',           4),
('Anderson, Tamara, Nicole e Arthur',        4),
('Auta Duarte (Lene) e Joaquim',             2),
('Janine e Maciel e Filho',                  3),
('Marcão e Margarida',                       2),
('Brenda e Marido',                          2);
