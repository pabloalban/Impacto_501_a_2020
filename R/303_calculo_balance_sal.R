#---------------------------------------------------------------------------------------------------
# Cargando información
load( paste0( parametros$RData_seg, 'IESS_SAL_estimacion.RData' ) )
load( paste0( parametros$RData, 'IESS_proyeccion_poblacion.RData' ) )
load( paste0( parametros$RData, 'IESS_proyeccion_salarios_escenario_1.RData' ) )
load( paste0( parametros$RData, 'IESS_IVM_proyeccion_beneficios_escenario_1.RData' ) )
load( paste0( parametros$RData, 'IESS_IVM_proyeccion_calibrada_beneficios_escenario_1.RData' ) )

# Borrando variables, solo quedan variables a ser utilizadas
rm( list = ls()[ !( ls() %in% c( parametros_lista, 
                                 'pob_proy', 'ben_proy', 'sal_proy', 'pen_proy', 'gast_proy',
                                 'ben_est_fre', 'ben_est_sev' ) ) ] )

message( '\tBalance seguro ', parametros$seguro, ' calculando escenario: ', esc$nombre )

# Balance corriente --------------------------------------------------------------------------------
message( '\tGenerando balance corriente' )

aportes <- merge( pob_proy, 
                  sal_proy[ , list( t, sexo, x, sal ) ], by = c( 't', 'sexo', 'x' ) )
aportes <- merge( aportes, 
                  pen_proy[ , list( t, sexo, x, pen_ant_3, pen_nue_3, pen_ant_4, pen_nue_4 ) ], 
                  by = c( 't', 'sexo', 'x' ) )
aportes <- merge( aportes, 
                  ben_proy[ , list( t, sexo, x, i_p, i_f, sbu ) ], 
                  by = c( 't', 'sexo', 'x' ) )
setorder( aportes, t, sexo, x )

aportes <- aportes[ t <= parametros$horizonte ]

message( '\tProyectando masa salarial' )
aportes[ , M := esc$calibra_apo * sal * l2_cot ]

# Beneficios de renta vitalicia
message( '\tProyectando beneficios por pensiones' )

# Beneficio por pensiones de vejez
cal_pen_vej <- esc$calibra_pen_vej

aportes[ t > 0, P3_ant := cal_pen_vej * pen_ant_3 * l33 ]
aportes[ t > 0, P3_nue := cal_pen_vej * pen_nue_3 * l23 ]

aportes[ t == 0, P3 := cal_pen_vej * pen_ant_3 * l3 ]
aportes[ t > 0, P3 := P3_ant + P3_nue ]
aportes[ , P3_sbu := sbu * l3 ]
aportes[ , P3_dec := ( P3 - P3_sbu ) / 13 + P3_sbu ]
aportes[ , P3_nodec := 12 * ( P3 - P3_sbu ) / 13 ]

# Beneficio por pensiones de invalidez
cal_pen_inv <- esc$calibra_pen_inv

aportes[ t > 0, P4_ant := cal_pen_inv * pen_ant_3 * l44  ]
aportes[ t > 0, P4_nue := cal_pen_inv * pen_nue_4 * l24 ]

aportes[ t == 0, P4 := cal_pen_inv * pen_ant_4 * l4 ]
aportes[ t > 0, P4 := P4_ant + P4_nue ]
aportes[ , P4_sbu := sbu * l4 ]
aportes[ , P4_dec := ( P4 - P4_sbu ) / 13 + P4_sbu ]
aportes[ , P4_nodec := 12 * ( P4 - P4_sbu ) / 13 ]

# Beneficios de montepios
aportes[ , P6 :=  parametros$mont_prop_afi * ( P3 + P4 ) ]
aportes[ , P6_sbu := P6 - sbu * parametros$mont_prop_afi * ( l3 + l4 ) ]
aportes[ , P6_dec := ( P6 - P6_sbu ) / 13 + P6_sbu ]
aportes[ , P6_nodec := 12 * ( P6 - P6_sbu ) / 13 ]

# Beneficios por pensiones
aportes[ , P_pen := P3 + P4 + P6 ]
aportes[ , P_sbu := P3_sbu + P4_sbu + P6_sbu ]
aportes[ , P_dec := P3_dec + P4_dec + P6_dec ]
aportes[ , P_nodec := P3_nodec + P4_nodec + P6_nodec ]

