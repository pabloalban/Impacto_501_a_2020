message( '\tLectura de las tasas de aportes' )

# Carga de datos -----------------------------------------------------------------------------------
file_tasas <- paste0( parametros$RData, 'IESS_tasas_aportacion.Rdata' )
load( file = file_tasas )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

message( '\tGenerando tablas de tasas de aportaciones' )
#1. ivm_corto---------------------------------------------------------------------------------------

file <- "ivm_corto"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, rep(2, dim(aux)[2]-1)  ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)


file <- "ivm_largo"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, 0, rep(2, 6) ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)



file <- "salud_largo"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, 0, rep(2, 6) ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)


file <- "salud_corto"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, rep(2, dim(aux)[2]-1) ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)


file <- "rt_largo"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, 0, rep(2, 6) ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)


file <- "rt_corto"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, rep(2, dim(aux)[2]-1 )  ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)

file <- "cd_261"

aux <- get(file)

aux_xtab <- xtable( aux, digits = c( 0, 0, rep(2, dim(aux)[2]-1 ) ) )

aux_xtab <- tildes_a_latex( aux_xtab )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'IESS_', file,'.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = nrow(aux),
       sanitize.text.function = identity,
       comment = FALSE,
       timestamp = FALSE
)
#---------------------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
