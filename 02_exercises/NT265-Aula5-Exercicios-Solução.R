#' ----
#' title: manipulacao de dados em r - tidyverse
#' author: mauricio vancine
#' date: 2025-11-29
#' ----


# pacotes -----------------------------------------------------------------

# pacotes
library(tidyverse)
library(palmerpenguins)

# dados -------------------------------------------------------------------

# dados
data("penguins")
penguins <- penguins
head(penguins)

# readr, readxl e writexl -------------------------------------------------

## exercicio 01 ----
# salve o dataset penguins em CSV e leia novamente
readr::write_csv(penguins, "penguins.csv")
dados_csv <- readr::read_csv("penguins.csv")
head(dados_csv)

## exercicio 02 ----
# exporte e leia o arquivo Excel
writexl::write_xlsx(penguins, "penguins.xlsx")
dados_excel <- readxl::read_excel("penguins.xlsx")
head(dados_excel)

## exercicio 03 ----
# salve apenas as colunas species, island e body_mass_g
penguins %>%
    dplyr::select(species, island, body_mass_g) %>%
    writexl::write_xlsx("penguins_subset.xlsx")

# tibble ------------------------------------------------------------------

## exercicio 04 ----
# crie um tibble com o número de indivíduos por espécie
meu_tibble <- tibble::tibble(
    especie = unique(penguins$species),
    individuos = c(44, 119, 123))
meu_tibble

# maggriter ---------------------------------------------------------------

## exercicio 05 ----
# calcule a massa média de cada espécie
penguins %>%
    dplyr::group_by(species) %>%
    dplyr::summarise(media_massa = mean(body_mass_g, na.rm = TRUE))

# tidyr -------------------------------------------------------------------

## exercicio 06 ----
# reorganize medidas de comprimento de asa e bico em formato longo
longo <- penguins %>%
    dplyr::select(species, flipper_length_mm, bill_length_mm) %>%
    tidyr::pivot_longer(
        cols = c(flipper_length_mm, bill_length_mm),
        names_to = "medida",
        values_to = "valor")
head(longo)

## exercicio 07 ----
# voltar ao formato largo com pivot_wider, criando uma coluna id e preenchimento igual a zero 
# dicas: tibble::rowid_to_column e values_fill = 0
largo <- longo %>%
    tibble::rowid_to_column() %>% 
    tidyr::pivot_wider(names_from = medida, 
                       values_from = valor, 
                       values_fill = 0)
head(largo)

# dplyr -------------------------------------------------------------------

## exercicio 08 ----
# selecione pinguins da ilha Dream e ordene pela massa
penguins %>%
    dplyr::filter(island == "Dream") %>%
    dplyr::arrange(desc(body_mass_g)) %>%
    head()

## exercicio 09 ----
# crie uma variável de massa corporal em kg
penguins %>%
    dplyr::mutate(body_mass_kg = body_mass_g/1000) %>%
    dplyr::select(species, body_mass_g, body_mass_kg) %>%
    head()

## exercicio 10 ----
# calcule a média e o desvio-padrão da massa por espécie
penguins %>%
    dplyr::group_by(species) %>%
    dplyr::summarise(
        media = mean(body_mass_g, na.rm = TRUE),
        desvio = sd(body_mass_g, na.rm = TRUE))

## exercicio 11 ----
# selecione todas as colunas que terminam com "_mm"
penguins %>%
    dplyr::select(ends_with("_mm")) %>%
    head()

# stringr -----------------------------------------------------------------

## exercicio 12 ---- 
# padronize o nome das ilhas para minúsculas
stringr::str_to_lower(unique(penguins$island))

## exercicio 13 ----
# quais colunas possuem nome com "_mm"
stringr::str_subset(colnames(penguins), "mm")

# forcats -----------------------------------------------------------------

## exercicio 14 ----
# veja a frequência das espécies ordenadas
penguins %>%
    dplyr::mutate(species = forcats::fct_infreq(species)) %>%
    dplyr::count(species)

## exercicio 15 ---- 
# agrupe a classe de ilha menos abundante em "Outras"
penguins %>%
    dplyr::mutate(island_fact = forcats::fct_lump_lowfreq(island, other_level = "Outras")) %>% 
    dplyr::count(island_fact)

# lubridate ---------------------------------------------------------------

## exercicio 16 ---- 
# extraia mês e ano das datas do palmerpenguins
month(penguins_datas$data_obs, label = TRUE)
year(penguins_datas$data_obs)

## exercicio 17 ---- 
# crie uma coluna com datas a partir de hoje acrescentando datas somando dias aleatórios de 0 a 100
# dica: sample(0:100, nrow(penguins), replace = TRUE)
set.seed(123)
penguins_datas <- penguins %>%
    dplyr::mutate(data_random = today() + days(sample(0:100, nrow(penguins), replace = TRUE)))
penguins_datas$data_random

# purrr -------------------------------------------------------------------

## exercicio 18 ----
# crie uma lista com as massas por espécie e calcule médias
# dica: purrr::split(var, group)
listas_massa <- purrr::split(penguins$body_mass_g, penguins$species)
purrr::map(listas_massa, mean, na.rm = TRUE)

## exercicio 19 ----
# crie um tibble com o desvio padrao das massas por espécie
# use o resultado do ex. 18 e purrr::map_df
purrr::map_df(listas_massa, sd, na.rm = TRUE)

# desafio -----------------------------------------------------------------

## exercicio 20 ---- 
# calcule massa média por ilha, exporte para Excel e depois importe
penguins %>%
    dplyr::group_by(island) %>%
    dplyr::summarise(media_massa = mean(body_mass_g, narm = TRUE)) %>%
    writexl::write_xlsx("media_massa_ilha.xlsx")

readxl::read_excel("media_massa_ilha.xlsx")

# end ---------------------------------------------------------------------