#' ----
#' title: manipulacao de dados em r - tidyverse
#' author: mauricio vancine
#' date: 2025-10-15
#' ----

# packages ----------------------------------------------------------------

library(tidyverse)
library(readxl)
library(writexl)
library(lubridate)
library(parallel)

# topics ------------------------------------------------------------------

# contextualizacao
# tidyverse
# readr, readxl e writexl
# tibble
# magrittr (pipe - %>%)
# tidyr
# dplyr
# stringr
# forcats
# lubridate
# purrr

# tidyverse -----------------------------------------------------------
# instalar pacote
# install.packages("tidyverse")

# carregar pacote
library(tidyverse)

# list all packages in the tidyverse 
tidyverse::tidyverse_packages(include_self = TRUE)

# 5. diretorio de trabalho -----------------------------------------------

# definir o diretorio de trabalho
setwd("/home/mude/data/github/course-intror/data") # mudem

# verificar o diretorio
getwd()

# listar os arquivos
dir()

# readr, readxl e writexl ----------------------------------------------

## importar ----
# formato .csv
si <- readr::read_csv("ATLANTIC_AMPHIBIANS_sites.csv")
si

da <- read.csv("ATLANTIC_AMPHIBIANS_sites.csv", encoding = "latin1")
da

class(si)
class(da)

# formato .txt
si <- readr::read_tsv("ATLANTIC_AMPHIBIANS_sites.txt")
si

# importar .xlsx
# install.packages("readxl")
library("readxl")

# exportar .xlsx
# install.packages("writexl")
library("writexl")

# importar sites
si <- readxl::read_xlsx("ATLANTIC_AMPHIBIANS_sites.xlsx", sheet = 1)
si

## exportar ----
# exportar csv
readr::write_csv(si, "ATLANTIC_AMPHIBIANS_sites_exportado.csv")

# exportar txt
readr::write_tsv(si, "ATLANTIC_AMPHIBIANS_sites_exportado.txt")

# exportar excel
writexl::write_xlsx(si, "ATLANTIC_AMPHIBIANS_sites_exportado.xlsx")


# tibble --------------------------------------------------------------

# tibble
tb <- tibble::tibble(a = 1:10)
tb

as.data.frame(tb)

# view the sites data
tibble::glimpse(si)

# magrittr (pipe - %>%) -----------------------------------------------
# sem pipe
sqrt(sum(1:100))

# com pipe
1:100 %>% 
  sum() %>% 
  sqrt()

# fixar amostragem
set.seed(42)

# sem pipe
ve <- sum(sqrt(sort(log10(rpois(100, 10)))))
ve

# fixar amostragem
set.seed(42)

# sem pipe
ve <- sqrt(sum(sample(0:60, 6)))
ve

# fixar amostragem
set.seed(42)

# com pipe
ve <- sample(0:60, 6) %>% 
  sum() %>%
  sqrt() 
ve  

# exercicios --------------------------------------------------------------

log10(cumsum(1:100))

sum(sqrt(abs(rnorm(100))))

sum(log(sample(1:10, 10000, rep = TRUE)))

# palmerpenquins ----------------------------------------------------------

# instalar 
# install.packages("palmerpenguins")

# carregar
library(palmerpenguins)

# ajuda dos dados
?penguins
?penguins_raw

# visualizar os dados
penguins
penguins_raw

# glimpse
tibble::glimpse(penguins)
tibble::glimpse(penguins_raw)

#  tidyr ---------------------------------------------------------------

# funcoes
# 1. unite(): junta dados de múltiplas colunas em uma
# 2. separate(): separa caracteres em múlplica colunas
# 3. drop_na(): retira linhas com NA
# 4. replace_na(): substitui NA
# 5. pivot_wider(): long para wide
# 6. pivot_longer(): wide para long

# 1. unite()
# unir colunas
penguins_raw_unir <- tidyr::unite(data = penguins_raw, 
                                  col = "region_island",
                                  Region:Island, 
                                  sep = ", ",
                                  remove = FALSE)
head(penguins_raw_unir[, c("Region", "Island", "region_island")])
  
# 2. separate()
# separar colunas
penguins_raw_separar <- tidyr::separate(data = penguins_raw, 
                                        col = Stage,
                                        into = c("stage", "egg_stage"), 
                                        sep = ", ",
                                        remove = FALSE)
head(penguins_raw_separar[, c("Stage", "stage", "egg_stage")])

# 3. drop_na()
# remover linhas com na
penguins_raw_todas_na <- tidyr::drop_na(data = penguins_raw)
head(penguins_raw_todas_na)

