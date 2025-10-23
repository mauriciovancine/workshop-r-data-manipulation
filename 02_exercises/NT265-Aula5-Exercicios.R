#' ----
#' title: manipulacao de dados em r - tidyverse
#' author: mauricio vancine
#' date: 2025-11-29
#' ----


# pacotes -----------------------------------------------------------------

# pacotes


# dados -------------------------------------------------------------------

# dados


# readr, readxl e writexl -------------------------------------------------

## exercicio 01 ----
# salve o dataset penguins em CSV e leia novamente

## exercicio 02 ----
# exporte e leia o arquivo Excel

## exercicio 03 ----
# salve apenas as colunas species, island e body_mass_g

# tibble ------------------------------------------------------------------

## exercicio 04 ----
# crie um tibble com o número de indivíduos por espécie

# maggriter ---------------------------------------------------------------

## exercicio 05 ----
# calcule a massa média de cada espécie

# tidyr -------------------------------------------------------------------

## exercicio 06 ----
# reorganize medidas de comprimento de asa e bico em formato longo


## exercicio 07 ----
# voltar ao formato largo com pivot_wider, criando uma coluna id e preenchimento igual a zero 
# dicas: tibble::rowid_to_column e values_fill = 0

# dplyr -------------------------------------------------------------------

## exercicio 08 ----
# selecione pinguins da ilha Dream e ordene pela massa

## exercicio 09 ----
# crie uma variável de massa corporal em kg

## exercicio 10 ----
# calcule a média e o desvio-padrão da massa por espécie

## exercicio 11 ----
# selecione todas as colunas que terminam com "_mm"

# stringr -----------------------------------------------------------------

## exercicio 12 ---- 
# padronize o nome das ilhas para minúsculas

## exercicio 13 ----
# quais colunas possuem nome com "_mm"

# forcats -----------------------------------------------------------------

## exercicio 14 ----
# veja a frequência das espécies ordenadas

## exercicio 15 ---- 
# agrupe a classe de ilha menos abundante em "Outras"

# lubridate ---------------------------------------------------------------

## exercicio 16 ---- 
# extraia mês e ano das datas do palmerpenguins

## exercicio 17 ---- 
# crie uma coluna com datas a partir de hoje acrescentando datas somando dias aleatórios de 0 a 100
# dica: sample(0:100, nrow(penguins), replace = TRUE)

# purrr -------------------------------------------------------------------

## exercicio 18 ----
# crie uma lista com as massas por espécie e calcule médias
# dica: purrr::split(var, group)

## exercicio 19 ----
# crie um tibble com o desvio padrao das massas por espécie
# use o resultado do ex. 18 e purrr::map_df

# desafio -----------------------------------------------------------------

## exercicio 20 ---- 
# calcule massa média por ilha, exporte para Excel e depois importe

# end ---------------------------------------------------------------------