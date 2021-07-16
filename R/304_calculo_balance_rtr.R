message( paste( rep('-', 100 ), collapse = '' ) )

load( paste0( parametros$RData_seg, 'IESS_RTR_proy_beneficarios_prestacion.RData' ) )
load( paste0( parametros$RData, 'IESS_proyeccion_salarios_escenario_1.Rdata' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_proyeccion_beneficios.RData' ) )

# Borrando variables, solo quedan variables a ser utilizadas
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros', 'pob_proy', 'ben_proy', 'sal_proy', 
                                 'pen_proy' ) ) ] )

message( '\tBalance seguro ', parametros$seguro, ' calculando escenario: ', esc$nombre )

#1.Balance corriente -------------------------------------------------------------------------------
message( '\tGenerando balance corriente' )
balance <- merge( pob_proy, 
                  sal_proy[ , list( t, sexo, x, sal ) ], by = c( 't', 'sexo', 'x' ),all.x = TRUE ,all.y = TRUE)
balance <- merge( balance, 
                  ben_proy, 
                  by = c( 't', 'sexo', 'x' ),all.x = TRUE )

balance <- balance %>% replace(is.na(.), 0)

message( '\tProyectando masa salarial' )
balance[ , M := esc$calibra_apo * sal * l2_cot ]

balance <- balance[order(t,x,sexo)]
#1 . 1.  Beneficios de renta vitalicia---------------------------------------------------------------
message( '\tProyectando beneficios por pensiones de incapacidad' )

#1. 1.  1.  Beneficio por pensiones de incapacidad PA y PT de RTR-----------------------------------
cal_pen_pa_pt <- esc$calibra_pen_pa_pt
por_inc<-(1200*0.8+146*1)/1346 #porcentaje de incapacidad promedio ponderado entre PT y PA a dic 2018

balance[      , B5_ant := cal_pen_pa_pt * pen_pa_pt * l55  ]
balance[      , B5_nue := cal_pen_pa_pt * pen_pa_pt * l25 ]

balance[ , B5 := B5_ant + B5_nue ]
balance[ , B5_sbu := sbu * l5 ]
balance[ , B5_dec := ( B5 - B5_sbu ) / 13 + B5_sbu ]
balance[ , B5_nodec := 12 * ( B5 - B5_sbu ) / 13 ]

#1. 1.  2.  Beneficio por pensiones de incapacidad PP de RTR----------------------------------------
cal_pen_pp <- esc$calibra_pen_pp

balance[ , B7_ant := cal_pen_pp * pen_pp * l7  ]
#No hay nuevas entradas de pensionistas de incapacidad PP

balance[ , B7 := cal_pen_pp * pen_pp * l7 ]
balance[ , B7_sbu := sbu * l7 ]
balance[ , B7_dec := ( B7 - B7_sbu ) / 13 + B7_sbu ]
balance[ , B7_nodec := 12 * ( B7 - B7_sbu ) / 13 ]

#1 . 2.  Beneficios por indemnizaciones--------------------------------------------------------------
message( '\tProyectando beneficios por indemnizaciones' )

cal_indemn <- esc$calibra_indmn

balance[ , B8 := cal_indemn * pen_indemn * l8  ]

#1 . 3.  Beneficios por subsidios--------------------------------------------------------------------
message( '\tProyectando beneficios por subsidios' )

cal_subs <- esc$calibra_subs

balance[  , B11 := cal_subs * pen_sub * l_11  ]

#1. 4.  Beneficios para orfandad--------------------------------------------------------------------
message( '\tProyectando beneficios por orfandad' )
cal_pen_mo <- esc$calibra_orf

balance[ , B9 :=  cal_pen_mo * pen_mo * l9  ]
balance[ , B9_sbu := sbu * 0.4 * ( l9 ) ]
balance[ , B9_dec := ( B9 - 0.4 * B9_sbu ) / 13 + B9_sbu ]
balance[ , B9_nodec := 12 * ( B9 - B9_sbu ) / 13 ]

#1. 5.  Beneficios para viudedad--------------------------------------------------------------------
message( '\tProyectando beneficios por viudedad' )
cal_pen_mv <- esc$calibra_viud 

balance[ , B10 :=  cal_pen_mv * pen_mv * l_10  ]
balance[ , B10_sbu := sbu * 0.6 * ( l_10 ) ]
balance[ , B10_dec := ( B10 - 0.6 * B10_sbu ) / 13 + B10_sbu ]
balance[ , B10_nodec := 12 * ( B10 - B10_sbu ) / 13 ]

#1. 6.  Pago de prestaciones médico asistenciales---------------------------------------------------
message( '\tProyectando el pago de prestaciones médico asistenciales' )
balance <- merge( balance, esc$apo_act_salud, by = 't', all.x = TRUE )
balance[ , B12 :=  por_apo_salud * M ]