# remover linhas com na de uma coluna
penguins_raw_colunas_na <- tidyr::drop_na(data = penguins_raw,
                                          any_of("Comments"))
head(penguins_raw_colunas_na[, "Comments"])

# 4. replace_na()
# substituir nas por 0 em uma coluna
penguins_raw_subs_na <- tidyr::replace_na(data = penguins_raw,
                                          list(Comments = "Unknown"))
head(penguins_raw_subs_na[, "Comments"])

# 5. pivot_wider()
# long para wide
penguins_raw_pivot_wider <- tidyr::pivot_wider(data = penguins_raw[, c(2, 3, 13)], 
                                               names_from = Species, 
                                               values_from = `Body Mass (g)`)
head(penguins_raw_pivot_wider)

# long para wide
penguins_raw_pivot_wider <- tidyr::pivot_wider(data = penguins_raw[, c(2, 3, 13)], 
                                               names_from = Species, 
                                               values_from = `Body Mass (g)`,
                                               values_fill = 0)
head(penguins_raw_pivot_wider)

# 6. pivot_longer()
# wide para long
penguins_raw_pivot_longer <- tidyr::pivot_longer(data = penguins_raw[, c(2, 3, 10:13)], 
                                                 cols = `Culmen Length (mm)`:`Body Mass (g)`,
                                                 names_to = "medidas", 
                                                 values_to = "valores")
head(penguins_raw_pivot_longer)

# dplyr ---------------------------------------------------------------

# funcoes
# 1. relocate(): muda a ordem das colunas
# 2. rename(): muda o nome das colunas
# 3. select(): seleciona colunas pelo nome ou posição
# 4. pull(): seleciona uma coluna como vetor
# 5. mutate(): adiciona novas colunas ou resultados em colunas existentes
# 6. arrange(): reordena as linhas com base nos valores de colunas
# 7. filter(): seleciona linhas com base em valores de colunas
# 8. slice(): seleciona linhas de diferente formas
# 9. distinct(): remove linhas com valores repetidos com base nos valores de colunas
# 10. count(): conta observações para um grupo
# 11. group_by(): agrupa linhas pelos valores das colunas
# 12. summarise(): resume os dados através de funções considerando valores das colunas

# 1. relocate()
# reordenar colunas - nome
penguins_relocate_col <- penguins %>% 
  dplyr::relocate(sex, year, .after = island)
head(penguins_relocate_col)

# reordenar colunas - posicao
penguins_relocate_ncol <- penguins %>% 
  dplyr::relocate(sex, year, .after = 2)
head(penguins_relocate_ncol)

# 2. rename()
# renomear colunas
penguins_rename <- penguins %>% 
  dplyr::rename(bill_length = bill_length_mm,
                bill_depth = bill_depth_mm,
                flipper_length = flipper_length_mm,
                body_mass = body_mass_g)
head(penguins_rename)

# 3. select()
# selecionar colunas por posicao
penguins_select_position <- penguins %>% 
  dplyr::select(3:6)
head(penguins_select_position)

# selecionar colunas por nomes
penguins_select_names <- penguins %>% 
  dplyr::select(bill_length_mm:body_mass_g)
head(penguins_select_names)

# remover colunas pelo nome
penguins_select_names_remove <- penguins %>% 
  dplyr::select(-(bill_length_mm:body_mass_g))
head(penguins_select_names_remove)

# selecionar colunas por padrao - starts_with(), ends_with() e contains()
penguins_select_contains <- penguins %>% 
  dplyr::select(contains("_mm"))
head(penguins_select_contains)

# 4. pull()
# coluna para vetor
penguins_select_pull <- penguins %>% 
  dplyr::pull(bill_length_mm)
head(penguins_select_pull, 15)

# 5. mutate()
# adicionar colunas
penguins_mutate <- penguins %>% 
  dplyr::mutate(body_mass_kg = body_mass_g/1e3, .before = sex)
head(penguins_mutate)

# 6. arrange()
# reordenar os valores por ordem crescente
penguins_arrange <- penguins %>% 
  dplyr::arrange(body_mass_g)
head(penguins_arrange)

# reordenar os valores por ordem decrescente
penguins_arrange_desc <- penguins %>% 
  dplyr::arrange(desc(body_mass_g))
head(penguins_arrange_desc)

# reordenar os valores por ordem decrescente
penguins_arrange_desc_m <- penguins %>% 
  dplyr::arrange(-body_mass_g)
head(penguins_arrange_desc_m)

# 7. filter()
# filtrar linhas por valores de uma coluna
penguins_filter <- penguins %>% 
  dplyr::filter(body_mass_g >= 5000)