aportes[ , P := P_pen ]

message( '\tProyectando aportes' )
pob_ext_cob <- 1/10
aportes[ , l8 := pob_ext_cob * l8 ]
# Aportes de activos
aportes <- merge( aportes, esc$apo_act, by = 't', all.x = TRUE )
aportes[ t == 0 , A2 := 0 ]
aportes[ , A2 := por_apo * M ]

aportes[ , A8_2 := 0 ]
aportes[ l2_cot + l3 + l4 + l6 > 0, A8_2 := por_apo_ext_cot * M * l8 / ( l2_cot + l3 + l4 + l6 ) ] 
aportes[ t == 0 , A8_2 := 0 ]

apo_pen <- esc$aporte_pen
# Aportes de pensionistas de vejez sin décimos
aportes[ , A3 := apo_pen * ( P3 - P3 / 12 - sbu ) ] 
aportes[ t == 0 , A3 := 0 ]

aportes[ , A8_3 := 0 ]
aportes[ l2_cot + l3 + l4 + l6 > 0, A8_3 := por_apo_ext_pen * ( P3 - P3 / 12 - sbu ) * l8 / ( l2_cot + l3 + l4 + l6 ) ] 
aportes[ t == 0 , A8_3 := 0 ]

# Aportes de pensionistas de invalidez sin décimos
aportes[ , A4 := apo_pen * ( P4 - P4 / 12 - sbu ) ]
aportes[ t == 0 , A4 := 0 ]

aportes[ , A8_4 := 0 ]
aportes[ l2_cot + l3 + l4 + l6 > 0, A8_4 := por_apo_ext_pen * ( P4 - P4 / 12 - sbu ) * l8 / ( l2_cot + l3 + l4 + l6 ) ] 
aportes[ t == 0 , A8_4 := 0 ]

# Aportes de montepios sin décimos
aportes[ , A6 := apo_pen * ( P6 - P6 / 12 - sbu ) ]
aportes[ t == 0 , A6 := 0 ]

aportes[ , A8_6 := 0 ]
aportes[ l2_cot + l3 + l4 + l6 > 0, A8_6 := por_apo_ext_pen * ( P6 - P6 / 12 - sbu ) * l8 / ( l2_cot + l3 + l4 + l6 ) ] 
aportes[ t == 0 , A8_6 := 0 ]

# Aportes de cotizantes para menores de 18
aportes[ t == 0 , A7 := 0 ]
aportes[ , A7 := por_apo_men_18 * M ]

# Aportes afiliados
aportes[ , A8 := A8_2 + A8_3 + A8_4 + A8_6  ]
aportes[ , A_afi := A2 + A3 + A4 + A6 + A7 + A8 ]

# Contribución del estado 
# aportes[ , A_est := 0 ]
# aportes[ t == 0 , A_est := 0 ]

# Aportes totales
# aportes[ , A := A_afi + A_est  ]
aportes[ , A := A_afi ]

# Gasto administrativo
aportes[ , G := por_apo_gas * M ]
aportes[ t == 0 , G := 0 ]

aportes_anual <- aportes[ , list( M = sum( M ),
                                  A = sum( A ),
                                  A_afi = sum( A_afi ),
                                  # A_est = sum( A_est ),
                                  A2 = sum( A2 ),
                                  A3 = sum( A3 ),
                                  A4 = sum( A4 ),
                                  A6 = sum( A6 ),
                                  A7 = sum( A7 ),
                                  A8 = sum( A8 ),
                                  A8_2 = sum( A8_2 ),
                                  A8_3 = sum( A8_3 ),
                                  A8_4 = sum( A8_4 ),
                                  A8_6 = sum( A8_6 ),
                                  G = sum( G ) ), 
                          by = list( t ) ]

# Estimación de beneficios -------------------------------------------------------------------------
beneficios <- aportes[ , list( t, sexo, x, l2, l3, l4, l5, l2_cot, l6, l7, l8 = pob_ext_cob * l8, M ) ]

# Estimación de beneficios de salud
beneficios[ , u := as.character( cut( x, breaks = c( 0, 1, seq( 5, 60, 5 ), seq( 70, 80, 10 ), 110 ), 
                                      include.lowest = TRUE, right = FALSE, ordered_result = TRUE ) ) ]
