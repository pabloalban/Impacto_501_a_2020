message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tGenerando tabla de balance total' )

escenarios_lista <- paste0( 'escenario_', 1: 2)

for ( i in 1:length( escenarios_lista ) ) {
  escenario <- escenarios_lista[i]
  #escenario <- escenarios_lista[1]
  load( paste0( parametros$RData_seg, 'IESS_RTR_balances_', escenario, '.RData' ) )
  
  # Balance corriente ------------------------------------------------------------------------
  # aux <- balance_anual[ , list( t = t + parametros$anio_ini, A, B, G, V_cor, V_cap ) ]
  # aux[, t := as.character( t )]
  # xtb_aux <- xtable( aux, digits = c( 0, 0, 2, 2, 2, 2, 2 ) )
  # print( xtb_aux,
  #        file = paste0( parametros$resultado_tablas, 'iess_balance_corriente_', escenario, '.tex' ),
  #        type = 'latex', 
  #        include.colnames = FALSE, include.rownames = FALSE, 
  #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
  #        only.contents = TRUE, 
  #        hline.after = NULL, sanitize.text.function = identity )
  # 
  # aux <- balance_anual[ , list( t = t + parametros$anio_ini, A2, A5, A7, A9, A10, A, A_est, A_tot = A + A_est ) ]
  # aux[, t := as.character( t )]
  # xtb_aux <- xtable( aux, digits = c( 0, 0, 2, 2, 2, 2, 2, 2, 2, 2 ) )
  # print( xtb_aux,
  #        file = paste0( parametros$resultado_tablas, 'iess_balance_aportes_', escenario, '.tex' ),
  #        type = 'latex', 
  #        include.colnames = FALSE, include.rownames = FALSE, 
  #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
  #        only.contents = TRUE, 
  #        hline.after = NULL, sanitize.text.function = identity )
  # 
  # aux <- balance_anual[ , list( t = t + parametros$anio_ini,t, B5, B7, B8, B9, B10, B11, B12, B ) ]
  # aux[, t := as.character( t )]
  # xtb_aux <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2, 2, 2 ,2, 2, 2) )
  # print( xtb_aux,
  #        file = paste0( parametros$resultado_tablas, 'iess_balance_beneficios_', escenario, '.tex' ),
  #        type = 'latex', 
  #        include.colnames = FALSE, include.rownames = FALSE, 
  #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
  #        only.contents = TRUE, 
  #        hline.after = NULL, sanitize.text.function = identity )
  # 
  # # Balance dinámico  ------------------------------------------------------------------------
  # # Balance dinámico (actuarial) -------------------------------------------------------------
  # aux <- balance_anual[ , list( anio = t + parametros$anio_ini, t, A_vap, A_est_vap, B_vap, G_vap, V0, V ) ]
  # aux[, anio := as.character( anio )]
  # xtb_aux <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2, 2, 2, 2 ) )
  # print( xtb_aux,
  #        file = paste0( parametros$resultado_tablas, 'iess_balance_actuarial_', escenario, '.tex' ),
  #        type = 'latex', 
  #        include.colnames = FALSE, include.rownames = FALSE, 
  #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
  #        only.contents = TRUE, 
  #        hline.after = NULL, sanitize.text.function = identity )
  # 
  # # Balance dinámico (aportes) ---------------------------------------------------------------
  # aux <- balance_anual[ , list( anio = t + parametros$anio_ini, t, A2_vap, A5_vap, A7_vap, A9_vap,
  #                               A10_vap, A_vap, A_est_vap, A_tot = A_vap + A_est_vap ) ]
  # aux[, anio := as.character( anio )]
  # xtb_aux <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2 ) )
  # print( xtb_aux,
  #        file = paste0( parametros$resultado_tablas, 'iess_balance_aportes_vap_', escenario, '.tex' ),
  #        type = 'latex', 
  #        include.colnames = FALSE, include.rownames = FALSE, 
  #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
  #        only.contents = TRUE, 
  #        hline.after = NULL, sanitize.text.function = identity )
  # 
  # # Balance dinámico (beneficios) ------------------------------------------------------------
  # 
  # aux <- balance_anual[ , list( anio = t + parametros$anio_ini, t, B5_vap, B7_vap, B8_vap, B9_vap,
  #                               B10_vap, B11_vap, B12_vap,  B_vap ) ]
  # aux[, anio := as.character( anio )]
  # xtb_aux <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2) )
  # print( xtb_aux,
  #        file = paste0( parametros$resultado_tablas, 'iess_balance_beneficios_vap_', escenario, '.tex' ),
  #        type = 'latex', 
  #        include.colnames = FALSE, include.rownames = FALSE, 
  #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
  #        only.contents = TRUE, 
  #        hline.after = NULL, sanitize.text.function = identity )
  
  # Balance dinámico (resumen) ---------------------------------------------------------------
  aux <- balance_anual[ t == max(t), 
                        list( V0, A2_vap, A5_vap, A7_vap, A9_vap, A10_vap, A_est_vap,
                              A_tot = A_vap + A_est_vap, 
                              activo = V0 + A_vap + A_est_vap,
                              B5_vap, B7_vap, B8_vap, B9_vap, B10_vap, B11_vap, B12_vap,
                              G_vap,
                              B_vap,
                              pasivo = B_vap + G_vap, 
                              V ) ]
  aux1 <- melt.data.table( aux, measure.vars = 1:ncol(aux) )
  aux2 <- data.table( V0 = 'Reserva inicial', 
                      A2_vap = 'Aportes activos', 
                      A5_vap = 'Aportes pensionistas de incapacidad permanente absoluta y total', 
                      A7_vap = 'Aportes pensionistas de incapacidad permanente parcial',
                      A9_vap = 'Aportes pensionistas montep\\\'{i}o de orfandad',
                      A10_vap = 'Aportes pensionistas montep\\\'{i}o de viudedad',
                      A_est_vap = 'Aporte estatal para financiar las pensiones', 
                      A_tot = 'Aportes totales', 
                      activo = 'Total activo actuarial', 
                      B5_vap = 'Beneficios por incapacidad permanente absoluta y total', 
                      B7_vap = 'Beneficios por incapacidad permanente parcial (rentas vitalicias)',
                      B8_vap = 'Beneficios por incapacidad permanente parcial (indemnizaciones)',
                      B9_vap = 'Beneficios pensionistas montep\\\'{i}o de orfandad',
                      B10_vap = 'Beneficios pensionistas montep\\\'{i}o de viudedad',
                      B11_vap = 'Beneficios por incapacidad temporal',
                      B12_vap = 'Prestaciones m\\\'{e}dico asistenciales',
                      B_vap = 'Beneficios totales', 
                      G_vap = 'Gastos administrativos',
                      pasivo = 'Total pasivo actuarial',
                      V = 'Super\\\'{a}vit actuarial' )
  aux2 <- melt.data.table( aux2, measure.vars = 1:ncol(aux2) )
  aux <- merge( aux2, aux1, by = 'variable', all.x = TRUE )
  setnames(aux, c('item', 'descripcion', 'valor'))
  xtb_aux <- xtable( aux[ , list(descripcion, valor)], digits = c( 0, 0, 2 ) )
  
  print( xtb_aux,
         file = paste0( parametros$resultado_tablas, 'rt_bal_act_vap_', escenario, '.tex' ),
         type = 'latex', 
         include.colnames = FALSE, include.rownames = FALSE, 
         format.args = list( decimal.mark = ',', big.mark = '.' ), 
         only.contents = TRUE, 
         hline.after = c(1, 7, 8, 9, 16, 18, 19),
         sanitize.text.function = identity,
         add.to.row = list(pos = list(9),
                           command = c(paste(" \n \\hline  \\multicolumn{2}{c}{\\textbf{Pasivo actuarial}}  \\\\ \n"))))

  rm( balance, balance_anual )
}

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
