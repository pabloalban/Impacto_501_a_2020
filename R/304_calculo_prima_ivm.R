message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tCálculo de la prima' )

N <- 1:2

escenarios <- paste0( 'escenario_', N )

for ( escenario in escenarios ) {
  message( '\tCálculo de la prima para el ', escenario )
  load( paste0( parametros$RData_seg, 'IESS_IVM_balances_', escenario, '.RData' ) )
  
  prima <- balance_anual[ t > 0, list( t, v, M, A, A3, A4, A6, A_est, B, B_dec, G, 
                                       M_vap, A_vap, A3_vap, A4_vap, A6_vap, A_est_vap, 
                                       B_vap, B_dec_vap, G_vap, V0, V ) ]
  
  # Porcentaje de contribución por décimos
  delta <- 1.0
  
# Prima de reparto puro ----------------------------------------------------------------------------
  prima[ , pri_rep_pur := ( B + G ) /  M ] # sin aporte estatal
  prima[ , pri_rep_pur_apo_est := ( B + G - A_est ) /  M ] # con aporte estatal AE
  prima[ , pri_rep_pur_delta := ( B + G - delta * B_dec - A_est ) / M ] 
  prima[ , pri_rep_pur_delta_pen := delta * B_dec / M ]
  
# Prima nivelada en cada horizonte -----------------------------------------------------------------
  prima[ , pri_med_niv := ( B_vap + G_vap - V0 ) /  M_vap ] # sin aporte estatal
  prima[ , pri_med_niv_apo_est := ( B_vap + G_vap - A_est_vap - V0 ) /  M_vap ] # con aporte estatal AE
  prima[ , pri_med_niv_delta := ( B_vap + G_vap - delta * B_dec_vap - A_est_vap - V0 ) / M_vap ] 
  prima[ , pri_med_niv_delta_pen := delta * B_dec_vap / M_vap ]
  
  save( prima, 
        file = paste0( parametros$RData_seg, 'IESS_IVM_primas_', escenario, '.RData' ) )  
}

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()

#---------------------------------------------------------------------------------------------------
# cargar resultados
# escenario <- 'escenario_7' 
# load( paste0( parametros$RData_seg, 'IESS_IVM_balances_', escenario, '.RData' ) ) 
# load( paste0( parametros$RData_seg, 'IESS_IVM_primas_', escenario, '.RData' ) )
