message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tCálculo de la prima' )

escenarios <- paste0( 'escenario_', 1:2 )

for ( escenario in escenarios ) { # escenario<-'escenario_1'
  message( '\tCálculo de la prima para el ', escenario )
  load( paste0( parametros$RData_seg, 'IESS_SAL_balances_', escenario, '.RData' ) )
  
  prima <- balance_anual[ t > 0, list( t, v, M, A, A3, A4, A6, A_est, B, B7, G, 
                                       M_vap, A_vap, A3_vap, A4_vap, A6_vap, A_est_vap, 
                                       B7_vap, B_vap, G_vap, V0, V ) ]
  
  # Prima de reparto puro ----------------------------------------------------------------------------
  prima[ , pri_rep_pur := ( B + G ) /  M ] # sin aporte estatal
  prima[ , pri_rep_pur_apo_est := ( B + G - A_est ) /  M ] # con aporte estatal AE
  prima[ , pri_rep_pur_7 := B7 /  M ]
  
  # Prima nivelada en cada horizonte -----------------------------------------------------------------
  prima[ , pri_med_niv := ( B_vap + G_vap - V0 ) /  M_vap ] # sin aporte estatal
  prima[ , pri_med_niv_apo_est := ( B_vap + G_vap - A_est_vap - V0 ) /  M_vap ] # con aporte estatal AE
  prima[ , pri_med_niv_apo_est_m18 := ( B_vap + G_vap - A_est_vap - V0 ) /  M_vap ] # con aporte estatal y para menores de 18 años
  prima[ , pri_med_niv_7 :=  B7_vap /  M_vap ] # con aporte estatal y para menores de 18 años
  
  save( prima, 
        file = paste0( parametros$RData_seg, 'IESS_SAL_primas_', escenario, '.RData' ) )  
}

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()

