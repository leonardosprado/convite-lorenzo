-- ─────────────────────────────────────────────
-- Migration 002 — vincula fralda a cada convidado
-- Fonte: distribuicao_fraldas_cha.csv
-- Pré-requisito: 001_fraldas.sql + convidados seedados
-- ─────────────────────────────────────────────

-- Grupo geral
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - G (50 un)' where nome = 'Adma e Roberto';
update convidados set fralda = 'Pampers - M (44 un)'                              where nome = 'Simone';
update convidados set fralda = 'Pampers - P (26 un)'                              where nome = 'Adão';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Geovana e Bruno';
update convidados set fralda = 'Pampers Confort Sec - G (60 un)'                  where nome = 'Luciene e Elker';

-- Familiares meus
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (50 un)'    where nome = 'Ronaldo e Iraci';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Júnior e Denise';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Léo e Thassara e Bárbara';
update convidados set fralda = 'Pampers Confort Sec - M (70 un)'                  where nome = 'Izabella e Felipe';
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - M (38 un)' where nome = 'Eunice';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Aglair e Delson';
update convidados set fralda = 'Pampers Confort Sec - G (60 un)'                  where nome = 'Renan e Mariana';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Rômulo e Geovanna e Isabel';
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (50 un)'    where nome = 'Renato e Cecília e Augusto';
update convidados set fralda = 'Babysec Premium - M (68 un)'                      where nome = 'Rômulo e Selma';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Gabriel e Ester Alice e Maria';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Araci e Adail';
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - G (38 un)' where nome = 'Luís Miguel';
update convidados set fralda = 'Pampers - P (26 un)'                              where nome = 'Lucas';
update convidados set fralda = 'Pampers Confort Sec - G (60 un)'                  where nome = 'Joana e Rafael';
update convidados set fralda = 'Babysec Premium - M (68 un)'                      where nome = 'Tia Fátima';
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (50 un)'    where nome = 'Isadora e Vitor';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Antônio e Joyce';
update convidados set fralda = 'Babysec Premium - G (48 un)'                      where nome = 'Rodrigo';
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - M (38 un)' where nome = 'Gustavo';

-- Familiares Crô
update convidados set fralda = 'Babysec Premium - M (60 un)'                      where nome = 'Oswarina';
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (38 un)'    where nome = 'Tia Sueli';
update convidados set fralda = 'Pampers - M (44 un)'                              where nome = 'Tia Sônia';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Jessyca e Pedro e Pedrinho e Emanuel';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Pollyanna e Amanda e Valdinei';

-- Amigos
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - G (50 un)' where nome = 'Laíssa e Walison';
update convidados set fralda = 'Pampers Confort Sec - G (60 un)'                  where nome = 'Fernando e Anna Cecília';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Leonardo, Heloísa e Livia';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Jordana, Guilherme, Clarisse e Anthony';
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (50 un)'    where nome = 'Karyne e Rafael';
update convidados set fralda = 'Babysec Premium - M (68 un)'                      where nome = 'Thaynan e Augusto';
update convidados set fralda = 'Pampers Confort Sec - G (60 un)'                  where nome = 'Halls e Caroline';
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - G (50 un)' where nome = 'Silvio e Milena';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Luan e Esposa';
update convidados set fralda = 'Pampers Confort Sec - M (70 un)'                  where nome = 'Gabriela e Pedro';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Murilo e Camila';
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (50 un)'    where nome = 'Luciana e Adriel';
update convidados set fralda = 'Babysec Premium - M (60 un)'                      where nome = 'Amanda de Paula';
update convidados set fralda = 'Pampers - P (26 un)'                              where nome = 'Vinícius';
update convidados set fralda = 'Pampers Confort Sec - G (60 un)'                  where nome = 'Sérgio e Verenice';
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - G (50 un)' where nome = 'Vinícius (Tchê) e Daniela';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Bruno e Ravila';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Jorge, Larissa, Arthur e Alice';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Anderson, Tamara, Nicole e Arthur';
update convidados set fralda = 'MamyPoko Fralda Calça Dia & Noite - G (50 un)'    where nome = 'Auta Duarte (Lene) e Joaquim';
update convidados set fralda = 'Pampers Confort Sec - G (70 un)'                  where nome = 'Janine e Maciel e Filho';
update convidados set fralda = 'Babysec Premium - G (60 un)'                      where nome = 'Marcão e Margarida';
update convidados set fralda = 'MamyPoko Fralda Calça Super Proteção - G (50 un)' where nome = 'Brenda e Marido';