head(penguins_filter)

# filtrar linhas por valores de duas colunas
penguins_filter_two <- penguins %>% 
  dplyr::filter(species == "Adelie" & sex == "female")
head(penguins_filter_two)

# filtrar linhas por mais de um valor e mais de uma coluna
penguins_filter_in <- penguins %>% 
  dplyr::filter(species %in% c("Adelie", "Gentoo"),
                sex == "female")
head(penguins_filter_in)

# 8. slice()
# selecionar linhas por intervalos
penguins_slice <- penguins %>% 
  dplyr::slice(n = c(1, 3, 300:n()))
head(penguins_slice)

# selecionar linhas iniciais
penguins_slice_head <- penguins %>% 
  dplyr::slice_head(n = 5)
head(penguins_slice_head)

# selecionar linhas por valores de uma coluna
penguins_slice_max <- penguins %>% 
  dplyr::slice_max(body_mass_g, n = 5)
head(penguins_slice_max)

# selecionar linhas aleatoriamente
penguins_slice_sample <- penguins %>% 
  dplyr::slice_sample(n = 30)
head(penguins_slice_sample)

# 9. distinct()
# retirar linhas com valores duplicados
penguins_distinct <- penguins %>% 
  dplyr::distinct(body_mass_g)
head(penguins_distinct)

# retirar linhas com valores duplicados e manter colunas
penguins_distinct_keep_all <- penguins %>% 
  dplyr::distinct(body_mass_g, .keep_all = TRUE)
head(penguins_distinct_keep_all)

# 10. count()
# contagens de valores para uma coluna
penguins_count <- penguins %>% 
  dplyr::count(species)
penguins_count

# contagens de valores para mais de uma coluna
penguins_count_two <- penguins %>% 
  dplyr::count(species, island)
penguins_count_two

# contagens de valores para mais de uma coluna
penguins_count_two_sort <- penguins %>% 
  dplyr::count(species, island, sort = TRUE)
penguins_count_two_sort

# 11. group_by()
# agrupamento
penguins_group_by <- penguins %>% 
  dplyr::group_by(species)
head(penguins_group_by)

# 12. summarise()
# resumo
penguins_summarise <- penguins %>% 
  dplyr::group_by(species) %>% 
  dplyr::summarize(body_mass_g_mean = mean(body_mass_g, na.rm = TRUE),
                   body_mass_g_sd = sd(body_mass_g, na.rm = TRUE))
penguins_summarise

# bind_rows() e bind_cols()
# selecionar as linhas para dois tibbles
penguins_01 <- dplyr::slice(penguins, 1:5) %>% dplyr::select(1:3)
penguins_02 <- dplyr::slice(penguins, 51:55) %>% dplyr::select(4:6)

# combinar as linhas
penguins_bind_rows <- dplyr::bind_rows(penguins_01, penguins_02, .id = "id")
head(penguins_bind_rows)

## combinar as colunas
penguins_bind_cols <- dplyr::bind_cols(penguins_01, penguins_02, .name_repair = "unique")
head(penguins_bind_cols)

# stringr -------------------------------------------------------------

# comprimento
stringr::str_length(string = "penguins")

# substituir
stringr::str_replace(string = "penguins", pattern = "i", replacement = "y")

# separar
stringr::str_split(string = "p-e-n-g-u-i-n-s", pattern = "-", simplify = TRUE)

# extrair pela posicao
stringr::str_sub(string = "penguins", end = 3)

# extrair por padrao
stringr::str_extract(string = "penguins", pattern = "p")

# inserir espaco em branco - esquerda
stringr::str_pad(string = "penguins", width = 10, side = "left")

# inserir espaco em branco - direita
stringr::str_pad(string = "penguins", width = 10, side = "right")

# inserir espaco em branco - ambos
stringr::str_pad(string = "penguins", width = 10, side = "both")

# remover espacos em branco - esquerda
stringr::str_trim(string = " penguins ", side = "left")

# remover espacos em branco - direta
stringr::str_trim(string = " penguins ", side = "right")

# remover espacos em branco - ambos
stringr::str_trim(string = " penguins ", side = "both")

# minusculas
stringr::str_to_lower(string = "Penguins")

# maiusculas
stringr::str_to_upper(string = "penguins")

# primeiro caracter maiusculo da primeira palavra
stringr::str_to_sentence(string = "palmer penGuins")

# primeiro caracter maiusculo de cada palavra
stringr::str_to_title(string = "palmer penGuins")

# ordenar - crescente
stringr::str_sort(x = letters)

