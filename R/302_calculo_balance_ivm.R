message( paste( rep('-', 100 ), collapse = '' ) )

load( paste0( parametros$RData, 'IESS_proyeccion_poblacion.RData' ) )
load( paste0( parametros$RData, 'IESS_proyeccion_salarios_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_IVM_proyeccion_beneficios_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_IVM_proyeccion_calibrada_beneficios_', esc$nombre, '.RData' ) )

# Borrando variables, solo quedan variables a ser utilizadas
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros', 'pob_proy', 'ben_proy', 'sal_proy', 
                                 'pen_proy', 'gast_proy' ) ) ] )

message( '\tBalance seguro ', parametros$seguro, ' calculando escenario: ', esc$nombre )

# Balance corriente --------------------------------------------------------------------------------
message( '\tGenerando balance corriente' )
balance <- merge( pob_proy, 
                  sal_proy[ , list( t, sexo, x, sal ) ], by = c( 't', 'sexo', 'x' ) )
balance <- merge( balance, 
                  pen_proy[ , list( t, sexo, x, pen_ant_3, pen_nue_3, pen_ant_4, pen_nue_4 ) ], 
                  by = c( 't', 'sexo', 'x' ) )
balance <- merge( balance, 
                  ben_proy[ , list( t, sexo, x, i_p, i_f, sbu, ben_25, ben_35, ben_45, ben_65 ) ], 
                  by = c( 't', 'sexo', 'x' ) )
setorder( balance, t, sexo, x )

message( '\tProyectando masa salarial' )
balance[ , M := esc$calibra_apo * sal * l2_cot ]

# Beneficios de renta vitalicia
message( '\tProyectando beneficios por pensiones' )

# Beneficio por pensiones de vejez
cal_pen_vej <- esc$calibra_pen_vej

balance[ t > 0, B3_ant := cal_pen_vej * pen_ant_3 * l33 ]
balance[ t > 0, B3_nue := cal_pen_vej * pen_nue_3 * l23 ]

balance[ t == 0, B3 := cal_pen_vej * pen_ant_3 * l3 ]
balance[ t > 0, B3 := B3_ant + B3_nue ]
balance[ , B3_sbu := sbu * l3 ]
balance[ , B3_dec := ( B3 - B3_sbu ) / 13 + B3_sbu ]
balance[ , B3_nodec := 12 * ( B3 - B3_sbu ) / 13 ]

# Beneficio por pensiones de invalidez
cal_pen_inv <- esc$calibra_pen_inv

balance[ t > 0, B4_ant := cal_pen_inv * pen_ant_3 * l44  ]
balance[ t > 0, B4_nue := cal_pen_inv * pen_nue_4 * l24 ]

balance[ t == 0, B4 := cal_pen_inv * pen_ant_4 * l4 ]
balance[ t > 0, B4 := B4_ant + B4_nue ]
balance[ , B4_sbu := sbu * l4 ]
balance[ , B4_dec := ( B4 - B4_sbu ) / 13 + B4_sbu ]
balance[ , B4_nodec := 12 * ( B4 - B4_sbu ) / 13 ]

# Beneficios de montepios
balance[ , B6 :=  parametros$mont_prop_afi * ( B3 + B4 ) ]
balance[ , B6_sbu := B6 - sbu * parametros$mont_prop_afi * ( l3 + l4 ) ]
balance[ , B6_dec := ( B6 - B6_sbu ) / 13 + B6_sbu ]
balance[ , B6_nodec := 12 * ( B6 - B6_sbu ) / 13 ]

# Beneficios por pensiones
balance[ , B_pen := B3 + B4 + B6 ]
balance[ , B_sbu := B3_sbu + B4_sbu + B6_sbu ]
balance[ , B_dec := B3_dec + B4_dec + B6_dec ]
balance[ , B_nodec := B3_nodec + B4_nodec + B6_nodec ]

# Beneficios de transición
message( '\tProyectando beneficios por transiciones' )
balance[ , B25 := esc$calibra_aux_fun * ben_25 * l25 ]
balance[ , B35 := esc$calibra_aux_fun * ben_35 * l35 ]
balance[ , B45 := esc$calibra_aux_fun * ben_45 * l45 ]
balance[ , B65 := esc$calibra_aux_fun * ben_65 * ( parametros$mont_prop_afi * ( cal_pen_vej * l3 + cal_pen_inv * l4 ) ) ]

# Beneficios por auxilio de funerales
balance[ , B_aux := B25 + B35 + B45 + B65 ]

# Beneficios totales
balance[ , B := B_pen + B_aux ]

message( '\tProyectando aportes' )
# Aportes de activos
balance <- merge( balance, esc$apo_act, by = 't', all.x = TRUE )
balance[ t == 0 , A2 := 0 ]
balance[ , A2 := por_apo * M ]

# Aportes de pensionistas de vejez sin décimos
balance[ , A3 := por_apo_pen_vej * ( B3 - B3 / 12 - sbu ) ] 
balance[ t == 0 , A3 := 0 ]

# Aportes de pensionistas de invalidez sin décimos
balance[ , A4 := por_apo_pen_inv * ( B4 - B4 / 12 - sbu ) ]
balance[ t == 0 , A4 := 0 ]

# Aportes de montepios sin décimos
balance[ , A6 := por_apo_pen_mon * ( B6 - B6 / 12 - sbu ) ]
balance[ t == 0 , A6 := 0 ]

# Aportes totales
balance[ , A := A2 + A3 + A4 + A6  ]

# Gasto administrativo
balance[ , G := esc$porcentaje_gasto * A ]
balance[ t == 0 , G := 0 ]

# Contribución del estado 
balance[ , A_est := esc$aporte_estado * B_pen ]
balance[ t == 0 , A_est := 0 ]

