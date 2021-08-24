message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura de tasas de aportación' )

#Cargando información ------------------------------------------------------------------------------
file <- paste0(parametros$Data, 'IESS_tasas_501_261.xlsx' )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Lectura--------------------------------------------------------------------------------------------
ivm_largo <- read_excel(file,
                        sheet = 'ivm_largo',
                        col_names = TRUE,
                        col_types = NULL,
                        na = "",
                        skip = 0) %>% clean_names() %>%
  mutate( fecha = as.Date( fecha, "%Y-%mm-%dd", tz = "UTC"))


ivm_corto <- read_excel(file,
                        sheet = 'ivm_corto',
                        col_names = FALSE,
                        col_types = NULL,
                        na = "",
                        skip = 2) %>% clean_names()

salud_corto <- read_excel(file,
                        sheet = 'salud_corto',
                        col_names = FALSE,
                        col_types = NULL,
                        na = "",
                        skip = 2) %>% clean_names()

salud_largo <- read_excel(file,
                          sheet = 'salud_largo',
                          col_names = TRUE,
                          col_types = NULL,
                          na = "",
                          skip = 0) %>% clean_names() %>%
  mutate( fecha = as.Date( fecha, "%Y-%mm-%dd", tz = "UTC"))


rt_corto <- read_excel(file,
                          sheet = 'rt_corto',
                          col_names = FALSE,
                          col_types = NULL,
                          na = "",
                          skip = 2) %>% clean_names()


rt_largo <- read_excel(file,
                          sheet = 'rt_largo',
                          col_names = TRUE,
                          col_types = NULL,
                          na = "",
                          skip = 0) %>% clean_names() %>%
  mutate( fecha = as.Date( fecha, "%Y-%mm-%dd", tz = "UTC"))


cd_261 <- read_excel(file,
                       sheet = '261',
                       col_names = FALSE,
                       col_types = NULL,
                       na = "",
                       skip = 2) %>% clean_names()

#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando tasas de aportación' )

save( ivm_largo,
      ivm_corto,
      salud_largo,
      salud_corto,
      rt_largo,
      rt_corto,
      cd_261,
      file = paste0( parametros$RData, 'IESS_tasas_aportacion.Rdata' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()
