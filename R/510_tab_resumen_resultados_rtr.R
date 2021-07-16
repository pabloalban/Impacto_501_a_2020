message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tGenerando la tabla de resumen de resultados de la valuación' )

#parametrización de los escenarios------------------------------------------------------------------
nom_esc <- c( 'Escenario 1', 'Escenario 2')
escenario <- paste0( 'escenario_', 1:length( nom_esc ) )

#Creación data.frame--------------------------------------------------------------------------------
result<-NULL  
result_list <- vector(mode = "list", length = length( escenario ))
for( i in 1:length( escenario ) ){
  load( paste0( parametros$RData_seg, 'IESS_RTR_primas_', escenario[i], '.RData' ) )
  load( paste0( parametros$RData_seg, 'IESS_RTR_configuracion_', escenario[i], '.RData' ) )
  load( paste0( parametros$RData_seg, 'IESS_RTR_balances_',escenario[i],'.RData' ) )
  aux <- balance_anual[ t == max(t), 
                        list( 
                          i_a=formatC(esc$i_a*100,decimal.mark = ",", format='f',digits = 2),
                          i_sbu=formatC(esc$i_sbu*100,decimal.mark = ",", format='f',digits = 5),
                          i_sal=formatC(esc$i_r*100,decimal.mark = ",", format='f',digits = 5),
                          i_p=formatC(esc$i_p*100,decimal.mark = ",", format='f',digits = 5),
                          V0=formatC(V0,decimal.mark = ",",big.mark = ".", format='f',digits = 2), 
                          A2_vap=formatC(A2_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          A_jub_vap=formatC(A5_vap+A7_vap+A9_vap+A10_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          A_est_vap=formatC(A_est_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          activo = formatC(V0 + A_vap + A_est_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          BP_vap = formatC(B5_vap + B7_vap + B8_vap + B9_vap + B10_vap + B11_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          B12_vap = formatC(B12_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          B_vap = formatC(round(B_vap,2),decimal.mark = ",",big.mark = ".", format='f',digits = 2), 
                          G_vap = formatC(round(G_vap,2),decimal.mark = ",",big.mark = ".", format='f',digits = 2), 
                          pasivo = formatC(B_vap + G_vap,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          V = formatC(V,decimal.mark = ",",big.mark = ".", format='f',digits = 2),
                          pri_med_niv_apo=format( 100 * prima[ t == parametros$horizonte ]$pri_med_niv_apo_est_pen,
                                                  digits = 4, nsmall = 2, big.mark = '.', 
                                                  decimal.mark = ',', format = 'f' )
                        ) ]
  aux1 <- melt.data.table( aux, measure.vars = 1:ncol(aux) )
  aux2 <- data.table( 
    i_a='Tasa actuarial (\\%)',
    i_sbu='Tasa de crecimiento del SBU (\\%)',
    i_sal='Tasa de crecimiento del salario promedio (\\%)',
    i_p='Tasa de crecimiento de las pensiones (\\%)',
    V0 = 'Reserva inicial (USD)', 
    A2_vap = 'Aportes de afiliados (USD)', 
    A_jub_vap = 'Aportes de jubilados (USD)', 
    A_est_vap = 'Aportes del Estado (USD)', 
    activo = 'Activo actuarial', 
    BP_vap = 'Beneficios por pensiones',
    # B5_vap = 'Benefcios por incapacidad permanente absoluta y total',
    # B7_vap = 'Benefcios por incapacidad permanente parcial (rentas vitalicias)',
    # B8_vap = 'Benefcios por incapacidad permanente parcial (indemnizaciones)',
    # B9_vap = 'Benefcios pensionistas montepío de orfandad',
    # B10_vap = 'Benefcios pensionistas montepío de viudedad',
    # B11_vap = 'Benefcios por incapacidad temporal',
    B12_vap = 'Prestaciones m\\\'{e}dico asistenciales ',
    B_vap = 'Beneficios totales (USD)', 
    G_vap = 'Gastos administrativos (USD)',
    pasivo = 'Pasivo actuarial (USD)',
    V = 'Super\\\'{a}vit actuarial (USD)',
    pri_med_niv_apo='Prima media nivelada (\\%)')
  aux2 <- melt.data.table( aux2, measure.vars = 1:ncol(aux2) )
  aux <- as_tibble(merge( aux2, aux1, by = 'variable', all.x = TRUE ))
  setnames(aux, c('item', 'descripcion', 'valor'))
  aux<-select(aux,-item)
  result_list[[i]]<-aux
  if ( i=='1' ) {
    result=aux 
  } else {
    result<-left_join(result,aux,by='descripcion')}
  rm( balance, balance_anual )
}

#Guardar en latex-----------------------------------------------------------------------------------
xtb_aux <- xtable(result)
print( xtb_aux,
       file = paste0( parametros$resultado_tablas, 'iess_resultados.tex' ),
       type = 'latex', 
       include.colnames = FALSE, 
       include.rownames = FALSE, 
       #format.args = list( decimal.mark = ',', big.mark = '.' ), 
       #hline.after = c(1, 2 , 3, 8, 9, 10, 11),
       only.contents = TRUE,
       sanitize.text.function = identity,
       hline.after = NULL)

#Borrando los dataframes----------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()