aux <- copy( beneficios )
aux[ , u := as.character( cut( x, breaks = c( 0, 5, seq( 20, 60, 20 ), 110 ), 
                               include.lowest = TRUE, right = FALSE, ordered_result = TRUE ) ) ]
beneficios <- rbind( beneficios, aux )

beneficios <- merge( beneficios, 
                     ben_est_sev[ , list( sexo, u, enf, ser, cap, icd, ED, EX, q_p, q_s, q_c ) ],
                     by = c( 'sexo', 'u' ), 
                     all.x = TRUE, 
                     allow.cartesian = TRUE )

beneficios <- merge( beneficios, 
                     ben_est_fre[ t == t_max, list( sexo, u, enf, lambda ) ],
                     by = c( 'sexo', 'u', 'enf' ), 
                     all.x = TRUE, 
                     allow.cartesian = TRUE )

beneficios[ , m := ( 1 + esc$i_m )^(t) ]
beneficios[ is.na( q_p ), q_p := 0 ]
beneficios[ is.na( q_s ), q_s := 0 ]
beneficios[ is.na( q_c ), q_c := 0 ]
beneficios[ is.na( lambda ), lambda := 0 ]
beneficios[ is.na( ED ), ED := 0 ]
beneficios[ is.na( EX ), EX := 0 ]

# Inflación médica
beneficios[ , EX := m * EX ]

# Población total cubierta
beneficios[ , l := l2_cot + l3 + l4 + l6 + l7 + l8 ]

# Probabilidad de enfermar
q_e <- 1.0
cal_ben <- 1.44

# Proyección de beneficios por grupo de asegurados
beneficios[ ser != 'HO', B2 := cal_ben * lambda * EX * q_p * q_s * q_c * q_e * l2_cot ]
beneficios[ ser == 'HO', B2 := cal_ben * lambda * ED * EX * q_p * q_s * q_c * q_e * l2_cot ]
beneficios[ ser != 'HO', B3 := cal_ben * lambda * EX * q_p * q_s * q_c * q_e * l3 ]
beneficios[ ser == 'HO', B3 := cal_ben * lambda * ED * EX * q_p * q_s * q_c * q_e * l3 ]
beneficios[ ser != 'HO', B4 := cal_ben * lambda * EX * q_p * q_s * q_c * q_e * l4 ]
beneficios[ ser == 'HO', B4 := cal_ben * lambda * ED * EX * q_p * q_s * q_c * q_e * l4 ]
beneficios[ ser != 'HO', B6 := cal_ben * lambda * EX * q_p * q_s * q_c * q_e * l6 ]
beneficios[ ser == 'HO', B6 := cal_ben * lambda * ED * EX * q_p * q_s * q_c * q_e * l6 ]
beneficios[ , B7 := 0 ]
beneficios[ ser != 'HO' & x < 18, B7 := 6 * cal_ben * lambda * EX * q_p * q_s * q_c * q_e * l7 ] 
beneficios[ ser == 'HO' & x < 18, B7 := 6 * cal_ben * lambda * ED * EX * q_p * q_s * q_c * q_e * l7 ]
beneficios[ ser != 'HO', B8 := cal_ben * lambda * EX * q_p * q_s * q_c * q_e * l8 ]
beneficios[ ser == 'HO', B8 := cal_ben * lambda * ED * EX * q_p * q_s * q_c * q_e * l8 ]

# Beneficio por subsidios
cal_sub <- 0.015702013
por_mas <- 70 / 365
beneficios[ , B9 := 0 ]
beneficios[ enf == 'E', B9 := cal_sub * q_p * q_s * q_c * q_e * por_mas * M ]

# Beneficios totales
beneficios[ , B := B2 + B3 + B4 + B6 + B7 + B8 + B9 ]

# Sin asegurados no hay beneficios
beneficios[ l == 0, `:=`( B = 0, B2 = 0, B3 = 0, B4 = 0, B6 = 0, B7 = 0, B8 = 0, B9 = 0 ) ]

beneficios[ , A_est_cat := 0 ]
beneficios[ enf == 'C', A_est_cat := B2 + B7 + B8 ]
beneficios[ , A_est_3 := B3 ]
beneficios[ , A_est_4 := B4 ]
beneficios[ , A_est_6 := B6 ]
beneficios[ , A_est := esc$aporte_estado * ( A_est_cat + A_est_3 + A_est_4 + A_est_6 ) ]