# Balance corriente
balance_anual <- balance[ , list( M = sum( M ),
                                  A = sum( A ),
                                  A2 = sum( A2 ),
                                  A3 = sum( A3 ),
                                  A4 = sum( A4 ),
                                  A6 = sum( A6 ),
                                  A_est = sum( A_est ),

                                  B = sum( B ),
                                  B_pen = sum( B_pen ),
                                  B_sbu = sum( B_sbu ),
                                  B_dec = sum( B_dec ),
                                  B_nodec = sum( B_nodec ),
                                  
                                  B3 = sum( B3 ),
                                  B3_sbu = sum( B3_sbu ),
                                  B3_dec = sum( B3_dec ),
                                  B3_nodec = sum( B3_nodec ),
                                  B3_ant = sum( B3_ant ),
                                  B3_nue = sum( B3_nue ),
                                  
                                  B4 = sum( B4 ),
                                  B4_sbu = sum( B4_sbu ),
                                  B4_dec = sum( B4_dec ),
                                  B4_nodec = sum( B4_nodec ),
                                  B4_ant = sum( B4_ant ),
                                  B4_nue = sum( B4_nue ),
                                  
                                  B6 = sum( B6 ),
                                  B6_sbu = sum( B6_sbu ),
                                  B6_dec = sum( B6_dec ),
                                  B6_nodec = sum( B6_nodec ),
                                  
                                  B_aux = sum( B_aux ),
                                  G = sum( G ) ), 
                          by = list( t ) ]

balance_anual <- merge( balance_anual, esc$apo_act[ , list( t, i_a ) ], by = 't' )
setorder( balance_anual, t )
balance_anual[ , r := i_a ]
balance_anual[ t == 0, r := 0 ]
balance_anual[ , r := 1 + r ]
balance_anual[ , r := cumprod( r ) ]
balance_anual[ , v := 1 / r  ]
balance_anual[ , V_cor := A + A_est - B - G ]
balance_anual[ t == 0, `:=`( M = 0, A = 0, A2 = 0, A3 = 0, A4 = 0, A6 = 0, A_est = 0, 
                             B = 0, B_pen = 0, B_sbu = 0, B_dec = 0, B_nodec = 0,
                             B3 = 0, B3_sbu = 0, B3_dec = 0, B3_nodec = 0, B3_ant = 0, B3_nue = 0,
                             B4 = 0, B4_sbu = 0, B4_dec = 0, B4_nodec = 0, B4_ant = 0, B4_nue = 0,
                             B6 = 0, B6_sbu = 0, B6_dec = 0, B6_nodec = 0,
                             B_aux = 0, G = 0, V_cor = 0 ) ]
balance_anual[ , V_cap := V_cor ]
balance_anual[ t == 0, V_cap := esc$V0 ]
balance_anual[ , V_cap := r * cumsum( v * V_cap ) ]

# Balance actuarial
balance_anual[ , M_vap := cumsum( v * M ) ]
balance_anual[ , A_vap := cumsum( v * A ) ]
balance_anual[ , A2_vap := cumsum( v * A2 ) ]
balance_anual[ , A3_vap := cumsum( v * A3 ) ]
balance_anual[ , A4_vap := cumsum( v * A4 ) ]
balance_anual[ , A6_vap := cumsum( v * A6 ) ]
balance_anual[ , A_est_vap := cumsum( v * A_est ) ]

balance_anual[ , B_vap := cumsum( v * B ) ]
balance_anual[ , B_pen_vap := cumsum( v * B_pen ) ]
balance_anual[ , B_sbu_vap := cumsum( v * B_sbu ) ]
balance_anual[ , B_dec_vap := cumsum( v * B_dec ) ]
balance_anual[ , B_nodec_vap := cumsum( v * B_nodec ) ]

balance_anual[ , B3_vap := cumsum( v * B3 ) ]
balance_anual[ , B3_sbu_vap := cumsum( v * B3_sbu ) ]
balance_anual[ , B3_dec_vap := cumsum( v * B3_dec ) ]
balance_anual[ , B3_nodec_vap := cumsum( v * B3_nodec ) ]
balance_anual[ , B3_ant_vap := cumsum( v * B3_ant ) ]
balance_anual[ , B3_nue_vap := cumsum( v * B3_nue ) ]

balance_anual[ , B4_vap := cumsum( v * B4 ) ]
balance_anual[ , B4_sbu_vap := cumsum( v * B4_sbu ) ]
balance_anual[ , B4_dec_vap := cumsum( v * B4_dec ) ]
balance_anual[ , B4_nodec_vap := cumsum( v * B4_nodec ) ]
balance_anual[ , B4_ant_vap := cumsum( v * B4_ant ) ]
balance_anual[ , B4_nue_vap := cumsum( v * B4_nue ) ]

balance_anual[ , B6_vap := cumsum( v * B6 ) ]
balance_anual[ , B6_sbu_vap := cumsum( v * B6_sbu ) ]
balance_anual[ , B6_dec_vap := cumsum( v * B6_dec ) ]
balance_anual[ , B6_nodec_vap := cumsum( v * B6_nodec ) ]

balance_anual[ , B_aux_vap := cumsum( v * B_aux ) ]

balance_anual[ , G_vap := cumsum( v * G ) ]
balance_anual[ , V := v * V_cap ]
balance_anual[ , V0 := esc$V0 ]

# Guardando balances -------------------------------------------------------------------------------
message( '\tGuardando balances' )
save( balance, balance_anual,
      file = paste0( parametros$RData_seg, 'IESS_IVM_balances_', esc$nombre, '.RData' ) )

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros' ) ) ] )
gc()
