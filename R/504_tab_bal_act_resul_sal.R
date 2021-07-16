message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura balance actuarial al 31 de diciembre de salud' )

# Tabla balance actuarial al 31 de diciembre de salud CD 501 ---------------------------------------
load( file = paste0( parametros$RData_seg, 'IESS_SAL_presentacion_resultados.RData' ) ) 

aux <- copy( act_bal_resul1 )
aux_xtable <- xtable( aux, digits = c( 0, 0, 2, 2, 2 ) )
print( aux_xtable,
       file = paste0( parametros$resultado_tablas, 'iess_act_bal_resul_CD_501_sal', '.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = 6,
       sanitize.text.function = identity )


# Tabla balance actuarial al 31 de diciembre de salud CD 501----------------------------------------
message( '\tLectura pasivo-balance actuarial al 31 de diciembre de salud' )

load( file = paste0( parametros$RData_seg, 'IESS_SAL_presentacion_resultados.RData' ) ) 

aux <- copy( pas_bal_resul1 )
aux_xtable <- xtable( aux, digits = c( 0, 0, 2, 2, 2 ) )
print( aux_xtable,
       file = paste0( parametros$resultado_tablas, 'iess_pas_bal_resul_CD_501_sal', '.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = c(7,8),
       sanitize.text.function = identity )

message( '\tLectura balance actuarial al 31 de diciembre de salud' )

# Tabla balance actuarial al 31 de diciembre de salud CD 261----------------------------------------
load( file = paste0( parametros$RData_seg, 'IESS_SAL_presentacion_resultados.RData' ) )

aux <- copy( act_bal_resul2 )
aux_xtable <- xtable( aux, digits = c( 0, 0, 2, 2, 2 ) )
print( aux_xtable,
       file = paste0( parametros$resultado_tablas, 'iess_act_bal_resul_CD_261_sal', '.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = 6,
       sanitize.text.function = identity )


# Tabla balance actuarial al 31 de diciembre de salud CD 261----------------------------------------
message( '\tLectura pasivo-balance actuarial al 31 de diciembre de salud' )

load( file = paste0( parametros$RData_seg, 'IESS_SAL_presentacion_resultados.RData' ) )

aux <- copy( pas_bal_resul2 )
aux_xtable <- xtable( aux, digits = c( 0, 0, 2, 2, 2 ) )
print( aux_xtable,
       file = paste0( parametros$resultado_tablas, 'iess_pas_bal_resul_CD_261_sal', '.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = c(7,8),
       sanitize.text.function = identity )

# Tabla COMPARACIÓN DE LAS PRIMAS DE APORTES: RESOLUCIÓN C.D. 501 – RESOLUCIÓN C.D. 261-------------
message( '\tLectura COMPARACIÓN DE LAS PRIMAS DE APORTES: RESOLUCIÓN C.D. 501 – RESOLUCIÓN C.D. 261.' )

load( file = paste0( parametros$RData_seg, 'IESS_SAL_presentacion_resultados.RData' ) )

aux <- copy( primas_aporte_sal )
aux[, anio := as.character(substr(format(as.Date(anio),"%Y"),1,4)) ]
aux[, cd1 := cd1*100 ]
aux[, cd2 := cd2*100 ]
aux_xtable <- xtable( aux, digits = c( 0, 0, 2, 2 ) )
print( aux_xtable,
       file = paste0( parametros$resultado_tablas, 'iess_primas_aporte_sal', '.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = NULL,
       sanitize.text.function = identity )

# Tabla Impacto de la RESOLUCIÓN C.D. 501 y RESOLUCIÓN C.D. 261-------------------------------------
message( '\tLectura impacto de la RESOLUCIÓN C.D. 501 y RESOLUCIÓN C.D. 261.' )

load( file = paste0( parametros$RData_seg, 'IESS_SAL_presentacion_resultados.RData' ) )

aux <- copy( comp_cds )
aux[, anio := as.character( anio ) ]

aux_xtable <- xtable( aux, digits = c( 0, 0, 2, 2, 2 ) )
print( aux_xtable,
       file = paste0( parametros$resultado_tablas, 'iess_comp_cds_sal', '.tex' ),
       type = 'latex',
       include.colnames = FALSE,
       include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = NULL,
       sanitize.text.function = identity )

message( paste( rep('-', 100 ), collapse = '' ) )
gc()