beneficios_anual <- beneficios[ , list( B = sum( B ),
                                        B2 = sum( B2 ),
                                        B3 = sum( B3 ),
                                        B4 = sum( B4 ),
                                        B6 = sum( B6 ),
                                        B7 = sum( B7 ),
                                        B8 = sum( B8 ),
                                        B9 = sum( B9 ),
                                        A_est_3 = sum( A_est_3 ),
                                        A_est_4 = sum( A_est_4 ),
                                        A_est_6 = sum( A_est_6 ),
                                        A_est_cat = sum( A_est_cat ),
                                        A_est = sum( A_est ) ),
                                by = list( t ) ]

setorder( beneficios_anual, t )

balance_anual <- merge( aportes_anual,
                        beneficios_anual, by = 't' )
balance_anual[ , A := A_afi + A_est ]
balance_anual[ , i_a := esc$i_a ]
balance_anual[ , r := ( 1 + i_a )^(t) ]
balance_anual[ , v := ( 1 + i_a )^(-t) ]
balance_anual[ , V_cor := A - B - G ]
balance_anual[ t == 0, `:=`( M = 0, A = 0, A_afi = 0, A2 = 0, A3 = 0, A4 = 0, A6 = 0, A7 = 0, 
                             A8 = 0, A8_2 = 0, A8_3 = 0, A8_4 = 0, A8_6 = 0, 
                             A_est_3 = 0, A_est_4 = 0, A_est_6 = 0, A_est_cat = 0, A_est = 0,
                             B = 0, B2 = 0, B3 = 0, B4 = 0, B6 = 0, B7 = 0, B8 = 0, B9 = 0,
                             G = 0, V_cor = 0 ) ]
balance_anual[ , V_cap := V_cor ]
balance_anual[ t == 0, V_cap := esc$V0 ]
balance_anual[ , V_cap := r * cumsum( v * V_cap ) ]

# Balance actuarial
balance_anual[ , M_vap := cumsum( v * M ) ]
balance_anual[ , A_vap := cumsum( v * A ) ]
balance_anual[ , A_afi_vap := cumsum( v * A_afi ) ]
balance_anual[ , A2_vap := cumsum( v * A2 ) ]
balance_anual[ , A3_vap := cumsum( v * A3 ) ]
balance_anual[ , A4_vap := cumsum( v * A4 ) ]
balance_anual[ , A6_vap := cumsum( v * A6 ) ]
balance_anual[ , A7_vap := cumsum( v * A7 ) ]
balance_anual[ , A8_vap := cumsum( v * A8 ) ]
balance_anual[ , A8_2_vap := cumsum( v * A8_2 ) ]
balance_anual[ , A8_3_vap := cumsum( v * A8_3 ) ]
balance_anual[ , A8_4_vap := cumsum( v * A8_4 ) ]
balance_anual[ , A8_6_vap := cumsum( v * A8_6 ) ]
balance_anual[ , A_est_3_vap := cumsum( v * A_est_3 ) ]
balance_anual[ , A_est_4_vap := cumsum( v * A_est_4 ) ]
balance_anual[ , A_est_6_vap := cumsum( v * A_est_6 ) ]
balance_anual[ , A_est_cat_vap := cumsum( v * A_est_cat ) ]
balance_anual[ , A_est_vap := cumsum( v * A_est ) ]
balance_anual[ , B_vap := cumsum( v * B ) ]
balance_anual[ , B2_vap := cumsum( v * B2 ) ]
balance_anual[ , B3_vap := cumsum( v * B3 ) ]
balance_anual[ , B4_vap := cumsum( v * B4 ) ]
balance_anual[ , B6_vap := cumsum( v * B6 ) ]
balance_anual[ , B7_vap := cumsum( v * B7 ) ]
balance_anual[ , B8_vap := cumsum( v * B8 ) ]
balance_anual[ , B9_vap := cumsum( v * B9 ) ]
balance_anual[ , G_vap := cumsum( v * G ) ]
balance_anual[ , V := v * V_cap ]
balance_anual[ , V0 := esc$V0 ]

# Guardando balances -------------------------------------------------------------------------------
message( '\tGuardando balances' )
save( aportes, beneficios, balance_anual,
      file = paste0( parametros$RData_seg, 'IESS_SAL_balances_', esc$nombre, '.RData' ) )

rm( list = ls()[ !( ls() %in% c( parametros_lista ) ) ] )
gc()