# ordenar - decrescente
stringr::str_sort(x = letters, dec = TRUE)

# alterar valores das colunas
penguins_stringr_valores <- penguins %>% 
  dplyr::mutate(species = stringr::str_to_lower(species))

# alterar nome das colunas
penguins_stringr_nomes <- penguins %>% 
  dplyr::rename_with(stringr::str_to_title)

# forcats -------------------------------------------------------------

# converter dados de string para fator
forcats::as_factor(penguins_raw$Species) %>% head()

# mudar o nome dos niveis
forcats::fct_recode(penguins$species, 
                    ade = "Adelie", 
                    chi = "Chinstrap", 
                    gen = "Gentoo") %>% head()

# inverter os niveis
forcats::fct_rev(penguins$species) %>% head()

# especificar a ordem dos niveis
forcats::fct_relevel(penguins$species, "Chinstrap", "Gentoo", "Adelie") %>% head()

# niveis pela ordem em que aparecem
forcats::fct_inorder(penguins$species) %>% head()

## ordem (decrescente) de frequecia
forcats::fct_infreq(penguins$species) %>% head()

# agregacao de niveis raros em um nivel
forcats::fct_lump(penguins$species) %>% head()

# transformar varias colunas em fator
penguins_raw_multi_factor <- penguins_raw %>% 
  dplyr::mutate(across(where(is.character), forcats::as_factor))
penguins_raw_multi_factor

# lubridate ----------------------------------------------------------

# carregar
library(lubridate)

# extrair a data nesse instante
lubridate::today()

# extrair a data e tempo nesse instante
lubridate::now()

# strings e numeros para datas
lubridate::dmy("03-03-2021")

# strings e numeros para datas
lubridate::dmy("03-Mar-2021")
lubridate::dmy(03032021)
lubridate::dmy("03032021")
lubridate::dmy("03/03/2021")
lubridate::dmy("03.03.2021")

# especificar horarios e fuso horario
lubridate::dmy_h("03-03-2021 13")
lubridate::dmy_hm("03-03-2021 13:32")
lubridate::dmy_hms("03-03-2021 13:32:01")
lubridate::dmy_hms("03-03-2021 13:32:01", tz = "America/Sao_Paulo")

# dados com componentes individuais
dados <- tibble::tibble(
  ano = c(2021, 2021, 2021),
  mes = c(1, 2, 3),
  dia = c(12, 20, 31),
  hora = c(2, 14, 18), 
  minuto = c(2, 44, 55))
dados

# dados com componentes individuais
dados %>% 
  dplyr::mutate(data = lubridate::make_datetime(ano, mes, dia, hora, minuto))

# data para data-horario
lubridate::as_datetime(today())

# data-horario para data
lubridate::as_date(now())

# extrair
lubridate::year(now())
lubridate::month(now())
lubridate::month(now(), label = TRUE)
lubridate::day(now())
lubridate::wday(now())
lubridate::wday(now(), label = TRUE)
lubridate::second(now())

# incluir
# data
data <- dmy_hms("04-03-2021 01:04:56")

# incluir
lubridate::year(data) <- 2020
lubridate::month(data) <- 01
lubridate::hour(data) <- 13

# incluir varios valores
update(data, year = 2020, month = 1, mday = 1, hour = 1)

# purrr --------------------------------------------------------------

# loop for
for(i in 1:10){
  print(i)
}

# loop for com map
purrr::map(.x = 1:10, .f = print)

# lista
x <- list(1:5, c(4, 5, 7), c(1, 1, 1), c(2, 2, 2, 2, 2))
x

# funcao map
purrr::map(x, sum)

# variacoes da funcao map
purrr::map_dbl(x, sum)
purrr::map_chr(x, paste, collapse = " ")

# listas
x <- list(3, 5, 0, 1)
y <- list(3, 5, 0, 1)
z <- list(3, 5, 0, 1)

# map2* duas litas
purrr::map2_dbl(x, y, prod)

# pmap muitas listas
purrr::pmap_dbl(list(x, y, z), prod)

# resumo dos dados
penguins %>% 
  dplyr::select(where(is.numeric)) %>% 
  tidyr::drop_na() %>% 
  purrr::map_dbl(mean)

# analise dos dados
penguins %>%
  dplyr::group_split(island, species) %>% 
  purrr::map(~ lm(bill_depth_mm ~ bill_length_mm, data = .x)) %>% 
  purrr::map(summary) %>% 
  purrr::map("r.squared")

# carregar
library(parallel)

# numero de cores
parallel::detectCores()

# end ---------------------------------------------------------------------
