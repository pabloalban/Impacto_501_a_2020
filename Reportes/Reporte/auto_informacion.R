message( '\tEstableciendo información para la configuración del reporte' )

REP <- new.env()

#Nombres de Seguros---------------------------------------------------------------------------------
REP$seg_rt<-as.character("Seguro de Riesgos del Trabajo")
REP$seg_ivm<-as.character("Seguro de Invalidez, Vejez y Muerte")
REP$seg_sal<-as.character("Seguro General de Salud Individual y Familiar")

REP$CD501<-as.character("Resolución No. C.D. 501")
REP$CD261<-as.character("Resolución No. C.D. 261")

REP$iess<-as.character("\\caption*{\\textbf{Instituto Ecuatoriano de Seguridad Social}}\\\\")


#Autoinformación para RTR---------------------------------------------------------------------------
# Escenario 1: CD261--------------------------------------------------------------------------------
escenario <- 'escenario_1'
load( paste0( parametros$RData_seg, 'IESS_RTR_configuracion_', escenario, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_primas_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_balances_', esc$nombre, '.RData' ) )

REP$bal_act_esc_1 <- format( balance_anual[ t == parametros$horizonte ]$V,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_cap_esc_1 <- format( balance_anual[ t == parametros$horizonte ]$V_cap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$duracion_esc_1 <- max( which( balance_anual$V_cap > 0 ) ) + parametros$anio_ini -1

REP$cap_ini <- format( esc$V0,
                       digits = 2, nsmall = 2, big.mark = '.',
                       decimal.mark = ',', format = 'f' )

REP$pri_med_niv_esc_1 <- format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                 digits = 4, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$apo_est_esc_1<-format( 100 * esc$aporte_estado[3,2],
                           digits = 2, nsmall = 2, big.mark = '.',
                           decimal.mark = ',', format = 'f' )

REP$tasa_act_esc_1<-format( 100 * esc$i_a,
                            digits = 2, nsmall = 2, big.mark = '.',
                            decimal.mark = ',', format = 'f' )

REP$tasa_aporte_jub_esc_1<-format( 100 * esc$aporte_jub,
                                  digits = 2, nsmall = 2, big.mark = '.',
                                  decimal.mark = ',', format = 'f' )

REP$tasa_porcentaje_gasto_esc_1<-format( 100 * esc$porcentaje_gasto,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )

REP$tasa_aporte_esc_1<-format( 100 * esc$apo_act[2,2] + 100 * esc$apo_act_salud[2,2],
                                         digits = 2, nsmall = 2, big.mark = '.',
                                         decimal.mark = ',', format = 'f' )

REP$tasa_aporte_salud_esc_1<-format( 100 * esc$apo_act_salud[1,2],
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )

REP$bal_sum_act_1 <- format( balance_anual[ t == parametros$horizonte ]$Act+esc$V0,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_sum_pas_1 <- format( balance_anual[ t == parametros$horizonte ]$B_vap+balance_anual[ t == parametros$horizonte ]$G_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_est_1 <- format( balance_anual[ t == parametros$horizonte ]$A_est_vap -
                                 balance_anual[ t == '1' ]$A_est_vap,
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )

REP$ing_apo_afi_1 <- format( balance_anual[ t == parametros$horizonte ]$A2_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

ing<-balance_anual[ t == parametros$horizonte ]$A2_vap
# Escenario 2: CD501--------------------------------------------------------------------------------
escenario <- 'escenario_2'
load( paste0( parametros$RData_seg, 'IESS_RTR_configuracion_', escenario, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_primas_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_balances_', esc$nombre, '.RData' ) )

REP$bal_act_esc_2 <- format( balance_anual[ t == parametros$horizonte ]$V,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_cap_esc_2 <- format( balance_anual[ t == parametros$horizonte ]$V_cap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$duracion_esc_2 <- max( which( balance_anual$V_cap > 0 ) ) + parametros$anio_ini -1

REP$cap_ini <- format( esc$V0,
                       digits = 2, nsmall = 2, big.mark = '.',
                       decimal.mark = ',', format = 'f' )

REP$pri_med_niv_esc_2 <- format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                 digits = 4, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$apo_est_esc_2<-format( 100 * esc$aporte_estado[3,2],
                           digits = 2, nsmall = 2, big.mark = '.',
                           decimal.mark = ',', format = 'f' )

REP$tasa_act_esc_2<-format( 100 * esc$i_a,
                            digits = 2, nsmall = 2, big.mark = '.',
                            decimal.mark = ',', format = 'f' )

REP$tasa_aporte_jub_esc_2<-format( 100 * esc$aporte_jub,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )

REP$tasa_porcentaje_gasto_esc_2<-format( 100 * esc$porcentaje_gasto,
                                         digits = 2, nsmall = 2, big.mark = '.',
                                         decimal.mark = ',', format = 'f' )

REP$tasa_aporte_esc_2<-format( 100 * esc$apo_act[2,2] + 100 * esc$apo_act_salud[2,2],
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )

REP$tasa_aporte_salud_esc_2<-format( 100 * esc$apo_act_salud[1,2],
                                     digits = 2, nsmall = 2, big.mark = '.',
                                     decimal.mark = ',', format = 'f' )

REP$bal_sum_act_2 <- format( balance_anual[ t == parametros$horizonte ]$Act+esc$V0,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_sum_pas_2 <- format( balance_anual[ t == parametros$horizonte ]$B_vap+balance_anual[ t == parametros$horizonte ]$G_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_est_2 <- format( balance_anual[ t == parametros$horizonte ]$A_est_vap -
                               balance_anual[ t == '1' ]$A_est_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_afi_2 <- format( balance_anual[ t == parametros$horizonte ]$A2_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$dif_ing_apo_afi <- format( ing - balance_anual[ t == parametros$horizonte ]$A2_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )



#Autoinformación para IVM---------------------------------------------------------------------------
# Escenario 1: CD261--------------------------------------------------------------------------------
escenario <- 'escenario_1'
load( paste0( parametros$RData_seg, 'IESS_IVM_configuracion_', escenario, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_IVM_primas_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_IVM_balances_', esc$nombre, '.RData' ) )

REP$bal_act_esc_1_ivm <- format( balance_anual[ t == parametros$horizonte ]$V,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_cap_esc_1_ivm <- format( balance_anual[ t == parametros$horizonte ]$V_cap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$duracion_esc_1_ivm <- max( which( balance_anual$V_cap > 0 ) ) + parametros$anio_ini -1

REP$cap_ini_ivm <- format( esc$V0,
                       digits = 2, nsmall = 2, big.mark = '.',
                       decimal.mark = ',', format = 'f' )

REP$pri_med_niv_esc_1_ivm <- format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                 digits = 4, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$apo_est_esc_1_ivm<-format( 100 * esc$aporte_estado,
                           digits = 2, nsmall = 2, big.mark = '.',
                           decimal.mark = ',', format = 'f' )

REP$tasa_act_esc_1_ivm<-format( 100 * esc$i_a,
                            digits = 2, nsmall = 2, big.mark = '.',
                            decimal.mark = ',', format = 'f' )

REP$tasa_aporte_jub_esc_1_ivm<-format( 100 * esc$aporte_jub,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )

REP$tasa_porcentaje_gasto_esc_1_ivm<-format( 100 * esc$porcentaje_gasto,
                                         digits = 2, nsmall = 2, big.mark = '.',
                                         decimal.mark = ',', format = 'f' )

REP$tasa_aporte_esc_1_ivm<-format( 100 * esc$apo_act[2,7],
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )


REP$bal_sum_act_1_ivm <- format( balance_anual[ t == parametros$horizonte ]$Act+esc$V0,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_sum_pas_1_ivm <- format( balance_anual[ t == parametros$horizonte ]$B_vap+balance_anual[ t == parametros$horizonte ]$G_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_est_1_ivm <- format( balance_anual[ t == parametros$horizonte ]$A_est_vap -
                               balance_anual[ t == '1' ]$A_est_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_afi_1_ivm <- format( balance_anual[ t == parametros$horizonte ]$A2_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

ing_ivm<-balance_anual[ t == parametros$horizonte ]$A2_vap
# Escenario 2: CD501--------------------------------------------------------------------------------
escenario <- 'escenario_2'
load( paste0( parametros$RData_seg, 'IESS_IVM_configuracion_', escenario, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_IVM_primas_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_IVM_balances_', esc$nombre, '.RData' ) )

REP$bal_act_esc_2_ivm <- format( balance_anual[ t == parametros$horizonte ]$V,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_cap_esc_2_ivm <- format( balance_anual[ t == parametros$horizonte ]$V_cap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$duracion_esc_2_ivm <- max( which( balance_anual$V_cap > 0 ) ) + parametros$anio_ini -1

REP$cap_ini_ivm <- format( esc$V0,
                       digits = 2, nsmall = 2, big.mark = '.',
                       decimal.mark = ',', format = 'f' )

REP$pri_med_niv_esc_2_ivm <- format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                 digits = 4, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$apo_est_esc_2_ivm<-format( 100 * esc$aporte_estado,
                           digits = 2, nsmall = 2, big.mark = '.',
                           decimal.mark = ',', format = 'f' )

REP$tasa_act_esc_2_ivm<-format( 100 * esc$i_a,
                            digits = 2, nsmall = 2, big.mark = '.',
                            decimal.mark = ',', format = 'f' )

REP$tasa_aporte_jub_esc_2_ivm<-format( 100 * esc$aporte_jub,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )

REP$tasa_porcentaje_gasto_esc_2_ivm<-format( 100 * esc$porcentaje_gasto,
                                         digits = 2, nsmall = 2, big.mark = '.',
                                         decimal.mark = ',', format = 'f' )

REP$tasa_aporte_esc_2_ivm<-format( 100 * esc$apo_act[2,7],
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )

REP$bal_sum_act_2_ivm <- format( balance_anual[ t == parametros$horizonte ]$Act+esc$V0,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$bal_sum_pas_2_ivm <- format( balance_anual[ t == parametros$horizonte ]$B_vap+balance_anual[ t == parametros$horizonte ]$G_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_est_2_ivm <- format( balance_anual[ t == parametros$horizonte ]$A_est_vap -
                               balance_anual[ t == '1' ]$A_est_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$ing_apo_afi_2_ivm <- format( balance_anual[ t == parametros$horizonte ]$A2_vap,
                             digits = 2, nsmall = 2, big.mark = '.',
                             decimal.mark = ',', format = 'f' )

REP$dif_ing_apo_afi_ivm <- format( balance_anual[ t == parametros$horizonte ]$A2_vap - ing_ivm,
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )



#Autoinformación para Salud-------------------------------------------------------------------------
# Escenario 1: CD261--------------------------------------------------------------------------------
escenario <- 'escenario_1'
load( paste0( parametros$RData_seg, 'IESS_SAL_configuracion_', escenario, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_SAL_primas_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_SAL_balances_', esc$nombre, '.RData' ) )

REP$bal_act_esc_1_sal <- format( balance_anual[ t == parametros$horizonte ]$V,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$bal_cap_esc_1_sal <- format( balance_anual[ t == parametros$horizonte ]$V_cap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$duracion_esc_1_sal <- max( which( balance_anual$V_cap > 0 ) ) + parametros$anio_ini -1

REP$cap_ini_sal <- format( esc$V0,
                           digits = 2, nsmall = 2, big.mark = '.',
                           decimal.mark = ',', format = 'f' )

REP$pri_med_niv_esc_1_sal <- format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                     digits = 4, nsmall = 2, big.mark = '.',
                                     decimal.mark = ',', format = 'f' )

REP$apo_est_esc_1_sal<-format( 100 * esc$aporte_estado,
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )

REP$tasa_act_esc_1_sal<-format( 100 * esc$i_a,
                                digits = 2, nsmall = 2, big.mark = '.',
                                decimal.mark = ',', format = 'f' )

REP$tasa_aporte_jub_esc_1_sal<-format( 100 * esc$aporte_jub,
                                       digits = 2, nsmall = 2, big.mark = '.',
                                       decimal.mark = ',', format = 'f' )

REP$tasa_porcentaje_gasto_esc_1_sal<-format( 100 * esc$porcentaje_gasto,
                                             digits = 2, nsmall = 2, big.mark = '.',
                                             decimal.mark = ',', format = 'f' )

REP$tasa_aporte_esc_1_sal<-format( 100 * esc$apo_act[2,]$por_apo,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )


REP$bal_sum_act_1_sal <- format( balance_anual[ t == parametros$horizonte ]$Act+esc$V0,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$bal_sum_pas_1_sal <- format( balance_anual[ t == parametros$horizonte ]$B_vap+balance_anual[ t == parametros$horizonte ]$G_vap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$ing_apo_est_1_sal <- format( balance_anual[ t == parametros$horizonte ]$A_est_vap -
                                   balance_anual[ t == '1' ]$A_est_vap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$ing_apo_afi_1_sal <- format( balance_anual[ t == parametros$horizonte ]$A2_vap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

ing_sal<-balance_anual[ t == parametros$horizonte ]$A2_vap
# Escenario 2: CD501--------------------------------------------------------------------------------
escenario <- 'escenario_2'
load( paste0( parametros$RData_seg, 'IESS_SAL_configuracion_', escenario, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_SAL_primas_', esc$nombre, '.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_SAL_balances_', esc$nombre, '.RData' ) )

REP$bal_act_esc_2_sal <- format( balance_anual[ t == parametros$horizonte ]$V,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$bal_cap_esc_2_sal <- format( balance_anual[ t == parametros$horizonte ]$V_cap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$duracion_esc_2_sal <- max( which( balance_anual$V_cap > 0 ) ) + parametros$anio_ini -1

REP$cap_ini_sal <- format( esc$V0,
                           digits = 2, nsmall = 2, big.mark = '.',
                           decimal.mark = ',', format = 'f' )

REP$pri_med_niv_esc_2_sal <- format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                     digits = 4, nsmall = 2, big.mark = '.',
                                     decimal.mark = ',', format = 'f' )

REP$apo_est_esc_2_sal<-format( 100 * esc$aporte_estado,
                               digits = 2, nsmall = 2, big.mark = '.',
                               decimal.mark = ',', format = 'f' )

REP$tasa_act_esc_2_sal<-format( 100 * esc$i_a,
                                digits = 2, nsmall = 2, big.mark = '.',
                                decimal.mark = ',', format = 'f' )

REP$tasa_aporte_jub_esc_2_sal<-format( 100 * esc$aporte_jub,
                                       digits = 2, nsmall = 2, big.mark = '.',
                                       decimal.mark = ',', format = 'f' )

REP$tasa_porcentaje_gasto_esc_2_sal<-format( 100 * esc$porcentaje_gasto,
                                             digits = 2, nsmall = 2, big.mark = '.',
                                             decimal.mark = ',', format = 'f' )

REP$tasa_aporte_esc_2_sal<-format( 100 * esc$apo_act[2,]$por_apo,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )

REP$bal_sum_act_2_sal <- format( balance_anual[ t == parametros$horizonte ]$Act+esc$V0,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$bal_sum_pas_2_sal <- format( balance_anual[ t == parametros$horizonte ]$B_vap+balance_anual[ t == parametros$horizonte ]$G_vap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$ing_apo_est_2_sal <- format( balance_anual[ t == parametros$horizonte ]$A_est_vap -
                                   balance_anual[ t == '1' ]$A_est_vap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$ing_apo_afi_2_sal <- format( balance_anual[ t == parametros$horizonte ]$A2_vap,
                                 digits = 2, nsmall = 2, big.mark = '.',
                                 decimal.mark = ',', format = 'f' )

REP$dif_ing_apo_afi_sal <- format( ing_sal - balance_anual[ t == parametros$horizonte ]$A2_vap ,
                                   digits = 2, nsmall = 2, big.mark = '.',
                                   decimal.mark = ',', format = 'f' )