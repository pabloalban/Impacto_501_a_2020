message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tCalculando escenarios del balance para SAL' )

# Carga --------------------------------------------------------------------------------------------
load( paste0( parametros$RData, 'IESS_macro_estudio.RData' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros', 'Hipotesis' ) ) ] )

# Escenario 1: CD 261-------------------------------------------------------------------------------
esc <- new.env()

esc$nombre <- 'escenario_1'
message( '\n\t\t\t', esc$nombre )
esc$i_a <- 0.0625
esc$i_r <- Hipotesis[ 4, 2 ]
esc$i_sbu <- Hipotesis[ 5, 2 ]
esc$i_f <- Hipotesis[ 7, 2 ]
esc$i_p <- Hipotesis[ 7, 2 ]
esc$i_m <- 1.2 * Hipotesis[ 7, 2 ]
esc$V0 <- 6908125882.20
esc$aporte_estado <- 0.5
esc$aporte_pen <- 0
esc$calibra_aux_fun <- 0.275 
esc$calibra_apo <- 1.0
esc$calibra_pen_vej <- 1.105
esc$calibra_pen_inv <- 0.70
esc$mont_prof_afi <- 0.1275
esc$gadmin<-0.04 # porcentaje sobre el ingreso presupuestario que en la práctica corresponde a los aportes anuales
esc$apo_act <- data.table( t = 0:parametros$horizonte, 
                           por_apo = c( rep( 0.0571, 41 ) ) + 0.1 * 0.008, # prima para financiar el gasto administrativo, en porcentaje de los aportes
                           por_apo_ext_cot = 0.0341, # prima para financiar beneficios de cónyuges por extensión de cobertura
                           por_apo_ext_pen = 0.0415, # prima para financiar beneficios de cónyuges por extensión de cobertura
                           por_apo_men_18 = 0, # prima para financiar beneficios de menores a 18
                           por_apo_gas = esc$gadmin * c( rep( 0.0571, 41 ) )  # límite legal del gasto administrativo en porcentaje de los aportes
)

parametros_lista <- c( 'parametros', 'parametros_lista', 'esc', 'Hipotesis' )
source( 'R/303_calculo_balance_sal.R', encoding = 'UTF-8', echo = FALSE )
save( esc, file = paste0( parametros$RData_seg, 'IESS_SAL_configuracion_', esc$nombre, '.RData' ) )
rm( esc )

# Escenario 2: CD 501-------------------------------------------------------------------------------
esc <- new.env()

esc$nombre <- 'escenario_2'
message( '\n\t\t\t', esc$nombre )
esc$i_a <- 0.0625
esc$i_r <- Hipotesis[ 4, 2 ]
esc$i_sbu <- Hipotesis[ 5, 2 ]
esc$i_f <- Hipotesis[ 7, 2 ]
esc$i_p <- Hipotesis[ 7, 2 ]
esc$i_m <- 1.2 * Hipotesis[ 7, 2 ]
esc$V0 <- 6908125882.20 
esc$aporte_estado <- 0.5
esc$aporte_pen <- 0
esc$calibra_aux_fun <- 0.275 
esc$calibra_apo <- 1.0
esc$calibra_pen_vej <- 1.105
esc$calibra_pen_inv <- 0.70
esc$mont_prof_afi <- 0.1275
esc$gadmin<-0.04 # porcentaje sobre el ingreso presupuestario que en la práctica corresponde a los aportes anuales
esc$apo_act <- data.table( t = 0:parametros$horizonte, 
                           por_apo = c( 0.0814, 0.0694, 0.0594, rep( 0.0516, 38 ) ) + 0.1 * 0.008, # prima para financiar el gasto administrativo, en porcentaje de los aportes
                           por_apo_ext_cot = 0.0341, # prima para financiar beneficios de cónyuges por extensión de cobertura
                           por_apo_ext_pen = 0.0415, # prima para financiar beneficios de cónyuges por extensión de cobertura
                           por_apo_men_18 = 0, # prima para financiar beneficios de menores a 18
                           por_apo_gas = esc$gadmin * c( 0.0814, 0.0694, 0.0594, rep( 0.0516, 38 ) ) # límite legal del gasto administrativo en porcentaje de los aportes
)
parametros_lista <- c( 'parametros', 'parametros_lista', 'esc', 'Hipotesis' )
source( 'R/303_calculo_balance_sal.R', encoding = 'UTF-8', echo = FALSE )
save( esc, file = paste0( parametros$RData_seg, 'IESS_SAL_configuracion_', esc$nombre, '.RData' ) )
rm( esc )

# Cálculo de primas y análisis de ratios para todos los escenarios ---------------------------------
message( '\n\tCalculando primas y análisis de ratios' )
source( 'R/304_calculo_prima_sal.R', encoding = 'UTF-8', echo = FALSE )

#Limpiar Ram----------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
