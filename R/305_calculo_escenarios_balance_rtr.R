message( '\tCalculando escenarios del balance para RTR' )

#0. Ajustes necesarios de las transiciones de estados-----------------------------------------------

#0. 1.  Carga de hipótesis macro--------------------------------------------------------------------
load( paste0( parametros$RData, 'IESS_macro_estudio.RData' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros', 'Hipotesis' ) ) ] )

#1. Escenario 1: 261--------------------------------------------------------------------------------
esc <- new.env()
#1. 1.  Configuración del escenario 1---------------------------------------------------------------
esc$nombre <- 'escenario_1'
message( '\t\t\t', esc$nombre )
#1. 2.  Hipótesis-----------------------------------------------------------------------------------
esc$i_a <- 0.0625
esc$i_r <- Hipotesis[ 4, 2 ]
esc$i_sbu <- Hipotesis[ 5, 2 ]
esc$i_f <- Hipotesis[ 7, 2 ]
esc$i_p <- Hipotesis[ 7, 2 ]
esc$V0 <- 944552465.80

esc$aporte_estado <- data.table( t = 0:parametros$horizonte, 
                                 aporte_estado = c( rep( 0.28, 41 ) ) )

esc$porcentaje_gasto <- 0.0003 #0,03% de la masa salarial

#1. 3.  Factores de calibración --------------------------------------------------------------------
esc$calibra_apo <- 1.0
esc$calibra_pen_pa_pt <- 1.26
esc$calibra_pen_pp <- 1.28
esc$calibra_indmn <- 0.3529412
esc$calibra_subs <- 0.5
esc$calibra_orf <- 0.7407662
esc$calibra_viud <- 1
esc$aporte_jub <- 0.0276 # Aporte del 2.76% de los jubilados

#1. 4.  Factores de calculo de montepío-------------------------------------------------------------
esc$porc_ben_orf<- 2.67756315 #Porcentaje de benefcrs de orf respecto a los pensts de PA y PT
esc$porc_ben_viud<- 3.108469539 #Porcentaje de benefcrs de orf respecto a los pensts de PA y PT

esc$mont_prop_afi_orf<- 0.118449037 #Porcentaje que representan de las prestaciones
esc$mont_prop_afi_viud<- 0.254047820

#1. 5.  Tasa de aportación de los afiliados---------------------------------------------------------
esc$apo_act <- data.table( t = 0:parametros$horizonte, 
                           por_apo = c( rep(0.0055 ,41) ) )
esc$apo_act_salud <- data.table( t = 0:parametros$horizonte, 
                                 por_apo_salud = c( rep( 0, 41 ) ) )

#1. 6.  Calculos necesarios para el modelo actuarial------------------------------------------------
parametros_lista <- c( 'parametros_lista', 'esc', 'Hipotesis' )
source( 'R/304_calculo_balance_rtr.R', encoding = 'UTF-8', echo = FALSE )

save( esc, file = paste0( parametros$RData_seg, 'IESS_RTR_configuracion_', esc$nombre, '.RData' ) )
rm( esc )

#2. Escenario 2: 501--------------------------------------------------------------------------------
esc <- new.env()
#2. 1.  Configuración del escenario 1---------------------------------------------------------------
esc$nombre <- 'escenario_2'
message( '\t\t\t', esc$nombre )
#2. 2.  Hipótesis-----------------------------------------------------------------------------------
esc$i_a <- 0.0625
esc$i_r <- Hipotesis[ 4, 2 ]
esc$i_sbu <- Hipotesis[ 5, 2 ]
esc$i_f <- Hipotesis[ 7, 2 ]
esc$i_p <- Hipotesis[ 7, 2 ]
esc$V0 <- 944552465.80
esc$aporte_estado <- data.table( t = 0:parametros$horizonte, 
                                 aporte_estado = c( rep( 0.28, 41 ) ) )

esc$porcentaje_gasto <- 0.0003 #0,03% de la masa salarial

#2. 3.  Factores de calibración --------------------------------------------------------------------
esc$calibra_apo <- 1.0
esc$calibra_pen_pa_pt <- 1.26
esc$calibra_pen_pp <- 1.28
esc$calibra_indmn <- 0.3529412
esc$calibra_subs <- 0.5
esc$calibra_orf <- 0.7407662
esc$calibra_viud <- 1
esc$aporte_jub <- 0.0276 # Aporte del 2.76% de los jubilados

#2. 4.  Factores de calculo de montepío-------------------------------------------------------------
esc$porc_ben_orf<- 2.67756315 #Porcentaje de benefcrs de orf respecto a los pensts de PA y PT
esc$porc_ben_viud<- 3.108469539 #Porcentaje de benefcrs de orf respecto a los pensts de PA y PT

esc$mont_prop_afi_orf<- 0.118449037 #Porcentaje que representan de las prestaciones
esc$mont_prop_afi_viud<- 0.254047820

#2. 5.  Tasa de aportación de los afiliados---------------------------------------------------------
esc$apo_act <- data.table( t = 0:parametros$horizonte, 
                           por_apo = c(0.002, 0.002, 0.002,
                                       rep( ( (0.002*2024705)+(0.0038*662886))/2687591,38) ) )
esc$apo_act_salud <- data.table( t = 0:parametros$horizonte, 
                                 por_apo_salud = c( rep( 0, 41 ) ) )

#2. 6.  Calculos necesarios para el modelo actuarial------------------------------------------------
parametros_lista <- c( 'parametros_lista', 'esc', 'Hipotesis' )
source( 'R/304_calculo_balance_rtr.R', encoding = 'UTF-8', echo = FALSE )
save( esc, file = paste0( parametros$RData_seg, 'IESS_RTR_configuracion_', esc$nombre, '.RData' ) )

#5. Cálculo de primas y análisis de ratios para todos los escenarios -------------------------------
message( '\tCalculando primas y análisis de ratios' )

esc$gamma <- 0 # porcentaje de V_0 que se incluye en el calculo de la prima media nivelada 
source( 'R/306_calculo_prima_rtr.R', encoding = 'UTF-8', echo = FALSE )
#6. Limpiando memoria RAM---------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c(  'parametros' ) ) ] )
gc()