#Beneficios por pensiones---------------------------------------------------------------------
balance[ , B_pen := B5 + B7 + B8 + B9 + B10 + B11 ]
balance[ , B_sbu := B5_sbu + B7_sbu + B9_sbu + B10_sbu ]
balance[ , B_dec := B5_sbu + B7_sbu + B9_sbu + B10_sbu ]
balance[ , B_nodec := B5_nodec + B7_nodec + B9_nodec + B10_nodec ]

# Beneficios totales
balance[ , B := B_pen + B12 ]

#1. 7. Proyecciones de aportes de afiliados---------------------------------------------------------
message( '\tProyectando aportes' )
#1. 7.  1. Aportes de activos-----------------------------------------------------------------------
balance <- merge( balance, esc$apo_act, by = 't', all.x = TRUE )
balance[ t == 0 , A2 := 0 ]
balance[ , A2 := ( por_apo + por_apo_salud) * M ]

#1. 7. 2. Aportes de pensionistas de PA y PT sin décimos--------------------------------------------
aporte_jub<-esc$aporte_jub
balance[ , A5 := aporte_jub * B5_nodec ] 
balance[ t == 1 , A5 := 0.0276 * B5_nodec ]
balance[ t == 0 , A5 := 0 ]

#1. 7. 3. Aportes de pensionistas de PP sin décimos-------------------------------------------------
balance[ , A7 := aporte_jub * B7_nodec ]
balance[ t == 1 , A7 := 0.0276 * B7_nodec ]
balance[ t == 0 , A7 := 0 ]

#1. 7. 4. Aportes de beneficiarios de orfandad sin décimos------------------------------------------
balance[ , A9 := aporte_jub * B9_nodec ]
balance[ t == 1 , A9 := 0.0276 * B9_nodec ]
balance[ t == 0 , A9 := 0 ]

# 1. 7. 5. Aportes de beneficiarios de viudedad sin décimos-----------------------------------------
balance[ , A10 := aporte_jub * B10_nodec ]
balance[ t == 1 , A10 := 0.0276 * B10_nodec ]
balance[ t == 0 , A10 := 0 ]

# 1. 8. Resumen aportes y gastos---------------------------------------------------------------------
# Aportes totales
balance[ , A := (A2 + A5 + A7 + A9 + A10) ]

# Gasto administrativo
balance[ , G := esc$porcentaje_gasto * M ]
balance[ t == 0 , G := 0 ]

# Contribución del estado 
balance <- merge( balance, esc$aporte_estado, by = 't', all.x = TRUE )
balance[ , A_est := aporte_estado * B_pen ]
balance[ t == 0 , A_est := 0 ]

#Activos
balance[ , Act := A + A_est ]

#Pasivo
balance[ , Pas := B + G ]

#1. 9. Calculo Balance corriente----------------------------------------------------------------------------
balance_anual <- balance[ , list( M = sum( M , na.rm = TRUE ),
                                  Act = sum( Act, na.rm = TRUE ),
                                  Pas = sum( Pas , na.rm = TRUE),
                                  A = sum( A , na.rm = TRUE),
                                  A2 = sum( A2, na.rm = TRUE ),
                                  A5 = sum( A5 , na.rm = TRUE),
                                  A7 = sum( A7 , na.rm = TRUE),
                                  A9 = sum( A9 , na.rm = TRUE),
                                  A10 = sum( A10, na.rm = TRUE ),
                                  A_est = sum( A_est, na.rm = TRUE ),
                                  
                                  B = sum( B , na.rm = TRUE),
                                  B_pen = sum( B_pen, na.rm = TRUE ),
                                  B_sbu = sum( B_sbu , na.rm = TRUE),
                                  B_dec = sum( B_dec, na.rm = TRUE ),
                                  B_nodec = sum( B_nodec, na.rm = TRUE ),
                                  
                                  B5 = sum( B5 , na.rm = TRUE),
                                  B5_sbu = sum( B5_sbu , na.rm = TRUE),
                                  B5_dec = sum( B5_dec, na.rm = TRUE ),
                                  B5_nodec = sum( B5_nodec , na.rm = TRUE),
                                  B5_ant = sum( B5_ant , na.rm = TRUE),
                                  B5_nue = sum( B5_nue , na.rm = TRUE),
                                  
                                  B7 = sum( B7, na.rm = TRUE ),
                                  B7_sbu = sum( B7_sbu, na.rm = TRUE ),
                                  B7_dec = sum( B7_dec , na.rm = TRUE),
                                  B7_nodec = sum( B7_nodec, na.rm = TRUE ),
                                  B7_ant = sum( B7_ant, na.rm = TRUE ),

                                  B8 = sum( B8, na.rm = TRUE ),
                                  
                                  B9 = sum( B9, na.rm = TRUE ),
                                  B9_sbu = sum( B9_sbu , na.rm = TRUE),
                                  B9_dec = sum( B9_dec , na.rm = TRUE),
                                  B9_nodec = sum( B9_nodec, na.rm = TRUE ),
                                  
                                  B10 = sum( B10, na.rm = TRUE ),
                                  B10_sbu = sum( B10_sbu, na.rm = TRUE ),
                                  B10_dec = sum( B10_dec , na.rm = TRUE),
                                  B10_nodec = sum( B10_nodec , na.rm = TRUE),
                                  
                                  B11 = sum( B11 , na.rm = TRUE),
                                  
                                  B12 = sum( B12 , na.rm = TRUE),
                                  
                                  G = sum( G, na.rm = TRUE ) ), 
                          by = list( t ) ]

