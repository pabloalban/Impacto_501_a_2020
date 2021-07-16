message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tGenerando tabla de balance total' )

escenarios_lista <- paste0( 'escenario_', 1:2 )

for ( i in 1:length( escenarios_lista ) ) {
        escenario <- escenarios_lista[i]
        load( paste0( parametros$RData_seg, 'IESS_IVM_balances_', escenario, '.RData' ) )
        
        # # Balance corriente ------------------------------------------------------------------------
        # aux <- balance_anual[ , list( t = t + parametros$anio_ini, A, A_est, B, G, V_cor, V_cap ) ]
        # aux[, t := as.character( t )]
        # xtb_aux <- xtable( aux, digits = c( 0, 0, 2, 2, 2, 2, 2, 2 ) )
        # print( xtb_aux,
        #        file = paste0( parametros$resultado_tablas, 'iess_balance_corriente_', escenario, '.tex' ),
        #        type = 'latex', 
        #        include.colnames = FALSE, include.rownames = FALSE, 
        #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
        #        only.contents = TRUE, 
        #        hline.after = NULL, sanitize.text.function = identity )
        # 
        # aux <- balance_anual[ , list( t = t + parametros$anio_ini, A2, A3, A4, A6, A, A_est, A_tot = A + A_est ) ]
        # aux[, t := as.character( t )]
        # xtb_aux <- xtable( aux, digits = c( 0, 0, 2, 2, 2, 2, 2, 2, 2 ) )
        # print( xtb_aux,
        #        file = paste0( parametros$resultado_tablas, 'iess_balance_aportes_', escenario, '.tex' ),
        #        type = 'latex', 
        #        include.colnames = FALSE, include.rownames = FALSE, 
        #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
        #        only.contents = TRUE, 
        #        hline.after = NULL, sanitize.text.function = identity )
        # 
        # aux <- balance_anual[ , list( t = t + parametros$anio_ini, B3, B4, B6, B_pen, B_aux, B ) ]
        # aux[, t := as.character( t )]
        # xtb_aux <- xtable( aux, digits = c( 0, 0, 2, 2, 2, 2, 2, 2 ) )
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
        # 
        # aux <- balance_anual[ , list( anio = t + parametros$anio_ini, t, A2_vap, A3_vap, A4_vap,
        #                               A6_vap, A_vap, A_est_vap, A_tot = A_vap + A_est_vap ) ]
        # aux[, anio := as.character( anio )]
        # xtb_aux <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2, 2, 2, 2, 2 ) )
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
        # aux <- balance_anual[ , list( anio = t + parametros$anio_ini, t, B3_vap, B4_vap, B6_vap,
        #                               B_pen_vap, B_aux_vap, B_vap ) ]
        # aux[, anio := as.character( anio )]
        # xtb_aux <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2, 2, 2, 2 ) )
        # print( xtb_aux,
        #        file = paste0( parametros$resultado_tablas, 'iess_balance_beneficios_vap_', escenario, '.tex' ),
        #        type = 'latex', 
        #        include.colnames = FALSE, include.rownames = FALSE, 
        #        format.args = list( decimal.mark = ',', big.mark = '.' ), 
        #        only.contents = TRUE, 
        #        hline.after = NULL, sanitize.text.function = identity )
        
        # Balance dinámico (resumen) ---------------------------------------------------------------
        aux <- balance_anual[ t == max(t), 
                              list( V0, A2_vap, A3_vap, A4_vap, A6_vap, A_est_vap,
                                    A_tot = A_vap + A_est_vap, 
                                    activo = V0 + A_vap + A_est_vap,
                                    B3_vap, B4_vap, B6_vap, B_aux_vap, B_vap, G_vap, 
                                    pasivo = B_vap + G_vap, 
                                    V ) ]
        aux1 <- melt.data.table( aux, measure.vars = 1:ncol(aux) )
        aux2 <- data.table( V0 = 'Reserva inicial', 
                            A2_vap = 'Aportes activos', 
                            A3_vap = 'Aportes pensionistas vejez', 
                            A4_vap = 'Aportes pensionistas invalidez',
                            A6_vap = 'Aportes pensionistas montep\\\'{i}o', 
                            A_est_vap = 'Aporte estatal', 
                            A_tot = 'Aportes totales', 
                            activo = 'Activo actuarial', 
                            B3_vap = 'Beneficios pensionistas vejez', 
                            B4_vap = 'Beneficios pensionistas invalidez', 
                            B6_vap = 'Beneficios pensionistas montep\\\'{i}o', 
                            B_aux_vap = 'Beneficios auxilio funerales', 
                            B_vap = 'Beneficios totales', 
                            G_vap = 'Gastos administrativos',
                            pasivo = 'Pasivo actuarial',
                            V = 'Balance actuarial' )
        aux2 <- melt.data.table( aux2, measure.vars = 1:ncol(aux2) )
        aux <- merge( aux2, aux1, by = 'variable', all.x = TRUE )
        setnames(aux, c('item', 'descripcion', 'valor'))
        xtb_aux <- xtable( aux[ , list(descripcion, valor)], digits = c( 0, 0, 2 ) )
        print( xtb_aux,
               file = paste0( parametros$resultado_tablas, 'ivm_bal_act_vap_', escenario, '.tex' ),
               type = 'latex', 
               include.colnames = FALSE, include.rownames = FALSE, 
               format.args = list( decimal.mark = ',', big.mark = '.' ), 
               only.contents = TRUE, 
               hline.after = c(1, 6, 7, 8, 12, 13, 14, 15), sanitize.text.function = identity )
        
        rm( balance, balance_anual )
}

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