balance_anual[ , i_a := esc$i_a ]
balance_anual[ , r := ( 1 + i_a )^(t) ]
balance_anual[ , v := ( 1 + i_a )^(-t) ]
balance_anual[ , V_cor := A + A_est - B - G]
balance_anual[ t == 0, `:=`( M = 0, A = 0, A2 = 0, A5 = 0, A7 = 0, A9 = 0, A10 = 0,
                             B = 0, B_pen = 0, B_sbu = 0, B_dec = 0, B_nodec = 0,
                             B5 = 0, B5_sbu = 0, B5_dec = 0, B5_nodec = 0, B5_ant = 0, B5_nue = 0,
                             B7 = 0, B7_sbu = 0, B7_dec = 0, B7_nodec = 0, B7_ant = 0, B8 = 0, 
                             B10 = 0, B10_sbu = 0, B10_dec = 0, B10_nodec = 0, B11 = 0, B12 = 0,
                             B9 = 0, B9_sbu = 0, B9_dec = 0, B9_nodec = 0,
                             G = 0, V_cor = 0 , Act = 0, Pas = 0) ]
balance_anual[ , V_cap := V_cor ]
balance_anual[ t == 0, V_cap := esc$V0 ]
balance_anual[ , V_cap := r * cumsum( v * V_cap ) ]

#2. Balance actuarial-------------------------------------------------------------------------------
balance_anual[ , M_vap := cumsum( v * M ) ]
balance_anual[ , Act := cumsum( v * Act ) ]
balance_anual[ , Pas := cumsum( v * Pas ) ]
balance_anual[ , A_vap := cumsum( v * A ) ]
balance_anual[ , A2_vap := cumsum( v * A2 ) ]
balance_anual[ , A5_vap := cumsum( v * A5 ) ]
balance_anual[ , A7_vap := cumsum( v * A7 ) ]
balance_anual[ , A9_vap := cumsum( v * A9 ) ]
balance_anual[ , A10_vap := cumsum( v * A10 ) ]

balance_anual[ , A_est_vap := cumsum( v * A_est ) ]

balance_anual[ , B_vap := cumsum( v * B ) ]
balance_anual[ , B_pen_vap := cumsum( v * B_pen ) ]
balance_anual[ , B_sbu_vap := cumsum( v * B_sbu ) ]
balance_anual[ , B_dec_vap := cumsum( v * B_dec ) ]
balance_anual[ , B_nodec_vap := cumsum( v * B_nodec ) ]

balance_anual[ , B5_vap := cumsum( v * B5 ) ]
balance_anual[ , B5_sbu_vap := cumsum( v * B5_sbu ) ]
balance_anual[ , B5_dec_vap := cumsum( v * B5_dec ) ]
balance_anual[ , B5_nodec_vap := cumsum( v * B5_nodec ) ]
balance_anual[ , B5_ant_vap := cumsum( v * B5_ant ) ]
balance_anual[ , B5_nue_vap := cumsum( v * B5_nue ) ]

balance_anual[ , B7_vap := cumsum( v * B7 ) ]
balance_anual[ , B7_sbu_vap := cumsum( v * B7_sbu ) ]
balance_anual[ , B7_dec_vap := cumsum( v * B7_dec ) ]
balance_anual[ , B7_nodec_vap := cumsum( v * B7_nodec ) ]
balance_anual[ , B7_ant_vap := cumsum( v * B7_ant ) ]

balance_anual[ , B8_vap := cumsum( v * B8 ) ]

balance_anual[ , B9_vap := cumsum( v * B9 ) ]
balance_anual[ , B9_sbu_vap := cumsum( v * B9_sbu ) ]
balance_anual[ , B9_dec_vap := cumsum( v * B9_dec ) ]
balance_anual[ , B9_nodec_vap := cumsum( v * B9_nodec ) ]

balance_anual[ , B10_vap := cumsum( v * B10 ) ]
balance_anual[ , B10_sbu_vap := cumsum( v * B10_sbu ) ]
balance_anual[ , B10_dec_vap := cumsum( v * B10_dec ) ]
balance_anual[ , B10_nodec_vap := cumsum( v * B10_nodec ) ]

balance_anual[ , B11_vap := cumsum( v * B11 ) ]

balance_anual[ , B12_vap := cumsum( v * B12 ) ]

balance_anual[ , G_vap := cumsum( v * G ) ]
balance_anual[ , V := v * V_cap ]
balance_anual[ , V0 := esc$V0 ]

# Guardando balances -------------------------------------------------------------------------------
message( '\tGuardando balances' )
save( balance, balance_anual,
      file = paste0( parametros$RData_seg, 'IESS_RTR_balances_', esc$nombre, '.RData' ) )

# Limpiando memoria RAM-----------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros' ) ) ] )
gc()
